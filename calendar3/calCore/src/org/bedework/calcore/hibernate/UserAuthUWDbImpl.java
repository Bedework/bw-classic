/*
 Copyright (c) 2000-2005 University of Washington.  All rights reserved.

 Redistribution and use of this distribution in source and binary forms,
 with or without modification, are permitted provided that:

   The above copyright notice and this permission notice appear in
   all copies and supporting documentation;

   The name, identifiers, and trademarks of the University of Washington
   are not used in advertising or publicity without the express prior
   written permission of the University of Washington;

   Recipients acknowledge that this distribution is made available as a
   research courtesy, "as is", potentially with defects, without
   any obligation on the part of the University of Washington to
   provide support, services, or repair;

   THE UNIVERSITY OF WASHINGTON DISCLAIMS ALL WARRANTIES, EXPRESS OR
   IMPLIED, WITH REGARD TO THIS SOFTWARE, INCLUDING WITHOUT LIMITATION
   ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
   PARTICULAR PURPOSE, AND IN NO EVENT SHALL THE UNIVERSITY OF
   WASHINGTON BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
   DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
   PROFITS, WHETHER IN AN ACTION OF CONTRACT, TORT (INCLUDING
   NEGLIGENCE) OR STRICT LIABILITY, ARISING OUT OF OR IN CONNECTION WITH
   THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
/* **********************************************************************
    Copyright 2005 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
*/
package org.bedework.calcore.hibernate;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.BwAuthUserPrefs;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.calfacade.svc.UserAuthRO;

import java.util.Collection;
import java.util.TreeSet;
import org.apache.log4j.Logger;

/** Implementation of UserAuth that handles UW DB tables for authorisation.
 *
 * @author Mike Douglass    douglm@rpi.edu
 * @version 1.0
 */
public class UserAuthUWDbImpl implements UserAuth {
  /** Ideally this would trigger the debugging log in the underlying jdbc
   * implementation.
   */
  private boolean debug = false;

  private transient Logger log;

  protected CallBack cb;

  /** Current user access
   */
  private int curUsertype = noPrivileges;

  private String curUser;

  private UserAuthRO userAuthRO;

  /** Constructor
   */
  public UserAuthUWDbImpl() {
  }

  /* ====================================================================
   *  The following affect the state of the current user.
   * ==================================================================== */

  /** Initialise the implementing object. This method may be called repeatedly
   * with the same or different classes of object.
   *
   * <p>This is not all that well-defined. This area falls somewhere
   * between the back-end and the front-end, depending upon how a site
   * implements its authorisation.
   *
   * <p>To make this interface independent of any particular implementation
   * we make the parameter an Object. We will call this method early on in
   * the life of a web session giving it the incoming request. This allows
   * a role-driven implementation to determine what roles the user has. The
   * object may choose to adjust that users rights at each request or ignore
   * subsequent calls (though note that some containers recheck a users
   * rights periodically)
   *
   * <p>A database driven implementation is free to ignore the call
   * altogether.
   *
   * <p> To summarise: this method will be called with an HttpServletRequest
   * object.
   *
   * @param  userid    user whose access we are setting
   * @param  cb        CallBack object
   * @param  val        Object
   * @exception CalFacadeException If there's a problem
   */
  public void initialise(String userid, CallBack cb,
                         Object val) throws CalFacadeException {
    curUser = userid;
    this.cb = cb;

    if (userid != null) {
      curUsertype = getUsertype(userid);
    }
    userAuthRO = null;
    debug = getLogger().isDebugEnabled();
  }

  /** Initialise the implementing object with an access level.
   *
   * <p>At UW the supplied access is ignored and the current access level set
   * from the database.
   *
   * @param  userid    user whose access we are setting
   * @param  cb        CallBack object
   * @param  val       int sum  of allowable access.
   * @exception CalFacadeException If there's a problem
   */
  public void initialise(String userid, CallBack cb,
                         int val) throws CalFacadeException {
    curUser = userid;
    this.cb = cb;

    if (userid != null) {
      curUsertype = getUsertype(userid);
    }
    userAuthRO = null;
    debug = getLogger().isDebugEnabled();
  }

  /** Reinitialise the implementing object on subsequent entries.
   *
   * @param  cb        CallBack object
   * @exception CalFacadeException If there's a problem
   */
  public void reinitialise(CallBack cb) throws CalFacadeException {
    this.cb = cb;
  }

  /*  ===================================================================
   *  The following return the state of the current user.
   *  =================================================================== */

