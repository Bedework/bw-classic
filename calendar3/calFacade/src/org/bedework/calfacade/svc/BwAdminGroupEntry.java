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

import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.util.CalFacadeUtil;

import java.io.Serializable;

/** A table allowing us to retrieve administrative grp members which
 * may themselves be groups.
 *
 *   @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwAdminGroupEntry implements Serializable {
  /* group is a reserved word in (h)sql */
  private BwGroup grp;

  private int groupId;  // Generated

  private int memberId = CalFacadeDefs.unsavedItemKey;

  private boolean memberIsGroup;

  private BwPrincipal member;

  /** Constructor
   *
   */
  public BwAdminGroupEntry() {
  }

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

  /** Set the group
   *
   * @param val    BwGroup
   */
  public void setGrp(BwGroup val) {
    grp = val;
  }

  /** Get the group
   *
   * @return BwGroup    the group
   */
  public BwGroup getGrp() {
    return grp;
  }

  /** Set the grp id
   *
   * @param val    int grp id
   */
  public void setGroupId(int val) {
    groupId = val;
  }

  /** Get the grp id
   *
   * @return int    the grp id
   */
  public int getGroupId() {
    return groupId;
  }

  /** Set the member id
   *
   * @param val    int member id
   */
  public void setMemberId(int val) {
    memberId = val;
  }

  /** Get the member id
   *
   * @return int    the member id
   */
  public int getMemberId() {
    return memberId;
  }

  /** Set the member is grp flag
   *
   * @param val    boolean member is grp flag
   */
  public void setMemberIsGroup(boolean val) {
    memberIsGroup = val;
  }

  /** Get the member is grp flag
   *
   * @return boolean    the member is grp flag
   */
  public boolean getMemberIsGroup() {
    return memberIsGroup;
  }

  /** Set the member
   *
   * @param val    BwPrincipal member
   */
  public void setMember(BwPrincipal val) {
    member = val;
    memberId = val.getId();
    memberIsGroup = (val instanceof BwGroup);
  }

  /** Get the member
   *
   * @return BwPrincipal    the member
   */
  public BwPrincipal getMember() {
    return member;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  /** Compare this and an object
   *
   * @param  o    object to compare.
   * @return int -1, 0, 1
   */
  public int compareTo(Object o) {
    if (o == this) {
      return 0;
    }

    if (o == null) {
      return -1;
    }

    if (!(o instanceof BwAdminGroupEntry)) {
      return -1;
    }

    BwAdminGroupEntry that = (BwAdminGroupEntry)o;

    int res = getGrp().compareTo(that.getGrp());
    if(res != 0) {
      return res;
    }

    res = CalFacadeUtil.cmpIntval(getMemberId(), that.getMemberId());
    if(res != 0) {
      return res;
    }

    return CalFacadeUtil.cmpBoolval(getMemberIsGroup(), that.getMemberIsGroup());
  }

  public int hashCode() {
    int hc;

    if (getMemberIsGroup()) {
      hc = 1;
    } else {
      hc = 2;
    }

    return hc * getGrp().hashCode() * getMemberId();
  }

  public boolean equals(Object obj) {
    return compareTo(obj) == 0;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwAdminGroupEntry(");
    BwPrincipal.toStringSegment(sb, "grp=", getGrp());
    sb.append(", memberId=");
    sb.append(getMemberId());
    sb.append(", memberIsGroup=");
    sb.append(getMemberIsGroup());
    sb.append(")");

    return sb.toString();
  }
}
