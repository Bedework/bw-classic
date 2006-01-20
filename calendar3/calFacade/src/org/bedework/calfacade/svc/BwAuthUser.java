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
package org.bedework.calfacade.svc;

import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeDefs;

import java.io.Serializable;

/** Value object to represent an authorised calendar user - that is a user
 * with some special privilege. This could also be represented by users
 * with roles.
 *
 *   @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwAuthUser implements Serializable {
  private int id = CalFacadeDefs.unsavedItemKey;
  protected BwUser user;  // Related user entry

  protected BwAuthUserPrefs prefs;  // Related user prefs entry

  private int usertype;

  /* ====================================================================
   *                   Constructors
   * ==================================================================== */

  /** No-arg constructor
   */
  public BwAuthUser() {
  }

  /** Create an authuser vo by specifying all its fields
   *
   * @param  user           UserVO object representing user
   * @param  usertype       int type of user
    */
  public BwAuthUser(BwUser user,
                    int usertype) {
    this.user = user;
    this.usertype = usertype;
  }

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

  /**    Set the id
   * @param val   id
   */
  public void setId(int val) {
    id = val;
  }

  /** Get the unique id
   *
   * @return int    the unique id
   */
  public int getId() {
    return id;
  }

  /**
   * @param val
   */
  public void setUser(BwUser val) {
    user = val;
  }

  /**
   * @return  BwUser user entry
   */
  public BwUser getUser() {
    return user;
  }

  /**
   * @param val
   */
  public void setPrefs(BwAuthUserPrefs val) {
    prefs = val;
  }

  /**
   * @return  BwAuthUserPrefs auth prefs
   */
  public BwAuthUserPrefs getPrefs() {
    return prefs;
  }

  /**
   * @param val
   */
  public void setUsertype(int val) {
    usertype = adjustUsertype(val);
  }

  /**
   * @return  int user type
   */
  public int getUsertype() {
    return usertype;
  }

  /* ====================================================================
   *                      Convenience methods
   * ==================================================================== */

  /**
   * @return boolean true for alert user
   */
  public boolean isAlertUser() {
    return ((getUsertype() & UserAuth.alertUser) != 0);
  }

  /**
   * @return boolean true for public event user
   */
  public boolean isPublicEventUser() {
    return ((getUsertype() & UserAuth.publicEventUser) != 0);
  }

  /**
   * @return boolean true for super user
   */
  public boolean isSuperUser() {
    return ((getUsertype() & UserAuth.superUser) != 0);
  }

  /* ====================================================================
   *                        Private methods
   * ==================================================================== */

  /* Adjust the user type.
   *
   * <p>This routine should ensure all the super user privileges are
   * set.
   *
   * @param userType    int unadjusted user type.
   * @return int   adjusted user type.
   * @exception CalFacadeException   For invalid usertype values.
   */
  private int adjustUsertype(int userType) {
    if ((userType & ~UserAuth.allAuth) != 0) {
      throw new RuntimeException("Invalid authorised user type: " + userType);
    }

    if ((userType & UserAuth.superUser) != 0) {
      return UserAuth.allAuth;
    }

    /** We'll allow any combination of the remaining flags.
     */
    return userType;
  }

  /* ====================================================================
   *                        Object methods
   * ==================================================================== */

  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (!(obj instanceof BwAuthUser)) {
      return false;
    }

    BwAuthUser that = (BwAuthUser)obj;

    return getUser().equals(that.getUser());
  }

  public int hashCode() {
    return 7 * getUser().hashCode();
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwAuthUser{user=");
    sb.append(getUser());
    sb.append(", usertype=");
    sb.append(getUsertype());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    BwUser u = (BwUser)getUser().clone();

    BwAuthUser au = new BwAuthUser(u, getUsertype());

    BwAuthUserPrefs aup = getPrefs();

    if (aup != null) {
      aup = (BwAuthUserPrefs)aup.clone();
      aup.setAuthUser(au);

      au.setPrefs(aup);
    }

    return au;
  }
}
