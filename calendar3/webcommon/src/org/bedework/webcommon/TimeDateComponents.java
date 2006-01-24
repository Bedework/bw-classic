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

package org.bedework.webcommon;

import org.bedework.appcommon.CalendarInfo;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calsvci.CalSvcI;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.FieldPosition;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

/** A wrapper around date/time objects that is used to generate form elements

   @author   Mike Douglass douglm@rpi.edu
   @author   Greg Barnes
 */
/* Note:  because this is commonly (exclusively) used as a Struts bean,
   throwing exceptions from the setter methods leads to errors that
   are hard to catch (they are called by BeanUtils.populate, which
   is executed even before Struts lets you validate).

   Presumably, bad values (e.g., setYear("blxk")) are mostly due to
   malicious or erroneous form input, so we will turn them into default
   values instead.

   If you want a bean that throws exceptions when you pass in bad values,
   you should create a superclass, subclass, or sibling to this one.
 */
public class TimeDateComponents implements Serializable {
  /** Label that indicates no time is specified */
  private static final String NO_TIME_LABEL = "None";
  /** Internal value to show no time is specified */
  private static final String NO_TIME_VALUE = "-1";

  // arrays of values and labels for dropdown menus for various units of time

  /** default labels for am and pm */
  // XXX: Should localize
  private static final String[] DEFAULT_AMPM_LABELS = {"am", "pm"};

  /* * default labels for the dates in a month */
  //private static String[] defaultDayLabels =
  //    new String[maximumValues(Calendar.DAY_OF_MONTH)];
  //** default internal values for the dates in a month */
  //private static String[] defaultDayVals =
  //    new String[maximumValues(Calendar.DAY_OF_MONTH)];

  /** default labels for the months of the year */
  private static String[] defaultMonthLabels =
      new String[maximumValues(Calendar.MONTH)];
  /** default internal values for the months of the year */
  private static String[] defaultMonthVals =
      new String[maximumValues(Calendar.MONTH)];

  // The hour arrays have an extra member to indicate no specified time
  /** default labels for the hours of the day */
  private static String[] defaultHourLabels =
      new String[maximumValues(Calendar.HOUR) + 1];
  /** default internal values for the hours of the day */
  private static String[] defaultHourVals =
      new String[maximumValues(Calendar.HOUR) + 1];
  /** default labels for the hours of the day (24-hour clock) */
  private static String[] defaultHour24Labels =
      new String[maximumValues(Calendar.HOUR_OF_DAY) + 1];
  /** default internal values for the hours of the day (24-hour clock) */
  private static String[] defaultHour24Vals =
      new String[maximumValues(Calendar.HOUR_OF_DAY) + 1];

  /** default labels for the minutes of the hour */
  private static String[] defaultMinuteLabels =
      new String[maximumValues(Calendar.MINUTE)];
  /** default internal values for the minutes of the hour */
  private static String[] defaultMinuteVals =
      new String[maximumValues(Calendar.MINUTE)];

  /**
    Get the maximum number of distinct values for an appropriate unit of time
    @param unit The unit of time.  Should be one of the constants in
       <code>java.util.Calendar</code>, such as <code>DAY_OF_MONTH</code>
    @return the maximum number of distinct values for that unit.  E.g., for
      <code>DAY_OF_MONTH</code> and a Gregorian calendar, 31
   */
  private static int maximumValues(int unit) {
    Calendar cal = Calendar.getInstance();
    return cal.getMaximum(unit) - cal.getMinimum(unit) + 1;
  }

