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

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwEventProxy;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwRecurrenceId;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.svc.EventInfo;

import net.fortuna.ical4j.model.Dur;
import net.fortuna.ical4j.model.CategoryList;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.property.Attendee;
import net.fortuna.ical4j.model.property.Categories;
import net.fortuna.ical4j.model.property.Clazz;
import net.fortuna.ical4j.model.property.Contact;
import net.fortuna.ical4j.model.property.Created;
import net.fortuna.ical4j.model.property.DateListProperty;
import net.fortuna.ical4j.model.property.DateProperty;
import net.fortuna.ical4j.model.property.Description;
import net.fortuna.ical4j.model.property.DtEnd;
import net.fortuna.ical4j.model.property.DtStamp;
import net.fortuna.ical4j.model.property.DtStart;
import net.fortuna.ical4j.model.property.Duration;
import net.fortuna.ical4j.model.property.ExDate;
import net.fortuna.ical4j.model.property.ExRule;
import net.fortuna.ical4j.model.property.LastModified;
import net.fortuna.ical4j.model.property.Location;
import net.fortuna.ical4j.model.property.Organizer;
import net.fortuna.ical4j.model.property.Priority;
import net.fortuna.ical4j.model.property.RDate;
import net.fortuna.ical4j.model.property.RecurrenceId;
import net.fortuna.ical4j.model.property.RRule;
import net.fortuna.ical4j.model.property.Sequence;
import net.fortuna.ical4j.model.property.Status;
import net.fortuna.ical4j.model.property.Summary;
import net.fortuna.ical4j.model.property.Transp;
import net.fortuna.ical4j.model.property.Uid;
import net.fortuna.ical4j.model.property.Url;
import net.fortuna.ical4j.model.PropertyList;

import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

