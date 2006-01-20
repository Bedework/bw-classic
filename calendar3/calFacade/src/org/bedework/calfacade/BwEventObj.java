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

/** An Event in Bedework.
 *
 * <p>From RFC2445<pre>
 *     A "VEVENT" calendar component is defined by the
 * following notation:
 *
 *   eventc     = "BEGIN" ":" "VEVENT" CRLF
 *                eventprop *alarmc
 *                "END" ":" "VEVENT" CRLF
 *
 *   eventprop  = *(
 *
 *              ; the following are optional,
 *              ; but MUST NOT occur more than once
 *
 *              class / created / description / dtstart / geo /
 *              last-mod / location / organizer / priority /
 *              dtstamp / seq / status / summary / transp /
 *              uid / url / recurid /
 *
 *              ; either 'dtend' or 'duration' may appear in
 *              ; a 'eventprop', but 'dtend' and 'duration'
 *              ; MUST NOT occur in the same 'eventprop'
 *
 *              dtend / duration /
 *
 *              ; the following are optional,
 *              ; and MAY occur more than once
 *
 *              attach / attendee / categories / comment /
 *              contact / exdate / exrule / rstatus / related /
 *              resources / rdate / rrule / x-prop
 *
 *              )
 * </pre>
 * Optional:
     class
     created          created
     description      description
     dtstart          dtstart
     geo
     last-mod         lastmod
     location         location
     organizer        organizerId
     priority         priority
     dtstamp          dtstamp
     seq              sequence
     status           status
     summary          summary
     transp           transparency
     uid              guid
     url              link
     recurid          recurrenceId

   One of or neither
     dtend            dtend
     duration         duration

   Optional and repeatable
      alarmc          alarms
      attach
      attendee        attendees
      categories      categories
      comment
      contact         sponsor
      exdate          exdates
      exrule
      rstatus
      related
      resources
      rdate           rdates
      rrule           rrules
      x-prop



  Extra non-rfc fields:
      private String cost;
      private UserVO creator;
      private boolean isPublic;
      private CalendarVO calendar;
      private RecurrenceVO recurrence;
      private char recurrenceStatus = 'N'; // Derived from above

 * --------------------------------------------------------------------
 *
 *
 *  @version 1.0
 */
public class BwEventObj extends BwEvent {

  /** Constructor
   */
  public BwEventObj() {
    super();
  }

  /** Constructor
   *
   * @param owner        BwUser user who owns the entity
   * @param publick      boolean true if this is a public entity
   * @param creator      BwUser user who created the entity
   * @param access
   * @param summary      String  Short description
   * @param description  String Long description
   * @param dtstart      DateTimeVO start
   * @param dtend        DateTimeVO end
   * @param link         String URL with more info
   * @param cost         String Cost to attend
   * @param organizer    OrganizerVO object
   * @param location     event's location
   * @param sponsor      event's sponsor
   * @param guid         String guid value
   * @param transparency String value
   * @param dtstamp      String UTC last modification time
   * @param lastmod      String UTC last modification time
   * @param created      String UTC creation datetime
   * @param priority     int rfc priority
   * @param sequence     int rfc sequence
   * @param recurrence   RecurrenceVO information
   */
  public BwEventObj(BwUser owner,
                 boolean publick,
                 BwUser creator,
                 String access,
                 String summary,
                 String description,
                 BwDateTime dtstart,
                 BwDateTime dtend,
                 String link,
                 String cost,
                 BwOrganizer organizer,
                 BwLocation location,
                 BwSponsor sponsor,
                 String guid,
                 String transparency,
                 String dtstamp,
                 String lastmod,
                 String created,
                 int priority,
                 int sequence,
                 BwRecurrence recurrence) {
    super(owner, publick, creator, access, summary, description,
          dtstart, dtend, link, cost, organizer, location,
          sponsor, guid, transparency, dtstamp, lastmod, created,
          priority, sequence, recurrence);
  }

  public Object clone() {
    BwEventObj ev = new BwEventObj();

    copyTo(ev);

    return ev;
  }
}
