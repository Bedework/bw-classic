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

/** The location of an <code>Event</code>
 *
 *  @version 1.0
 */
public class BwLocation extends BwEventProperty {
  private String address;
  private String subaddress;
  private String link;

  /** Constructor
   *
   */
  public BwLocation() {
    super();
  }

  /** create a location with all fields specified
   *
   * @param owner          BwUser user who owns the entity
   * @param publick        boolean true if this is a public entity
   * @param creator        BwUser user who created the entity
   * @param access
   * @param address        main address
   * @param subaddress     secondary address
   * @param link           String URL with more info
   */
  public BwLocation(BwUser owner,
                    boolean publick,
                    BwUser creator,
                    String access,
                    String address,
                    String subaddress,
                    String link) {
    super(owner, publick, creator, access);
    this.address = address;
    this.subaddress = subaddress;
    this.link = link;
  }

  /**
   * @param val
   */
  public void setAddress(String val) {
    address = val;
  }

  /** Get the main address of the location
   *
   * @return the main address of the location
   */
  public String getAddress() {
    return address;
  }

  /**
   * @param val
   */
  public void setSubaddress(String val) {
    subaddress = val;
  }

  /** Get the secondary address of the location
   *
   * @return the secondary address of the location
   */
  public String getSubaddress() {
    return subaddress;
  }

  /** Set the Location's URL
   *
   * @param link The new URL
   */
  public void setLink(String link) {
    this.link = link;
  }

  /** Get the link for the location
   *
   * @return the link for the location
   */
  public String getLink() {
    return link;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compareTo(Object o) {
    if (this == o) {
      return 0;
    }

    if (!(o instanceof BwLocation)) {
      return -1;
    }

    BwLocation that = (BwLocation)o;

    int res = CalFacadeUtil.cmpObjval(getAddress(), that.getAddress());

    if (res != 0) {
      return res;
    }

    return CalFacadeUtil.cmpObjval(getOwner(), that.getOwner());
  }

  public int hashCode() {
    int hc = 1;

    if (getAddress() != null) {
      hc *= getAddress().hashCode();
    }

    if (getOwner() != null) {
      hc *= getOwner().hashCode();
    }

    return hc;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwLocation{");

    toStringSegment(sb);
    sb.append(", address=");
    sb.append(getAddress());
    sb.append(", subaddress=");
    sb.append(getSubaddress());
    sb.append(", link=");
    sb.append(getLink());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    if (getId() <= CalFacadeDefs.maxReservedLocationId) {
      // It's a reserved immutable location. Just return it.
      return this;
    }

    return new BwLocation((BwUser)getOwner().clone(),
                          getPublick(),
                          (BwUser)getCreator().clone(),
                          getAccess(),
                          getAddress(), getSubaddress(), getLink());
  }
}
