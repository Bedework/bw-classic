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

package org.bedework.appcommon;

import org.bedework.calfacade.svc.EventInfo;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;
import org.apache.log4j.Logger;

/** This class allows a TimeView class to provide information about each day
 * represented by that view. This can be used to build grids or tables.
 *
 * <p>This information is always returned as a hierarchical set of these
 * entries with the top being years, containing months, weeks and days.
 *
 * @author  Mike Douglass douglm@rpi.edu
 */
public class TimeViewDailyInfo implements Serializable {
  /** The view that created this.
   */
  private TimeView view;

  /** Date as MyCalendarVO object
   */
  private MyCalendarVO cal;

  /** true if this is just a filler - we insert filler into weeks so that they
   always havea  weekful of entries even as we cross month boundaries
   */
  private boolean filler;

  /** true if this is a day entry
   */
  private boolean dayEntry;

  /** More than one entry
   */
  private boolean multiDay;

  /** Date as YYYYMMDD
   */
  private String date;

  /** Short printable date
   */
  private String dateShort;

  /** Long printable date
   */
  private String dateLong;

  /** True if this is in the current month
   */
  private boolean currentMonth;

  /** Is first of period
   */
  private boolean firstDay;

  /** Is last of period
   */
  private boolean lastDay;

  /** Is first of week
   */
  private boolean firstDayOfWeek;

  /** Is last of week
   */
  private boolean lastDayOfWeek;

  /** Is first of month
   */
  private boolean firstDayOfMonth;

  /** Is last of month
   */
  private boolean lastDayOfMonth;

  /** Day of week
   */
  private int dayOfWeek;

  /** Day of month as numeric string
   */
  private int dayOfMonth;

  /** Week of year as numeric string
   */
  private String weekOfYear;

  /** Name of day of month
   */
  private String dayName;

  /** Month as numeric string
   */
  private String month;

  /** Name of month
   */
  private String monthName;

  /** Short name of month
   */
  private String shortMonthName;

  /** Year as numeric string
   */
  private String year;

  /** The entries this contains, if this is years next is months, then weeks
   * then days.
   */
  private TimeViewDailyInfo[] entries;

  /** The events - possibly empty
   */
  private Collection events;

  /** The wrapped events - possibly null
   */
  private Collection eventFormatters;

  /** The view that created this.
   *
   * @param val
   */
  public void setView(TimeView val) {
    view = val;
  }

  /** The view that created this.
   *
   * @return TimeView
   */
  public TimeView getView() {
    return view;
  }

  /**
   * @param val
   */
  public void setCal(MyCalendarVO val) {
    cal = val;
  }

  /**
   * @return MyCalendarVO
   */
  public MyCalendarVO getCal() {
    return cal;
  }

  /**
   * @param val
   */
  public void setFiller(boolean val) {
    filler = val;
  }

  /**
   * @return boolean
   */
  public boolean getFiller() {
    return filler;
  }

  /**
   * @param val
   */
  public void setDayEntry(boolean val) {
    dayEntry = val;
  }

  /**
   * @return boolean
   */
  public boolean getDayEntry() {
    return dayEntry;
  }

  /**
   * @param val
   */
  public void setMultiDay(boolean val) {
    multiDay = val;
  }

  /**
   * @return boolean
   */
  public boolean isMultiDay() {
    return multiDay;
  }

  /**
   * @param val
   */
  public void setDate(String val) {
    date = val;
  }

  /**
   * @return String
   */
  public String getDate() {
    return date;
  }

  /**
   * @param val
   */
  public void setDateShort(String val) {
    dateShort = val;
  }

  /**
   * @return String
   */
  public String getDateShort() {
    return dateShort;
  }

  /**
   * @param val
   */
  public void setDateLong(String val) {
    dateLong = val;
  }

  /**
   * @return String
   */
  public String getDateLong() {
    return dateLong;
  }

  /**
   * @param val
   */
  public void setCurrentMonth(boolean val) {
    currentMonth = val;
  }

  /**
   * @return boolean
   */
  public boolean isCurrentMonth() {
    return currentMonth;
  }

  /**
   * @param val
   */
  public void setFirstDay(boolean val) {
    firstDay = val;
  }

  /**
   * @return boolean
   */
  public boolean isFirstDay() {
    return firstDay;
  }

  /**
   * @param val
   */
  public void setLastDay(boolean val) {
    lastDay = val;
  }

