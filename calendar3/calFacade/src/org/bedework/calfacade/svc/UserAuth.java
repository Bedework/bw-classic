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

import java.io.Serializable;
import java.util.Collection;

/** An interface to define an application based authorisation method.
 *
 * <p>The actual authorisation of the user will be site specific.
 * For example, if we are using a roles based scheme, the implementation of
 * this interface will check the current users role.
 *
 * <p>There is no method to add a user as we are simply giving users certain
 * rights. The underlying implementation may choose to use a database and
 * remove those entries for which there are no special rights.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 2.2
 */
public interface UserAuth extends Serializable {
  /** Define the various access levels. Note these are powers of two so
   * we can add them up.
   */
  public static final int noPrivileges = 0;

  /** Not one who stays awake but one who can add alerts
   */
  public static final int alertUser = 2;

  /** A user who can add public events
   */
  public static final int publicEventUser = 64;

  /** A user who can administer any content
   */
  public static final int contentAdminUser = 128;

  /** One who can do everything
   */
  public static final int superUser = 32768;

  /** Useful value.
   */
  public static final int allAuth = alertUser +
                                    publicEventUser +
                                    contentAdminUser +
                                    superUser;

  /** Class to be implemented by caller and passed during init.
   */
  public static abstract class CallBack implements Serializable {
    /**
     * @param account
     * @return BwUser represented by account
     * @throws CalFacadeException
     */
    public abstract BwUser getUser(String account) throws CalFacadeException;

    /**
     * @param id
     * @return BwUser with the given id
     * @throws CalFacadeException
     */
    public abstract BwUser getUser(int id) throws CalFacadeException;

    /**
     * @param user
     * @throws CalFacadeException
     */
    public abstract void addUser(BwUser user) throws CalFacadeException;

    /** Allows this class to be passed to other admin classes
     *
     * @return UserAuth
     * @throws CalFacadeException
     */
    public abstract UserAuth getUserAuth() throws CalFacadeException;

    /** An implementation specific method allowing access to the underlying
     * persisitance engine. This may return, for example, a Hibernate session,
     *
     * @return Object    db session
     * @throws CalFacadeException
     */
    public abstract Object getDbSession() throws CalFacadeException;
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
   * the life of a web session giving it the request. This allows
   * a role-driven implementation to determine what roles the user has. The
   * object may choose to adjust that users rights at each request or ignore
   * subsequent calls (though note that some containers recheck a users
   * rights periodically)
   *
   * <p>Any implementation is free to ignore the call
   * altogether.
   *
   * @param  userid    user whose access we are setting
   * @param  cb        CallBack object
   * @param  val        Object
   * @param debug
   * @exception CalFacadeException If there's a problem
   */
  public void initialise(String userid, CallBack cb,
                         Object val,
                         boolean debug) throws CalFacadeException;

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
   * @param debug
   * @exception CalFacadeException If there's a problem
   */
  public void initialise(String userid, CallBack cb,
                         int val,
                         boolean debug) throws CalFacadeException;

  /** ===================================================================
   *  The following return the state of the current user.
   *  =================================================================== */

  /** Return the current userid. If non-null this object has been
   * initialised otherwise one of the initialsie methods must be called.
   *
   * @return String          non-null for initialised object.
   * @exception CalFacadeException If there's a problem
   */
  public String getUserid() throws CalFacadeException;

  /** Return a read only object represeting the state of the current user.
   *
   * @return UserAuthRO        object representing user state
   * @exception CalFacadeException If there's a problem
   */
  public UserAuthRO getUserAuthRO() throws CalFacadeException;

  /** Return the type of the current user.
   *
   * @return int        user type as defined above,
   * @exception CalFacadeException If there's a problem
   */
  public int getUsertype() throws CalFacadeException;

  /** Check for priv user
   *
   * @return boolean    true for super user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isSuperUser() throws CalFacadeException;

  /** Check for alert user
   *
   * @return boolean    true for alert user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isAlertUser() throws CalFacadeException;

  /** Check for public events owner user
   *
   * @return boolean    true for public events owner user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isOwnerUser() throws CalFacadeException;

  /** Check for content admin user
   *
   * @return boolean    true for content admin user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isContentAdminUser() throws CalFacadeException;

  /** ===================================================================
   *  The following should not change the state of the current users
   *  access which is set and retrieved with the above methods.
   *  =================================================================== */

  /** Show whether user entries can be displayed or modified with this
   * class. Some sites may use other mechanisms.
   *
   * <p>This may need supplementing with changes to the jsp. For example,
   * it's hard to deal programmatically with the case of directory/roles
   * based authorisation and db based user information.
   *
   * @return boolean    true if user maintenance is implemented.
   */
  public boolean getUserMaintOK();

  /** Return the type of the user.
   *
   * @param  userid     String user id
   * @return int        user type as defined above,
   * @exception CalFacadeException If there's a problem
   */
  public int getUsertype(String userid) throws CalFacadeException;

  /** Set the type of the user.
   *
   * @param  userid     String user id
   * @param  utype      int user type as defined above,
   * @exception CalFacadeException If there's a problem
   */
  public void setUsertype(String userid, int utype)
          throws CalFacadeException;

  /** Adjust the user type to enure all the super user privileges are
   * set.
   *
   * @param userType    int unadjusted user type.
   * @return int   adjusted user type.
   * @exception CalFacadeException   For invalid usertype values.
   */
  public int adjustUsertype(int userType) throws CalFacadeException;

