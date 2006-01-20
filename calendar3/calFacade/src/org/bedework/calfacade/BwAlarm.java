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

import org.bedework.calfacade.ifs.Attendees;
import org.bedework.calfacade.ifs.AttendeesI;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.TreeSet;

/** An alarm in UWCal representing an rfc2445 valarm object.
 *
 *  @version 1.0
 *  @author Mike Douglass   douglm@rpi.edu
 */
public abstract class BwAlarm implements AttendeesI, Comparable, Serializable {
  /** audio */
  public final static int alarmTypeAudio = 0;

  /** display*/
  public final static int alarmTypeDisplay = 1;

  /** email */
  public final static int alarmTypeEmail = 2;

  /** procedure */
  public final static int alarmTypeProcedure = 3;

  /** Names for type of alarm */
  public final static String[] alarmTypes = {
    "AUDIO",
    "DISPLAY",
    "EMAIL",
    "PROCEDURE"};

  protected int alarmType;

  protected int id = CalFacadeDefs.unsavedItemKey;

  protected int userid;

  /** The user */
  protected BwUser user;

  protected String trigger;
  protected boolean triggerStart;
  protected boolean triggerDateTime;
  protected String duration;
  protected int repeat;

  protected long triggerTime;
  protected long previousTrigger;
  protected int repeatCount;
  protected boolean expired;

  protected String attach;
  protected String description;
  protected String summary;
  protected Collection attendees;

  protected Attendees attendeesHelper;

  protected long sequence;

  /* ------------------------- Non-db fields ---------------------------- */

  /** Calculated on a call to getTriggerDate()
   */
  protected Date triggerDate;

  /** Constructor
   *
   */
  public BwAlarm() {
  }

  /** Constructor for all fields (for db retrieval)
   *
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
  public BwAlarm(int alarmType,
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
    this.alarmType = alarmType;
    this.user = user;
    if (user != null) {
      this.userid = user.getId();
    }
    this.trigger = trigger;
    this.triggerStart = triggerStart;
    this.triggerDateTime = triggerDateTime;
    this.duration = duration;
    this.repeat = repeat;
    this.triggerTime = triggerTime;
    this.previousTrigger = previousTrigger;
    this.repeatCount = repeatCount;
    this.expired = expired;
    this.attach = attach;
    this.description = description;
    this.summary = summary;
    setAttendees(attendees);

    this.sequence = sequence;
  }

  /* ====================================================================
   *                      Bean methods
   * ==================================================================== */

  /** Set the alarmType for this event
   *
   * @param val    alarmType
   */
  public void setAlarmType(int val) {
    alarmType = val;
  }

  /** Get the alarmType
   *
   * @return int    alarmType
   */
  public int getAlarmType() {
    return alarmType;
  }

  /** Set the id for this alarm
   *
   * @param val   alarm id
   */
  public void setId(int val) {
    id = val;
  }

  /** Get the alarm's id
   *
   * @return int    the alarm's unique id
   */
  public int getId() {
    return id;
  }

  /**    Set the userid
   *
   * @param val   userid
   */
  public void setUserid(int val) {
    userid = val;
  }

  /** Get the user id
   *
   * @return int    the userid
   */
  public int getUserid() {
    return userid;
  }

  /** set the user
   *
   * @param val  UserVO user
   */
  public void setUser(BwUser val) {
    user = val;
    if (user == null) {
      userid = CalFacadeDefs.unsavedItemKey;
    } else {
      userid = user.getId();
    }
  }

  /** Get the user
   *
   * @return UserVO     user, userVO
   */
  public BwUser getUser() {
    return user;
  }

  /** Set the trigger - rfc format
   *
   * @param val    String trigger value
   */
  public void setTrigger(String val) {
    trigger = val;
  }

  /** Get the trigger in rfc format
   *
   *  @return String   trigger value
   */
  public String getTrigger() {
    return trigger;
  }

  /** Set the triggerStart flag
   *
   *  @param val    boolean true if we trigger off start
   */
  public void setTriggerStart(boolean val) {
    triggerStart = val;
  }

  /** Get the triggerStart flag
   *
   *  @return boolean    true if we trigger off start
   */
  public boolean getTriggerStart() {
    return triggerStart;
  }

