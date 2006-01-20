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

/** An alarm for a todo in UWCal.
 *
 *  @version 1.0
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class BwTodoAlarm extends BwAlarm {
  /** Set while retrieving object */
  private int todoid;

  /** The todo this refers to. Either this or the EventVO reference will be set.
   *
   */
  private BwTodo todo;

  /** Constructor
   *
   */
  public BwTodoAlarm() {
  }

  /** Constructor for all fields (for db retrieval)
   *
   * @param todo          TodoVO for this alarm - if non-null event == null
   * @param alarmType     type of alarm
   * @param user          Owner of alarm
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
   * @param sequence      long sequence value
   */
  public BwTodoAlarm(BwTodo todo,
                     int alarmType,
                     BwUser user,
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
                     Collection attendees,
                     long sequence) {
    super(alarmType, user, trigger, triggerStart, triggerDateTime,
          duration, repeat, triggerTime, previousTrigger,
          repeatCount, expired, attach, description,
          summary, attendees, sequence);
    this.todo = todo;
  }

  /** Make an audio alarm
  *
   * @param todo
   * @param user
   * @param trigger
   * @param triggerStart
   * @param triggerDateTime
   * @param duration
   * @param repeat
   * @param attach
   * @return BwTodoAlarm
   */
  public static BwTodoAlarm audioAlarm(BwTodo todo,
                                       BwUser user,
                                       String trigger,
                                       boolean triggerStart,
                                       boolean triggerDateTime,
                                       String duration,
                                       int repeat,
                                       String attach) {
    return new BwTodoAlarm(todo, alarmTypeAudio, user,
                           trigger, triggerStart, triggerDateTime,
                           duration, repeat,
                           0, 0, 0, false,
                           attach,
                           null, null, null, 0);
  }

  /** Make a display alarm
  *
   * @param todo
   * @param user
   * @param trigger
   * @param triggerStart
   * @param triggerDateTime
   * @param duration
   * @param repeat
   * @param description
   * @return BwTodoAlarm
   */
  public static BwTodoAlarm displayAlarm(BwTodo todo,
                                         BwUser user,
                                         String trigger,
                                         boolean triggerStart,
                                         boolean triggerDateTime,
                                         String duration,
                                         int repeat,
                                         String description) {
    return new BwTodoAlarm(todo, alarmTypeDisplay, user,
                           trigger, triggerStart, triggerDateTime,
                           duration, repeat,
                           0, 0, 0, false,
                           null, description, null, null, 0);
  }

  /** Make an email alarm
  *
   * @param todo
   * @param user
   * @param trigger
   * @param triggerStart
   * @param triggerDateTime
   * @param duration
   * @param repeat
   * @param attach
   * @param description
   * @param summary
   * @param attendees
   * @return BwTodoAlarm
   */
  public static BwTodoAlarm emailAlarm(BwTodo todo,
                                       BwUser user,
                                       String trigger,
                                       boolean triggerStart,
                                       boolean triggerDateTime,
                                       String duration,
                                       int repeat,
                                       String attach,
                                       String description,
                                       String summary,
                                       Collection attendees) {
    return new BwTodoAlarm(todo, alarmTypeEmail, user,
                           trigger, triggerStart, triggerDateTime,
                           duration, repeat,
                           0, 0, 0, false,
                           attach,
                           description, summary, attendees, 0);
  }

  /** Make a procedure alarm
  *
   * @param todo
   * @param user
   * @param trigger
   * @param triggerStart
   * @param triggerDateTime
   * @param duration
   * @param repeat
   * @param attach
   * @param description
   * @return BwTodoAlarm
   */
  public static BwTodoAlarm procedureAlarm(BwTodo todo,
                                           BwUser user,
                                           String trigger,
                                           boolean triggerStart,
                                           boolean triggerDateTime,
                                           String duration,
                                           int repeat,
                                           String attach,
                                           String description) {
    return new BwTodoAlarm(todo, alarmTypeProcedure, user,
                           trigger, triggerStart, triggerDateTime,
                           duration, repeat,
                           0, 0, 0, false,
                           attach,
                           description, null, null, 0);
  }

  /* ====================================================================
   *                      Bean methods
   * ==================================================================== */

  /** set the todo
   *
   * @param val  TodoVO todo
   */
  public void setTodo(BwTodo val) {
    todo = val;
  }

  /** Get the event
   *
   * @return TodoVO     todo
   */
  public BwTodo getTodo() {
    return todo;
  }

  /**    Set the todoid
   *
   * @param val   todoid
   */
  public void setTodoid(int val) {
    todoid = val;
  }

  /** Get the todo id
   *
   * @return int    the todoid
   */
  public int getTodoid() {
    return todoid;
  }

  public Date getTriggerDate() throws CalFacadeException {
    try {
      if (triggerDate != null) {
        return triggerDate;
      }

      Trigger tr = new Trigger();
      tr.setValue(trigger);

      /* if dt is null then it's a duration????
       */
      Date dt = tr.getDateTime();
      if (dt == null) {
        Dur dur = tr.getDuration();

        if (todo == null) {
          throw new CalFacadeException("No todo for alarm " + this);
        }

        dt = dur.getTime(CalFacadeUtil.getDate(todo.getDtstart()));
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

    if (todo != null) {
      hc *= todo.hashCode();
    }

    hc *= super.hashCode();

    return hc;
  }

  /* We consider two event alarms equal if their event, user, times and
   * durations match.
   */
  public boolean equals(Object obj) {
    if (obj == this) {
      return true;
    }

    if (!(obj instanceof BwTodoAlarm)) {
      return false;
    }

    BwTodoAlarm that = (BwTodoAlarm)obj;

    if (!eqObj(todo, that.todo)) {
      return false;
    }

    return super.equals(obj);
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("TodoAlarmVO{");

    if (todo != null) {
      sb.append(", todoId=");
      sb.append(todo.getId());
    }

    sb.append(", ");

    sb.append(super.toString());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    BwTodoAlarm a = new BwTodoAlarm(null,  //todo
                                    alarmType,
                                    null, // user
                                    trigger,
                                    triggerStart,
                                    triggerDateTime,
                                    duration,
                                    repeat,
                                    triggerTime,
                                    previousTrigger,
                                    repeatCount,
                                    expired,
                                    attach,
                                    description,
                                    summary,
                                    cloneAttendees(),
                                    sequence
                                    );

    // Don't clone event or todo, they are cloning us

    if (user != null) {
      a.setUser((BwUser)user.clone());
    }

    return a;
  }
}

