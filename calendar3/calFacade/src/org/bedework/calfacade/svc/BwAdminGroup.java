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
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.BwPrincipal;

/** An object representing a calendar admin group.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 2.2
 */
public class BwAdminGroup extends BwGroup {
  private String description;

  private BwUser groupOwner;

  private BwUser owner;

  /** Create a new object.
   */
  public BwAdminGroup() {
    super();
  }

  /** Create a new object.
   *
   * @param  account       String group account name
   */
  public BwAdminGroup(String account) {
    super(account);
  }

  /** Create a new object.
   *
   * @param  account       String group account name
   * @param  description   String group description
   * @param  groupOwner    BwUser user who owns the group.
   * @param  owner         BwUser user who owns the group entities.
   */
  public BwAdminGroup(String account,
                      String description,
                      BwUser groupOwner,
                      BwUser owner) {
    super(account);
    this.description = description;
    this.groupOwner = groupOwner;
    this.owner = owner;
  }

  /* ====================================================================
   *                      Bean methods
   * ==================================================================== */

  /** Set the description of the group.
   *
   * @param   val     String group description.
   */
  public void setDescription(String val) {
    description = val;
  }

  /** Return the description of the group.
   *
   * @return String        group description
   */
  public String getDescription() {
    return description;
  }

  /** Set the group owner.
   *
   * @param   val     UserVO group owner.
   */
  public void setGroupOwner(BwUser val) {
    groupOwner = val;
  }

  /** Return the group owner.
   *
   * @return BwUser        group owner
   */
  public BwUser getGroupOwner() {
    return groupOwner;
  }

  /** Set the owner of the group.
   *
   * @param   val     UserVO group event owner.
   */
  public void setOwner(BwUser val) {
    owner = val;
  }

  /** Return the owner of the group.
   *
   * @return UserVO        group owner
   */
  public BwUser getOwner() {
    return owner;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwAdminGroup{");
    toStringSegment(sb);
    sb.append(", description=");
    sb.append(getDescription());
    BwPrincipal.toStringSegment(sb, "groupOwner=", getGroupOwner());
    BwPrincipal.toStringSegment(sb, "owner=", getOwner());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    BwAdminGroup ag = new BwAdminGroup();
    copyTo(ag);

    ag.setDescription(getDescription());
    ag.setGroupOwner((BwUser)getGroupOwner().clone());
    ag.setOwner((BwUser)getOwner().clone());

    return ag;
  }
}