/** Class to provide utility methods for translating to BwEvent from ical4j classes
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class BwEventUtil extends IcalUtil {

  /** We are going to try to construct a BwEvent object from a VEvent. This
   * may represent a new event or an update to a pre-existing event. In any
   * case, the VEvent probably has insufficient information to completely
   * reconstitute the event object so we'll get the uid first and retrieve
   * the event if it exists.
   *
   * <p>If it doesn't exist, we'll first fill in the appropriate fields,
   * (non-public, creator, created etc) then for both cases update the
   * remaining fields from the VEvent.
   *
   * <p>Recurring events present some challenges. If there is no recurrence
   * id the vevent represents the master entity which defines the recurrence
   * rules. If a recurrence id is present then the vevent represents a
   * recurrence instance and we should not attempt to retrieve the actual
   * object but the referenced instance.
   *
   * <p>For an update we have to keep track of which fields were present in
   * the vevent and set all absent fields to null in the BwEvent.
   *
   * @param cb          IcalCallback object
   * @param cal
   * @param evs         Events we already converted - used to check for overrides.
   * @param val         VEvent object
   * @param debug
   * @return EventInfo  object representing new entry or updated entry
   * @throws CalFacadeException
   */
  public static EventInfo toEvent(IcalCallback cb,
                                  BwCalendar cal,
                                  Collection evs,
                                  VEvent val,
                                  boolean debug) throws CalFacadeException {
    if (val == null) {
      return null;
    }

    IcalChangeTable chg = new IcalChangeTable();

    try {
      PropertyList pl = val.getProperties();
      ComponentWrapper wrapper = new ComponentWrapper(val);

      if (pl == null) {
        // Empty VEvent
        return null;
      }

      /** We need to know if this is a public event.
       *
       * NOTE: This was wrong. We can probably figure it out from retrieved
       *        event. Ignore class for moment.
       */
//      Property prop = pl.getProperty(Property.CLASS);
//      boolean pubEvent = (prop != null) && ("PUBLIC".equals(prop.getValue()));
      Property prop;

      // Get the guid from the VEvent

      String guid = null;

      prop = pl.getProperty(Property.UID);
      if (prop != null) {
        guid = prop.getValue();
        chg.changed(Property.UID); // get that out of the way
      }

      if (guid == null) {
        /* XXX A guid is required - but are there devices out there without a
         *       guid - and if so how do we handle it?
         */
        throw new CalFacadeException("No guid for event");
      }

      /* See if we have a recurrence id */

      BwRecurrenceId ridObj = null;
      String rid = null;

      prop = pl.getProperty(Property.RECURRENCE_ID);
      if (prop != null) {
        ridObj =  new BwRecurrenceId();
        ridObj.initFromDateTime((DateProperty)prop, cb.getTimezones());

        Parameter par = getParameter(prop, "RANGE");
        if (par != null) {
          /* XXX What do I do with it? */
          ridObj.setRange(par.getValue());
          warn("TRANS-TO_EVENT: Got a recurrence id range");
        }

        rid = ridObj.getDate();
        chg.changed(Property.RECURRENCE_ID); // get that out of the way
      }

      EventInfo masterEI = null;
      EventInfo evinfo = null;
      BwEvent ev = null;

      if (rid != null) {
        // See if we have a new master event. If so create a proxy to that event.
        masterEI = findMaster(guid, evs);

        if (masterEI != null) {
          evinfo = new EventInfo();
          ev = BwEventProxy.makeAnnotation(masterEI.getEvent(), null);
          evinfo.setEvent(ev);
          masterEI.getOverrides().add(ev);
          ev.setRecurrenceId(rid);
          if (debug) {
            debugMsg("TRANS-TO_EVENT: Created override for guid " + guid);
          }
        }
      }

      if (evinfo == null) {
        if (debug) {
          debugMsg("TRANS-TO_EVENT: try to fetch event with guid=" + guid + " and rid=" + rid);
        }

        /* FIXME I think this is wrong. We probably want to provide
         * expansions etc.
         */
        Collection eis = cb.getEvent(cal, guid, rid,
                                     CalFacadeDefs.retrieveRecurMaster);
        if ((eis == null) || (eis.size() == 0)) {
          // do nothing
        } else if (eis.size() > 1) {
          throw new CalFacadeException("More than one event returned for guid.");
        } else {
          evinfo = (EventInfo)eis.iterator().next();
        }

        if (debug) {
          if (evinfo != null) {
            debugMsg("TRANS-TO_EVENT: fetched event with guid");
          } else {
            debugMsg("TRANS-TO_EVENT: did not find event with guid");
          }
        }

        if (evinfo == null) {
          evinfo = new EventInfo();
          ev = new BwEventObj();
          ev.setCreator(cb.getUser());
          ev.setGuid(guid);
          evinfo.setEvent(ev);
          evinfo.setNewEvent(true);
        } else {
          evinfo.setNewEvent(false);
          ev = evinfo.getEvent();
        }
      }

      if (rid != null) {
        evinfo.setRecurrenceId(rid);
      }

      CalTimezones ctz = cb.getTimezones();
      DtStart dtStart = (DtStart)pl.getProperty(Property.DTSTART);
      if (dtStart != null) {
        chg.changed(Property.DTSTART);
      }

      DtEnd dtEnd = (DtEnd)pl.getProperty(Property.DTEND);
      if (dtEnd != null) {
        chg.changed(Property.DTEND);
      }

      Duration duration = (Duration)pl.getProperty(Property.DURATION);
      if (duration != null) {
        chg.changed(Property.DURATION);
      }

      setDates(ctz, ev, dtStart, dtEnd, duration);

      Collection exdates = null;
      Collection rdates = null;

      Iterator it = pl.iterator();

      while (it.hasNext()) {
        prop = (Property)it.next();

        //debugMsg("ical prop " + prop.getClass().getName());
        String pval = prop.getValue();
        if ((pval != null) && (pval.length() == 0)) {
          pval = null;
        }

        chg.changed(prop.getName());

        if (prop instanceof Attendee) {
          ev.addAttendee(getAttendee((Attendee)prop));
        } else if (prop instanceof Categories) {
          /* ------------------- Categories -------------------- */

          CategoryList cl = ((Categories)prop).getCategories();

          if (cl != null) {
            /* Got some categories */

            Iterator cit = cl.iterator();

            while (cit.hasNext()) {
              String wd = (String)cit.next();

              BwCategory cat = new BwCategory();
              cat.setWord(wd);

              BwCategory dbcat = cb.findCategory(cat);

              if (dbcat == null) {
                cb.addCategory(cat);
                dbcat = cat;
              }

              ev.addCategory(dbcat);
            }
          } else {
            /* Most personal events don't have a category */
          }
        } else if (prop instanceof Clazz) {
          /* ------------------- Class -------------------- */

          /* We did this above */
        } else if (prop instanceof Contact) {
          /* ------------------- Contact -------------------- */

          /* This doesn't work. We now just send the name and use that to
             retrieve a matching entry.
          AltRep alt = IcalUtil.getAltRep(prop);

          /* The related db sponsor entry * /
          BwSponsor dbsp = null;

          boolean same = false;

          if (ev != null ) {
            dbsp = ev.getSponsor();
          } else if (alt != null) {
            /* Try to use the altrep to retrieve the contact
             * /
            dbsp = uriGen.getSponsor(alt.getUri());

            if (dbsp != null) {
              dbsp = svci.getSponsor(dbsp.getId());
            }
          }

          if (dbsp != null) {
            /* Build what we think we sent them
             * /
            String dbspVal = makeContactString(dbsp);

            if ((pval == null) && (dbspVal == null)) {
              same = true;
            } else if ((pval != null) && pval.equals(dbspVal)) {
              same = true;
            }
          }

          if (!same) {
            /** Value seems to have changed - any way to parse new value?* /
            ev.setSponsor(makeContact(pval));
          } else {
            ev.setSponsor(dbsp);
          }*/
          ev.setSponsor(makeContact(pval));
        } else if (prop instanceof Created) {
          /* ------------------- Created -------------------- */

          ev.setCreated(wrapper.getCreated());
        } else if (prop instanceof Description) {
          /* ------------------- Description -------------------- */

          ev.setDescription(pval);
        } else if (prop instanceof DtEnd) {
          /* ------------------- DtEnd -------------------- */
        } else if (prop instanceof DtStamp) {
          /* ------------------- DtStamp -------------------- */

          ev.setDtstamp(wrapper.getDtStamp());
        } else if (prop instanceof DtStart) {
          /* ------------------- DtStart -------------------- */
        } else if (prop instanceof Duration) {
          /* ------------------- Duration -------------------- */
          /* Skip this until the rest are done.
           */
        } else if (prop instanceof ExDate) {
          /* ------------------- ExDate -------------------- */

          if (exdates == null) {
            exdates = new TreeSet();
          }

          exdates.addAll(makeDateTimes((DateListProperty)prop, ctz));
        } else if (prop instanceof ExRule) {
          /* ------------------- ExRule -------------------- */

          ev.getRecurrence().addExrule(pval);
          ev.setRecurrenceChanged(true);
          ev.setRecurring(true);
        } else if (prop instanceof LastModified) {
          /* ------------------- LastModified -------------------- */

          ev.setLastmod(wrapper.getLastModified());
        } else if (prop instanceof Location) {
          /* ------------------- Location -------------------- */

          /* don't work
          AltRep alt = IcalUtil.getAltRep(prop);

          /* The related db BwLocation entry * /
          BwLocation dbloc = null;

          boolean same = false;

          if (!evinfo.getNewEvent()) {
            dbloc = ev.getLocation();
          } else if (alt != null) {
            /* Try to use the altrep to retrieve the location
             * /
            dbloc = uriGen.getLocation(alt.getUri());

            if (dbloc != null) {
              dbloc = svci.getLocation(dbloc.getId());
            }
          }

          if (dbloc != null) {
            /* Build what we think we sent them
             * /
            String dblocVal = makeLocationString(dbloc);

            if ((pval == null) && (dblocVal == null)) {
              same = true;
            } else if ((pval != null) && pval.equals(dblocVal)) {
              same = true;
            }
          }

          if (!same) {
            /** Value seems to have changed - any way to parse new value?* /
            ev.setLocation(makeLocation(pval));
          } else {
            ev.setLocation(dbloc);
          }*/
          ev.setLocation(makeLocation(cb, pval));
        } else if (prop instanceof Organizer) {
          /* ------------------- Organizer -------------------- */

          ev.setOrganizer(getOrganizer((Organizer)prop, ev));
        } else if (prop instanceof RDate) {
          /* ------------------- RDate -------------------- */


          if (rdates == null) {
            rdates = new TreeSet();
          }

          rdates.addAll(makeDateTimes((DateListProperty)prop, ctz));
        } else if (prop instanceof RecurrenceId) {
          // Done above
        } else if (prop instanceof RRule) {
          /* ------------------- RRule -------------------- */

          ev.getRecurrence().addRrule(pval);
          ev.setRecurrenceChanged(true);
          ev.setRecurring(true);
        } else if (prop instanceof Priority) {
          /* ------------------- Priority -------------------- */

          ev.setPriority(((Priority)prop).getLevel());
        } else if (prop instanceof Sequence) {
          /* ------------------- Sequence -------------------- */

          ev.setSequence(((Sequence)prop).getSequenceNo());
        } else if (prop instanceof Status) {
          /* ------------------- Status -------------------- */

          ev.setStatus(pval);
        } else if (prop instanceof Summary) {
          /* ------------------- Summary -------------------- */

          ev.setSummary(pval);
        } else if (prop instanceof Transp) {
          /* ------------------- Transp -------------------- */

          ev.setTransparency(pval);
        } else if (prop instanceof Uid) {
          /* ------------------- Uid -------------------- */

          /* We did this above */
        } else if (prop instanceof Url) {
          /* ------------------- Url -------------------- */

          ev.setLink(pval);
        } else {
          if (debug) {
            debugMsg("Unsupported property with class " + prop.getClass() +
                     " and value " + pval);
          }
        }
      }

      if (exdates != null) {
        CalFacadeUtil.updateCollection(ev.getRecurrence().getExdates(),
                                       exdates);

        ev.setRecurrenceChanged(true);
        ev.setRecurring(true);
      }

      if (rdates != null) {
        CalFacadeUtil.updateCollection(ev.getRecurrence().getRdates(),
                                       rdates);

        ev.setRecurrenceChanged(true);
        ev.setRecurring(true);
      }

      VAlarmUtil.processVEventAlarms(val, ev);

      processChangeTable(chg, ev);

      if (debug) {
        debugMsg(ev.toString());
      }

      if (masterEI != null) {
        // Just return null as this event is on its override list
        return null;
      }

      return evinfo;
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /** Set the dates in an event given a start and one or none of end and
   *  duration.
   *
   * @param ctz
   * @param ev
   * @param dtStart
   * @param dtEnd
   * @param duration
   * @throws CalFacadeException
   */
  public static void setDates(CalTimezones ctz, BwEvent ev, DtStart dtStart, DtEnd dtEnd,
                              Duration duration) throws CalFacadeException {
    try {
      if (dtStart == null) {
        throw new CalFacadeException("Missing event start time");
      }

      ev.setDtstart(BwDateTime.makeDateTime(dtStart, ctz));

      char endType = BwEvent.endTypeNone;

      if (dtEnd != null) {
        ev.setDtend(BwDateTime.makeDateTime(dtEnd, ctz));
        endType = BwEvent.endTypeDate;
      }

      /** If we were given a duration store it in the event and calculate
          an end to the event - which we should not have been given.
       */
      if (duration != null) {
        if (endType != BwEvent.endTypeNone) {
          throw new CalFacadeException(CalFacadeException.endAndDuration);
        }

        endType = BwEvent.endTypeDuration;
        ev.setDuration(duration.getValue());

        Dur dur = duration.getDuration();

        ev.setDtend(BwDateTime.makeDateTime(dtStart,
                                            ev.getDtstart().getDateType(),
                                            dur, ctz));
      } else if (endType == BwEvent.endTypeNone) {
        /* No duration and no end specified. Set the end values to the start
           values + 1
         */
        boolean dateOnly = ev.getDtstart().getDateType();
        Dur dur;

        if (dateOnly) {
          dur = new Dur(1, 0, 0, 0); // 1 day
        } else {
          dur = new Dur(0, 0, 0, 1); // 1 second
        }
        ev.setDtend(BwDateTime.makeDateTime(dtStart, dateOnly, dur, ctz));
      }

      if (endType != BwEvent.endTypeDuration) {
        // Calculate a duration
        ev.setDuration(BwDateTime.makeDuration(ev.getDtstart(), ev.getDtend()).toString());
      }

      ev.setEndType(endType);
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /* ====================================================================
                      Private methods
     ==================================================================== */

  /* Go through the change table entries removing fields that were not present in
   * the vevent
   */
  private static void processChangeTable(IcalChangeTable chg, BwEvent ev) throws CalFacadeException {
    Iterator it = chg.values().iterator();

    while (it.hasNext()) {
      IcalChangeTable.Entry ent = (IcalChangeTable.Entry)it.next();

      if (ent.changed || !ent.eventProperty) {
        continue;
      }

      switch (ent.index) {
      case PropertyIndex.CLASS:
        break;

      case PropertyIndex.CREATED:
        break;

      case PropertyIndex.DESCRIPTION:
        ev.setDescription(null);
        break;

      case PropertyIndex.DTSTAMP:
        break;

      case PropertyIndex.DTSTART:
        break;

      case PropertyIndex.DURATION:
        break;

      case PropertyIndex.GEO:
        break;

      case PropertyIndex.LAST_MODIFIED:
        break;

      case PropertyIndex.LOCATION:
        ev.setLocation(null);
        break;

      case PropertyIndex.ORGANIZER:
        break;

      case PropertyIndex.PRIORITY:
        break;

      case PropertyIndex.RECURRENCE_ID:
        break;

      case PropertyIndex.SEQUENCE:
        break;

      case PropertyIndex.STATUS:
        break;

      case PropertyIndex.SUMMARY:
        ev.setSummary(null);
        break;

      case PropertyIndex.UID:
        break;

      case PropertyIndex.URL:
        ev.setLink(null);
        break;

      case PropertyIndex.DTEND:
        break;

      case PropertyIndex.TRANSP:
        break;


      /* ---------------------------- Multi valued --------------- */

      case PropertyIndex.ATTACH:
        break;

      case PropertyIndex.ATTENDEE:
        break;

      case PropertyIndex.CATEGORIES:
        break;

      case PropertyIndex.COMMENT:
        break;

      case PropertyIndex.CONTACT:
        break;

      case PropertyIndex.EXDATE:
        break;

      case PropertyIndex.EXRULE:
        break;

      case PropertyIndex.REQUEST_STATUS:
        break;

      case PropertyIndex.RELATED_TO:
        break;

      case PropertyIndex.RESOURCES:
        break;

      case PropertyIndex.RDATE:
        break;

      case PropertyIndex.RRULE:
        break;
      }
    }
  }

  /* See if the master event is already in the collection of events
   * we've processed for this calendar. Only called if we have an event
   * with a recurrence id
   */
  private static EventInfo findMaster(String guid, Collection evs) {
    if (evs == null) {
      return null;
    }
    Iterator it = evs.iterator();

    while (it.hasNext()) {
      EventInfo ei = (EventInfo)it.next();
      BwEvent ev = ei.getEvent();

      if ((ev.getRecurrence().getRecurrenceId() == null) &&
          guid.equals(ev.getGuid()) &&
          ei.getNewEvent()) {
        return ei;
      }
    }

    return null;
  }

  /*
  private static final String defaultDelim = ", ";
  private static final String urlDelim = " - ";

  private static final String nameValSep = ": ";

  private void addNonNull(String delim, String resourceKey,
                          String val, StringBuffer sb) {
    if ((val != null) && (val.length() > 0)) {
      sb.append(delim);
      sb.append(svci.getResources().getString(resourceKey));
      sb.append(nameValSep);
      sb.append(val);
    }
  }

  private String makeFieldStart(String delim, String resourceKey) {
    StringBuffer sb = new StringBuffer(delim);
    sb.append(svci.getResources().getString(resourceKey));
    sb.append(nameValSep);

    return sb.toString();
  }*/

  /* Try to build a location from the supplied string. This only works if
   * the delimiters and keywords remain intact.
   *
   * <p>We retrieve the closest matching location or create a new one.
   */
  private static BwLocation makeLocation(IcalCallback cb, String val) throws CalFacadeException {
    if (val == null) {
      return null;
    }

    return cb.ensureLocationExists(val);
  }

  /* Try to build a contact from the supplied string. This only works if
   * the delimiters and keywords remain intact.
   */
  private static BwSponsor makeContact(String val) {
    if (val == null) {
      return null;
    }

    BwSponsor sp = new BwSponsor();

    sp.setName(val);
    return sp;
  }
}