  /** Initialize the arrays of time labels and values */
  static {
    /** For convenience, Get localized version of a calendar */
    //XXX some of this needs to be localized still
    Calendar cal = Calendar.getInstance(/* XXX locale?????*/);

    /*
    for (int i = 0, dateOfMonth = cal.getMinimum(Calendar.DAY_OF_MONTH);
         i < defaultDayLabels.length; i++, dateOfMonth++) {
      defaultDayLabels[i] = String.valueOf(dateOfMonth);

      //XXX assuming max number of days in months is two-digits
      defaultDayVals[i] = twoDigit(dateOfMonth);
    }
    */

    cal.set(Calendar.MONTH, cal.getMinimum(Calendar.MONTH));
    cal.getTime(); // force recompute

    for (int i = 0; i < defaultMonthLabels.length; i++) {
      // this gives abbreviated form of month name
      defaultMonthLabels[i] = String.valueOf(getComponent(cal, DateFormat.MONTH_FIELD,
                                                     DateFormat.MEDIUM));
      //XXX assuming max number of months is two-digits
      /** Calendar class month numbers start at 0
       */
      defaultMonthVals[i] = twoDigit(cal.get(Calendar.MONTH) + 1);
      cal.add(Calendar.MONTH, 1);
    }

    defaultHourLabels[0] = NO_TIME_LABEL;
    defaultHourVals[0] = NO_TIME_VALUE;

    /* Calendar.HOUR is 0 for 12 o'clock.  Skip 0, then add it to the end
       labeled as 12, but with value 0 */
    defaultHourLabels[defaultHourLabels.length - 1] =
        (defaultHourLabels.length-1) + "";
    defaultHourVals[defaultHourLabels.length - 1] = twoDigit(0);

    for (int i = 1, hour = cal.getMinimum(Calendar.HOUR) + 1;
         i < defaultHourLabels.length - 1; i++, hour++) {
      defaultHourLabels[i] = String.valueOf(hour);
      //XXX assuming max hour is two digits
      defaultHourVals[i] = twoDigit(hour);
    }

    defaultHour24Labels[0] = NO_TIME_LABEL;
    defaultHour24Vals[0] = NO_TIME_VALUE;

    for (int i=1, hourOfDay = cal.getMinimum(Calendar.HOUR_OF_DAY);
         i < defaultHour24Labels.length; i++, hourOfDay++) {
      defaultHour24Labels[i] = twoDigit(hourOfDay);
      //XXX assuming max hour of day is two digits
      defaultHour24Vals[i] = twoDigit(hourOfDay);
    }

    for (int i=0, minute = cal.getMinimum(Calendar.MINUTE);
         i < defaultMinuteLabels.length; i++, minute++) {
      defaultMinuteLabels[i] = twoDigit(minute);
      //XXX assuming max number of days in months is two-digits
      defaultMinuteVals[i] = twoDigit(minute);
    }
  }

  //private boolean debug;

  private transient Logger log;

  private CalSvcI svci;
  private CalendarInfo calInfo;

  /** Holds time and date information */
  private Calendar cal;

  //private String[] dayLabels;
  //private String[] dayVals;
  private String[] monthLabels;
  private String[] monthVals;

  private String[] hourLabels;
  private String[] hourVals;

  /* We populate minuteLabels and minuteVals with the appropriate increments. */
  private String[] minuteLabels;
  private String[] minuteVals;

  /** Only accept minute values that are multiples of this */
  private int minuteIncrement;

  private String[] ampmLabels;

  /** Are we on the 24-hour clock? */
  private boolean hour24;

  /** current value of am/pm */
  private boolean isAm = true;

  private boolean dateOnly;

  private String fieldInError;

  /**  An exception used by this class
   */
  public static class TimeDateException extends CalFacadeException {
    /**
     * @param msg
     */
    public TimeDateException(String msg) {
      super(msg);
    }
  }

  /** Set up instance of this class using default values.
   *
   * @param svci
   * @param calInfo
   * @param minuteIncrement  increment for minutes: &le; 1 is all,
   *                        5 is every 5 minutes, etc
   * @param hour24        true if we ignore am/pm and use 24hr clock
   * @param debug
   * @exception TimeDateException If there is something wrong with the minutes
   *                        arrays
   */
  public TimeDateComponents(CalSvcI svci,
                            CalendarInfo calInfo,
                            int minuteIncrement,
                            boolean hour24,
                            boolean debug) throws TimeDateException {
    if (debug) {
      getLogger().debug("Init TimeDateComponents with hour24= " + hour24);
    }
    this.svci = svci;
    this.calInfo = calInfo;
    this.hour24 = hour24;
    //this.debug = debug;

    //dayLabels = defaultDayLabels;
    //dayVals = defaultDayVals;
    monthLabels = defaultMonthLabels;
    monthVals = defaultMonthVals;
    if (hour24) {
      hourLabels = defaultHour24Labels;
      hourVals = defaultHour24Vals;
    } else {
      hourLabels = defaultHourLabels;
      hourVals = defaultHourVals;
    }

    setMinutes(defaultMinuteLabels, defaultMinuteVals, minuteIncrement);

    this.ampmLabels = DEFAULT_AMPM_LABELS;
  }

  /**
    Set the minutes arrays to a subset of the values in two given arrays
    @param minuteLabels Array from which to draw the labels
    @param minuteVals Array from which to draw the values
    @param minuteIncrement Choose the 0th entry in each array, and every
       minuteIncrement'th one after that
    @exception TimeDateException If either of the arrays given is not
       the proper length
   */
  public void setMinutes(String[] minuteLabels,
                         String[] minuteVals,
                         int minuteIncrement) throws TimeDateException {
    this.minuteIncrement = (minuteIncrement <= 1) ? 1: minuteIncrement;

    if ((minuteLabels.length != defaultMinuteLabels.length) ||
        (minuteVals.length != defaultMinuteLabels.length)) {
      throw new TimeDateException("minute values/labels must have " +
          defaultMinuteLabels.length +  " entries");
    }

    if (this.minuteIncrement == 1) {
      this.minuteLabels = minuteLabels;
      this.minuteVals = minuteVals;
    } else {
      int sz = defaultMinuteLabels.length / this.minuteIncrement;

      this.minuteLabels = new String[sz];
      this.minuteVals = new String[sz];

      for (int i=0, j=0;
           j < minuteLabels.length;
           i++, j += this.minuteIncrement)
      {
        this.minuteLabels[i] = minuteLabels[j];
        this.minuteVals[i] = minuteVals[j];
      }
    }
  }