  /** Return the current userid. If non-null this object has been
   * initialised otherwise one of the initialsie methods must be called.
   *
   * @return String          non-null for initialised object.
   * @exception CalFacadeException If there's a problem
   */
  public String getUserid() throws CalFacadeException {
    return curUser;
  }

  /** Return a read only object represeting the state of the current user.
   *
   * @return UserAuthRO        object representing user state
   * @exception CalFacadeException If there's a problem
   */
  public UserAuthRO getUserAuthRO() throws CalFacadeException {
    if (userAuthRO == null) {
      userAuthRO = new UserAuthRO(curUser, curUsertype);
    }

    return userAuthRO;
  }

  /** Return the type of the current user.
   *
   * @return int        user type as defined above,
   * @exception CalFacadeException If there's a problem
   */
  public int getUsertype() throws CalFacadeException {
    return curUsertype;
  }

  /** Check for priv user
   *
   * @return boolean    true for super user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isSuperUser() throws CalFacadeException {
    return (curUsertype & superUser) != 0;
  }

  /** Check for alert user
   *
   * @return boolean    true for alert user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isAlertUser() throws CalFacadeException {
    return (curUsertype & alertUser) != 0;
  }

  /** Check for public events owner user
   *
   * @return boolean    true for public events owner user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isOwnerUser() throws CalFacadeException {
    return (curUsertype & publicEventUser) != 0;
  }

  /** Check for content admin user
   *
   * @return boolean    true for content admin user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isContentAdminUser() throws CalFacadeException {
    return (curUsertype & contentAdminUser) != 0;
  }

  /** ===================================================================
   *  The following should not change the state of the current users
   *  access which is set and retrieved with the above methods.
   *  =================================================================== */

  /** Show whether user entries can be displayed or modified with this
   * class. Some sites may use other mechanisms.
   *
   * @return boolean    true if user maintenance is implemented.
   */
  public boolean getUserMaintOK() {
    return true;
  }

  /** Return the type of the user.
   *
   * @param  userid     String user id
   * @return int        user type as defined above,
   * @exception CalFacadeException If there's a problem
   */
  public int getUsertype(String userid) throws CalFacadeException {
    BwAuthUser au = getUser(userid);

    if (au == null) {
      return noPrivileges;
    }

    return au.getUsertype();
  }

  /** Set the type of the user.
   *
   * @param  userid     String user id
   * @param  utype      int user type as defined above,
   * @exception CalFacadeException If there's a problem
   */
  public void setUsertype(String userid, int utype)
          throws CalFacadeException {
    throw new CalFacadeException("Unimplemented");
  }

  /** Adjust the user type to ensure all the super user privileges are
   * set.
   *
   * @param userType    int unadjusted user type.
   * @return int   adjusted user type.
   * @exception CalFacadeException   For invalid usertype values.
   */
  public int adjustUsertype(int userType) throws CalFacadeException {
    if ((userType & ~allAuth) != 0) {
      throw new CalFacadeException("Invalid authorised user type: " + userType);
    }

    if ((userType & superUser) != 0) {
      return allAuth;
    }

    /** We'll allow any combination of the remaining flags.
     */
    return userType;
  }

  /** Just see if the user has any special privileges.
   * Same as getUserType(userid) != noPrivileges;
   *
   * @param  userid     String user id
   * @return boolean true if the user has any special privileges
   * @exception CalFacadeException If there's a problem
   */
  public boolean isAuthorised(String userid) throws CalFacadeException {
    return getUser(userid).getUsertype() != noPrivileges;
  }

  /** Check for priv user
   * Same as getUserType(userid) == superUser;
   *
   * @param  userid     String user id
   * @return boolean    true for super user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isSuperUser(String userid) throws CalFacadeException {
    return getUser(userid).getUsertype() == superUser;
  }

  /** Remove any special authorisation for this user.
   *
   * <p>For this implementation, we remove them from the table.
   *
   * @param  val      AuthUserVO users entry
   * @exception CalFacadeException If there's a problem
   */
  public void removeAuth(BwAuthUser val) throws CalFacadeException {
    getSess().delete(val);
  }

  public void updateUser(BwAuthUser val) throws CalFacadeException {
//    BwAuthUser dbEntry = getUserEntry(val.getUser());

    if (val.getUsertype() == noPrivileges) {
      // Delete it
//      if (dbEntry != null) {
        removeAuth(val);
//      }

      return;
    }

//    if (dbEntry == null) {
//      addAuth(val);
//      return;
//    }

    updateUserEntry(val);
  }

  public BwAuthUser getUser(String account) throws CalFacadeException {
    return getUserEntry(account);
  }

  public BwAuthUser getUser(BwUser user) throws CalFacadeException {
    return getUserEntry(user);
  }

