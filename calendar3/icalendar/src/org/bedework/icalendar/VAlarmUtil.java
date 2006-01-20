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

import org.bedework.calfacade.BwAlarm;
import org.bedework.calfacade.BwAttendee;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAlarm;
import org.bedework.calfacade.CalFacadeException;

import net.fortuna.ical4j.model.component.VAlarm;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Dur;
import net.fortuna.ical4j.model.parameter.Related;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.property.Action;
import net.fortuna.ical4j.model.property.Attach;
import net.fortuna.ical4j.model.property.Attendee;
import net.fortuna.ical4j.model.property.Description;
import net.fortuna.ical4j.model.property.Duration;
import net.fortuna.ical4j.model.property.Repeat;
import net.fortuna.ical4j.model.property.Summary;
import net.fortuna.ical4j.model.property.Trigger;
import net.fortuna.ical4j.model.PropertyList;

import java.net.URI;
import java.util.Iterator;

/** Class to provide utility methods for handline VAlarm ical4j classes
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class VAlarmUtil extends IcalUtil {

  /** If there are any alarms for this event add them to the events alarm
   * collection
   *
   * @param val
   * @param ev
   * @throws CalFacadeException
   */
  public static void processVEventAlarms(VEvent val, BwEvent ev) throws CalFacadeException {
    try {
      ComponentList als = val.getAlarms();

      if ((als == null) || als.isEmpty()) {
        return;
      }

      Iterator it = als.iterator();

      while (it.hasNext()) {
        Object o = it.next();

        if (!(o instanceof VAlarm)) {
          throw new IcalMalformedException("Invalid alarm list");
        }

        VAlarm va = (VAlarm)o;

        PropertyList pl = va.getProperties();

        if (pl == null) {
          // Empty VAlarm
          throw new IcalMalformedException("Invalid alarm list");
        }

        Property prop;
        BwEventAlarm al;

        // All alarm types require action and trigger

        prop = pl.getProperty(Property.ACTION);
        if (prop == null) {
          throw new IcalMalformedException("Invalid alarm");
        }

        String actionStr = prop.getValue();

        TriggerVal tr = getTrigger(pl);
        DurationRepeat dr = getDurationRepeat(pl);

        if ("EMAIL".equals(actionStr)) {
          al = BwEventAlarm.emailAlarm(ev, ev.getCreator(),
                                       tr.trigger, tr.triggerStart, tr.triggerDateTime,
                                       dr.duration, dr.repeat,
                                       getOptStr(pl, "ATTACH"),
                                       getReqStr(pl, "DESCRIPTION"),
                                       getReqStr(pl, "SUMMARY"),
                                       null);

          Iterator atts = getReqStrs(pl, "ATTENDEE");

          while (atts.hasNext()) {
            al.addAttendee(getAttendee((Attendee)atts.next()));
          }
        } else if ("AUDIO".equals(actionStr)) {
          al = BwEventAlarm.audioAlarm(ev, ev.getCreator(),
                                       tr.trigger, tr.triggerStart, tr.triggerDateTime,
                                       dr.duration, dr.repeat,
                                       getOptStr(pl, "ATTACH"));
        } else if ("DISPLAY".equals(actionStr)) {
          al = BwEventAlarm.displayAlarm(ev, ev.getCreator(),
                                         tr.trigger, tr.triggerStart, tr.triggerDateTime,
                                         dr.duration, dr.repeat,
                                         getReqStr(pl, "DESCRIPTION"));
        } else if ("PROCEDURE".equals(actionStr)) {
          al = BwEventAlarm.procedureAlarm(ev, ev.getCreator(),
                                           tr.trigger, tr.triggerStart, tr.triggerDateTime,
                                           dr.duration, dr.repeat,
                                           getReqStr(pl, "ATTACH"),
                                           getOptStr(pl, "DESCRIPTION"));
        } else {
          throw new IcalMalformedException("Invalid alarm - bad type");
        }

        /* XXX fix when EventInfo available
        ev.addAlarm(al);
        */
      }
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  private VAlarm setAlarm(BwAlarm val) throws Throwable {
    VAlarm alarm = new VAlarm();

    int atype = val.getAlarmType();

    addProperty(alarm, new Action(BwAlarm.alarmTypes[atype]));

    if (val.getTriggerDateTime()) {
      DateTime dt = new DateTime(val.getTrigger());
      addProperty(alarm, new Trigger(dt));
    } else {
      Trigger tr = new Trigger(new Dur(val.getTrigger()));
      if (!val.getTriggerStart()) {
        addParameter(tr, Related.END);
      }
      addProperty(alarm, tr);
    }

    if (val.getDuration() != null) {
      addProperty(alarm, new Duration(new Dur(val.getDuration())));
    }
    addProperty(alarm, new Repeat(val.getRepeat()));

    if (atype == BwAlarm.alarmTypeAudio) {
      if (val.getAttach() != null) {
        addProperty(alarm, new Attach(new URI(val.getAttach())));
      }
    } else if (atype == BwAlarm.alarmTypeDisplay) {
      addProperty(alarm, new Description(val.getDescription()));
    } else if (atype == BwAlarm.alarmTypeEmail) {
      addProperty(alarm, new Attach(new URI(val.getAttach())));
      addProperty(alarm, new Description(val.getDescription()));
      addProperty(alarm, new Summary(val.getSummary()));

      Iterator attit = val.iterateAttendees();
      while (attit.hasNext()) {
        BwAttendee att = (BwAttendee)attit.next();

        addProperty(alarm, setAttendee(att));
      }
    } else if (atype == BwAlarm.alarmTypeProcedure) {
      addProperty(alarm, new Attach(new URI(val.getAttach())));
      if (val.getDescription() != null) {
        addProperty(alarm, new Description(val.getDescription()));
      }
    }

    return alarm;
  }
}

