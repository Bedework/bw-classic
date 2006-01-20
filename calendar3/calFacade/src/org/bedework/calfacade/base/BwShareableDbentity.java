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
package org.bedework.calfacade.base;

import org.bedework.calfacade.BwUser;

/** Base class for shareable database entities.
 *
 * @author Mike Douglass
 * @version 1.0
 */
public class BwShareableDbentity extends BwOwnedDbentity {
  /** The user who created the entity */
  private BwUser creator;

  /** Encoded access rights
   */
  private String access;

  /** No-arg constructor
   *
   */
  public BwShareableDbentity() {
    super();
  }

  /** Create an entity specifying the fields
   *
   * @param owner          BwUser user who owns the entity
   * @param publick        boolean true if this is a public entity
   * @param creator        BwUser user who created the entity
   * @param access
   */
  public BwShareableDbentity(BwUser owner,
                             boolean publick,
                             BwUser creator,
                             String access) {
    super(owner, publick);
    this.creator = creator;
    this.access = access;
  }

  /** Set the creator
   *
   * @param val     UserVO creator of the entity
   */
  public void setCreator(BwUser val) {
    creator = val;
  }

  /**
   *
   * @return UserVO    creator of the entity
   */
  public BwUser getCreator() {
    return creator;
  }

  /** Set the access
   *
   * @param val    String access
   */
  public void setAccess(String val) {
    access = val;
  }

  /** Get the access
   *
   * @return String   access
   */
  public String getAccess() {
    return access;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /** Add our stuff to the StringBuffer
   *
   * @param sb    StringBuffer for result
   */
   protected void toStringSegment(StringBuffer sb) {
    super.toStringSegment(sb);
    sb.append(", creator=");
    sb.append(userid(getCreator()));
    sb.append(", access=");
    sb.append(getAccess());
  }

   /** Copy this objects fields into the parameter
    *
    * @param val
    */
  public void copyTo(BwShareableDbentity val) {
    super.copyTo(val);
    val.setCreator((BwUser)getCreator().clone());
    val.setAccess(getAccess());
  }
}
