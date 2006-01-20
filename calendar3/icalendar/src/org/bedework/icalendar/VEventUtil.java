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

import org.bedework.calfacade.BwAttendee;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwOrganizer;
import org.bedework.calfacade.BwRecurrence;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.CalFacadeException;

import edu.rpi.cct.uwcal.common.URIgen;

import net.fortuna.ical4j.model.CategoryList;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.Date;
import net.fortuna.ical4j.model.DateList;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Dur;
import net.fortuna.ical4j.model.parameter.AltRep;
import net.fortuna.ical4j.model.parameter.Value;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.PeriodList;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.property.Categories;
import net.fortuna.ical4j.model.property.Clazz;
import net.fortuna.ical4j.model.property.Contact;
import net.fortuna.ical4j.model.property.Created;
import net.fortuna.ical4j.model.property.Description;
import net.fortuna.ical4j.model.property.DtStamp;
import net.fortuna.ical4j.model.property.Duration;
import net.fortuna.ical4j.model.property.ExDate;
import net.fortuna.ical4j.model.property.ExRule;
import net.fortuna.ical4j.model.property.LastModified;
import net.fortuna.ical4j.model.property.Location;
import net.fortuna.ical4j.model.property.Priority;
import net.fortuna.ical4j.model.property.RDate;
import net.fortuna.ical4j.model.property.RRule;
import net.fortuna.ical4j.model.property.Sequence;
import net.fortuna.ical4j.model.property.Status;
import net.fortuna.ical4j.model.property.Summary;
import net.fortuna.ical4j.model.property.Uid;
import net.fortuna.ical4j.model.property.Url;
import net.fortuna.ical4j.model.PropertyList;
import net.fortuna.ical4j.model.Recur;

import java.net.URI;
import java.util.Collection;
import java.util.Iterator;