  /** Set the triggerDateTime flag
   *
   *  @param val    boolean true if we trigger off DateTime
   */
  public void setTriggerDateTime(boolean val) {
    triggerDateTime = val;
  }

  /** Get the triggerDateTime flag
   *
   *  @return boolean    true if we trigger off DateTime
   */
  public boolean getTriggerDateTime() {
    return triggerDateTime;
  }

  /** Set the duration - rfc format
   *
   * @param val    String duration value
   */
  public void setDuration(String val) {
    duration = val;
  }

  /** Get the duration in rfc format
   *
   *  @return String   duration value
   */
  public String getDuration() {
    return duration;
  }

  /** Set the repetition count for this alarm, 0 means no repeat, 1 means
   * 2 alarms will be sent etc.
   *
   * @param val   repetition count
   */
  public void setRepeat(int val) {
    repeat = val;
  }

  /** Get the repetition count
   *
   * @return int    the repetition count
   */
  public int getRepeat() {
    return repeat;
  }

  /** set the long trigger time value
   *
   *  @param val     long trigger time value in millisecs
   *  @throws CalFacadeException
   */
  public void setTriggerTime(long val) throws CalFacadeException {
    triggerTime = val;
  }

  /** Get the trigger Date value. This is the earliest time for the
   * alarm.
   *
   *  @return Date   trigger time as a date object
   *  @throws CalFacadeException
   */
  public abstract Date getTriggerDate() throws CalFacadeException;

  /** Get the long trigger time value. This is the next time for the
   * alarm.
   *
   *  @return long   trigger time value in millisecs
   *  @throws CalFacadeException
   */
  public long getTriggerTime() throws CalFacadeException {
    if (triggerTime != 0) {
      return triggerTime;
    }

    triggerTime = getNextTriggerDate().getTime();

    return triggerTime;
  }

  /** Get the next trigger Date value. This is the next time for the
   * alarm.
   *
   * <p>This is based on the previous time which will have been set when the
   * alarm was last triggered.
   *
   * <p>Returns null for no more triggers.
   *
   * <p>Can be called repeatedly for the same result. To move to the next
   * trigger time, update repeatCount.
   *
   *  @return Date   next trigger time as a date object
   *  @throws CalFacadeException
   */
  public Date getNextTriggerDate() throws CalFacadeException {
    if (previousTrigger == 0) {
      // First time
      return getTriggerDate();
    }

    triggerTime = 0; // Force refresh

    if (repeat == 0) {
      // No next trigger
      return null;
    }

    if (repeatCount == repeat) {
      // No next trigger
      return null;
    }

    // Parse duration into components
    int plusMinus = 1;
    int days = 0;
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    int weeks = 0;

    StringTokenizer st = new StringTokenizer(duration, "+-PDTHMSW", true);
    String svToken;
    String token = null;

    while (st.hasMoreTokens()) {
      svToken = token;
      token = st.nextToken();

      if ("-".equals(token)) {
        plusMinus = -1;
      } else if ("D".equals(token)) {
        days = Integer.parseInt(svToken);
      } else if ("H".equals(token)) {
        hours = Integer.parseInt(svToken);
      } else if ("M".equals(token)) {
        minutes = Integer.parseInt(svToken);
      } else if ("S".equals(token)) {
        seconds = Integer.parseInt(svToken);
      } else if ("W".equals(token)) {
        weeks = Integer.parseInt(svToken);
      }
    }

    boolean hadNonZero = false;

    GregorianCalendar cal = new GregorianCalendar();
    cal.setTime(getTriggerDate());

    for (int i = 0; i < repeatCount; i++) {
      if (weeks != 0) {
        cal.add(Calendar.WEEK_OF_YEAR, plusMinus * weeks);
        hadNonZero = true;
      }

      if (days != 0) {
        cal.add(Calendar.DATE, plusMinus * days);
        hadNonZero = true;
      }

      if (hours != 0) {
        cal.add(Calendar.HOUR, plusMinus * hours);
        hadNonZero = true;
      }

      if (minutes != 0) {
        cal.add(Calendar.MINUTE, plusMinus * minutes);
        hadNonZero = true;
      }

      if (seconds != 0) {
        cal.add(Calendar.SECOND, plusMinus * seconds);
        hadNonZero = true;
      }
    }

    // Watch for bogus duration
    if (!hadNonZero) {
      throw new CalFacadeException("Invalid duration");
    }

    return cal.getTime();
  }

