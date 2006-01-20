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

import java.io.Serializable;

/** Represents a stored timezone. This whole area is somewhat problematical,
 * RFC2554 refers to timezones by tzid but thereis as yet not statndard
 * source for timezones, nor any standard way of naming them.
 *
 * <p>Currently, the best we can do is store a timezone when we see a new
 * id and hope we don't get sent bogus ones, or alternatively store a set we
 * believe to be complete and run the risk of encountering ones we missed.
 *
 * <p>For the moment we will assign ownership to tzids and user defined
 * tzids will be storedunder their ownership.
 *
 * @author Mike Douglass   douglm@rpi.edu
 *  @version 1.0
 */
public class BwTimeZone implements Serializable {
  private int id = CalFacadeDefs.unsavedItemKey;

  /** This is the timezone id this is known by.
   */
  private String tzid;

  /* * We store timezones in CalendarVO objects.
   * /
  private CalendarVO calendar;
  */

  /** User who owns this timezone */
  private BwUser owner;

  private boolean publick;

  private String vtimezone; // rfc2554 representation

  /** This is the corresponding java.util.TimeZone id.
   * It provides a mapping from external timezones to java timezones.
   */
  private String jtzid;

  /** Constructor
   *
   */
  public BwTimeZone() {
  }

  /** Set the id for this timezone
   *
   * @param val   alarm id
   */
  public void setId(int val) {
    id = val;
  }

  /** Get the timezone's id
   *
   * @return int    the timezone's unique id
   */
  public int getId() {
    return id;
  }

  /**  Set the tzid
   *
   * @param val    String tzid
   */
  public void setTzid(String val) {
    tzid = val;
  }

  /** Get the tzid
   *
   * @return String    tzid
   */
  public String getTzid() {
    return tzid;
  }

  /* * Set the timezone's calendar
   *
   * @param val    CalendarVO timezone's calendar
   * /
  public void setCalendar(CalendarVO val) {
    calendar = val;
  }

  /* * Get the timezone's calendar
   *
   * @return CalendarVO   the timezone's calendar
   * /
  public CalendarVO getCalendar() {
    return calendar;
  }*/

  /** Set the timezone public flag
   *
   *  @param val    true if the timezone is public
   */
  public void setPublick(boolean val) {
    publick = val;
  }

  /**
   * @return boolean true for public
   */
  public boolean getPublick() {
    return publick;
  }

  /**
   * @param  val      UserVO timezone owner
   */
  public void setOwner(BwUser val) {
    owner = val;
  }

  /**
   * @return UserVO     timezone's owner
   */
  public BwUser getOwner() {
    return owner;
  }

  /** Set the vtimezone
   *
   * @param val    String vtimezone
   */
  public void setVtimezone(String val) {
    vtimezone = val;
  }

  /** Get the vtimezone
   *
   * @return String   vtimezone
   */
  public String getVtimezone() {
    return vtimezone;
  }

  /** Set the java timezone id
   *
   * @param val    String java timezone id
   */
  public void setJtzid(String val) {
    jtzid = val;
  }

  /** Get the java timezone id
   *
   * @return String   java timezone id
   */
  public String getJtzid() {
    return jtzid;
  }

  /* ====================================================================
   *                        Object methods
   * ==================================================================== */

  public int hashCode() {
    int hc = 1;

    if (getTzid() != null) {
      hc *= getTzid().hashCode();
    }

    if (getPublick()) {
      return hc *= 2;
    }

    if (getOwner() != null) {
      hc *= getOwner().hashCode();
    }

    return hc;
  }

  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (!(obj instanceof BwTimeZone)) {
      return false;
    }

    BwTimeZone that = (BwTimeZone)obj;

    if (!CalFacadeUtil.eqObjval(getTzid(), that.getTzid())) {
      return false;
    }

    if (getPublick() != that.getPublick()) {
      return false;
    }

    if (getPublick()) {
      return true;
    }

    return !CalFacadeUtil.eqObjval(getOwner(), that.getOwner());
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("TimeZoneVO{id=");
    sb.append(id);
    sb.append(", tzid=");
    sb.append(tzid);
    sb.append(", publick=");
    sb.append(getPublick());
    sb.append(", owner=");
    sb.append(owner);
    sb.append(", jtzid=");
    sb.append(jtzid);
    sb.append("}");

    return sb.toString();
  }
}