  public Collection getAll() throws CalFacadeException {
    HibSession sess = getSess();

    sess.namedQuery("getAllAuthUsers");

    return sess.getList();
  }

  /* ====================================================================
   *                          Protected methods
   * ==================================================================== */

  protected BwAuthUser getUserEntry(String account) throws CalFacadeException {
    if (debug) {
      trace("getUserEntry for " + account + " as " + curUser);
    }

    return getUserEntry(cb.getUser(account));
  }

  protected BwAuthUser getUserEntry(BwUser u) throws CalFacadeException {
    if (debug) {
      trace("getUserEntry for user " + u);
    }

    if (u == null) {
      return null;
    }

    BwAuthUser au = null;

    HibSession sess = getSess();

    Object o = sess.get(BwAuthUser.class, u.getId());
    if (o != null) {
      au = (BwAuthUser)o;
    } else {
      sess.createQuery("from " + BwAuthUser.class.getName() + " as au " +
                       "where au = :user");
      sess.setEntity("user", u);

      au = (BwAuthUser)sess.getUnique();
    }

    if (au == null) {
      return null;
    }

    BwAuthUserPrefs prefs = au.getPrefs();

    if (prefs == null) {
      prefs = new BwAuthUserPrefs();
      prefs.setAuthUser(au);

      prefs.setAutoAddCategories(true);
      prefs.setAutoAddLocations(true);
      prefs.setAutoAddSponsors(true);
      prefs.setAutoAddCalendars(true);

      prefs.setPreferredCategories(new TreeSet());
      prefs.setPreferredLocations(new TreeSet());
      prefs.setPreferredSponsors(new TreeSet());
      prefs.setPreferredCalendars(new TreeSet());

      sess.save(prefs);

      au.setPrefs(prefs);
    }

    return au;
  }

  /** Update the given user entry.
   *
   * @param  val    AuthUserVO users entry
   * @exception CalFacadeException If there's a problem
   */
  protected void updateUserEntry(BwAuthUser val) throws CalFacadeException {
    HibSession sess = getSess();

    sess.saveOrUpdate(val);

    // try explicit prefs update
    BwAuthUserPrefs aup = val.getPrefs();
    if (aup != null) {
      sess.saveOrUpdate(aup);
    }
  }

  /** Add an entry to the authorization table
   *
   * @param  val            AuthUserVO object with at least the userid
   * @exception CalFacadeException If there's a problem
   */
  protected void addAuth(BwAuthUser val) throws CalFacadeException {
    getSess().saveOrUpdate(val);
  }

  protected void addPrefs(BwAuthUser val) throws CalFacadeException {
    BwAuthUserPrefs prefs = val.getPrefs();
    getSess().saveOrUpdate(prefs);
  }

  /*
  protected void getPrefs(BwAuthUser au) throws CalFacadeException {
    int id = au.getUser().getId();

    HibSession sess = getSess();
    BwAuthUserPrefs aup;

    Object o = sess.get(BwAuthUserPrefs.class, id);
    if (o != null) {
      aup = (BwAuthUserPrefs)o;
    } else {
      StringBuffer q = new StringBuffer();

      q.append("from ");
      q.append(BwAuthUserPrefs.class.getName());
      q.append(" as au where au.userid = :userid");

      sess.createQuery(q.toString());

      sess.setInt("userid", id);

      aup = (BwAuthUserPrefs)sess.getUnique();
    }

    au.setPrefs(aup);
  }
  */

  /* ====================================================================
   *                       Preferences methods
   * ==================================================================== */

  public void setAutoAddCategories(BwAuthUser user, boolean val)
      throws CalFacadeException {
    BwAuthUserPrefs prefs = user.getPrefs();

    if (val == prefs.getAutoAddCategories()) {
      return;
    }

    prefs.setAutoAddCategories(val);
    getSess().saveOrUpdate(prefs);
  }

  public boolean addCategory(BwAuthUser user, BwCategory key)
      throws CalFacadeException {
    BwAuthUserPrefs prefs = user.getPrefs();

    if (!prefs.addCategory(key)) {
      return false;
    }

    getSess().saveOrUpdate(prefs);

    return true;
  }

  public void removeCategory(BwAuthUser user, BwCategory cat)
      throws CalFacadeException {
    HibSession sess = getSess();

    if (user == null) {
      /* Remove from all */

      /* Removing all children seems difficult with hibernate
         cheat for the moment */
      sess.namedQuery("removeLocationForAll");
      sess.setInt("id", cat.getId());

      int removed = sess.executeUpdate();

      if (debug) {
        trace("removed " +removed + " locations from prefs");
      }

      return;
    }

    BwAuthUserPrefs prefs = user.getPrefs();

    if (!prefs.removeCategory(cat)) {
      return;
    }

    getSess().saveOrUpdate(prefs);
  }

