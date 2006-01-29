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

import org.bedework.dumprestore.dump.DumpGlobals;
import org.bedework.dumprestore.dump.DumpIntf;

import java.util.Iterator;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpAll extends Dumpling {
  private DumpIntf di;

  /** Constructor
   *
   * @param globals
   * @param di
   */
  public DumpAll(DumpGlobals globals, DumpIntf di) {
    super(globals);

    this.di = di;
  }

  /* (non-Javadoc)
   * @see org.bedework.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    tagStart(dumpTag);

    info("Dumping system parameters.");
    di.open();
    new DumpSyspars(globals).dumpSection(di.getSyspars());
    di.close();

    info("Dumping users.");
    di.open();
    new DumpUsers(globals).dumpSection(di.getUsers());
    di.close();

    info("Dumping timezones.");
    di.open();
    new DumpTimeZones(globals).dumpSection(di.getTimeZones());
    di.close();

    info("Dumping calendars.");
    di.open();
    new DumpCalendars(globals).dumpSection(di.getCalendars());
    di.close();

    info("Dumping locations.");
    di.open();
    new DumpLocations(globals).dumpSection(di.getLocations());
    di.close();

    info("Dumping sponsors.");
    di.open();
    new DumpSponsors(globals).dumpSection(di.getSponsors());
    di.close();

    info("Dumping organizers.");
    di.open();
    new DumpOrganizers(globals).dumpSection(di.getOrganizers());
    di.close();

    info("Dumping attendees.");
    di.open();
    new DumpAttendees(globals).dumpSection(di.getAttendees());
    di.close();

    info("Dumping alarms.");
    di.open();
    new DumpAlarms(globals).dumpSection(di.getAlarms());
    di.close();

    info("Dumping categories.");
    di.open();
    new DumpCategories(globals).dumpSection(di.getCategories());
    di.close();

    /* These all reference the above */

    info("Dumping auth users (and prefs).");
    di.open();
    new DumpAuthUsers(globals).dumpSection(di.getAuthUsers());
    di.close();

    info("Dumping events.");
    di.open();
    new DumpEvents(globals).dumpSection(di.getEvents());
    di.close();

    /*
    info("Dumping filters.");
    di.open();
    new DumpFilters(globals).dumpSection(di.getFilters());
    di.close();
    */

    info("Dumping admin groups.");
    di.open();
    new DumpAdminGroups(globals).dumpSection(di.getAdminGroups());
    di.close();

    info("Dumping user preferences.");
    di.open();
    new DumpUserPrefs(globals).dumpSection(di.getPreferences());
    di.close();

    info("Dumping lastmods.");
    di.open();
    new DumpDbLastmods(globals).dumpSection(di.getDbLastmods());
    di.close();

    tagEnd(dumpTag);
  }
}

