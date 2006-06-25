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
package org.bedework.calfacade.util;

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwDuration;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.svc.EventInfo;

import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Period;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

import org.apache.log4j.Logger;

/** Select periods in the Collection of periods which fall within a given
 * time period. By incrementing that time period we can break up the given
 * periods into time periods of a given granularity.
 *
 * <p>Don't make much sense? Try an example:
 *
 * <p>The given set of periods is a set of events for the week. The granularity
 * is one day - each call gives events appearing in that day - possibly extending
 * into previous and next days.
 *
 * <p>Another? The periods are a set of freebusy objects defining busy time for
 * one day.
 * The granularity is 30 minutes. The result is a free busy for a day divided
 * into 30 minute periods.
 *
 * @author Mike Douglass douglm at rpi.edu
 */
public class Granulator {
  private Granulator() {}

  /** This class defines the entities which occupy time and the period of
   * interest and can be passed repeatedly to getPeriodsEvents.
   *
   * <p>The end datetime will be updated ready for the next call. If endDt is
   * non-null on entry it will be used to set the startDt.
   */
  public static class GetPeriodsPars {
    boolean debug = false;

    /** Event Info or EventPeriod or Period objects to extract from */
    public Collection periods;
    /** Start of period - updated at each call from endDt */
    public BwDateTime startDt;
    /** Duration of period or granularity */
    public BwDuration dur;
    /** */
    public CalTimezones tzcache;

    /** On return has the end date of the period. */
    public BwDateTime endDt;
  }

  /** Select the events in the collection which fall within the period
   * defined by the start and duration.
   *
   * @param   pars      GetPeriodsPars object
   * @return  Collection of EventInfo being one days events or empty for no events.
   * @throws CalFacadeException
   */
  public static Collection getPeriodsEvents(GetPeriodsPars pars) throws CalFacadeException {
    ArrayList al = new ArrayList();
    long millis = 0;
    if (pars.debug) {
      millis = System.currentTimeMillis();
    }

    if (pars.endDt != null) {
      pars.startDt = pars.endDt.copy(pars.tzcache);
    }
    pars.endDt = pars.startDt.addDuration(pars.dur, pars.tzcache);
    String start = pars.startDt.getDate();
    String end = pars.endDt.getDate();

    if (pars.debug) {
      debugMsg("Did UTC stuff in " + (System.currentTimeMillis() - millis));
    }

    EntityRange er = new EntityRange();
    Iterator it = pars.periods.iterator();
    while (it.hasNext()) {
      er.setEntity(it.next());

      /* Period is within range if:
             ((evstart < end) and ((evend > start) or
                 ((evstart = evend) and (evend >= start))))
       */

      int evstSt = er.start.compareTo(end);

      //debugMsg("                   event " + evStart + " to " + evEnd);

      if (evstSt < 0) {
        int evendSt = er.end.compareTo(start);

        if ((evendSt > 0) ||
            (er.start.equals(er.end) && (evendSt >= 0))) {
          // Passed the tests.
          //if (debug) {
          //  debugMsg("Event passed range " + start + "-" + end +
          //           " with dates " + evStart + "-" + evEnd +
          //           ": " + ev.getSummary());
          //}
          al.add(er.entity);
        }
      }
    }

    return al;
  }

  private static class EntityRange {
    Object entity;

    String start;
    String end;

    void setEntity(Object o) throws CalFacadeException {
      entity = o;

      if (o instanceof EventInfo) {
        EventInfo ei = (EventInfo)o;
        BwEvent ev = ei.getEvent();

        start = ev.getDtstart().getDate();
        end = ev.getDtend().getDate();

        return;
      }

      if (o instanceof EventPeriod) {
        EventPeriod ep = (EventPeriod)o;

        start = String.valueOf(ep.getStart());
        end = String.valueOf(ep.getEnd());

        return;
      }

      if (o instanceof Period) {
        Period p = (Period)o;

        start = String.valueOf(p.getStart());
        end = String.valueOf(p.getEnd());

        return;
      }

      start = null;
      end = null;
    }
  }

  /**
   *
   */
  public static class EventPeriod implements Comparable {
    private DateTime start;
    private DateTime end;
    private int type;  // from BwFreeBusyComponent

    /** Constructor
     *
     * @param start
     * @param end
     * @param type
     */
    public EventPeriod(DateTime start, DateTime end, int type) {
      this.start = start;
      this.end = end;
      this.type = type;
    }

    /**
     * @return DateTime
     */
    public DateTime getStart() {
      return start;
    }

    /**
     * @return DateTime
     */
    public DateTime getEnd() {
      return end;
    }

    /**
     * @return int
     */
    public int getType() {
      return type;
    }

    public int compareTo(Object o) {
      if (!(o instanceof EventPeriod)) {
        return -1;
      }

      EventPeriod that = (EventPeriod)o;

      /* Sort by type first */
      if (type < that.type) {
        return -1;
      }

      if (type > that.type) {
        return 1;
      }

      int res = start.compareTo(that.start);
      if (res != 0) {
        return res;
      }

      return end.compareTo(that.end);
    }

    public boolean equals(Object o) {
      return compareTo(o) == 0;
    }

    public int hashCode() {
      return 7 * (type + 1) * (start.hashCode() + 1) * (end.hashCode() + 1);
    }

    public String toString() {
      StringBuffer sb = new StringBuffer("EventPeriod{start=");

      sb.append(start);
      sb.append(", end=");
      sb.append(end);
      sb.append(", type=");
      sb.append(type);
      sb.append("}");

      return sb.toString();
    }
  }

  private static void debugMsg(String msg) {
    Logger.getLogger(Granulator.class).debug(msg);
  }
}
