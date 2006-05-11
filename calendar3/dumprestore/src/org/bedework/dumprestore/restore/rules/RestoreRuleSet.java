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

import org.bedework.dumprestore.restore.RestoreGlobals;

import org.apache.commons.digester.Digester;
import org.apache.commons.digester.RuleSetBase;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class RestoreRuleSet extends RuleSetBase {
  protected RestoreGlobals globals;

  /** Constructor
   *
   * @param globals
   */
  public RestoreRuleSet(RestoreGlobals globals) {
    super();
    this.globals = globals;
  }

  public void addRuleInstances(Digester d) {
    d.addRule("caldata/*/owner-key", new OwnerRule(globals));
    d.addRule("caldata/*/owner-key/*", new OwnerFieldRule(globals));

    d.addRule("caldata/syspars/system", new SysparsRule(globals));
    d.addRule("caldata/syspars/system/*", new SysparsFieldRule(globals));

    UserFieldRule ufr = new UserFieldRule(globals);
    d.addRule("caldata/users/user", new UserRule(globals));
    d.addRule("caldata/users/user/*", ufr);

    d.addRule("caldata/timezones/timezone", new TimeZoneRule(globals));
    d.addRule("caldata/timezones/timezone/*", new TimeZoneFieldRule(globals));

    d.addRule("caldata/calendars/calendar", new CalendarRule(globals));
    d.addRule("caldata/calendars/calendar/*", new CalendarFieldRule(globals));

    d.addRule("caldata/locations/location", new LocationRule(globals));
    d.addRule("caldata/locations/location/*", new LocationFieldRule(globals));

    d.addRule("caldata/sponsors/sponsor", new SponsorRule(globals));
    d.addRule("caldata/sponsors/sponsor/*", new SponsorFieldRule(globals));

    d.addRule("caldata/organizers/organizer", new OrganizerRule(globals));
    d.addRule("caldata/organizers/organizer/*", new OrganizerFieldRule(globals));

    d.addRule("caldata/attendees/attendee", new AttendeeRule(globals));
    d.addRule("caldata/attendees/attendee/*", new AttendeeFieldRule(globals));

    /* 2.3.2
    d.addRule("caldata/dblastmods/dblastmod", new DbLastmodRule(globals));
    d.addRule("caldata/dblastmods/dblastmod/*", new DbLastmodFieldRule(globals));
    */

    d.addRule("caldata/eventRefs/eventRef", new EventRefRule(globals));
    d.addRule("caldata/eventRefs/eventRef/*", new EventRefFieldRule(globals));

    /* 2.3.2 */
    KeywordFieldRule kfr = new KeywordFieldRule(globals);
    d.addRule("caldata/keywords/keyword", new KeywordRule(globals));
    d.addRule("caldata/keywords/keyword/*", kfr);

    CategoryFieldRule catfr = new CategoryFieldRule(globals);
    d.addRule("caldata/categories/category", new CategoryRule(globals));
    d.addRule("caldata/categories/category/*", catfr);

    AdminGroupFieldRule agfr = new AdminGroupFieldRule(globals);
    d.addRule("caldata/adminGroups/adminGroup", new AdminGroupRule(globals));
    d.addRule("caldata/adminGroups/adminGroup/*", agfr);

    AuthUserFieldRule aufr = new AuthUserFieldRule(globals);
    d.addRule("caldata/authusers/authuser", new AuthUserRule(globals));
    d.addRule("caldata/authusers/authuser/*", aufr);

    UserPrefsFieldRule upfr = new UserPrefsFieldRule(globals);
    d.addRule("caldata/user-preferences/user-prefs", new UserPrefsRule(globals));
    d.addRule("caldata/user-preferences/user-prefs/*", upfr);

    EventFieldRule efr = new EventFieldRule(globals);
    d.addRule("caldata/events/event", new EventRule(globals));
    d.addRule("caldata/events/event/*", efr);

    d.addRule("caldata/event-annotations/event-annotation", new EventRule(globals));
    d.addRule("caldata/event-annotations/event-annotation/*", efr);

    AlarmRule alr = new AlarmRule(globals);
    AlarmFieldRule alfr = new AlarmFieldRule(globals);
    d.addRule("caldata/alarms/event-alarm", alr);
    d.addRule("caldata/alarms/event-alarm/*", alfr);
    d.addRule("caldata/alarms/todo-alarm", alr);
    d.addRule("caldata/alarms/todo-alarm/*", alfr);

    FilterRule fr = new FilterRule(globals);
    d.addRule("caldata/filters/aliasFilter", fr);
    d.addRule("caldata/filters/andFilter", fr);
    d.addRule("caldata/filters/creatorFilter", fr);
    d.addRule("caldata/filters/keyFilter", fr);
    d.addRule("caldata/filters/locationFilter", fr);
    d.addRule("caldata/filters/notFilter", fr);
    d.addRule("caldata/filters/orFilter", fr);
    d.addRule("caldata/filters/sponsorFilter", fr);
    d.addRule("caldata/filters/*", new FilterFieldRule(globals));
    d.addRule("caldata/filters", new FiltersRule(globals));
  }
}

