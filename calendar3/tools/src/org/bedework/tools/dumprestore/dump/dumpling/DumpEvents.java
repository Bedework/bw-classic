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
package org.bedework.tools.dumprestore.dump.dumpling;

import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAnnotation;
import org.bedework.tools.dumprestore.dump.DumpGlobals;



//import java.io.Writer;
import java.util.Collection;
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
   * @see org.bedework.tools.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    tagStart(sectionEvents);

    while (it.hasNext()) {
      BwEvent e = (BwEvent)it.next();

      dumpEvent(e);
    }

    tagEnd(sectionEvents);
  }

  private void dumpEvent(BwEvent e) throws Throwable {
    tagStart(objectEvent);

    shareableEntityTags(e);

    if (e instanceof BwEventAnnotation) {
      taggedVal("target", ((BwEventAnnotation)e).getId());
    }

    taggedVal("dtstamp", e.getDtstamp());
    taggedVal("last-mod", e.getLastmod());
    taggedVal("create-date", e.getCreated());

    taggedVal("priority", e.getPriority());
    taggedVal("sequence", e.getSequence());

    BwDateTime start = e.getDtstart();
    taggedVal("start-dtval", start.getDtval());
    taggedVal("start-date-type", start.getDateType());
    taggedVal("start-tzid", start.getTzid());
//    taggedVal("start-date", start.getDate());

    BwDateTime end = e.getDtend();
    if (end != null) {
      taggedVal("end-dtval", end.getDtval());
      taggedVal("end-date-type", end.getDateType());
      taggedVal("end-tzid", end.getTzid());
//      taggedVal("end-date", end.getDate());
    }

    taggedVal("duration", e.getDuration());
    taggedVal("end-type", e.getEndType());

    taggedVal("summary", e.getSummary());
    taggedVal("description", e.getDescription());
    taggedVal("link", e.getLink());
    taggedVal("status", e.getStatus());
    taggedVal("cost", e.getCost());

    // taggedVal("recurringStatus", e.getRecurringStatus());

    taggedEntityId("location", e.getLocation());
    taggedEntityId("sponsor", e.getSponsor());
    taggedEntityId("organizer", e.getOrganizer());

    tagStart("eventCategories");

    Collection keys = e.getCategories();
    Iterator keysi = keys.iterator();

    while (keysi.hasNext()) {
      BwCategory k = (BwCategory)keysi.next();

      taggedVal("category", k.getId());
    }

    tagEnd("eventCategories");
    tagEnd(objectEvent);

    globals.events++;
  }
}

