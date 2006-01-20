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
package org.bedework.appcommon;

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.FieldPosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import org.apache.log4j.Logger;

/** Representation of the MyCalendar uwcal class.
 *
 * This object is intended to allow applications to interact with the
 * calendar back end. It does not represent the internal stored structure of a
 * MyCalendar object.
 *
 *   @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class MyCalendarVO implements Serializable {
  /** Time and date as a Calendar object.
   */
  private Calendar calendar;

  private static CalendarInfo calInfo;

  private DateFormat isoformat = new SimpleDateFormat("yyyyMMdd");

  /** Create a MyCalendarVO object representing the current date and time.
   */
  public MyCalendarVO() {
    this(new Date(System.currentTimeMillis()), Locale.getDefault());
  }

  /** Create a MyCalendarVO object representing a particular date and time.
   *
   * @param date   Non-null Date object.
   */
  public MyCalendarVO(Date date) {
    this(date, Locale.getDefault());
  }

  /** Create a MyCalendarVO object representing a particular date and time
   * in the given locale.
   *
   * @param date   Non-null Date object.
   * @param loc    Locale
   */
  public MyCalendarVO(Date date, Locale loc) {
    if ((calInfo == null) || (!calInfo.getLocale().equals(loc))) {
      calInfo = new CalendarInfo(loc);
    }

    calendar = Calendar.getInstance(loc);

    calendar.setTime(date);
  }

  /** Create a MyCalendarVO object representing a particular DateTime
   * object.
   *
   * @param dtm   Non-null BwDateTime object.
   * @throws CalFacadeException
   */
  public MyCalendarVO(BwDateTime dtm) throws CalFacadeException {
    this(CalFacadeUtil.getDate(dtm));
  }

  /** Create a MyCalendarVO object representing a particular date and time.
   * The calendar object must have the same locale.
   *
   * @param calendar     Calendar object representing the date and time.
   * @param loc    Locale
   */
  private MyCalendarVO(Calendar calendar, Locale loc) {
    if ((calInfo == null) || (!calInfo.getLocale().equals(loc))) {
      calInfo = new CalendarInfo(loc);
    }

    this.calendar = calendar;
  }

  /** Return Calendar info object
   *
   * @return CalendarInfo    object providing localized calendar info
   */
  public CalendarInfo getCalInfo() {
    return calInfo;
  }

  /** Return Calendar object representing this object
   *
   * @return Calendar    object representing this object
   */
  public Calendar getCalendar() {
    return calendar;
  }

  /** Return Date object representing this object
   *
   * @return Date    object representing this object
   */
  public Date getTime() {
    return calendar.getTime();
  }

  /** get time in millisecs
   *
   * @return long
   */
  public long getTimeInMillis() {
    return calendar.getTimeInMillis();
  }

  /** ===================================================================
   *                Components of the date
   *  =================================================================== */

  /** Get the year for this object.
   *
   * @return int    year for this object
   */
  public int getYear() {
    return calendar.get(Calendar.YEAR);
  }

  /** Get the number of the month for this object.
   * Note:  The first month is number 1.
   *
   * @return int    month number for this object
   */
  public int getMonth() {
    return calendar.get(Calendar.MONTH) + 1;
  }

  /** Get the day of the month for this object.
   *
   * @return int    day of the month for this object
   */
  public int getDay() {
    return calendar.get(Calendar.DATE);
  }

  /** Get the hour of the (24 hour) day for this object.
   *
   * @return int    hour of the day for this object
   */
  public int getHour24() {
    return calendar.get(Calendar.HOUR_OF_DAY);
  }

  /** Get the hour of the day for this object.
   *
   * @return int    hour of the day for this object
   */
  public int getHour() {
    return calendar.get(Calendar.HOUR);
  }

  /** Get the minute of the hour for this object.
   *
   * @return int    minute of the hour for this object
   */
  public int getMinute() {
    return calendar.get(Calendar.MINUTE);
  }

  /** Get the am/pm value
   *
   * @return int   am/pm for this object.
   */
  public int getAmPm() {
    return calendar.get(Calendar.AM_PM);
  }

  /** Get the day of the week for this object.
   *
   * @return int    day of the week
   */
  public int getDayOfWeek() {
    return getDayOfWeek(calendar);
  }

  /** Get the day name for this object.
   *
   * @return String    day name for this object
   */
  public String getDayName() {
    return calInfo.getDayName(getDayOfWeek());
  }

  /** Get the day of the week for a Calendar object
   *
   * @param c The date to evaluate
   * @return The day of the week for a Calendar
   */
  public int getDayOfWeek(Calendar c) {
//    return c.get(Calendar.DAY_OF_WEEK) % numberDaysInWeek;
    return c.get(Calendar.DAY_OF_WEEK);
  }

  /** Get the long month name for this object.
   *
   * @return String    month name for this object
   */
  public String getMonthName() {
    return getComponent(DateFormat.MONTH_FIELD, DateFormat.LONG);
  }

  /** Get the short month name for this object.
   *
   * @return String    short month name for this object
   */
  public String getShortMonthName() {
    return getComponent(DateFormat.MONTH_FIELD, DateFormat.MEDIUM);
  }

  /** Get a four-digit representation of the year
   *
   * @return String   four-digit representation of the year for this object.
   */
  public String getFourDigitYear() {
    return String.valueOf(getYear());
  }

  /** Get a two-digit representation of the month of year
   *
   * @return String   two-digit representation of the month of year for
   *                  this object.
   */
  public String getTwoDigitMonth() {
    return getTwoDigit(getMonth());
  }

  /** Get a two-digit representation of the day of the month
   *
   * @return String   two-digit representation of the day of the month for
   *                  this object.
   */
  public String getTwoDigitDay() {
    return getTwoDigit(getDay());
  }

  /** Get a two-digit representation of the 24 hour day hour
   *
   * @return String   two-digit representation of the hour for this object.
   */
  public String getTwoDigitHour24() {
    return getTwoDigit(getHour24());
  }

  /** Get a two-digit representation of the hour
   *
   * @return String   two-digit representation of the hour for this object.
   */
  public String getTwoDigitHour() {
    return getTwoDigit(getHour());
  }

  /* * Get a two-digit representation of the minutes
   *
   *   @return String   two-digit representation of the minutes for this object.
   * /
  public String getTwoDigitMinute() {
    return getTwoDigit(getMinute());
  }

  /** ===================================================================
   *                Get various representations of date/time
   *  =================================================================== */

  /**  Get a short String representation of the time of day
   *
   * @return String        Short representation of the time of day
   *            represented by this object.
   */
  public String getTimeString() {
    return getTimeString(DateFormat.getTimeInstance(DateFormat.SHORT));
  }

  /** Get a <code>String</code> representation of the time of day
   *
   * @param df      DateFormat format for the result
   * @return String  time of day, formatted per df
   */
  public String getTimeString(DateFormat df) {
    return df.format(getTime());
  }

  /**  Get a short String representation of the date
   *
   * @return String        Short representation of the date
   *            represented by this object.
   */
  public String getDateString() {
    return getFormattedDateString(DateFormat.SHORT);
  }

  /**  Get a long String representation of the date
   *
   * @return String        long representation of the date
   *            represented by this object.
   */
  public String getLongDateString() {
    return getFormattedDateString(DateFormat.LONG);
  }

  /**  Get a full String representation of the date
   *
   * @return String        full representation of the date
   *            represented by this object.
   */
  public String getFullDateString() {
    return getFormattedDateString(DateFormat.FULL);
  }

  /** Get a <code>String</code> representation of the date
   *
   * @param style       int DateFormat style for the result
   * @return String  date formatted per df
   */
  public String getFormattedDateString(int style) {
    return getFormattedDateString(DateFormat.getDateInstance(style));
  }

  /** Get a <code>String</code> representation of the date
   *
   * @param df      DateFormat format for the result
   * @return String  date formatted per df
   */
  public String getFormattedDateString(DateFormat df) {
    return df.format(getTime());
  }

  /** Get an eight-digit String representation of the date
   *
   * @return String  date in the form <code>YYYYMMDD</code>
   */
  public String getDateDigits() {
    return getFormattedDateString(isoformat);
  }

  /** ===================================================================
   *                Adding and subtracting time
   *  =================================================================== */

  /** Get a calendar some time later or earlier than this one
   *
   * @param unit Units to add/subtract, <i>e.g.</i>,
   *          <code>Calendar.DATE</code> to add days
   * @param amount Number of units to add or subtract.  Use negative
   *            numbers to subtract
   * @return MyCalendarVO    new object corresponding to this
   *                  object +/- the appropriate number of units
   */
  private MyCalendarVO addTime(int unit, int amount) {
    return new MyCalendarVO(add(calendar, unit, amount), calInfo.getLocale());
  }

  /**  Get a MyCalendarVO object one day earlier.
   *
   * @return MyCalendarVO    equivalent to this object one day earlier.
   */
  public MyCalendarVO getYesterday() {
    return addTime(Calendar.DATE, -1);
  }

  /**  Get a MyCalendarVO object one day later.
   *
   * @return MyCalendarVO    equivalent to this object one day later.
   */
  public MyCalendarVO getTomorrow() {
    return addTime(Calendar.DATE, 1);
  }

  /**  Get a MyCalendarVO object one week earlier.
   *
   * @return MyCalendarVO    equivalent to this object one week earlier.
   */
  public MyCalendarVO getPrevWeek() {
    return addTime(Calendar.WEEK_OF_YEAR, -1);
  }

  /**  Get a MyCalendarVO object one week later.
   *
   * @return MyCalendarVO    equivalent to this object one week later.
   */
  public MyCalendarVO getNextWeek() {
    return addTime(Calendar.WEEK_OF_YEAR, 1);
  }

  /**  Get a MyCalendarVO object one month earlier.
   *
   * @return MyCalendarVO    equivalent to this object one month earlier.
   */
  public MyCalendarVO getPrevMonth() {
    return addTime(Calendar.MONTH, -1);
  }

  /**  Get a MyCalendarVO object one month later.
   *
   * @return MyCalendarVO    equivalent to this object one month later.
   */
  public MyCalendarVO getNextMonth() {
    return addTime(Calendar.MONTH, 1);
  }

  /**  Get a MyCalendarVO object one year earlier.
   *
   * @return MyCalendarVO    equivalent to this object one year earlier.
   */
  public MyCalendarVO getPrevYear() {
    return addTime(Calendar.YEAR, -1);
  }

  /**  Get a MyCalendarVO object one year later.
   *
   * @return MyCalendarVO    equivalent to this object one year later.
   */
  public MyCalendarVO getNextYear() {
    return addTime(Calendar.YEAR, 1);
  }

  /** ===================================================================
   *                Relative times
   *  =================================================================== */

  /** Get the first day of the year for this object
   *
   * @return MyCalendarVO    representing the first day of the year for this
   *             object, e.g. if this object represents February 5, 2000,
   *             returns a MyCalendarVO object representing January 1, 2000.
   */
  public MyCalendarVO getFirstDayOfThisYear() {
    Calendar firstDay = (Calendar)calendar.clone();
    firstDay.set(Calendar.DAY_OF_YEAR,
                 calendar.getMinimum(Calendar.DAY_OF_YEAR));
    return new MyCalendarVO(firstDay, calInfo.getLocale());
  }

  /** Get the last day of the year for this object
   *
   * @return MyCalendarVO    epresenting the last day of the year for this
   *             object, e.g. if this object represents February 5, 2000,
   *             returns a MyCalendarVO object representing December 31, 2000.
   */
  public MyCalendarVO getLastDayOfThisYear() {
    Calendar c = (Calendar)calendar.clone();
    c.set(Calendar.DAY_OF_YEAR, calendar.getMinimum(Calendar.DAY_OF_YEAR));
    c.add(Calendar.YEAR, 1);
    c.add(Calendar.DATE, -1);
    return new MyCalendarVO(c, calInfo.getLocale());
  }

  /**  Get the first day of the month for this object
   *
   * @return MyCalendarVO    representing the first day of the month for this
   *             object, e.g. if this object represents February 5, 2000,
   *             returns a MyCalendarVO object representing February 1, 2000.
   */
  public MyCalendarVO getFirstDayOfThisMonth() {
    Calendar firstDay = (Calendar)calendar.clone();
    firstDay.set(Calendar.DAY_OF_MONTH,
                 calendar.getMinimum(Calendar.DAY_OF_MONTH));
    return new MyCalendarVO(firstDay, calInfo.getLocale());
  }

  /** Get the last day of the month for this object
   *
   * @return MyCalendarVO    representing the last day of the month for this
   *             object, e.g. if this object represents February 5, 2000,
   *             returns a MyCalendarVO object representing February 29, 2000.
   */
  public MyCalendarVO getLastDayOfThisMonth() {
    Calendar c = (Calendar)calendar.clone();
    c.set(Calendar.DAY_OF_MONTH, calendar.getMinimum(Calendar.DAY_OF_MONTH));
    c.add(Calendar.MONTH, 1);
    c.add(Calendar.DATE, -1);
    return new MyCalendarVO(c, calInfo.getLocale());
  }

  /**  Get the first day of the week for this object
   *
   * @return MyCalendarVO    representing the first day of the week for this
   *             object.
   */
  public MyCalendarVO getFirstDayOfThisWeek() {
    Calendar firstDay = (Calendar)calendar.clone();
    firstDay.set(Calendar.DAY_OF_WEEK, calInfo.getFirstDayOfWeek());
    return new MyCalendarVO(firstDay, calInfo.getLocale());
  }

  /** Get the last day of the week for this object
   *
   * @return MyCalendarVO    representing the last day of the week for this
   *             object.
   */
  public MyCalendarVO getLastDayOfThisWeek() {
    Calendar c = (Calendar)calendar.clone();
    c.set(Calendar.DAY_OF_WEEK, calInfo.getFirstDayOfWeek());
    c.add(Calendar.WEEK_OF_YEAR, 1);
    c.add(Calendar.DATE, -1);
    return new MyCalendarVO(c, calInfo.getLocale());
  }

  protected void debugMsg(String msg) {
    Logger.getLogger(this.getClass()).debug(msg);
  }

  /* ====================================================================
   *                Useful methods
   * ==================================================================== */

  /**
   * @return Date todays date
   */
  public static Date getTodaysDate() {
    Calendar cal = Calendar.getInstance();
    cal.set(Calendar.HOUR, 0);
    cal.set(Calendar.MINUTE, 0);
    cal.set(Calendar.SECOND, 0);
    cal.set(Calendar.MILLISECOND, 0);

    return cal.getTime();
  }

  /* ====================================================================
   *                Comparisons
   * ==================================================================== */

  /**
   * @param that
   * @return boolean true if that is same as this
   */
  public boolean isSameDate(MyCalendarVO that) {
    return getFormattedDateString(isoformat).equals(
          that.getFormattedDateString(isoformat));
  }

  /**
   * @param val
   * @return boolean true if that is after this
   */
  public boolean after(Object val) {
    if (!(val instanceof MyCalendarVO)) {
      return false;
    }

    MyCalendarVO that = (MyCalendarVO)val;

    return calendar.after(that.calendar);
  }

  /**
   * @param val
   * @return boolean true if that is before this
   */
  public boolean before(Object val) {
    if (!(val instanceof MyCalendarVO)) {
      return false;
    }

    MyCalendarVO that = (MyCalendarVO)val;

    return calendar.before(that.calendar);
  }

  /* ====================================================================
   *                Object methods
   * ==================================================================== */

  public boolean equals(Object val) {
    if (!(val instanceof MyCalendarVO)) {
      return false;
    }

    MyCalendarVO that = (MyCalendarVO)val;

    return calendar.equals(that.calendar);
  }

  public String toString() {
    return getDateString() + " " + getTimeString();
  }

