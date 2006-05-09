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
package org.bedework.dumprestore.restore.rules;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAnnotation;
import org.bedework.calfacade.BwEventObj;
import org.bedework.dumprestore.restore.RestoreGlobals;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class EventFieldRule extends EntityFieldRule {
  EventFieldRule(RestoreGlobals globals) {
    super(globals);
  }

  public void field(String name) throws Exception {
    BwEvent e = (BwEvent)top();

    if (shareableContainedEntityTags(e, name)) {
      return;
    }

    try {
      /* pre-hibernate fields */
      if (name.equals("lastmod")) { // pre-hibernate
        e.setLastmod(isoDateTimeFld());
      } else if (name.equals("created")) {  // pre-hibernate
        e.setCreated(isoDateTimeFld());
        e.setDtstamp(isoDateTimeFld());
      } else if (name.equals("longdesc")) { // pre-hibernate
        e.setDescription(stringFld());
      } else if (name.equals("startdate")) { // pre-hibernate
        e.setDtstart(dateFld());
      } else if (name.equals("starttime")) { // pre-hibernate
        makeDateTimeFld(e.getDtstart());
      } else if (name.equals("enddate")) { // pre-hibernate
        e.setEndType(BwEvent.endTypeDate);
        e.setDtend(dateFld());
      } else if (name.equals("endtime")) { // pre-hibernate
        makeDateTimeFld(e.getDtend());
      } else if (name.equals("shortdesc")) { // pre-hibernate
        e.setSummary(stringFld());
      } else if (name.equals("keyword")) { // pre-hibernate
        //globals.eventKeysTbl.put(intFld(), e.getId());
        BwCategory cat = categoryFld();
        e.addCategory(cat);
        BwCalendar cal = globals.catCalTbl.get(cat.getId());
        if (cal == null) {
          error("No mapping for category " + cat + " for event " + e);
        } else {
          e.setCalendar(cal);
        }
      } else if (name.equals("eventKeywords")) { // pre-hibernate
        // Nothing to do.

      } else if (name.equals("target-calendar")) {
        BwEvent target = getAnnotationTarget(e);

        // target.setCalendar()
      } else if (name.equals("name")) {
        e.setName(stringFld());
      } else if (name.equals("guid")) {
        e.setGuid(stringFld());
      } else if (name.equals("summary")) {
        e.setSummary(stringFld());
      } else if (name.equals("description")) {
        e.setDescription(stringFld());

        /* Start */
      } else if (name.equals("start-date-type")) {
        dateType = booleanFld();
        tzid = null;
      } else if (name.equals("start-tzid")) {
        tzid = stringFld();
      } else if (name.equals("start-dtval")) {
        dtVal = fixedDateTimeFld();
      } else if (name.equals("start-date")) {
        // Could compare given UTC time
        e.setDtstart(dateTimeFld());

        /* end */
      } else if (name.equals("end-date-type")) {
        dateType = booleanFld();
        tzid = null;
      } else if (name.equals("end-tzid")) {
        tzid = stringFld();
      } else if (name.equals("end-dtval")) {
        dtVal = fixedDateTimeFld();
      } else if (name.equals("end-date")) {
        // Could compare given UTC time
        e.setDtend(dateTimeFld());

      } else if (name.equals("duration")) {
        e.setDuration(stringFld());
      } else if (name.equals("end-type")) {
        e.setEndType(charFld());

      } else if (name.equals("link")) {
        e.setLink(stringFld());
      } else if (name.equals("status")) {
        String status = stringFld();
        if ((status != null) &&
            (!status.equals("F"))) {       // 2.3
          e.setStatus(status);
        }
      } else if (name.equals("cost")) {
        e.setCost(stringFld());
      } else if (name.equals("deleted")) {
        e.setDeleted(booleanFld());

      } else if (name.equals("dtstamp")) {
        e.setDtstamp(stringFld());
      } else if (name.equals("last-mod")) {
        e.setLastmod(stringFld());
      } else if (name.equals("create-date")) {
        e.setCreated(stringFld());

      } else if (name.equals("priority")) {
        e.setPriority(intFld());
      } else if (name.equals("sequence")) {
        e.setSequence(intFld());

      } else if (name.equals("eventCategories")) {
        // Nothing to do.
      } else if (name.equals("category")) {
        globals.eventKeysTbl.put(intFld(), e.getId());
        e.addCategory(categoryFld());

      } else if (name.equals("sponsor")) {
        e.setSponsor(sponsorFld());
      } else if (name.equals("location")) {
        e.setLocation(locationFld());
      } else if (name.equals("organizer")) {
        e.setOrganizer(organizerFld());

      } else if (name.equals("transparency")) {
        e.setTransparency(stringFld());

      } else if (name.equals("eventAttendees")) {
        // Nothing to do.
      } else if (name.equals("attendee")) {
        throw new Exception("Unimplemented - attendee");

      } else if (name.equals("recurring")) {
        e.setRecurring(booleanFld());
      } else if (name.equals("eventRecurrence")) {
        // Nothing to do.
      } else if (name.equals("rrule")) {
        e.getRecurrence().addRrule(stringFld());
      } else if (name.equals("exrule")) {
        e.getRecurrence().addExrule(stringFld());

        /* rdate */
      } else if (name.equals("rdate-date-type")) {
        dateType = booleanFld();
        tzid = null;
      } else if (name.equals("rdate-tzid")) {
        tzid = stringFld();
      } else if (name.equals("rdate-dtval")) {
        dtVal = stringFld();
      } else if (name.equals("rdate-date")) {
        // Could compare given UTC time
        e.getRecurrence().addRdate(dateTimeFld());

        /* exdate */
      } else if (name.equals("exdate-date-type")) {
        dateType = booleanFld();
        tzid = null;
      } else if (name.equals("exdate-tzid")) {
        tzid = stringFld();
      } else if (name.equals("exdate-dtval")) {
        dtVal = stringFld();
      } else if (name.equals("exdate-date")) {
        // Could compare given UTC time
        e.getRecurrence().addExdate(dateTimeFld());

      } else if (name.equals("recurrenceId")) {
        e.setRecurrenceId(stringFld());
      } else if (name.equals("latestDate")) {
        e.getRecurrence().setLatestDate(stringFld());
      } else {
        unknownTag(name);
      }
    } catch (Exception ex) {
      error("Error processing event id " + e.getId(), ex);
      globals.entityError = true;
    }
  }

  private BwEvent getAnnotationTarget(BwEvent e) {
    BwEventAnnotation ann = (BwEventAnnotation)e;
    BwEvent target = ann.getTarget();

    if (target == null) {
      target = new BwEventObj();
    }

    ann.setTarget(target);
    return target;
  }

  private BwEvent getAnnotationMaster(BwEvent e) {
    BwEventAnnotation ann = (BwEventAnnotation)e;
    BwEvent master = ann.getMaster();

    if (master == null) {
      master = new BwEventObj();
    }

    ann.setMaster(master);
    return master;
  }
}

