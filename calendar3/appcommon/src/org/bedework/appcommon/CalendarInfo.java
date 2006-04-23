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

import java.io.Serializable;
import java.text.DateFormat;
import java.text.FieldPosition;
//import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/** Class to hold localized calendar info.
 *
 * @author Mike Douglass   douglm@rpi.edu
 *  @version 1.0
 */
public class CalendarInfo implements Serializable {
  /** Current locale
   */
  private Locale locale;

  /** Days of the week indexed by day of the week number - 1
   */
  private String[] dayNames = new String[7]; // indexed from 0
  private String[] shortDayNames = new String[7]; // indexed from 0

  /** Days of week ajusted with the first day of the week at index 0
   * This is used for presentation.
   */
  private String[] dayNamesAdjusted; // indexed from 0
  private String[] shortDayNamesAdjusted = new String[7]; // indexed from 0

  private int firstDayOfWeek;
  private int lastDayOfWeek;
  private int numberDaysInWeek;

  /** labels for the dates in a month */
  private String[] dayLabels;
  /** internal values for the dates in a month */
  private String[] dayVals;

  /** labels for the months of the year */
  private String[] monthLabels;
  /** internal values for the months of the year */
  private String[] monthVals;

  /** labels for the hours of the day */
  private String[] hourLabels;
  /** internal values for the hours of the day */
  private String[] hourVals;
  /** labels for the hours of the day (24-hour clock) */
  private String[] hour24Labels;
  /** internal values for the hours of the day (24-hour clock) */
  private String[] hour24Vals;

  /** labels for the minutes of the hour */
  private String[] minuteLabels;
  /** internal values for the minutes of the hour */
  private String[] minuteVals;

  /** Constructor
   *
   * @param locale
   */
  public CalendarInfo(Locale locale) {
    this.locale = locale;

    /** Set the localized names
     */

//    SimpleDateFormat dayFormat = new SimpleDateFormat("EEEE", getLocale());
//    SimpleDateFormat shortDayFormat = new SimpleDateFormat("E", getLocale());

    Calendar c = Calendar.getInstance(getLocale());
    ArrayList dow = new ArrayList();
    ArrayList sdow = new ArrayList();

    /* ********************* Day of Week ************************* */

    firstDayOfWeek = c.getFirstDayOfWeek();

    /** Get the number of days in a week. Is this ever anything other than 7?
     */
    numberDaysInWeek = getRangeSize(c, Calendar.DAY_OF_WEEK);

    lastDayOfWeek = firstDayOfWeek - 1;
    if (lastDayOfWeek < 1) {
      lastDayOfWeek += numberDaysInWeek;
    }

    for (int i = 0; i < 7; i++) {
      c.set(Calendar.DAY_OF_WEEK, i + 1);

      Date dt = c.getTime();
      dayNames[i] = DateTimeFormatter.getDayName(dt, getLocale());
      shortDayNames[i] = DateTimeFormatter.getShortDayName(dt, getLocale());
      dow.add(dayNames[i]);
      sdow.add(shortDayNames[i]);
    }

    if (firstDayOfWeek != 1) {
      /* Rotate the days of the week so that the first day is at the beginning
       */

      int fdow = firstDayOfWeek;
      while (fdow > 1) {
        Object o = dow.remove(0);
        dow.add(o);

        o = sdow.remove(0);
        sdow.add(o);

        fdow--;
      }

      dayNamesAdjusted = (String[])dow.toArray(new String[dow.size()]);
      shortDayNamesAdjusted = (String[])sdow.toArray(new String[sdow.size()]);
    } else {
      dayNamesAdjusted = dayNames;
      shortDayNamesAdjusted = shortDayNames;
    }

    /* ****************** Day of Month ***************************** */

    dayLabels = new String[getRangeSize(c, Calendar.DAY_OF_MONTH)];
    dayVals = new String[getRangeSize(c, Calendar.DAY_OF_MONTH)];

    int dom = c.getMinimum(Calendar.DAY_OF_MONTH);
    for (int i = 0; i < dayLabels.length; i++) {
      dayLabels[i] = String.valueOf(dom);
      dayVals[i] = twoDigit(dom);
      dom++;
    }

    /* *********************** Months ***************************** */

    monthLabels = new String[getRangeSize(c, Calendar.MONTH)];
    monthVals = new String[getRangeSize(c, Calendar.MONTH)];

    c.set(Calendar.MONTH, c.getMinimum(Calendar.MONTH));
    c.getTime(); // force recompute

    for (int i = 0; i < monthLabels.length; i++) {
      // this gives abbreviated form of month name
      monthLabels[i] = String.valueOf(getComponent(c, DateFormat.MONTH_FIELD,
                                                   DateFormat.MEDIUM));
      /* Calendar class month numbers start at 0 */
      monthVals[i] = twoDigit(c.get(Calendar.MONTH) + 1);
      c.add(Calendar.MONTH, 1);
    }

    /* *********************** Hours ***************************** */

    hourLabels = new String[getRangeSize(c, Calendar.HOUR)];
    hourVals = new String[getRangeSize(c, Calendar.HOUR)];

    /* Calendar.HOUR is 0 for 12 o'clock.  Skip 0, then add it to the end
       labeled as 12, but with value 0 */
    hourLabels[hourLabels.length - 1] = String.valueOf(hourLabels.length - 1);
    hourVals[hourLabels.length - 1] = twoDigit(0);

    int hour = c.getMinimum(Calendar.HOUR) + 1;

    for (int i = 1; i < hourLabels.length - 1; i++) {
      hourLabels[i] = String.valueOf(hour);
      hourVals[i] = twoDigit(hour);
      hour++;
    }

    hour24Labels = new String[getRangeSize(c, Calendar.HOUR_OF_DAY)];
    hour24Vals = new String[getRangeSize(c, Calendar.HOUR_OF_DAY)];

    int hourOfDay = c.getMinimum(Calendar.HOUR_OF_DAY);

    for (int i = 0; i < hour24Labels.length; i++) {
      hour24Labels[i] = twoDigit(hourOfDay);
      hour24Vals[i] = twoDigit(hourOfDay);
      hourOfDay++;
    }

    /* *********************** Minutes ***************************** */

    minuteLabels = new String[getRangeSize(c, Calendar.MINUTE)];
    minuteVals = new String[getRangeSize(c, Calendar.MINUTE)];

    int minute = c.getMinimum(Calendar.MINUTE);

    for (int i=0; i < minuteLabels.length; i++) {
      minuteLabels[i] = twoDigit(minute);
      minuteVals[i] = twoDigit(minute);
      minute++;
    }
  }

