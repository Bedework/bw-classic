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

package org.bedework.icalendar;

import net.fortuna.ical4j.model.Property;

/** Define an (arbitrary) index associated with an ical property
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public interface PropertyIndex {
  /** */
  public static final int CLASS = 0;

  /** */
  public static final int CREATED = 1;

  /** */
  public static final int DESCRIPTION = 2;

  /** */
  public static final int DTSTAMP = 3;

  /** */
  public static final int DTSTART = 4;

  /** */
  public static final int DURATION = 5;

  /** */
  public static final int GEO = 6;

  /** */
  public static final int LAST_MODIFIED = 7;

  /** */
  public static final int LOCATION = 8;

  /** */
  public static final int ORGANIZER = 9;

  /** */
  public static final int PRIORITY = 10;

  /** */
  public static final int RECURRENCE_ID = 11;

  /** */
  public static final int SEQUENCE = 12;

  /** */
  public static final int STATUS = 13;

  /** */
  public static final int SUMMARY = 14;

  /** */
  public static final int UID = 15;

  /** */
  public static final int URL = 16;

  /* Event only */

  /** */
  public static final int DTEND = 17;

  /** */
  public static final int TRANSP = 18;

  /* Todo only */

  /** */
  public static final int COMPLETED = 19;

  /** */
  public static final int DUE = 20;

  /** */
  public static final int PERCENT_COMPLETE = 21;

  /* ---------------------------- Multi valued --------------- */

  /* Event and Todo */

  /** */
  public static final int ATTACH = 22;

  /** */
  public static final int ATTENDEE = 23;

  /** */
  public static final int CATEGORIES = 24;

  /** */
  public static final int COMMENT = 25;

  /** */
  public static final int CONTACT = 26;

  /** */
  public static final int EXDATE = 27;

  /** */
  public static final int EXRULE = 28;

  /** */
  public static final int REQUEST_STATUS = 29;

  /** */
  public static final int RELATED_TO = 30;

  /** */
  public static final int RESOURCES = 31;

  /** */
  public static final int RDATE = 32;

  /** */
  public static final int RRULE = 33;

  /* -------------- Other non-event, non-todo ---------------- */

  /** */
  public static final int FREEBUSY = 34;

  /** */
  public static final int TZID = 35;

  /** */
  public static final int TZNAME = 36;

  /** */
  public static final int TZOFFSETFROM = 37;

  /** */
  public static final int TZOFFSETTO = 38;

  /** */
  public static final int TZURL = 39;

  /** */
  public static final int ACTION = 40;

  /** */
  public static final int REPEAT = 41;

  /** */
  public static final int TRIGGER = 42;

  /** Property names */
  public static final String[] propertyNames = {
    /* ---------------------------- Single valued --------------- */

    /* Event and Todo */
    Property.CLASS,

    Property.CREATED,

    Property.DESCRIPTION,

    Property.DTSTAMP,

    Property.DTSTART,

    Property.DURATION,

    Property.GEO,

    Property.LAST_MODIFIED,

    Property.LOCATION,

    Property.ORGANIZER,

    Property.PRIORITY,

    Property.RECURRENCE_ID,

    Property.SEQUENCE,

    Property.STATUS,

    Property.SUMMARY,

    Property.UID,

    Property.URL,

    /* Event only */

    Property.DTEND,

    Property.TRANSP,

    /* Todo only */

    Property.COMPLETED,

    Property.DUE,

    Property.PERCENT_COMPLETE,

    /* ---------------------------- Multi valued --------------- */

    /* Event and Todo */

    Property.ATTACH,

    Property.ATTENDEE,

    Property.CATEGORIES,

    Property.COMMENT,

    Property.CONTACT,

    Property.EXDATE,

    Property.EXRULE,

    Property.REQUEST_STATUS,

    Property.RELATED_TO,

    Property.RESOURCES,

    Property.RDATE,

    Property.RRULE,

    /* -------------- Other non-event, non-todo ---------------- */


    Property.FREEBUSY,

    Property.TZID,

    Property.TZNAME,

    Property.TZOFFSETFROM,

    Property.TZOFFSETTO,

    Property.TZURL,

    Property.ACTION,

    Property.REPEAT,

    Property.TRIGGER,
  };
}