  public void setAutoAddLocations(BwAuthUser user, boolean val)
      throws CalFacadeException {
    BwAuthUserPrefs prefs = user.getPrefs();

    if (val == prefs.getAutoAddLocations()) {
      return;
    }

    prefs.setAutoAddLocations(val);
    getSess().saveOrUpdate(prefs);
  }

  public boolean addLocation(BwAuthUser user, BwLocation loc)
      throws CalFacadeException {
    BwAuthUserPrefs prefs = user.getPrefs();

    if (!prefs.addLocation(loc)) {
      return false;
    }

    getSess().saveOrUpdate(prefs);

    return true;
  }

  public void removeLocation(BwAuthUser user, BwLocation loc)
      throws CalFacadeException {
    HibSession sess = getSess();

    if (user == null) {
      /* Remove from all */

      /* Removing all children seems difficult with hibernate
         cheat for the moment */
      sess.namedQuery("removeLocationForAll");
      sess.setInt("id", loc.getId());

      int removed = sess.executeUpdate();

      if (debug) {
        trace("removed " +removed + " locations from prefs");
      }

      return;
    }

    BwAuthUserPrefs prefs = user.getPrefs();

    if (!prefs.removeLocation(loc)) {
      return;
    }

    getSess().saveOrUpdate(prefs);
  }

  public void setAutoAddSponsors(BwAuthUser user, boolean val)
      throws CalFacadeException {
    BwAuthUserPrefs prefs = user.getPrefs();

    if (val == prefs.getAutoAddSponsors()) {
      return;
    }

    prefs.setAutoAddSponsors(val);
    getSess().saveOrUpdate(prefs);
  }

  public boolean addSponsor(BwAuthUser user, BwSponsor sp)
      throws CalFacadeException {
    BwAuthUserPrefs prefs = user.getPrefs();

    if (!prefs.addSponsor(sp)) {
      return false;
    }

    getSess().saveOrUpdate(prefs);

    return true;
  }

  public void removeSponsor(BwAuthUser user, BwSponsor sp)
      throws CalFacadeException {
    HibSession sess = getSess();

    if (user == null) {
      /* Remove from all */

      /* Removing all children seems difficult with hibernate
         cheat for the moment */
      sess.namedQuery("removeSponsorForAll");
      sess.setInt("id", sp.getId());

      int removed = sess.executeUpdate();

      if (debug) {
        trace("removed " +removed + " sponsors from prefs");
      }

      return;
    }

    BwAuthUserPrefs prefs = user.getPrefs();

    if (!prefs.removeSponsor(sp)) {
      return;
    }
    sess.saveOrUpdate(prefs);
  }

  public void setAutoAddCalendars(BwAuthUser user, boolean val)
      throws CalFacadeException {
    BwAuthUserPrefs prefs = user.getPrefs();

    if (val == prefs.getAutoAddCalendars()) {
      return;
    }

    prefs.setAutoAddCalendars(val);
    getSess().saveOrUpdate(prefs);
  }

  public boolean addCalendar(BwAuthUser user, BwCalendar loc)
      throws CalFacadeException {
    BwAuthUserPrefs prefs = user.getPrefs();

    if (!prefs.addCalendar(loc)) {
      return false;
    }

    getSess().saveOrUpdate(prefs);

    return true;
  }

  public void removeCalendar(BwAuthUser user, BwCalendar cal)
      throws CalFacadeException {
    HibSession sess = getSess();

    if (user == null) {
      /* Remove from all */

      /* Removing all children seems difficult with hibernate
         cheat for the moment */
      sess.namedQuery("removeCalendarForAll");
      sess.setInt("id", cal.getId());

      int removed = sess.executeUpdate();

      if (debug) {
        trace("removed " +removed + " calendars from prefs");
      }

      return;
    }

    BwAuthUserPrefs prefs = user.getPrefs();

    if (!prefs.removeCalendar(cal)) {
      return;
    }

    sess.saveOrUpdate(prefs);
  }

  /*  ===================================================================
   *                   Private methods
   *  =================================================================== */

  private HibSession getSess() throws CalFacadeException {
    HibSession sess = (HibSession)cb.getDbSession();
    if (sess == null) {
      throw new CalFacadeException("Null session returned");
    }

    return sess;
  }
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void trace(String msg) {
    getLogger().debug("trace: " + msg);
  }
}