  /**
   * @param val Locale
   */
  public void setLocale(Locale val) {
    locale = val;
  }

  /**
   * @return Locale
   */
  public Locale getLocale() {
    return locale;
  }

  /** Get the day name for the given day number (1-7).
   *
   * @param dow        int day of week value 1-7
   * @return String    day name
   */
  public String getDayName(int dow) {
    return dayNames[dow - 1];
  }

  /** Get the names of the day of the week
   *
   * @return String[] day names
   */
  public String[] getDayNames() {
    return dayNames;
  }

  /** Get the short names of the day of the week
   *
   * @return String day names
   */
  public String[] getShortDayNames() {
    return shortDayNames;
  }

  /** Get the names of the day of the week
   * Elements have been adjusted so that the first day of the week is at 0
   *
   * @return String[] day names
   */
  public String[] getDayNamesAdjusted() {
    return dayNamesAdjusted;
  }

  /** Get the short names of the day of the week
   * Elements have been adjusted so that the first day of the week is at 0
   *
   * @return String day names
   */
  public String[] getShortDayNamesAdjusted() {
    return shortDayNamesAdjusted;
  }

  /** Return the dayOfWeek regarded as the first day
   *
   * @return int   firstDayOfWeek from 1 - 7
   */
  public int getFirstDayOfWeek() {
    return firstDayOfWeek;
  }

  /** Return the dayOfWeek regarded as the last day
   *
   * @return int   lastDayOfWeek from 1 - 7
   */
  public int getLastDayOfWeek() {
    return lastDayOfWeek;
  }

  /**
   * @return labels
   */
  public String[] getDayLabels() {
    return dayLabels;
  }

  /**
   * @return vals
   */
  public String[] getDayVals() {
    return dayVals;
  }

  /**
   * @return labels
   */
  public String[] getMonthLabels() {
    return monthLabels;
  }

  /**
   * @return vals
   */
  public String[] getMonthVals() {
    return monthVals;
  }

  /**
   * @return labels
   */
  public String[] getHourLabels() {
    return this.hourLabels;
  }

  /**
   * @return vals
   */
  public String[] getHourVals() {
    return this.hourVals;
  }

  /**
   * @return labels
   */
  public String[] getHour24Labels() {
    return this.hour24Labels;
  }

  /**
   * @return vals
   */
  public String[] getHour24Vals() {
    return this.hour24Vals;
  }

  /**
   * @return labels
   */
  public String[] getMinuteLabels() {
    return this.minuteLabels;
  }

  /**
   * @return vals
   */
  public String[] getMinuteVals() {
    return this.minuteVals;
  }

  /* ====================================================================
   *                Private methods
   * ==================================================================== */

  /* Get a String representation of a particular time field of the object.
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
  private String getComponent(Calendar cal, int field, int dateFormat) {
    FieldPosition f = new FieldPosition(field);
    StringBuffer s = DateFormat.
        getDateTimeInstance(dateFormat, dateFormat, getLocale()).
        format(cal.getTime(), new StringBuffer(), f);

    return s.substring(f.getBeginIndex(), f.getEndIndex());
  }

  /* Return the size of the range for a given unit of time
   *
   * @param unit      value defined in java.util.Calendar
   * @return int      size of range
   */
  private int getRangeSize(Calendar cal, int unit) {
    return cal.getMaximum(unit) - cal.getMinimum(unit) + 1;
  }

  private static String twoDigit(int val) {
    if (val > 9) {
      return String.valueOf(val);
    }

    return "0" + String.valueOf(val);
  }
}
