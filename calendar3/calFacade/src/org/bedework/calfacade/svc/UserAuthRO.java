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
package org.bedework.calfacade.svc;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;

import java.util.Collection;

/** A read-only implementation of UserAuth which can be used by applications
 * which want to expose the current access level safely to the outside world.
 *
 * Web-applications for example should not expose the UserAuth methods to
 * the struts request handling mechanism.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 2.2
 */
public class UserAuthRO implements UserAuth {
  /** Current user access
   */
  private int curUsertype = noPrivileges;

  private String curUser;

  /** Create the object with an access level.
   *
   * @param  userid    user whose access we are setting
   * @param  val       int sum  of allowable access.
   */
  public UserAuthRO(String userid, int val) {
    curUser = userid;
    curUsertype = val;
  }

  /**
   * @param  userid    user whose access we are setting
   * @param  cb        CallBack object
   * @param  val        Object
   * @exception CalFacadeException If there's a problem
   */
  public void initialise(String userid, CallBack cb,
                         Object val,
                         boolean debug) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /** Initialise the implementing object with an access level.
   *
   * <p>This is not all that well-defined. This area falls somewhere
   * between the back-end and the front-end, depending upon how a site
   * implements its authorisation.
   *
   * <p>This allows role-based implementations using the standard servlet
   * authorization model to indicate what roles a user has. This may not get
   * called or it may be called and ignored.
   *
   * <p>This method should not update any underlying directory.
   *
   * <p>Any implementation is free to ignore the call altogether.
   * Alternatively an implementation may choose to base the access on the
   * supplied user and ignore the supplied access.
   *
   * @param  userid    user whose access we are setting
   * @param  cb        CallBack object
   * @param  val       int sum  of allowable access.
   * @exception CalFacadeException If there's a problem
   */
  public void initialise(String userid, CallBack cb,
                         int val,
                         boolean debug) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /** Reinitialise the implementing object on subsequent entries.
   *
   * @param  cb        CallBack object
   * @exception CalFacadeException If there's a problem
   */
  public void reinitialise(CallBack cb) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /** ===================================================================
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
    return this;
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
    return false;
  }

  /** Return the type of the user.
   *
   * @param  userid     String user id
   * @return int        user type as defined above,
   * @exception CalFacadeException If there's a problem
   */
  public int getUsertype(String userid) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /** Set the type of the user.
   *
   * @param  userid     String user id
   * @param  utype      int user type as defined above,
   * @exception CalFacadeException If there's a problem
   */
  public void setUsertype(String userid, int utype)
          throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /** Adjust the user type to ensure all the super user privileges are
   * set.
   *
   * @param userType    int unadjusted user type.
   * @return int   adjusted user type.
   * @exception CalFacadeException   For invalid usertype values.
   */
  public int adjustUsertype(int userType) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /** Just see if the user has any special privileges.
   * Same as getUserType(userid) != noPrivileges;
   *
   * @param  userid     String user id
   * @return boolean true if the user has any special privileges
   * @exception CalFacadeException If there's a problem
   */
  public boolean isAuthorised(String userid) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /** Check for priv user
   * Same as getUserType(userid) == superUser;
   *
   * @param  userid     String user id
   * @return boolean    true for super user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isSuperUser(String userid) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /** Remove any special authorisation for this user
   *
   * @param  val      AuthUserVO users entry
   * @exception CalFacadeException If there's a problem
   */
  public void removeAuth(BwAuthUser val) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.UserAuth#updateUser(org.bedework.calfacade.svc.BwAuthUser)
   */
  public void updateUser(BwAuthUser val) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.UserAuth#getUser(java.lang.String)
   */
  public BwAuthUser getUser(String userid) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.UserAuth#getUser(org.bedework.calfacade.BwUser)
   */
  public BwAuthUser getUser(BwUser u) throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.UserAuth#getAll()
   */
  public Collection getAll() throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  /* ====================================================================
   *                       Preferences methods
   * ==================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.UserAuth#setAutoAddCategories(org.bedework.calfacade.svc.BwAuthUser, boolean)
   */
  public void setAutoAddCategories(BwAuthUser user, boolean val)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public boolean addCategory(BwAuthUser user, BwCategory key)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public void removeCategory(BwAuthUser user, BwCategory key)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public void setAutoAddLocations(BwAuthUser user, boolean val)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public boolean addLocation(BwAuthUser user, BwLocation loc)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public void removeLocation(BwAuthUser user, BwLocation loc)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public void setAutoAddSponsors(BwAuthUser user, boolean val)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public boolean addSponsor(BwAuthUser user, BwSponsor sp)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public void removeSponsor(BwAuthUser user, BwSponsor sp)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public void setAutoAddCalendars(BwAuthUser user, boolean val)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public boolean addCalendar(BwAuthUser user, BwCalendar val)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }

  public void removeCalendar(BwAuthUser user, BwCalendar val)
      throws CalFacadeException {
    throw new CalFacadeException("Method not accessible");
  }
}