  /**
   * @return CalendarInfo
   */
  public CalendarInfo getCalInfo() {
    return calInfo;
  }

  /**
   *
   */
  public void resetError() {
    fieldInError = null;
  }

  /**
   * @return field name
   */
  public String getError() {
    return fieldInError;
  }

  /**
   * @return labels
   */
  public String[] getDayLabels() {
    return getCalInfo().getDayLabels();
  }

  /**
   * @return vals
   */
  public String[] getDayVals() {
    return getCalInfo().getDayVals();
  }

  /**
   * @return labels
   */
  public String[] getMonthLabels() {
    return this.monthLabels;
  }

  /**
   * @return vals
   */
  public String[] getMonthVals() {
    return this.monthVals;
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
  public String[] getMinuteLabels() {
    return this.minuteLabels;
  }

  /**
   * @return vals
   */
  public String[] getMinuteVals() {
    return this.minuteVals;
  }

  /**
   * @return labels
   */
  public String[] getAmpmLabels() {
    return this.ampmLabels;
  }

  /**
   * @param val
   */
  public void setDateOnly(boolean val) {
    dateOnly = val;
  }

  /**
   * @return bool
   */
  public boolean getDateOnly() {
    return dateOnly;
  }

  /** Sets this object's current date to now.  The time is not set.
   */
  public void setNow() {
    setDateTime(new Date(System.currentTimeMillis()));
  }

  /** Set this object's date.
   *
   * @param val   Date to use
   */
  public void setDateTime(Date val) {
    getCal().setTime(val);
    isAm = getCal().get(Calendar.AM_PM) == Calendar.AM;
  }

  /** Sets this object's current time from the given DateTimeVO value.
   *
   * @param val    DateTimeVO value.
   */
  public void setDateTime(BwDateTime val) {
    try {
      getCal().setTime(CalFacadeUtil.getDate(val));
      // Should set UTC
      setDateOnly(val.getDateType());
      isAm = getCal().get(Calendar.AM_PM) == Calendar.AM;
    } catch (Throwable t) {
      fieldInError = "DateTimeVO";
    }
  }

  /** Get a date object representing the date of the event
   *
   * @return Date object representing the date
   * @throws CalFacadeException
   */
  public BwDateTime getDateTime() throws CalFacadeException {
    boolean UTC = false;  // Need a flag

    return CalFacadeUtil.getDateTime(getCal().getTime(),
                                     getDateOnly(), UTC,
                                     svci.getTimezones());
  }

  /** Get a normalized version of the date
   *
   * @return String  date as YYYYMMDD
   * /
  public String getDateString() {
    return isoformat.format(getDate());
  }*/

  /** Set the year
   *
   * @param val   String 4 digit year yyyy
   */
  public void setYear(String val) {
    try {
      getCal().set(Calendar.YEAR, Integer.parseInt(val));
    } catch (NumberFormatException e) {
      getCal().set(Calendar.YEAR, 0);
      fieldInError = "YEAR";
    }
  }

  /**
   * @return 4 digit year
   */
  public String getYear() {
    return fourDigit(getCal().get(Calendar.YEAR));
  }

  /* XXX
     In the get methods below, we try to translate real values to the
     'values' in the arrays defined above (e.g., dayVals).
     We should also translate array values into real vals in the set methods.
     We don't.  The only reason this works is because currently we only
     use the default arrays, which map things in the obvious way (1 <-> 1).
     If one allows non-default arrays to be used (e.g., with Val arrays
     that contain non-numbers, the set methods would need to be changed.

     Note that the years are exempt here, as they are not selected by
     dropdown menus
   */
  /** Set the month number
   *
   * @param val   String 2 digit month number 01-xx
   */
  public void setMonth(String val) {
    try {
      getCal().set(Calendar.MONTH, Integer.parseInt(val) - 1);
    } catch (NumberFormatException e) {
      getCal().set(Calendar.MONTH, 0);
      fieldInError = "MONTH";
    }
  }

  /**
   * @return String month
   */
  public String getMonth() {
    // Calendar.MONTH returns 0-11
    return monthVals[getCal().get(Calendar.MONTH)];
  }

  /** Set the day number
   *
   * @param val   String 2 digit day number 01-xx
   */
  public void setDay(String val) {
    try {
      getCal().set(Calendar.DAY_OF_MONTH, Integer.parseInt(val));
    } catch (NumberFormatException e) {
      getCal().set(Calendar.DAY_OF_MONTH, 1);
      fieldInError = "MONTH";
    }
  }

  /**
   * @return String day
   */
  public String getDay() {
    // Calendar.DAY_OF_MONTH returns 1-31
    return getDayVals()[getCal().get(Calendar.DAY_OF_MONTH) - 1];
  }

  /**
    Set the hour in the underlying calendar
    @param hour Hour of the day (0-23)
   */
  private void setHourOfDay(int hour) {
    getCal().set(Calendar.HOUR_OF_DAY, hour);
  }

  /**
    Set the hour in the underlying calendar
    @param hour Hour of the day (0-11)
   */
  /* setting hour and am/pm separately doesn't seem to work, so we'll
     always set on a 24-hour clock
   */
  private void setHour(int hour) {
    if (!isAm) {
      hour += 12;
    }
    setHourOfDay(hour);
  }

  /** Set the hour
   *
   * @param val   String hour
   */
  public void setHour(String val) {
    try {
      if (hour24) {
        setHourOfDay(Integer.parseInt(val));
      } else {
        setHour(Integer.parseInt(val));
      }
    } catch (NumberFormatException e) {
      setHourOfDay(0);
      fieldInError = "HOUR";
    }
  }

  /**
   * @return String hour
   */
  public String getHour() {
    /* Calendar.HOUR_OF_DAY returns 0-23; must be adjusted up due NO_TIME_VAL
       Calendar.HOUR returns 0-11; must adjust due to funny 12/0 problem */
    if (this.hour24) {
      return this.hourVals[getCal().get(Calendar.HOUR_OF_DAY) + 1];
    } else if (getCal().get(Calendar.HOUR) == 0) {
      return this.hourVals[this.hourVals.length - 1];
    } else {
      return this.hourVals[getCal().get(Calendar.HOUR)];
    }
  }

  /** Set the minute. Will be rounded to minuteIncrement
   *
   * @param val   String minute
   */
  public void setMinute(String val) {
    getCal().set(Calendar.MINUTE, validMinute(val));
  }

  /**
   * @return String minute
   */
  public String getMinute() {
    /* Calendar.MINUTE returns 0-59; adjusted to account for
       minuteIncrement skipping */
    return this.minuteVals[getCal().get(Calendar.MINUTE) /
                           this.minuteIncrement];
  }

  /** Set the am/pm
   *
   * @param val   String am/pm
   */
  public void setAmpm(String val) {
    // am/pm is set with the hour
    isAm = val.equals(ampmLabels[0]);

    setHour(getCal().get(Calendar.HOUR));
  }

  /**
   * @return String am/pm
   */
  public String getAmpm() {
    // Calendar.AM_PM returns 0-1
    return ampmLabels[this.isAm ? 0 : 1];
  }

  /* ====================================================================
   *                Private methods
   * ==================================================================== */

  private Calendar getCal() {
    if (cal == null) {
      cal = Calendar.getInstance(/* XXX locale?????*/);
    }

    return cal;
  }

  private int validMinute(String val) {
    int imin;

    if ((val == null) || (val.equals(NO_TIME_VALUE))) {
      return 0;
    } else {
      try {
        imin = Integer.parseInt(val);
      } catch (NumberFormatException e) {
        imin = 0;
      }
    }

    if (this.minuteIncrement > 1) {
      return ((imin + 1) / this.minuteIncrement) * this.minuteIncrement;
    } else {
      return imin;
    }
  }

  private static String twoDigit(int val) {
    if (val > 9) {
      return String.valueOf(val);
    }

    return "0" + String.valueOf(val);
  }

  private static String fourDigit(int val) {
    if (val > 999) {
      return String.valueOf(val);
    }

    String strVal = String.valueOf(val);

    return "0000".substring(strVal.length()) + strVal;
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
  private static String getComponent(Calendar cal, int field, int dateFormat) {
    FieldPosition f = new FieldPosition(field);
    StringBuffer s = DateFormat.
        getDateTimeInstance(dateFormat, dateFormat/* XXX ,cal.getLocale() */).
        format(cal.getTime(), new StringBuffer(), f);
    return s.substring(f.getBeginIndex(), f.getEndIndex());
  }

  /** Get a logger for messages
   */
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  /* ====================================================================
   *                        Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("TimeDateComponents{");
    try {
      sb.append(getDateTime());
    } catch (Throwable t) {
      sb.append("Exception " + t);
    }
    sb.append("}");

    return sb.toString();
  }
}

