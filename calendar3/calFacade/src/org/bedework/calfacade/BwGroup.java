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

import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

/** Value object to represent a calendar group.
 *
 *   @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwGroup extends BwPrincipal {
  /** members of the group
   */
  private Collection groupMembers;

  /* ====================================================================
   *                   Constructors
   * ==================================================================== */

  /** Create a group
   */
  public BwGroup() {
    super();
  }

  /** Create a group with a given name
   *
   * @param  account            String group account name
   */
  public BwGroup(String account) {
    super(account);
  }

  public int getKind() {
    return principalGroup;
  }

  /** Set the members of the group.
   *
   * @param   val     Collection of group members.
   */
  public void setGroupMembers(Collection val) {
    groupMembers = val;
  }

  /** Return the members of the group.
   *
   * @return Collection        group members
   */
  public Collection getGroupMembers() {
    if (groupMembers == null) {
      groupMembers = new TreeSet();
    }
    return groupMembers;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /** Return true if the account name is in the group members.
   *
   * @param account
   * @param group     boolean true if we're testing for a group.
   * @return true if the account name is in the group members.
   */
  public boolean isMember(String account, boolean group) {
    Iterator it = getGroupMembers().iterator();

    while (it.hasNext()) {
      BwPrincipal mbr = (BwPrincipal)it.next();

      if (mbr.getAccount().equals(account)) {
        if (group == (mbr instanceof BwGroup)) {
          return true;
        }
      }
    }

    return false;
  }

  /** Add a group member. Return true if is was added, false if it was in
   * the list
   *
   * @param mbr        BwPrincipal to add
   * @return boolean   true if added
   */
  public boolean addGroupMember(BwPrincipal mbr) {
    return getGroupMembers().add(mbr);
  }

  /** Remove a group member. Return true if is was removed, false if it was
   * not in the list
   *
   * @param mbr        BwPrincipal to remove
   * @return boolean   true if removed
   */
  public boolean removeGroupMember(BwPrincipal mbr) {
    return getGroupMembers().remove(mbr);
  }

  protected void toStringSegment(StringBuffer sb) {
    super.toStringSegment(sb);
    sb.append(", groupMembers={");
    boolean first = true;

    Iterator it = getGroupMembers().iterator();
    while (it.hasNext()) {
      BwPrincipal mbr = (BwPrincipal)it.next();
      String name = "";
      if (first) {
        name = null;
        first = false;
      }
      BwPrincipal.toStringSegment(sb, name, mbr);
    }

    sb.append("}");
  }

  /* ====================================================================
   *                   Copying methods
   * ==================================================================== */

  /** Copy this to val
  *
  * @param val BwGroup target
  */
  public void copyTo(BwGroup val) {
    super.copyTo(val);

    Collection c = getGroupMembers();

    TreeSet ts = new TreeSet();

    if (c != null) {
      Iterator it = c.iterator();

      while (it.hasNext()) {
        BwPrincipal mbr = (BwPrincipal)it.next();
        ts.add((BwPrincipal)mbr.clone());
      }
    }

    val.setGroupMembers(ts);
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwGroup{");
    toStringSegment(sb);
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    /* We do not clone the attached subscriptions if present. These need to
       be cloned explicitly or we might set up a clone loop.
    */
    BwGroup g = new BwGroup();
    copyTo(g);

    return g;
  }
}
