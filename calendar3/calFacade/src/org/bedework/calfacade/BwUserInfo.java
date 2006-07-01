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
package org.bedework.calfacade;

import org.bedework.calfacade.base.BwDbentity;
import org.bedework.calfacade.util.CalFacadeUtil;
import org.bedework.calfacade.BwUser;

import java.util.Collection;
import java.util.TreeSet;

/** This class represent directory style information for the user. It will be
 * retrieved form a pluggable class which either stores it locally in the db or
 * uses a directory to retrieve the information.
 *
 *  @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwUserInfo extends BwDbentity {
  protected BwUser user;  // Related user entry

  private String lastname;
  private String firstname;
  private String phone;
  private String email;
  private String dept;

  /** Class for properties collection.
   */
  public static class UserProperty implements Comparable {
    /** Name of property */
    public String name;
    /** Value of proerty */
    public String val;

    /**
     * @param val
     */
    public void setName(String val) {
      name = val;
    }

    /**
     * @return  String name
     */
    public String getName() {
      return name;
    }

    /**
     * @param val
     */
    public void setVal(String val) {
      this.val = val;
    }

    /**
     * @return  String val
     */
    public String getVal() {
      return val;
    }

    public int compareTo(Object o) {
      if (this == o) {
        return 0;
      }

      if (!(o instanceof UserProperty)) {
        return 1;
      }

      UserProperty that = (UserProperty)o;

      int ret = CalFacadeUtil.compareStrings(name, that.name);
      if (ret == 0) {
        ret = CalFacadeUtil.compareStrings(val, that.val);
      }

      return ret;
    }
  }

  /* collection of UerProperty */
  private Collection properties;

  /* ====================================================================
   *                   Constructors
   * ==================================================================== */

  /** No-arg constructor
   */
  public BwUserInfo() {
  }

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

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
  public void setLastname(String val) {
    lastname = val;
  }

  /**
   * @return  String last name
   */
  public String getLastname() {
    return lastname;
  }

  /**
   * @param val
   */
  public void setFirstname(String val) {
    firstname = val;
  }

  /**
   * @return  String firstname
   */
  public String getFirstname() {
    return firstname;
  }

  /**
   * @param val
   */
  public void setPhone(String val) {
    phone = val;
  }

  /**
   * @return  String phone
   */
  public String getPhone() {
    return phone;
  }

  /**
   * @param val
   */
  public void setEmail(String val) {
    email = val;
  }

  /**
   * @return  String email
   */
  public String getEmail() {
    return email;
  }

  /**
   * @param val
   */
  public void setDept(String val) {
    dept = val;
  }

  /**
   * @return  String dept
   */
  public String getDept() {
    return dept;
  }

  /** The properties are any other properties thought to be useful. All of type
   * UserProperty.
   *
   * @param val
   */
  public void setProperties(Collection val) {
    properties = val;
  }

  /**
   * @return Collection of UserProperty
   */
  public Collection getProperties() {
    if (properties == null) {
      properties = new TreeSet();
    }
    return properties;
  }

  /* ====================================================================
   *                        Convenience methods
   * ==================================================================== */

  /**
   * @param val
   */
  public void addProperty(UserProperty val) {
    Collection c = getProperties();
    if (!c.contains(val)) {
      c.add(val);
    }
  }
  /* ====================================================================
   *                        Object methods
   * ==================================================================== */

  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (!(obj instanceof BwUserInfo)) {
      return false;
    }

    BwUserInfo that = (BwUserInfo)obj;

    return getUser().equals(that.getUser());
  }

  public int hashCode() {
    return 7 * getUser().hashCode();
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwUserInfo{");

    toStringSegment(sb);
    sb.append("user=");
    sb.append(userid(getUser()));
    sb.append(", lastName=");
    sb.append(getLastname());
    sb.append("}");

    return sb.toString();
  }
}
