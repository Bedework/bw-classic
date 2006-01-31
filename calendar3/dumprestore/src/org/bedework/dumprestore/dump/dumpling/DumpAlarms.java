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

import org.bedework.calfacade.BwAlarm;
import org.bedework.calfacade.BwEventAlarm;
import org.bedework.calfacade.BwTodoAlarm;
import org.bedework.dumprestore.dump.DumpGlobals;



import java.util.Iterator;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpAlarms extends Dumpling {
  /** Constructor
   *
   * @param globals
   */
  public DumpAlarms(DumpGlobals globals) {
    super(globals);
  }

  /* (non-Javadoc)
   * @see org.bedework.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    tagStart(sectionAlarms);

    while (it.hasNext()) {
      BwAlarm a = (BwAlarm)it.next();

      dumpAlarm(a);
    }

    tagEnd(sectionAlarms);
  }

  private void dumpAlarm(BwAlarm a) throws Throwable {
    boolean eventAlarm = a instanceof BwEventAlarm;

    if (eventAlarm) {
      tagStart(objectEventAlarm);
    } else {
      tagStart(objectTodoAlarm);
    }

    ownedEntityTags(a);
    taggedVal("trigger-type", a.getAlarmType());
    taggedVal("trigger", a.getTrigger());
    taggedVal("trigger-start", a.getTriggerStart());
    taggedVal("duration", a.getDuration());
    taggedVal("repeat", a.getRepeat());
    taggedVal("attach", a.getAttach());
    taggedVal("description", a.getDescription());
    taggedVal("summary", a.getSummary());
    taggedVal("trigger-time", a.getTriggerTime());
    taggedVal("previous-trigger", a.getPreviousTrigger());
    taggedVal("repeat-count", a.getRepeatCount());
    taggedVal("expired", a.getExpired());

    if (eventAlarm) {
      taggedEntityId("event", ((BwEventAlarm)a).getEvent());

      tagEnd(objectEventAlarm);
    } else {
      taggedEntityId("todo", ((BwTodoAlarm)a).getTodo());

      tagEnd(objectTodoAlarm);
    }

    globals.valarms++;
  }
}
