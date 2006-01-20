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

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwUser;
import org.bedework.tools.dumprestore.dump.DumpGlobals;

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
   * @see org.bedework.tools.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    tagStart(sectionCalendars);

    while (it.hasNext()) {
      BwCalendar cal = (BwCalendar)it.next();

      dumpCalendar(cal);
    }

    tagEnd(sectionCalendars);
  }

  private void dumpCalendar(BwCalendar val) throws Throwable {
    tagStart(objectCalendar);

    taggedVal("id", val.getId());
    taggedVal("name", val.getName());
    taggedVal("path", val.getPath());

    BwUser u = val.getOwner();

    if (u != null) {
      taggedVal("owner", u.getId());
    }
    taggedVal("publick", val.getPublick());
    taggedVal("access", val.getAccess());
    taggedVal("summary", val.getSummary());
    taggedVal("description", val.getDescription());
    taggedVal("mailListId", val.getMailListId());
    taggedVal("calendarCollection", val.getCalendarCollection());

    BwCalendar p = val.getCalendar();

    if (p != null) {
      taggedVal("parent", p.getId());
    }

    tagEnd(objectCalendar);

    globals.categories++;
  }
}
