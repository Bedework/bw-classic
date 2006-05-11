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

import org.bedework.calfacade.BwCalendar;
import org.bedework.dumprestore.dump.DumpGlobals;

import java.util.Iterator;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpCalendars extends Dumpling {
  /** Constructor
   *
   * @param globals
   */
  public DumpCalendars(DumpGlobals globals) {
    super(globals);
  }

  /* (non-Javadoc)
   * @see org.bedework.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    /* The iterator should return two calendars, the public root and the
     * user calendar root. We'll do a recursive dump.
     *
     * Note that the children follow the parent, allowing the restore to save
     * each object in turn rather than the entire tree in ine go.
     */
    tagStart(sectionCalendars);

    while (it.hasNext()) {
      BwCalendar cal = (BwCalendar)it.next();

      dumpCalendar(cal);
    }

    tagEnd(sectionCalendars);
  }

  private void dumpCalendar(BwCalendar val) throws Throwable {
    tagStart(objectCalendar);

    shareableContainedEntityTags(val);

    taggedVal("name", val.getName());
    taggedVal("path", val.getPath());
    taggedVal("summary", val.getSummary());
    taggedVal("description", val.getDescription());
    taggedVal("mailListId", val.getMailListId());
    taggedVal("calendarCollection", val.getCalendarCollection());
    taggedVal("calType", val.getCalType());

    tagEnd(objectCalendar);

    Iterator children = val.getChildren().iterator();
    while (children.hasNext()) {
      dumpCalendar((BwCalendar)children.next());
    }

    globals.categories++;
  }
}