/** Class to provide utility methods for translating to VEvent ical4j classes
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class VEventUtil extends IcalUtil {

  /** Make a VEvent object from an EventVO.
   *
   * @param val
   * @param uriGen
   * @return VEvent
   * @throws CalFacadeException
   */
  public static VEvent toIcalEvent(BwEvent val, URIgen uriGen) throws CalFacadeException {
    if (val == null) {
      return null;
    }

    try {
      VEvent vev = new VEvent();

      PropertyList pl = vev.getProperties();
      Property prop;

      /* ------------------- Alarms -------------------- */
      /* XXX Fix this when we use eventinfo object
      Iterator almit = val.iterateAlarms();

      while (almit.hasNext()) {
        BwAlarm alarm = (BwAlarm)almit.next();

        vev.getAlarms().add(setAlarm(alarm));
      }
      */

      /* ------------------- Attendees -------------------- */
      Iterator attit = val.iterateAttendees();

      while (attit.hasNext()) {
        BwAttendee att = (BwAttendee)attit.next();

        pl.add(setAttendee(att));
      }

      /* ------------------- Categories -------------------- */
      /* This needs to be changed if we add non-category keys */

      Collection ks = val.getCategories();

      if (ks != null) {
        /* This event has a category */

        Iterator it = ks.iterator();
        prop = new Categories();
        CategoryList cl = ((Categories)prop).getCategories();

        while (it.hasNext()) {
          BwCategory k = (BwCategory)it.next();

          cl.add(k.getWord());
        }

        pl.add(prop);
      } else {
        /* Most personal events don't have a category */
      }

      /* ------------------- Class -------------------- */

      pl.add(new Clazz("PUBLIC"));
//      if (pubEvent) {
//        pl.add(new Clazz("PUBLIC"));
//      } else {
//        pl.add(new Clazz("PRIVATE"));
//      }

      /* ------------------- Contact -------------------- */

      BwSponsor sp = val.getSponsor();
      if (sp != null) {
//        prop = new Contact(makeContactString(sp));
        prop = new Contact(sp.getName());

        if (uriGen != null) {
          prop.getParameters().add(new AltRep(uriGen.getSponsorURI(sp)));
        }
        pl.add(prop);
      }

      /* ------------------- Created -------------------- */

      prop = new Created(val.getCreated());
//      if (pars.includeDateTimeProperty) {
//        prop.getParameters().add(Value.DATE_TIME);
//      }
      pl.add(prop);

      /* ------------------- Description -------------------- */

      pl.add(new Description(val.getDescription()));

      /* ------------------- DtEnd/Duration --------------------
      */

      if (val.getEndType() == BwEvent.endTypeDate) {
        prop = val.getDtend().makeDtEnd();
        pl.add(prop);
      } else if (val.getEndType() == BwEvent.endTypeDuration) {
        addProperty(vev, new Duration(new Dur(val.getDuration())));
      }

      /* ------------------- DtStamp -------------------- */

      prop = new DtStamp(new DateTime(val.getDtstamp()));
//      if (pars.includeDateTimeProperty) {
//        prop.getParameters().add(Value.DATE_TIME);
//      }
      pl.add(prop);

      /* ------------------- DtStart -------------------- */

      prop = val.getDtstart().makeDtStart();
      pl.add(prop);

      /* ------------------- LastModified -------------------- */

      prop = new LastModified(new DateTime(val.getLastmod()));
//      if (pars.includeDateTimeProperty) {
//        prop.getParameters().add(Value.DATE_TIME);
//      }
      pl.add(prop);

      /* ------------------- Location -------------------- */

      BwLocation loc = val.getLocation();
      if (loc != null) {
        prop = new Location(loc.getAddress());
//        prop = new Location(makeLocationString(loc));
//        if (!pars.simpleLocation && (uriGen != null)) {
//          prop.getParameters().add(new AltRep(uriGen.getLocationURI(loc)));
//        }
        pl.add(prop);
      }

      /* ------------------- Organizer -------------------- */

      BwOrganizer org = val.getOrganizer();
      if (org != null) {
        pl.add(setOrganizer(org));
      }

      /* ------------------- Priority -------------------- */

      pl.add(new Priority(val.getPriority()));

      /* ------------------- Sequence -------------------- */

      pl.add(new Sequence(val.getSequence()));

      /* ------------------- Status -------------------- */

      String status = val.getStatus();
      if (status != null) {
        pl.add(new Status(status));
      }

      /* ------------------- Summary -------------------- */

      pl.add(new Summary(val.getSummary()));

      /* ------------------- Uid -------------------- */

      pl.add(new Uid(val.getGuid()));

      /* ------------------- Url -------------------- */

      String uri = val.getLink();

      if (uri != null) {
        pl.add(new Url(new URI(uri)));
      }

      if (val.getRecurring()) {
        doRecurring(val, pl);
      }

      return vev;
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /** Return the absolute latest end date for this event. Note that
   * exclusions may mean the actual latest date is earlier.
   *
   * @param ev
   * @param debug       true for some tracing
   * @return date
   * @throws CalFacadeException
   */
  public static Date getLatestRecurrenceDate(VEvent ev, boolean debug) throws CalFacadeException {
    try {
      PropertyList rrules = getProperties(ev, Property.RRULE);
      PropertyList rdts = getProperties(ev, Property.RDATE);

      if ((rrules == null) && (rdts == null)) {
        // Not a recurring event
        return null;
      }

      Date start = ev.getStartDate().getDate();
      Date until = null;

      if (rrules != null) {
        Iterator rit = rrules.iterator();
        while (rit.hasNext()) {
          RRule r = (RRule)rit.next();

          Date nextUntil = getLastDate(r.getRecur(), start);
          if (nextUntil == null) {
            /* We have a rule without an end date so it's infinite.
             */
            return null;
          }

          if (debug) {
            debugMsg("Last date for recur=" + nextUntil);
          }

          if ((until == null) || (nextUntil.after(until))) {
            until = nextUntil;
          }
        }

        /* We have some rules - none have an end date so it's infinite.
         */
        if (until == null) {
          // infinite
          return null;
        }
      }

      if (rdts != null) {
        // Get the latest date from each
        // XXX are these sorted?
        Iterator rit = rdts.iterator();
        while (rit.hasNext()) {
          RDate r = (RDate)rit.next();

          PeriodList pl = r.getPeriods();

          Iterator it = pl.iterator();

          while (it.hasNext()) {
            Period p = (Period)it.next();

            // Not sure if a single date gives a null end
            Date nextUntil = p.getEnd();

            if (nextUntil == null) {
              nextUntil = p.getStart();
            }

            if ((until == null) || (nextUntil.after(until))) {
              until = nextUntil;
            }
          }
        }
      }

      if (debug) {
        debugMsg("Last date before fix=" + until);
      }

      /* Now add the duration of the event to get us past the end
       */
      Duration d = (Duration)getProperty(ev, Property.DURATION);
      Dur dur;

      if  (d != null) {
        dur = d.getDuration();
      } else {
        dur = new Dur(ev.getStartDate().getDate(), ev.getEndDate().getDate());
      }

      /* Make a new duration incremented a little to avoid any boundary
          conditions */
      if  (dur.getWeeks() != 0) {
        dur = new Dur(dur.getWeeks() + 1);
      } else {
        dur = new Dur(dur.getDays() + 1, dur.getHours(), dur.getMinutes(),
                      dur.getSeconds());
      }

      until = new Date(dur.getTime(until));

      if (debug) {
        debugMsg("Last date after fix=" + until);
      }

      return until;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /* ====================================================================
                      Private methods
     ==================================================================== */

  private static void doRecurring(BwEvent val, PropertyList pl) throws Throwable {
    BwRecurrence rec = val.getRecurrence();

    Collection rr = rec.getRrules();
    Iterator rit = rr.iterator();
    while (rit.hasNext()) {
      RRule rule = new RRule();
      rule.setValue((String)rit.next());

      pl.add(rule);
    }

    Collection rd = rec.getRdates();
    rit = rd.iterator();
    while (rit.hasNext()) {
      RDate rdt = new RDate();

      rdt.setValue((String)rit.next());

      pl.add(rdt);
    }

    Collection er = rec.getExrules();
    rit = er.iterator();
    while (rit.hasNext()) {
      ExRule rule = new ExRule();
      rule.setValue((String)rit.next());

      pl.add(rule);
    }

    Collection ed = rec.getRdates();
    rit = ed.iterator();
    while (rit.hasNext()) {
      ExDate edt = new ExDate();

      edt.setValue((String)rit.next());

      pl.add(edt);
    }
  }

  /** Return the highest possible start date from this recurrence or null
   * if no count or until date specified
   */
  private static Date getLastDate(Recur r, Date start) {
    Date seed = start;
    Date until = r.getUntil();

    if (until != null) {
      return until;
    }

    int count = r.getCount();
    if (count < 1) {
      return null;
    }

    Dur days100 = new Dur(100, 0, 0, 0);
    int counted = 0;

    while (counted < count) {
      Date end = new DateTime(days100.getTime(start));
      DateList dl = r.getDates(seed, start, end, Value.DATE_TIME);

      int sz = dl.size();
      counted += sz;
      if (sz != 0) {
        until = (Date)dl.get(sz - 1);
      }
      start = end;
    }

    return until;
  }

     /*
  private String makeContactString(BwSponsor sp) {
    if (pars.simpleContact) {
      return sp.getName();
    }

    StringBuffer sb = new StringBuffer(sp.getName());
    addNonNull(defaultDelim, Resources.PHONENBR, sp.getPhone(), sb);
    addNonNull(defaultDelim, Resources.EMAIL, sp.getEmail(), sb);
    addNonNull(urlDelim, Resources.URL, sp.getLink(), sb);

    if (sb.length() == 0) {
      return null;
    }

    return sb.toString();
  }

  /* * Build a location string value from the location.
   *
   * <p>We try to build something we can parse later.
   * /
  private String makeLocationString(BwLocation loc) {
    if (pars.simpleLocation) {
      return loc.getAddress();
    }

    StringBuffer sb = new StringBuffer(loc.getAddress());
    addNonNull(defaultDelim, Resources.SUBADDRESS, loc.getSubaddress(), sb);
    addNonNull(urlDelim, Resources.URL, loc.getLink(), sb);

    if (sb.length() == 0) {
      return null;
    }

    return sb.toString();
  }*/
}

