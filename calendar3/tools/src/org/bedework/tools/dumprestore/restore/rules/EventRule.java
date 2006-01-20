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
package org.bedework.tools.dumprestore.restore.rules;

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAnnotation;
import org.bedework.tools.dumprestore.restore.RestoreGlobals;

import net.fortuna.ical4j.model.Dur;

import java.util.Properties;

import org.hibernate.Hibernate;
import org.hibernate.id.Configurable;
import org.hibernate.id.UUIDHexGenerator;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class EventRule extends EntityRule {
  UUIDHexGenerator uuidGen;

  /** Constructor
   *
   * @param globals
   */
  public EventRule(RestoreGlobals globals) {
    super(globals);

    Properties uidprops = new Properties();
    uidprops.setProperty("separator", "-");
    uuidGen = new UUIDHexGenerator();
    ((Configurable)uuidGen).configure(Hibernate.STRING, uidprops, null);
  }

  public void end(String ns, String name) throws Exception {
    BwEvent entity = (BwEvent)top();

    globals.events++;

    fixSharableEntity(entity, "Event");

    /* If it's an alias, save an entry in the alia table then remove the dummy target.
     * We'll update them all at the end
     */
    if (entity instanceof BwEventAnnotation) {
      globals.aliasTbl.put((BwEventAnnotation)entity);
      ((BwEventAnnotation)entity).setTarget(null);
    }

    try {
      if (globals.toHibernate) {
        if ((entity.getGuid() == null) || (entity.getGuid().length() == 0)) {
          if (globals.systemId == null) {
            throw new Exception("You must supply a system id");
          }

          /* ************** Duplicated code from calintfimpl **************** */
          String guidPrefix = "CAL-" + (String)uuidGen.generate(null, null);

          if (entity.getName() == null) {
            entity.setName(guidPrefix + ".ics");
          }

          String guid = guidPrefix + globals.systemId;

          if (globals.debug) {
//            trace("Set guid for " + entity.getId() + " to " + guid);
          }

          entity.setGuid(guid);
        }

        /* Try to fix up dates and times.
           Non-inclusive ends seems to mean:

           DATE-TIME start, no end        --  zero time at indicated time
           DATE-TIME start, DATE end      --  is that allowed, means remainder of day?
           DATE-TIME start, DATE-TIME end --  from start, up to, not including end
           DATE start                     --  all day event
           DATE start, DATE end           --  end - start + 1 all day(s)
        */

        BwDateTime start = entity.getDtstart();
        BwDateTime end = entity.getDtend();

        entity.setEndType(BwEvent.endTypeDate);

        if (!start.getDateType() && !end.getDateType()) {
          // Both date-time, assume OK
        } else if (start.getDateType() && end.getDateType()) {
          // Both date - could be trouble
          if (start.equals(end)) {
            // Assume OK
          } else {
            Dur dur = new Dur(start.makeDate(), end.makeDate());

            warn(dur.getDays() + " day event " + entity.getId() +
                 " start = " + start);
          }

          /* Increment the end by one day to take account of current practice */
          end = end.getNextDay(globals.timezones);
          entity.setDtend(end);
        } else if (!end.getDateType()) {
          // date start, date-time end --- illegal
          warn("date start, date-time end for event " + entity.getId() +
               " start = " + start.getDtval() +
               " end = " + end.getDtval());
        } else {
          /* date-time start, date end --- is this OK?
             We'll fix it by setting end to start.

          warn("date-time start, date end for event " + entity.getId() +
               " start = " + start.getDtval() +
               " end = " + end.getDtval());
           */
          globals.fixedNoEndTime++;
          entity.setDtend(start);
          entity.setEndType(BwEvent.endTypeNone);
          end = start;
        }

        if (end.before(start)) {
          warn("end before start for " + entity.getId() + " start = " + start +
               " end = " + end);

          end.init(start.getDateType(), start.getDtval(), null, globals.timezones);
        }

        if (entity.getSummary() == null) {
          warn("Event " + entity.getId() + " has no summary.");
          entity.setSummary("Missing summary");
        }

        if (entity.getCalendar() == null) {
          warn("Event " + entity.getId() + " has no calendar.");
          entity.setCalendar(globals.defaultPublicCal);
        }

        entity.setDuration(BwDateTime.makeDuration(start, end).toString());
      }

      if ((entity.getGuid() == null) || (entity.getGuid().length() == 0)) {
        error("Unable to save event " + entity.getId() + ". Has no guid.");
      }

      if (entity.getCalendar() == null) {
        error("Unable to save event " + entity.getId() + ". Has no calendar.");
      } else if (globals.rintf != null) {
        globals.rintf.restoreEvent(entity);
      }
    } catch (Throwable t) {
      throw new Exception(t);
    }

    pop();
  }
}

