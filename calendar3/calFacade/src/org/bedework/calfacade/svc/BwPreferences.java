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
package org.bedework.calfacade.svc;

import org.bedework.calfacade.base.BwOwnedDbentity;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;

import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

/** Account preferences for Bedework. These affect the user view of calendars.
 *
 *   @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwPreferences extends BwOwnedDbentity {
  /** The subscriptions
   */
  private Collection subscriptions;

  /** Collection of BwView
   */
  protected Collection views;

  private String email;

  /** The calendar they will use by default.
   */
  private BwCalendar defaultCalendar;

  private String skinName;

  private String skinStyle;

  /** Name of the view the user prefers to start with. null for default
   */
  private String preferredView;

  /** "day", "week" etc
   */
  private String preferredViewPeriod;

  /** Flag days as workdays. Space for not "W" for a workday.
   * 7 characters with Sunday the first. Localization code should handle
   * first day of week.
   */
  private String workDays;

  /** Time in minutes for workday start, e.g. 14:30 is 870
   */
  private int workdayStart;

  /* Time in minutes for workday end, e.g. 17:30 is 1050
   */
  private int workdayEnd;

  /* When adding events do we prefer end date ("date")
   *  or duration ("duration"). Note the values this field takes
   *  are internal values only - not meant for display.
   */
  private String preferredEndType;

  /** Value identifying an extra simple user mode - we just do stuff without
   * asking
   */
  public static final int extraSimpleMode = 0;

  /** Value identifying a simple user mode - we hide some stuff but make
   * fewer assumptions
   */
  public static final int simpleMode = 1;

  /** Value identifying an advanced user mode - reveal it in all its glory
   */
  public static final int advancedMode = 2;

  private int userMode;

  /** Constructor
   *
   */
  public BwPreferences() {
  }

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

  /** Set of subscriptions
   *
   * @param val        Collection of BwSubscription
   */
  public void setSubscriptions(Collection val) {
    subscriptions = val;
  }

  /** Get the subscriptions
   *
   * @return Collection    of BwSubscription
   */
  public Collection getSubscriptions() {
    if (subscriptions == null) {
      subscriptions = new TreeSet();
    }
    return subscriptions;
  }

  /** Set of views principal has defined
   *
   * @param val        Collection of BwView
   */
  public void setViews(Collection val) {
    views = val;
  }

  /** Get the calendars principal is subscribed to
   *
   * @return Collection    of BwView
   */
  public Collection getViews() {
    if (views == null) {
      views = new TreeSet();
    }
    return views;
  }

  /**
   * @param val
   */
  public void setEmail(String val) {
    email = val;
  }

  /**
   * @return String email
   */
  public String getEmail() {
    return email;
  }

  /**
   * @param val
   */
  public void setDefaultCalendar(BwCalendar val) {
    defaultCalendar = val;
  }

  /**
   * @return BwCalendar default calendar
   */
  public BwCalendar getDefaultCalendar() {
    return defaultCalendar;
  }

  /**
   * @param val
   */
  public void setSkinName(String val) {
    skinName = val;
  }

  /**
   * @return String skin name
   */
  public String getSkinName() {
    return skinName;
  }

  /**
   * @param val
   */
  public void setSkinStyle(String val) {
    skinStyle = val;
  }

  /**
   * @return String skin style
   */
  public String getSkinStyle() {
    return skinStyle;
  }

  /**
   * @param val
   */
  public void setPreferredView(String val) {
    preferredView = val;
  }

  /**
   * @return String preferred view
   */
  public String getPreferredView() {
    return preferredView;
  }

  /**
   * @param val
   */
  public void setPreferredViewPeriod(String val) {
    preferredViewPeriod = val;
  }

  /**
   * @return String preferred view period
   */
  public String getPreferredViewPeriod() {
    return preferredViewPeriod;
  }

  /**
   * @param val
   */
  public void setWorkDays(String val) {
    workDays = val;
  }

  /**
   * @return String work days
   */
  public String getWorkDays() {
    return workDays;
  }

  /**
   * @param val
   */
  public void setWorkdayStart(int val) {
    workdayStart = val;
  }

  /**
   * @return int work day start
   */
  public int getWorkdayStart() {
    return workdayStart;
  }

  /**
   * @param val
   */
  public void setWorkdayEnd(int val) {
    workdayEnd = val;
  }

  /**
   * @return int work day end
   */
  public int getWorkdayEnd() {
    return workdayEnd;
  }

  /**
   * @param val
   */
  public void setPreferredEndType(String val) {
    preferredEndType = val;
  }

  /**
   * @return String preferred end type (none, duration, date/time)
   */
  public String getPreferredEndType() {
    return preferredEndType;
  }

  /**
   * @param val
   */
  public void setUserMode(int val) {
    userMode = val;
  }

  /**
   * @return int user mode
   */
  public int getUserMode() {
    return userMode;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /**
   * @param val
   * @throws CalFacadeException
   */
  public void addSubscription(BwSubscription val) throws CalFacadeException {
    Collection c = getSubscriptions();
    if (c.contains(val)) {
      throw new CalFacadeException(CalFacadeException.duplicateSubscription);
    }
    c.add(val);
  }

  /**
   * @return Iterator over subscriptions
   */
  public Iterator iterateSubscriptions() {
    return getSubscriptions().iterator();
  }

  /**
   * @param val
   */
  public void addView(BwView val) {
    getViews().add(val);
  }

  /**
   * @return Iterator over views
   */
  public Iterator iterateViews() {
    return getViews().iterator();
  }

  /** Set the workday start minutes from a String time value
   *
   * @param val  String time value
   */
  public void setWorkdayStart(String val) throws CalFacadeException{
    setWorkdayStart(makeMinutesFromTime(val));
  }

  /** Get the workday start as a 4 digit String hours and minutes value
   *
   * @return String work day start time
   */
  public String getWorkdayStartTime() {
    return CalFacadeUtil.getTimeFromMinutes(getWorkdayStart());
  }

  /** Set the workday end minutes from a String time value
   *
   * @param val  String time value
   */
  public void setWorkdayEnd(String val) throws CalFacadeException{
    setWorkdayEnd(makeMinutesFromTime(val));
  }

  /** Get the workday end as a 4 digit String hours and minutes value
   *
   * @return String work day end time
   */
  public String getWorkdayEndTime() {
    return CalFacadeUtil.getTimeFromMinutes(getWorkdayEnd());
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  /** Comapre this view and an object
   *
   * @param  o    object to compare.
   * @return int -1, 0, 1
   */
  public int compareTo(Object o) {
    if (o == this) {
      return 0;
    }

    if (o == null) {
      return -1;
    }

    if (!(o instanceof BwPreferences)) {
      return -1;
    }

    BwPreferences that = (BwPreferences)o;

    return getOwner().compareTo(that.getOwner());
  }

  public int hashCode() {
    return getOwner().hashCode();
  }

  public boolean equals(Object obj) {
    return compareTo(obj) == 0;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwPreferences(");

    toStringSegment(sb);
    sb.append(", email=");
    sb.append(getEmail());
    sb.append(", defaultCalendar=");
    if (getDefaultCalendar() == null) {
      sb.append("null");
    } else {
      sb.append(getDefaultCalendar().getId());
    }
    sb.append(", skinName=");
    sb.append(getSkinName());
    sb.append(", skinStyle=");
    sb.append(getSkinStyle());
    sb.append(", preferredView=");
    sb.append(getPreferredView());
    sb.append(", preferredViewPeriod=");
    sb.append(getPreferredViewPeriod());
    sb.append(", workDays=");
    sb.append(getWorkDays());
    sb.append(", workdayStart=");
    sb.append(getWorkdayStart());
    sb.append(", workdayEnd=");
    sb.append(getWorkdayEnd());
    sb.append(")");

    return sb.toString();
  }

  /* ====================================================================
   *                   private methods
   * ==================================================================== */

  /** Turn a String time value e.g. 1030 into a numeric minutes value and set
   * the numeric value in the prefeences.
   *
   * <p>Ignores anything after the first four characters which must all be digits.
   *
   * @param val  String time value
   */
  private int makeMinutesFromTime(String val) throws CalFacadeException{
    boolean badval = false;
    int minutes = 0;

    try {
      int hours = Integer.parseInt(val.substring(0, 2));
      minutes = Integer.parseInt(val.substring(2, 4));
      if ((hours < 0) || (hours > 24)) {
        badval = true;
      } else if ((minutes < 0) || (minutes > 59)) {
        badval = true;
      } else {
        minutes *= (hours * 60);
      }
    } catch (Throwable t) {
      badval = true;
    }

    if (badval) {
      throw new CalFacadeException("org.bedework.prefs.badvalue", val);
    }

    return minutes;
  }
}
