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

import java.util.HashMap;

/** Class to track changes to a BwEvent
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class IcalChangeTable extends HashMap {
  /**
   */
  public static class Entry {
    boolean multiValued;

    /* Index of the property */
    int index;

    /* Name of the property */
    String name;

    /* True if it's an event property */
    boolean eventProperty;

    /* True if it's a todo property */
    boolean todoProperty;

    /* true if we saw a change */
    boolean changed;

    Entry(boolean multiValued, int index, boolean eventProperty,
          boolean todoProperty, boolean changed) {
      this.multiValued = multiValued;
      this.index = index;
      this.name = PropertyIndex.propertyNames[index];
      this.eventProperty = eventProperty;
      this.todoProperty = todoProperty;
      this.changed = changed;
    }

    Entry(int index, boolean eventProperty,
          boolean todoProperty, boolean changed) {
      this(false, index, eventProperty, todoProperty, changed);
    }

    Entry(int index, boolean eventProperty, boolean todoProperty) {
      this(index, eventProperty, todoProperty, false);
    }
  }

  /**
   */
  public static class EventEntry extends Entry {
    EventEntry(boolean multiValued, int index) {
      super(multiValued, index, true, false, false);
    }

    EventEntry(int index) {
      super(index, true, false, false);
    }
  }

  /**
   */
  public static class TodoEntry extends Entry {
    TodoEntry(boolean multiValued, int index) {
      super(multiValued, index, false, true, false);
    }

    TodoEntry(int index) {
      super(index, false, true, false);
    }
  }

  /**
   */
  public static class EventTodoEntry extends Entry {
    EventTodoEntry(boolean multiValued, int index) {
      super(multiValued, index, true, true, false);
    }

    EventTodoEntry(int index) {
      super(index, true, true, false);
    }
  }

  IcalChangeTable() {
    /* ---------------------------- Single valued --------------- */

    /* Event and Todo */
    put(new EventTodoEntry(PropertyIndex.CLASS));

    put(new EventTodoEntry(PropertyIndex.CREATED));

    put(new EventTodoEntry(PropertyIndex.DESCRIPTION));

    put(new EventTodoEntry(PropertyIndex.DTSTAMP));

    put(new EventTodoEntry(PropertyIndex.DTSTART));

    put(new EventTodoEntry(PropertyIndex.DURATION));

    put(new EventTodoEntry(PropertyIndex.GEO));

    put(new EventTodoEntry(PropertyIndex.LAST_MODIFIED));

    put(new EventTodoEntry(PropertyIndex.LOCATION));

    put(new EventTodoEntry(PropertyIndex.ORGANIZER));

    put(new EventTodoEntry(PropertyIndex.PRIORITY));

    put(new EventTodoEntry(PropertyIndex.RECURRENCE_ID));

    put(new EventTodoEntry(PropertyIndex.SEQUENCE));

    put(new EventTodoEntry(PropertyIndex.STATUS));

    put(new EventTodoEntry(PropertyIndex.SUMMARY));

    put(new EventTodoEntry(PropertyIndex.UID));

    put(new EventTodoEntry(PropertyIndex.URL));

    /* Event only */

    put(new EventEntry(PropertyIndex.DTEND));

    put(new EventEntry(PropertyIndex.TRANSP));

    /* Todo only */

    put(new TodoEntry(PropertyIndex.COMPLETED));

    put(new TodoEntry(PropertyIndex.DUE));

    put(new TodoEntry(PropertyIndex.PERCENT_COMPLETE));

    /* ---------------------------- Multi valued --------------- */

    /* Event and Todo */

    put(new EventTodoEntry(true, PropertyIndex.ATTACH));

    put(new EventTodoEntry(true, PropertyIndex.ATTENDEE));

    put(new EventTodoEntry(true, PropertyIndex.CATEGORIES));

    put(new EventTodoEntry(true, PropertyIndex.COMMENT));

    put(new EventTodoEntry(true, PropertyIndex.CONTACT));

    put(new EventTodoEntry(true, PropertyIndex.EXDATE));

    put(new EventTodoEntry(true, PropertyIndex.EXRULE));

    put(new EventTodoEntry(true, PropertyIndex.REQUEST_STATUS));

    put(new EventTodoEntry(true, PropertyIndex.RELATED_TO));

    put(new EventTodoEntry(true, PropertyIndex.RESOURCES));

    put(new EventTodoEntry(true, PropertyIndex.RDATE));

    put(new EventTodoEntry(true, PropertyIndex.RRULE));

    /* -------------- Other non-event, non-todo ---------------- */


    put(new Entry(PropertyIndex.FREEBUSY, false, false));

    put(new Entry(PropertyIndex.TZID, false, false));

    put(new Entry(PropertyIndex.TZNAME, false, false));

    put(new Entry(PropertyIndex.TZOFFSETFROM, false, false));

    put(new Entry(PropertyIndex.TZOFFSETTO, false, false));

    put(new Entry(PropertyIndex.TZURL, false, false));

    put(new Entry(PropertyIndex.ACTION, false, false));

    put(new Entry(PropertyIndex.REPEAT, false, false));

    put(new Entry(PropertyIndex.TRIGGER, false, false));
  }

  /** Set the change flag on the named entry.
   *
   * @param name
   * @return boolean false if entry not found
   */
  public boolean changed(String name) {
    Entry ent = getEntry(name);

    if (ent != null) {
      ent.changed = true;
      return true;
    }

    return false;
  }

  /** Get the named entry
   *
   * @param name
   * @return Entry null if not found
   */
  public Entry getEntry(String name) {
    return (Entry)get(name);
  }

  private void put(Entry ent) {
    put(ent.name, ent);
  }
}

