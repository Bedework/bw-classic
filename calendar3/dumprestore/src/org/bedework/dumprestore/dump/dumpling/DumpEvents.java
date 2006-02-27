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
package org.bedework.dumprestore.dump.dumpling;

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAnnotation;
import org.bedework.calfacade.BwRecurrence;
import org.bedework.calfacade.base.BwDbentity;
import org.bedework.dumprestore.dump.DumpGlobals;

import java.util.Iterator;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpEvents extends Dumpling {
  /** Constructor
   *
   * @param globals
   */
  public DumpEvents(DumpGlobals globals) {
    super(globals);
  }

  /* (non-Javadoc)
   * @see org.bedework.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    boolean taggedStart = false;
    boolean annotations = false;

    while (it.hasNext()) {
      BwEvent e = (BwEvent)it.next();
      
      if (!taggedStart) {
        if (e instanceof BwEventAnnotation) {
          tagStart(sectionEventAnnotations);
          annotations = true;
        } else {
          tagStart(sectionEvents);
        }
        
        taggedStart = true;
      }

      dumpEvent(e);
    }

    if (annotations) {
      tagEnd(sectionEventAnnotations);
    } else {
      tagEnd(sectionEvents);
    }
  }

  private void dumpEvent(BwEvent e) throws Throwable {
    BwEventAnnotation ann = null;

    if (e instanceof BwEventAnnotation) {
      ann = (BwEventAnnotation)e;
      taggedVal("target", ann.getTarget().getId());
      taggedVal("master", ann.getMaster().getId());
    }
    
    if (ann == null) {
      tagStart(objectEvent);
    } else {
      tagStart(objectEventAnnotation);
    }

    shareableContainedEntityTags(e);

    taggedVal("name", e.getName());
    taggedVal("guid", e.getGuid());
    taggedVal("summary", e.getSummary());
    taggedVal("description", e.getDescription());

    taggedDateTime("start", e.getDtstart());
    taggedDateTime("end", e.getDtend());
    taggedVal("duration", e.getDuration());
    taggedVal("end-type", e.getEndType());

    taggedVal("link", e.getLink());
    taggedVal("status", e.getStatus());
    taggedVal("cost", e.getCost());
    taggedVal("deleted", e.getDeleted());

    taggedVal("dtstamp", e.getDtstamp());
    taggedVal("last-mod", e.getLastmod());
    taggedVal("create-date", e.getCreated());

    taggedVal("priority", e.getPriority());
    taggedVal("sequence", e.getSequence());

    tagStart("eventCategories");

    Iterator it = e.getCategories().iterator();

    while (it.hasNext()) {
      BwDbentity ent = (BwDbentity)it.next();

      taggedEntityId("category", ent);
    }

    tagEnd("eventCategories");

    taggedEntityId("sponsor", e.getSponsor());
    taggedEntityId("location", e.getLocation());
    taggedEntityId("organizer", e.getOrganizer());

    taggedVal("transparency", e.getTransparency());

    tagStart("eventAttendees");

    it = e.getAttendees().iterator();

    while (it.hasNext()) {
      BwDbentity ent = (BwDbentity)it.next();

      taggedEntityId("attendee", ent);
    }

    tagEnd("eventAttendees");

    taggedVal("recurring", e.getRecurring());
    if (e.getRecurring()) {
      BwRecurrence r = e.getRecurrence();

      tagStart("eventRecurrence");
      it = r.iterateRrules();

      while (it.hasNext()) {
        taggedVal("rrule", it.next());
      }

      it = r.iterateExrules();

      while (it.hasNext()) {
        taggedVal("exrule", it.next());
      }

      it = r.iterateRdates();

      while (it.hasNext()) {
        taggedDateTime("rdate", (BwDateTime)it.next());
      }

      it = r.iterateExdates();

      while (it.hasNext()) {
        taggedDateTime("exdate", (BwDateTime)it.next());
      }

      taggedVal("recurrenceId", r.getRecurrenceId());
      taggedVal("latestDate", r.getLatestDate());

      tagEnd("eventRecurrence");
    }

    if (ann == null) {
      tagEnd(objectEvent);
      
      globals.events++;
    } else {
      taggedVal("target", ann.getTarget().getId());
      taggedVal("master", ann.getMaster().getId());
      tagEnd(objectEventAnnotation);
      
      globals.eventAnnotations++;
    }
  }
}