  /**
   * @return boolean
   */
  public boolean isLastDay() {
    return lastDay;
  }

  /**
   * @param val
   */
  public void setFirstDayOfWeek(boolean val) {
    firstDayOfWeek = val;
  }

  /**
   * @return boolean
   */
  public boolean isFirstDayOfWeek() {
    return firstDayOfWeek;
  }

  /**
   * @param val
   */
  public void setLastDayOfWeek(boolean val) {
    lastDayOfWeek = val;
  }

  /**
   * @return boolean
   */
  public boolean isLastDayOfWeek() {
    return lastDayOfWeek;
  }

  /**
   * @param val
   */
  public void setFirstDayOfMonth(boolean val) {
    firstDayOfMonth = val;
  }

  /**
   * @return boolean
   */
  public boolean isFirstDayOfMonth() {
    return firstDayOfMonth;
  }

  /**
   * @param val
   */
  public void setLastDayOfMonth(boolean val) {
    lastDayOfMonth = val;
  }

  /**
   * @return boolean
   */
  public boolean isLastDayOfMonth() {
    return lastDayOfMonth;
  }

  /**
   * @param val
   */
  public void setDayOfWeek(int val) {
    dayOfWeek = val;
  }

  /**
   * @return int
   */
  public int getDayOfWeek() {
    return dayOfWeek;
  }

  /**
   * @param val
   */
  public void setDayOfMonth(int val) {
    dayOfMonth = val;
  }

  /**
   * @return int
   */
  public int getDayOfMonth() {
    return dayOfMonth;
  }

  /**
   * @param val
   */
  public void setWeekOfYear(String val) {
    weekOfYear = val;
  }

  /**
   * @return String
   */
  public String getWeekOfYear() {
    return weekOfYear;
  }

  /**
   * @param val
   */
  public void setDayName(String val) {
    dayName = val;
  }

  /**
   * @return String
   */
  public String getDayName() {
    return dayName;
  }

  /**
   * @param val
   */
  public void setMonth(String val) {
    month = val;
  }

  /**
   * @return String
   */
  public String getMonth() {
    return month;
  }

  /**
   * @param val
   */
  public void setMonthName(String val) {
    monthName = val;
  }

  /**
   * @return String
   */
  public String getMonthName() {
    return monthName;
  }

  /**
   * @param val
   */
  public void setShortMonthName(String val) {
    shortMonthName = val;
  }

  /**
   * @return String
   */
  public String getShortMonthName() {
    return shortMonthName;
  }

  /**
   * @param val
   */
  public void setYear(String val) {
    year = val;
  }

  /**
   * @return String
   */
  public String getYear() {
    return year;
  }

  /**
   * @param val
   */
  public void setEntries(TimeViewDailyInfo[] val) {
    entries = val;
  }

  /**
   * @return TimeViewDailyInfo[]
   */
  public TimeViewDailyInfo[] getEntries() {
    return entries;
  }

  /**
   * @param val
   */
  public void setEvents(Collection val) {
    events = val;
    eventFormatters = null;
  }

  /**
   * @return Collection
   * @throws Throwable
   */
  public Collection getEvents() throws Throwable {
    if (events == null) {
      events = getDaysEvents(cal);
      eventFormatters = null;
    }

    return events;
  }

  /**
   * @return Collection
   * @throws Throwable
   */
  public Collection getEventFormatters() throws Throwable {
    try {
      getEvents();

      if (eventFormatters == null) {
        if (events == null) {
          return new Vector();
        }

        eventFormatters = new Vector();
        Iterator it = events.iterator();

        while (it.hasNext()) {
          eventFormatters.add(new EventFormatter((EventInfo)it.next(), view,
                              view.getTimezones()));
        }
      }
    } catch (Throwable t) {
      Logger.getLogger(this.getClass()).error("getEventFormatters", t);
      throw t;
    }

    return eventFormatters;
  }

  /** Return the events for the day as an array of value objects
   *
   * @param   date    MyCalendarVO object defining day
   * @return  Collection  one days events,  never null, length 0 for no events.
   * @exception Throwable if this is not a day object
   */
  private Collection getDaysEvents(MyCalendarVO date) throws Throwable {
    if (!getDayEntry()) {
      Logger.getLogger(this.getClass()).error("*******Not a day entry*****");
      throw new IllegalStateException("Not a day entry");
    }

    return view.getDaysEvents(date);
  }
}