  /** Just see if the user has any special privileges.
   * Same as getUserType(userid) != noPrivileges;
   *
   * @param  userid     String user id
   * @return boolean true if the user has any special privileges
   * @exception CalFacadeException If there's a problem
   */
  public boolean isAuthorised(String userid) throws CalFacadeException;

  /** Check for priv user
   * Same as getUserType(userid) == superUser;
   *
   * @param  userid     String user id
   * @return boolean    true for super user
   * @exception CalFacadeException If there's a problem
   */
  public boolean isSuperUser(String userid) throws CalFacadeException;

  /** Remove any special authorisation for this user
   *
   * @param  val      AuthUserVO users entry
   * @throws CalFacadeException
   */
  public void removeAuth(BwAuthUser val) throws CalFacadeException;

  /** Update the user entry
   *
   * @param  val      AuthUserVO users entry
   * @throws CalFacadeException
   */
  public void updateUser(BwAuthUser val) throws CalFacadeException;

  /** Return the given authorised user. Will always return an entry (except for
   * exceptional conditions.) An unauthorised user will have a usertype of
   * noPrivileges.
   *
   * @param  userid        String user id
   * @return AuthUserVO    users entry
   * @throws CalFacadeException
   */
  public BwAuthUser getUser(String userid) throws CalFacadeException;

  /** Return the given authorised user. Will always return an entry (except for
   * exceptional conditions.) An unauthorised user will have a usertype of
   * noPrivileges.
   *
   * @param  u             BwUser entry
   * @return AuthUserVO    users entry
   * @throws CalFacadeException
   */
  public BwAuthUser getUser(BwUser u) throws CalFacadeException;

  /** Return a collection of all authorised users
   *
   * @return Collection      of AuthUserVO for users with any special authorisation.
   * @throws CalFacadeException
   */
  public Collection getAll() throws CalFacadeException;

  /* ====================================================================
   *                       Preferences methods
   * ==================================================================== */

  /** Set the value in the user record. If it's changed update the database.
   *
   * @param user
   * @param val
   * @throws CalFacadeException
   */
  public void setAutoAddCategories(BwAuthUser user, boolean val)
      throws CalFacadeException;

  /** Add a category key to the preferred categories. Return true if it was
   * added, false if it was in the list.
   *
   * @param user
   * @param key
   * @return boolean if added
   * @throws CalFacadeException
   */
  public boolean addCategory(BwAuthUser user, BwCategory key)
      throws CalFacadeException;

  /** Remove a category preference for the given user if supplied or all users
   * if user is null.
   *
   * @param user   AuthUserVO entry for user or null for all users
   * @param key    category in the entry to remove
   * @throws CalFacadeException
   */
  public void removeCategory(BwAuthUser user, BwCategory key)
      throws CalFacadeException;

  /** Set the value in the user record. If it's changed update the database.
   *
   * @param user
   * @param val
   * @throws CalFacadeException
   */
  public void setAutoAddLocations(BwAuthUser user, boolean val)
      throws CalFacadeException;

  /** Add a location key to the preferred locations. Return true if it was
   * added, false if it was in the list.
   *
   * @param user
   * @param loc
   * @return boolean if added
   * @throws CalFacadeException
   */
  public boolean addLocation(BwAuthUser user, BwLocation loc)
      throws CalFacadeException;

  /** Remove a location preference for the given user if supplied or all users
   * if user is null.
   *
   * @param user   AuthUserVO entry for user or null for all users
   * @param loc    location in the entry to remove
   * @throws CalFacadeException
   */
  public void removeLocation(BwAuthUser user, BwLocation loc)
      throws CalFacadeException;

  /** Set the value in the user record. If it's changed update the database.
   *
   * @param user
   * @param val
   * @throws CalFacadeException
   */
  public void setAutoAddSponsors(BwAuthUser user, boolean val)
      throws CalFacadeException;

  /** Add a sponsor to the preferred sponsors. Return true if it was
   * added, false if it was in the list.
   *
   * @param user
   * @param sp
   * @return boolean if added
   * @throws CalFacadeException
   */
  public boolean addSponsor(BwAuthUser user, BwSponsor sp)
      throws CalFacadeException;

  /** Remove a sponsor preference for the given user if supplied or all users
   * if user is null.
   *
   * @param user   AuthUserVO entry for user or null for all users
   * @param sp    sponsor in the entry to remove
   * @throws CalFacadeException
   */
  public void removeSponsor(BwAuthUser user, BwSponsor sp)
      throws CalFacadeException;

  /** Set the value in the user record. If it's changed update the database.
   *
   * @param user
   * @param val
   * @throws CalFacadeException
   */
  public void setAutoAddCalendars(BwAuthUser user, boolean val)
      throws CalFacadeException;

  /** Add a calendar key to the preferred calendars. Return true if it was
   * added, false if it was in the list.
   *
   * @param user
   * @param val
   * @return boolean if added
   * @throws CalFacadeException
   */
  public boolean addCalendar(BwAuthUser user, BwCalendar val)
      throws CalFacadeException;

  /** Remove a calendar preference for the given user if supplied or all users
   * if user is null.
   *
   * @param user   AuthUserVO entry for user or null for all users
   * @param val    calendar in the entry to remove
   * @throws CalFacadeException
   */
  public void removeCalendar(BwAuthUser user, BwCalendar val)
      throws CalFacadeException;
}