  /** set the long previousTrigger time value
   *
   *  @param val     long lastTrigger time value in millisecs
   *  @throws CalFacadeException
   */
  public void setPreviousTrigger(long val) throws CalFacadeException {
    previousTrigger = val;
  }

  /** get the long previousTrigger time value
   *
   *  @return long    previousTrigger time value in millisecs
   *  @throws CalFacadeException
   */
  public long getPreviousTrigger() throws CalFacadeException {
    return previousTrigger;
  }

  /** Set the current repetition count for this alarm.
   *
   * @param val   repetition count
   */
  public void setRepeatCount(int val) {
    repeatCount = val;
  }

  /** Get the current repetition count
   *
   * @return int    the repetition count
   */
  public int getRepeatCount() {
    return repeatCount;
  }

  /** Set the expired flag
   *
   *  @param val    boolean true if the alarm has expired
   */
  public void setExpired(boolean val) {
    expired = val;
  }

  /** Get the expired flag
   *
   *  @return boolean    true if expired
   */
  public boolean getExpired() {
    return expired;
  }

  /** Set the attachment
   *
   * @param val    String attachment name
   */
  public void setAttach(String val) {
    attach = val;
  }

  /** Get the attachment
   *
   *  @return String   attachment name
   */
  public String getAttach() {
    return attach;
  }

  /** Set the description
   *
   * @param val    String description
   */
  public void setDescription(String val) {
    description = val;
  }

  /** Get the description
   *
   *  @return String   description
   */
  public String getDescription() {
    return description;
  }

  /** Set the summary
   *
   * @param val    String summary
   */
  public void setSummary(String val) {
    summary = val;
  }

  /** Get the summary
   *
   *  @return String   summary
   */
  public String getSummary() {
    return summary;
  }

  /** Set the attendees collection
   *
   * @param val    Collection of attendees
   */
  public void setAttendees(Collection val) {
    attendees = val;
    getAttendeesHelper().setAttendees(val);
  }

  /** Get the attendees
   *
   *  @return Collection     attendees list
   */
  public Collection getAttendees() {
    if (attendees == null) {
      attendees = new TreeSet();
      getAttendeesHelper().setAttendees(attendees);
    }

    return attendees;
  }

  /** Set sequence value
   *
   * @param val
   */
  public void setSequence(long val) {
    sequence = val;
  }

  /**
   * @return long sequence value
   */
  public long getSequence() {
    return sequence;
  }

  /* ====================================================================
   *                   Mappng methods
   * ==================================================================== */

  /**
   * @return type of entity
   */
  public int getEntityType() {
    return CalFacadeDefs.entityTypeAlarm;
  }