//  public Object clone() {
//    return new MyCalendarVO(this.getCalendar(), getLocale());
//  }

  /* ====================================================================
   *                Private methods
   * ==================================================================== */

  /** Get a two-digit representation of a one to two-digit number
   *
   * @param  i         int one or two digit number
   * @return String    two-digit representation of the number
   */
  private static String getTwoDigit(int i) {
    if (i < 10) {
      return "0" + i;
    }

    return String.valueOf(i);
  }

  /** Get a calendar some time later or earlier than this one
   *
   * @param c    The calendar to start with
   * @param unit The unit of time to add or subtract, <i>e.g.</i>,
   *           <code>MONTH</code>.  For possible values, see the constants in
   *           <code>java.util.Calendar</code>
   * @param amount The number of units to add or subtract.  A positive
   *              value means to add, a negative value to subtract
   * @return Calendar    equivalent to c some time later or earlier
   */
  private static Calendar add(Calendar c, int unit, int amount) {
    Calendar newc = (Calendar)c.clone();
    newc.add(unit, amount);
    return newc;
  }

  /** Get a String representation of a particular time
   *  field of the object.
   *
   * @param field The field to be returned,
   *        <i>e.g.</i>, <code>MONTH_FIELD</code>.  For possible values, see
   *       the constants in <code>java.text.DateFormat</code>
   * @param dateFormat The style of <code>DateFormat</code> to use,
   *            <i>e.g.</i>, <code>SHORT</code>.  For possible values, see
   *           the constants in <code>java.text.DateFormat</code>.
   * @return A <code>String</code> representation of a particular time
   *             field of the object.
   */
  private String getComponent(int field, int dateFormat) {
    FieldPosition f = new FieldPosition(field);
    StringBuffer s = DateFormat.
        getDateTimeInstance(dateFormat, dateFormat, calInfo.getLocale()).
        format(getTime(), new StringBuffer(), f);
    return s.substring(f.getBeginIndex(), f.getEndIndex());
  }
}
