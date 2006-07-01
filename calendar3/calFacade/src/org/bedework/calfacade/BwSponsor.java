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

import org.bedework.calfacade.util.CalFacadeUtil;

/** Value object representing the sponsor of an event
 *
 * @author Mike Douglass
 * @version 1.0
 */
public class BwSponsor extends BwEventProperty {
  private String name;
  private String phone;
  private String email;
  private String link;

  /** Constructor
   *
   */
  public BwSponsor() {
    super();
  }

  /** Create a sponsor specifying all fields
   *
   * @param owner          BwUser user who owns the entity
   * @param publick        boolean true if this is a public entity
   * @param creator        BwUser user who created the entity
   * @param access
   * @param name           String Name of the sponsor
   * @param phone          String Phone number
   * @param email          String E-mail
   * @param link           String URL with more info
   */
  public BwSponsor(BwUser owner,
                   boolean publick,
                   BwUser creator,
                   String access,
                   String name,
                   String phone,
                   String email,
                   String link) {
    super(owner, publick, creator, access);
    this.name = name;
    this.phone = phone;
    this.email = email;
    this.link = link;
  }

  /** Set the name
   *
   * @param val    String name
   */
  public void setName(String val) {
    name = val;
  }

  /** Get the name
   *
   * @return String   name
   */
  public String getName() {
    return name;
  }

  /**
   * @param val
   */
  public void setPhone(String val) {
    phone = val;
  }

  /**
   * @return String phone number
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
   * @return String email
   */
  public String getEmail() {
    return email;
  }

  /** Set the sponsor's URL
   *
   * @param link   String URL
   */
  public void setLink(String link) {
    this.link = link;
  }

  /**
   * @return String url
   */
  public String getLink() {
    return link;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compareTo(Object o) {
    if (!(o instanceof BwSponsor)) {
      return -1;
    }

    if (this == o) {
      return 0;
    }

    BwSponsor that = (BwSponsor)o;

    int res = CalFacadeUtil.cmpObjval(getName(), that.getName());

    if (res != 0) {
      return res;
    }

    return CalFacadeUtil.cmpObjval(getOwner(), that.getOwner());
  }

  public int hashCode() {
    int hc = 1;

    if (getName() != null) {
      hc *= getName().hashCode();
    }

    if (getOwner() != null) {
      hc *= getOwner().hashCode();
    }

    return hc;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwSponsor{");

    toStringSegment(sb);
    sb.append(", name=");
    sb.append(getName());
    sb.append(", phone=");
    sb.append(getPhone());
    sb.append(", email=");
    sb.append(getEmail());
    sb.append(", link=");
    sb.append(getLink());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    if (getId() <= CalFacadeDefs.maxReservedSponsorId) {
      // It's a reserved immutable sponsor. Just return it.
      return this;
    }

    return new BwSponsor((BwUser)getOwner().clone(),
                         getPublick(),
                         (BwUser)getCreator().clone(),
                         getAccess(),
                         getName(), getPhone(), getEmail(),
                         getLink());
  }
}
