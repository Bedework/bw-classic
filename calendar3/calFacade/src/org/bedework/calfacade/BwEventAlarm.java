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
package org.bedework.calfacade;

import java.util.Collection;
import java.util.Date;

import net.fortuna.ical4j.model.Dur;
import net.fortuna.ical4j.model.property.Trigger;

/** An alarm for an event in UWCal.
 *
 *  @version 1.0
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class BwEventAlarm extends BwAlarm {
  /** Set while retrieving object */
  private int eventid = CalFacadeDefs.unsavedItemKey;

  /** The event this refers to. Either this or the VtodoVO reference will be set.
   *
   */
  private BwEvent event;

  /** Constructor
   *
   */
  public BwEventAlarm() {
  }

  /** Constructor for all fields (for db retrieval)
   *
   * @param event         EventVO for this alarm - if non-null todo == null
   * @param owner         Owner of alarm
   * @param alarmType     type of alarm
   * @param trigger       This specifies the time for the alarm in rfc format
   * @param triggerStart  true if we trigger off the start
   * @param triggerDateTime  true if trigger is a date time value
   * @param duration      External form of duration
   * @param repeat        number of repetitions
   * @param triggerTime   This specifies the time for the next alarm
   *                      converted to internal format - if 0 has not been
   *                      calculated
   * @param previousTrigger   Used to determine if we missed an alarm
   * @param repeatCount   Repetition we are currently handling
   * @param expired       Set to true when we're done
   * @param attach        String audio file or attachment or exec
   * @param description   String description
   * @param summary       String summary (email)
   * @param attendees     Collection of attendees
   */
  public BwEventAlarm(BwEvent event,
                      BwUser owner,
                      int alarmType,
                      String trigger,
                      boolean triggerStart,
                      boolean triggerDateTime,
                      String duration,
                      int repeat,
                      long triggerTime,
                      long previousTrigger,
                      int repeatCount,
                      boolean expired,
                      String attach,
                      String description,
                      String summary,
                      Collection attendees) {
    super(owner, alarmType, trigger, triggerStart, triggerDateTime,
          duration, repeat, triggerTime, previousTrigger,
          repeatCount, expired, attach, description,
          summary, attendees);
    setEvent(event);
  }

  /** Make an audio alarm
   *
   * @param event
   * @param owner
   * @param trigger
   * @param triggerStart
   * @param triggerDateTime
   * @param duration
   * @param repeat
   * @param attach
   * @return BwEventAlarm
   */
  public static BwEventAlarm audioAlarm(BwEvent event,
                                        BwUser owner,
                                        String trigger,
                                        boolean triggerStart,
                                        boolean triggerDateTime,
                                        String duration,
                                        int repeat,
                                        String attach) {
    return new BwEventAlarm(event, owner, alarmTypeAudio,
                            trigger, triggerStart, triggerDateTime,
                            duration, repeat,
                            0, 0, 0, false,
                            attach,
                            null, null, null);
  }

  /** Make a display alarm
   *
   * @param event
   * @param owner
   * @param trigger
   * @param triggerStart
   * @param triggerDateTime
   * @param duration
   * @param repeat
   * @param description
   * @return BwEventAlarm
   */
  public static BwEventAlarm displayAlarm(BwEvent event,
                                          BwUser owner,
                                          String trigger,
                                          boolean triggerStart,
                                          boolean triggerDateTime,
                                          String duration,
                                          int repeat,
                                          String description) {
    return new BwEventAlarm(event, owner, alarmTypeDisplay,
                            trigger, triggerStart, triggerDateTime,
                            duration, repeat,
                            0, 0, 0, false,
                            null, description, null, null);
  }

  /** Make an email alarm
   *
   * @param event
   * @param owner
   * @param trigger
   * @param triggerStart
   * @param triggerDateTime
   * @param duration
   * @param repeat
   * @param attach
   * @param description
   * @param summary
   * @param attendees
   * @return BwEventAlarm
   */
  public static BwEventAlarm emailAlarm(BwEvent event,
                                        BwUser owner,
                                        String trigger,
                                        boolean triggerStart,
                                        boolean triggerDateTime,
                                        String duration,
                                        int repeat,
                                        String attach,
                                        String description,
                                        String summary,
                                        Collection attendees) {
    return new BwEventAlarm(event, owner, alarmTypeEmail,
                            trigger, triggerStart, triggerDateTime,
                            duration, repeat,
                            0, 0, 0, false,
                            attach,
                            description, summary, attendees);
  }

  /** Make a procedure alarm
   *
   * @param event
   * @param owner
   * @param trigger
   * @param triggerStart
   * @param triggerDateTime
   * @param duration
   * @param repeat
   * @param attach
   * @param description
   * @return BwEventAlarm
   */
  public static BwEventAlarm procedureAlarm(BwEvent event,
                                            BwUser owner,
                                            String trigger,
                                            boolean triggerStart,
                                            boolean triggerDateTime,
                                            String duration,
                                            int repeat,
                                            String attach,
                                            String description) {
    return new BwEventAlarm(event, owner, alarmTypeProcedure,
                            trigger, triggerStart, triggerDateTime,
                            duration, repeat,
                            0, 0, 0, false,
                            attach,
                            description, null, null);
  }

  /* ====================================================================
   *                      Bean methods
   * ==================================================================== */

  /** set the event
   *
   * @param val  BwEvent event
   */
  public void setEvent(BwEvent val) {
    event = val;
    if (event == null) {
      eventid = CalFacadeDefs.unsavedItemKey;
    } else {
      eventid = event.getId();
    }
  }

  /** Get the event
   *
   * @return BwEvent     event
   */
  public BwEvent getEvent() {
    return event;
  }

  /**    Set the eventid
   *
   * @param val   eventid
   */
  public void setEventid(int val) {
    eventid = val;
  }

  /** Get the event id
   *
   * @return int    the eventid
   */
  public int getEventid() {
    return eventid;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwAlarm#getTriggerDate()
   */
  public Date getTriggerDate() throws CalFacadeException {
    try {
      if (triggerDate != null) {
        return triggerDate;
      }

      Trigger tr = new Trigger();
      tr.setValue(getTrigger());

      /* if dt is null then it's a duration????
       */
      Date dt = tr.getDateTime();
      if (dt == null) {
        Dur dur = tr.getDuration();

        if (getEvent() == null) {
          throw new CalFacadeException("No event for alarm " + this);
        }

        dt = dur.getTime(CalFacadeUtil.getDate(getEvent().getDtstart()));
      }

      triggerDate = dt;

      return dt;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /* ====================================================================
   *                      Object methods
   * ==================================================================== */

  public int hashCode() {
    int hc = 1;

    if (getEvent() != null) {
      hc *= getEvent().hashCode();
    }

    hc *= super.hashCode();

    return hc;
  }

  /* We consider two event alarms equal if their event, user, times and
   * durations match.
   *
   * We do not check the other fields as they may be different if we are updating.
   */
  public boolean equals(Object obj) {
    if (obj == this) {
      return true;
    }

    if (!(obj instanceof BwEventAlarm)) {
      return false;
    }

    BwEventAlarm that = (BwEventAlarm)obj;

    if (!eqObj(getEvent(), that.getEvent())) {
      return false;
    }

    return super.equals(obj);
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwEventAlarm{");

    toStringSegment(sb);

    if (event != null) {
      sb.append(", eventid=");
      sb.append(getEvent().getId());
    }

    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    try {
      BwEventAlarm a = new BwEventAlarm(null,  //event
                                        null, // user
                                        getAlarmType(),
                                        getTrigger(),
                                        getTriggerStart(),
                                        getTriggerDateTime(),
                                        getDuration(),
                                        getRepeat(),
                                        getTriggerTime(),
                                        getPreviousTrigger(),
                                        getRepeatCount(),
                                        getExpired(),
                                        getAttach(),
                                        getDescription(),
                                        getSummary(),
                                        cloneAttendees());

      // Don't clone event , they are cloning us

      if (getOwner() != null) {
        a.setOwner((BwUser)getOwner().clone());
      }

      return a;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }
}

