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

import edu.rpi.cct.uwcal.access.AccessPrincipal;

import java.sql.Timestamp;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.TreeSet;

/** Value object to represent a calendar principal. Principals may be users,
 * groups or other special obects. Principals may own objects within the
 * system or simply identify a client to the system.
 *
 * <p>We need to address a problem that might occur with groups. If we choose
 * to allow a group all the facilities of a single user (subscriptions,
 * ownership etc) then we need to be careful with names and their uniqueness.
 *
 * <p>That is to say, the name will probably not be unique, for example, I might
 * have the id douglm and be a member of the group douglm.
 *
 * <p>Allowing groups all the rights of a user gives us the current functionality
 * of administrative groups as well as the functions we need for departmental
 * sites.
 *
 *   @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public abstract class BwPrincipal extends BwDbentity
                                  implements AccessPrincipal, Comparator {
  /** The internal name by which this principal is identified, unique within
   * its class
   */
  private String account;  // null for guest

  protected Timestamp created;

  /** Last time we saw this principal appear in our system.
   */
  protected Timestamp logon;

  /** Last time principal did something in our system.
   */
  protected Timestamp lastAccess;

  /** Last time principal modified something in our system.
   */
  protected Timestamp lastModify;

  /** Default access to category entries
   */
  protected String categoryAccess;

  /** Default access to sponsor entries
   */
  protected String sponsorAccess;

  /** Default access to location entries
   */
  protected String locationAccess;

  /* ...................................................................
              Non-db fields
     .................................................................... */

  /* groups of which this user is a member */
  protected Collection groups;

  // Derived from the groups.
  protected Collection groupNames;

  // For acl evaluation
  protected AccessPrincipal aclPrincipal;

  /* ====================================================================
   *                   Constructors
   * ==================================================================== */

  /** Create a guest PrincipalVO
   */
  public BwPrincipal() {
    this(null);
  }

  /** Create a PrincipalVO usually based on a single string name from an object,
   * e.g., an event.
   *
   * @param  account            String user id for database
   */
  public BwPrincipal(String account) {
    this.account = account;
  }

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

  /**
   * @return int kind
   */
  public abstract int getKind();

  /** Set the unauthenticated state.
   *
   * @param val
   */
  public void setUnauthenticated(boolean val) {
    if (val) {
      setAccount(null);
    }
  }

  /**
   * @return  boolean authenticated state
   */
  public boolean getUnauthenticated() {
    return getAccount() == null;
  }

  /**
   * @param val
   */
  public void setAccount(String val) {
    account = val;
  }

  /**
   * @return  String account name
   */
  public String getAccount() {
    return account;
  }

  /**
   * @param val
   */
  public void setCreated(Timestamp val) {
    created = val;
  }

  /**
   * @return Timestamp created
   */
  public Timestamp getCreated() {
    return created;
  }

  /**
   * @param val
   */
  public void setLogon(Timestamp val) {
    logon = val;
  }

  /**
   * @return Timetstamp last logon
   */
  public Timestamp getLogon() {
    return logon;
  }

  /**
   * @param val
   */
  public void setLastAccess(Timestamp val) {
    lastAccess = val;
  }

  /**
   * @return Timestamp last access
   */
  public Timestamp getLastAccess() {
    return lastAccess;
  }

  /**
   * @param val
   */
  public void setLastModify(Timestamp val) {
    lastModify = val;
  }

  /**
   * @return Timestamp last mod
   */
  public Timestamp getLastModify() {
    return lastModify;
  }

  /**
   * @param val The categoryAccess to set.
   */
  public void setCategoryAccess(String val) {
    categoryAccess = val;
  }

  /**
   * @return Returns the categoryAccess.
   */
  public String getCategoryAccess() {
    return categoryAccess;
  }

  /**
   * @param val The locationAccess to set.
   */
  public void setLocationAccess(String val) {
    locationAccess = val;
  }

  /**
   * @return Returns the locationAccess.
   */
  public String getLocationAccess() {
    return locationAccess;
  }

  /**
   * @param val The sponsorAccess to set.
   */
  public void setSponsorAccess(String val) {
    sponsorAccess = val;
  }

  /**
   * @return Returns the sponsorAccess.
   */
  public String getSponsorAccess() {
    return sponsorAccess;
  }

  /** Set of groups of which principal is a member
   *
   * @param val        Collection of BwPrincipal
   */
  public void setGroups(Collection val) {
    groupNames = null;
    groups = val;
  }

  /** Get the groups of which principal is a member.
   *
   * @return Collection    of BwPrincipal
   */
  public Collection getGroups() {
    if (groups == null) {
      groups = new TreeSet();
    }
    return groups;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /**
   * @param val BwPrincipal
   */
  public void addGroup(BwPrincipal val) {
    getGroups().add(val);
  }

  /**
   * @return  Iterator over BwPrincipal
   */
  public Iterator iterateGroups() {
    return getGroups().iterator();
  }

  /**
   * @return boolean true for a guest principal
   */
  public boolean isUnauthenticated() {
    return account == null;
  }

  /** Set of groupNames of which principal is a member
   *
   * @param val        Set of String
   */
  public void setGroupNames(Collection val) {
    groupNames = val;
  }

  /** Get the group names of which principal is a member.
   *
   * @return Set    of String
   */
  public Collection getGroupNames() {
    if (groupNames == null) {
      groupNames = new TreeSet();
      Iterator it = iterateGroups();
      while (it.hasNext()) {
        BwPrincipal group = (BwPrincipal)it.next();
        groupNames.add(group.getAccount());
      }
    }
    return groupNames;
  }

  protected void toStringSegment(StringBuffer sb) {
    super.toStringSegment(sb);
    sb.append(", account=");
    sb.append(account);
    sb.append(", created=");
    sb.append(created);
    sb.append(", logon=");
    sb.append(logon);
    sb.append(", lastAccess=");
    sb.append(lastAccess);
    sb.append(", lastModify=");
    sb.append(lastModify);
    sb.append(", kind=");
    sb.append(getKind());
  }

  /** Add a principal to the StringBuffer
   *
   * @param sb    StringBuffer for resultsb
   * @param name  tag
   * @param val   BwPrincipal
   */
  public static void toStringSegment(StringBuffer sb, String name, BwPrincipal val) {
    if (name != null) {
      sb.append(", ");
      sb.append(name);
      sb.append("=");
    }

    if (val == null) {
      sb.append("**NULL**");
    } else {
      sb.append("(");
      sb.append(val.getId());
      sb.append(", ");
      sb.append(val.getAccount());
      sb.append(")");
    }
  }

  /* ====================================================================
   *                   Copying methods
   * ==================================================================== */

  /** Copy this to val
   *
   * @param val BwPrincipal target
   */
  public void copyTo(BwPrincipal val) {
    val.setAccount(getAccount());
    val.setId(getId());
    val.setSeq(getSeq());
    val.setCreated(getCreated());
    val.setLogon(getLogon());
    val.setLastAccess(getLastAccess());
    val.setLastModify(getLastModify());
    val.setCategoryAccess(getCategoryAccess());
    val.setLocationAccess(getLocationAccess());
    val.setSponsorAccess(getSponsorAccess());
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compareTo(Object o) {
    return compare(this, o);
  }

  public int compare(Object o1, Object o2) {
    if (!(o1 instanceof BwPrincipal)) {
      return -1;
    }

    if (!(o2 instanceof BwPrincipal)) {
      return 1;
    }

    BwPrincipal p1 = (BwPrincipal)o1;
    BwPrincipal p2 = (BwPrincipal)o2;

    if (p1.getKind() < p2.getKind()) {
      return -1;
    }

    if (p1.getKind() > p2.getKind()) {
      return 1;
    }

    return CalFacadeUtil.compareStrings(p1.getAccount(), p2.getAccount());
  }

  public int hashCode() {
    int hc = 7 * (getKind() + 1);

    if (account != null) {
      hc = account.hashCode();
    }

    return hc;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwPrincipal{");

    toStringSegment(sb);
    sb.append("}");

    return sb.toString();
  }

  public abstract Object clone();
}
