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

/** Class to represent an RFC2554 recurrence id type. These are not stored
 * in separate tables but as components of the including class.
 *
 * <p>A Recurrence id is a DateTime type with the additon of a possible
 * range parameter used in selecting. The range is not stored in the
 * database and should only be used when decoding or encoding RFC2445
 * entities.
 *
 * <p>When objects of this class appear within an entity they represent the
 * start date [and time] of the entity as obtained by evaluating the rules.
 *
 * <p>If an entity is sent with such a recurrence id any accompanying data
 * represents a modification tothat entity. For example:
 * <pre>
 *    BEGIN:VCALENDAR
 *    CALSCALE:GREGORIAN
 *    PRODID:BedeWOrk
 *    VERSION:2.0
 *    BEGIN:VEVENT
 *    UID:12345@bedework.org
 *    SUMMARY:Group meeting
 *    DTSTAMP:20051106T101112Z
 *    DTSTART:20051107T110000Z
 *    DTEND:20051107T120000Z
 *    RRULE:FREQ=WEEKLY
 *    END:VEVENT
 *    BEGIN:VEVENT
 *    UID:12345@bedework.org
 *    RECURRENCE-ID:20051114T120000Z
 *    DTSTAMP:200511106T1101313Z
 *    DTEND:20051114T130000Z
 *    END:VEVENT
 *    END:VCALENDAR
 * </pre>
 * defines a weekly meeting starting at 2005, Nov, 7 lasting 1 hour. The
 * exception flags the meeting on 2005, Nov 14 as lasting 2 hours.
 *
 * @author Mike Douglass   douglm@rpi.edu
 *  @version 1.0
 */
public class BwRecurrenceId extends BwDateTime {
  private String range;

  /** Set the range for a query
   *
   * @param val
   */
  public void setRange(String val) {
    range = val;
  }

  /** Get the range for a query
   *
   * @return String range
   */
  public String getRange() {
    return range;
  }

  /* ====================================================================
   *                        Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwRecurrenceId{");
    sb.append(super.toString());
    sb.append(", range=");
    sb.append(getRange());
    sb.append("}");

    return sb.toString();
  }
}

