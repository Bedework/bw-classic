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

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwFreeBusyComponent;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.CalTimezones;

import net.fortuna.ical4j.model.Dur;
import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.PeriodList;
import net.fortuna.ical4j.model.component.VFreeBusy;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.parameter.FbType;
import net.fortuna.ical4j.model.property.DtEnd;
import net.fortuna.ical4j.model.property.DtStamp;
import net.fortuna.ical4j.model.property.DtStart;
import net.fortuna.ical4j.model.property.Duration;
import net.fortuna.ical4j.model.property.FreeBusy;
import net.fortuna.ical4j.model.PropertyList;

import java.util.Iterator;

/** Class to provide utility methods for translating to BwFreeBusy from ical4j classes
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class BwFreeBusyUtil extends IcalUtil {
  /**
   * @param cb
   * @param val
   * @param debug
   * @return BwFreeBusy
   * @throws CalFacadeException
   */
  public static BwFreeBusy toFreeBusy(IcalCallback cb,
                                      VFreeBusy val,
                                      boolean debug) throws CalFacadeException {
    if (val == null) {
      return null;
    }

    IcalChangeTable chg = new IcalChangeTable();

    try {
      PropertyList pl = val.getProperties();

      if (pl == null) {
        // Empty VEvent
        return null;
      }

      BwFreeBusy fb = new BwFreeBusy();

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

      setDates(ctz, fb, dtStart, dtEnd, duration);

      Iterator it = pl.iterator();

      while (it.hasNext()) {
        Property prop = (Property)it.next();

        String pval = prop.getValue();
        if ((pval != null) && (pval.length() == 0)) {
          pval = null;
        }

        chg.changed(prop.getName());

        if (prop instanceof FreeBusy) {
          FreeBusy fbusy = (FreeBusy)prop;
          PeriodList perpl = fbusy.getPeriods();
          Parameter par = getParameter(fbusy, "FBTYPE");
          int fbtype;

          if (par == null) {
            fbtype = BwFreeBusyComponent.typeBusy;
          } else if (par.equals(FbType.BUSY)) {
            fbtype = BwFreeBusyComponent.typeBusy;
          } else if (par.equals(FbType.BUSY_TENTATIVE)) {
            fbtype = BwFreeBusyComponent.typeBusyTentative;
          } else if (par.equals(FbType.BUSY_UNAVAILABLE)) {
            fbtype = BwFreeBusyComponent.typeBusyUnavailable;
          } else if (par.equals(FbType.FREE)) {
            fbtype = BwFreeBusyComponent.typeFree;
          } else {
            if (debug) {
              debugMsg("Unsupported parameter " + par.getName());
            }

            throw new IcalMalformedException("parameter " + par.getName());
          }

          BwFreeBusyComponent fbc = new BwFreeBusyComponent();

          fbc.setType(fbtype);

          Iterator perit = perpl.iterator();
          while (perit.hasNext()) {
            Period per = (Period)perit.next();

            fbc.addPeriod(per);
          }

          fb.addTime(fbc);
        } else if (prop instanceof DtEnd) {
          /* ------------------- DtEnd -------------------- */
        } else if (prop instanceof DtStamp) {
          /* ------------------- DtStamp -------------------- */

          //ev.setDtstamp(wrapper.getDtStamp());
        } else if (prop instanceof DtStart) {
          /* ------------------- DtStart -------------------- */
        } else {
          if (debug) {
            debugMsg("Unsupported property with class " + prop.getClass() +
                     " and value " + pval);
          }
        }
      }

      return fb;
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
   * @param fb
   * @param dtStart
   * @param dtEnd
   * @param duration
   * @throws CalFacadeException
   */
  public static void setDates(CalTimezones ctz, BwFreeBusy fb, DtStart dtStart,
                              DtEnd dtEnd,
                              Duration duration) throws CalFacadeException {
    try {
      if (dtStart == null) {
        throw new CalFacadeException("Missing event start time");
      }

      fb.setStart(BwDateTime.makeDateTime(dtStart, ctz));

      char endType = BwEvent.endTypeNone;

      if (dtEnd != null) {
        fb.setEnd(BwDateTime.makeDateTime(dtEnd, ctz));
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

        Dur dur = duration.getDuration();

        fb.setEnd(BwDateTime.makeDateTime(dtStart,
                                          fb.getStart().getDateType(),
                                          dur, ctz));
      } else if (endType == BwEvent.endTypeNone) {
        /* No duration and no end specified. Set the end values to the start
           values + 1
         */
        boolean dateOnly = fb.getStart().getDateType();
        Dur dur;

        if (dateOnly) {
          dur = new Dur(1, 0, 0, 0); // 1 day
        } else {
          dur = new Dur(0, 0, 0, 1); // 1 second
        }
        fb.setEnd(BwDateTime.makeDateTime(dtStart, dateOnly, dur, ctz));
      }
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }
}