  /* ====================================================================
   *                      Convenience methods
   * ==================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#iterateAttendees()
   */
  public Iterator iterateAttendees() {
    return getAttendeesHelper().iterateAttendees();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#clearAttendees()
   */
  public void clearAttendees() {
    getAttendeesHelper().clearAttendees();
    setAttendees(attendeesHelper.getAttendees());
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#addAttendee(org.bedework.calfacade.BwAttendee)
   */
  public void addAttendee(BwAttendee val) {
    getAttendeesHelper().addAttendee(val);
    setAttendees(attendeesHelper.getAttendees());
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#addAttendeeEmail(java.lang.String)
   */
  public void addAttendeeEmail(String val) {
    getAttendeesHelper().addAttendeeEmail(val);
    setAttendees(attendeesHelper.getAttendees());
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#getAttendeeEmailList()
   */
  public String[] getAttendeeEmailList() {
    if (attendees == null) {
      return null;
    }

    return attendeesHelper.getAttendeeEmailList();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#cloneAttendees()
   */
  public Collection cloneAttendees() {
    if (attendees == null) {
      return null;
    }

    return attendeesHelper.cloneAttendees();
  }

  /*
----------------------------------------------------
     dur-value  = (["+"] / "-") "P" (dur-date / dur-time / dur-week)

     dur-date   = dur-day [dur-time]
     dur-time   = "T" (dur-hour / dur-minute / dur-second)
     dur-week   = 1*DIGIT "W"
     dur-hour   = 1*DIGIT "H" [dur-minute]
     dur-minute = 1*DIGIT "M" [dur-second]
     dur-second = 1*DIGIT "S"
     dur-day    = 1*DIGIT "D"


Description

    If the property permits, multiple "duration" values are
   specified by a COMMA character (US-ASCII decimal 44) separated list
   of values. The format is expressed as the [ISO 8601] basic format for
   the duration of time. The format can represent durations in terms of
   weeks, days, hours, minutes, and seconds.
   No additional content value encoding (i.e., BACKSLASH character
   encoding) are defined for this value type.


Example

    A duration of 15 days, 5 hours and 20 seconds would be:

     P15DT5H0M20S

   A duration of 7 weeks would be:

     P7W
--------------------------------------------------------*/

  /* ====================================================================
   *                      Object methods
   * ==================================================================== */

  public int compareTo(Object o)  {
    if (!(o instanceof BwAlarm)) {
      throw new ClassCastException();
    }

    if (equals(o)) {
      return 0;
    }

    BwAlarm that = (BwAlarm)o;

    try {
      if (that.getTriggerTime() > getTriggerTime()) {
        return -1;
      }

      return 1;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  public int hashCode() {
    int hc = 31 * alarmType;

    if (user != null) {
      hc *= user.hashCode();
    }

    hc *= trigger.hashCode();
    if (triggerStart) {
      hc *= 2;
    }

    if (duration != null) {
      hc *= duration.hashCode();
      hc *= (repeat + 1);
    }

    return hc;
  }

  /* We consider two alarms equal if their user, times and
   * durations match.
   */
  public boolean equals(Object obj) {
    if (obj == this) {
      return true;
    }

    if (!(obj instanceof BwAlarm)) {
      return false;
    }

    BwAlarm that = (BwAlarm)obj;

    if (that.alarmType != alarmType) {
      return false;
    }

    if (!eqObj(user, that.user)) {
      return false;
    }

    if (!eqObj(trigger, that.trigger)) {
      return false;
    }

    if (that.triggerStart != triggerStart) {
      return false;
    }

    if (duration != null) {
      if (!eqObj(duration, that.duration)) {
        return false;
      }

      if (that.repeat != repeat) {
        return false;
      }
    }

    return true;
  }

  /** Compare two possibly null obects
   *
   * @param o1
   * @param o2
   * @return boolean true for equal
   */
  public boolean eqObj(Object o1, Object o2) {
    if (o1 == null) {
      return o2 == null;
    }

    if (o2 == null) {
      return false;
    }

    return o1.equals(o2);
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("ValarmVO{id=");
    sb.append(id);

    sb.append(", type=");
    sb.append(alarmTypes[alarmType]);

    sb.append(", owner=");

    if (user == null) {
      sb.append("**********null************");
    } else {
      sb.append(user.getAccount());
    }

    sb.append(", trigger(");
    if (triggerStart) {
      sb.append("START)=");
    } else {
      sb.append("END)=");
    }
    sb.append(trigger);

    if (duration != null) {
      sb.append(", duration=");
      sb.append(duration);
      sb.append(", repeat=");
      sb.append(repeat);
    }

    if (alarmType == alarmTypeAudio) {
      if (attach != null) {
        sb.append(", attach=");
        sb.append(attach);
      }
    } else if (alarmType == alarmTypeDisplay) {
      sb.append(", description=");
      sb.append(description);
    } else if (alarmType == alarmTypeEmail) {
      sb.append(", description=");
      sb.append(description);
      sb.append(", summary=");
      sb.append(summary);
      sb.append(", attendees=[");
      Iterator it = iterateAttendees();
      while (it.hasNext()) {
        sb.append(it.next());
      }
      sb.append("]");
      if (attach != null) {
        sb.append(", attach=");
        sb.append(attach);
      }
    } else if (alarmType == alarmTypeProcedure) {
      sb.append(", attach=");
      sb.append(attach);
      if (description != null) {
        sb.append(", description=");
        sb.append(description);
      }
    }

    sb.append(", sequence=");
    sb.append(sequence);
    sb.append("}");

    return sb.toString();
  }

  private Attendees getAttendeesHelper() {
    if (attendeesHelper == null) {
      attendeesHelper = new Attendees();
    }

    return attendeesHelper;
  }
}

