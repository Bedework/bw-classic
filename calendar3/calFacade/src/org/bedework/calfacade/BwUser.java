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

/** Value object to represent a calendar user.
 *
 *   @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwUser extends BwPrincipal {
  private long quota;

  private boolean instanceOwner;

  /* ====================================================================
   *                   Constructors
   * ==================================================================== */

  /** Create a guest user
   */
  public BwUser() {
    super();
  }

  /** Create a user object for an account name.
   *
   * @param  name            String user id for database
   */
  public BwUser(String name) {
    super(name);
  }

  public int getKind() {
    return principalUser;
  }

  /** Quota for this user. This will have to be an estimate I imagine.
   *
   * @param val
   */
  public void setQuota(long val) {
    quota = val;
  }

  /**
   * @return long
   */
  public long getQuota() {
    return quota;
  }

  /** An instance owner is the owner of an instance of the calendar system.
   * This is the id we run as for that particular instance, e.g. the campus
   * calendar, or the alumni calendar etc.
   *
   * @param val
   */
  public void setInstanceOwner(boolean val) {
    instanceOwner = val;
  }

  /**
   * @return boolean
   */
  public boolean getInstanceOwner() {
    return instanceOwner;
  }

  /* ====================================================================
   *                   Copying methods
   * ==================================================================== */

  /** Copy this to val
   *
   * @param val BwUser
   */
  public void copyTo(BwUser val) {
    super.copyTo(val);
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer("BwUser{");

    toStringSegment(sb);
    sb.append("instanceOwner=");
    sb.append(getInstanceOwner());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    /* We do not clone the attached subscriptions if present. These need to
       be cloned explicitly or we might set up a clone loop.
    */
    BwUser u = new BwUser();
    copyTo(u);

    return u;
  }
}
