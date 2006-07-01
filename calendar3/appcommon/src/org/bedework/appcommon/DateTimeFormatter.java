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

import net.fortuna.ical4j.model.TimeZone;

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.util.CalFacadeUtil;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.FieldPosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Locale;

/** Class to format and provide segments of dates and times.
 *
 * @author Mike Douglass   douglm@rpi.edu
 *  @version 1.0
 */
public class DateTimeFormatter implements Serializable {
  /** The date/time we are handling.
   */
  private BwDateTime date;
  private CalendarInfo calInfo;
  //private MyCalendarVO cal;
  private GregorianCalendar cal;

  private static volatile HashMap formattersTbl = new HashMap();

  /* What we store in the table */
  private static class Formatters {
    DateFormat dayFormatter;
    DateFormat shortDayFormatter;
    
    DateFormat longDateFormatter;
    DateFormat shortDateFormatter;
    DateFormat shortTimeFormatter;
    
    Formatters(Locale loc) {
      dayFormatter = new SimpleDateFormat("EEEE", loc);
      shortDayFormatter = new SimpleDateFormat("E", loc);
      
      longDateFormatter = DateFormat.getDateInstance(DateFormat.LONG, loc);
      shortDateFormatter = DateFormat.getDateInstance(DateFormat.SHORT, loc);
      shortTimeFormatter = DateFormat.getTimeInstance(DateFormat.SHORT, loc);
    }
  }

  /** Constructor
   *
   * @param calInfo
   */
  public DateTimeFormatter(CalendarInfo calInfo) {
    this.calInfo = calInfo;
  }

  /** Constructor
   *
   * @param calInfo
   * @param date
   * @param ctz
   * @throws CalFacadeException
   */
  public DateTimeFormatter(CalendarInfo calInfo, BwDateTime date, CalTimezones ctz)
          throws CalFacadeException {
    this.calInfo = calInfo;
    setDate(date, ctz);
  }

  /**
   * @param val
   * @param ctz
   * @throws CalFacadeException
   */
  public void setDate(BwDateTime val, CalTimezones ctz) throws CalFacadeException {
    date = val;
    //cal = new MyCalendarVO(CalFacadeUtil.getDate(val));
    cal = new GregorianCalendar();
    if (val.getTzid() != null) {
      TimeZone tz = ctz.getTimeZone(val.getTzid());
      if (tz != null) {
        cal.setTimeZone(tz);
      }
    }
    cal.setTime(CalFacadeUtil.getDate(val));
  }

  /** Return the unadjusted date part in the rfc format yyyymmdd
   *
   * @return String unadjusted date part in the rfc format yyyymmdd
   */
  public String getDate() {
    return date.getDtval().substring(0, 8);
  }

  /** True if this is a date only field - i.e all day
   */
  /**
   * @return boolean true for all day
   */
  public boolean getDateType() {
    return date.getDateType();
  }

  /** Return the utc formatted date
   *
   * @return String (possibly adjusted) date in the rfc format yyyymmddThhmmssZ
   * @throws CalFacadeException
   */
  public String getUtcDate() throws CalFacadeException {
    return date.getDate();
  }

  /** Get the year for this object.
   *
   * @return int    year for this object
   */
  public int getYear() {
    try {
      return Integer.parseInt(date.getDate().substring(0, 4));
    } catch (Throwable t) {
      return -1;
    }
  }

  /** Get a four-digit representation of the year
   *
   * @return String   four-digit representation of the year for this object.
   */
  public String getFourDigitYear() {
    try {
      return date.getDate().substring(0, 4);
    } catch (Throwable t) {
      return "XXXX";
    }
  }

  /** Get the number of the month for this object. A value between 1-12
   *
   * @return int    month number for this object
   */
  public int getMonth() {
    try {
      return Integer.parseInt(date.getDate().substring(4, 6));
    } catch (Throwable t) {
      return -1;
    }
  }

  /** Get a two-digit representation of the month of year
   *
   * @return String   two-digit representation of the month of year for
   *                  this object.
   */
  public String getTwoDigitMonth() {
    try {
      return date.getDate().substring(4, 6);
    } catch (Throwable t) {
      return "XX";
    }
  }

  /** Get the long month name for this object.
   *
   * @return String    month name for this object
   */
  public String getMonthName() {
    Formatters fmt = getFormatters();
    FieldPosition f = new FieldPosition(DateFormat.MONTH_FIELD);
    synchronized (fmt) {
      StringBuffer s = fmt.longDateFormatter.format(cal.getTime(), new StringBuffer(), f);
      return s.substring(f.getBeginIndex(), f.getEndIndex());
    }
  }

  /** Get the day of the month for this object. A value between 1-31
   *
   * @return int    day of the month for this object
   */
  public int getDay() {
    try {
      return Integer.parseInt(date.getDate().substring(6, 8));
    } catch (Throwable t) {
      return -1;
    }
  }

  /** Get the day name for this object.
   *
   * @return String    day name for this object
   */
  public String getDayName() {
    return calInfo.getDayName(getDayOfWeek());
  }

  /** Get the day of the week
   *
   * @return The day of the week for a Calendar
   */
  public int getDayOfWeek() {
    return cal.get(Calendar.DAY_OF_WEEK);
  }

  /** Get a two-digit representation of the day of the month
   *
   * @return String   two-digit representation of the day of the month for
   *                  this object.
   */
  public String getTwoDigitDay() {
    try {
      return date.getDate().substring(6, 8);
    } catch (Throwable t) {
      return "XX";
    }
  }

  /** Get the hour of the (24 hour) day for this object. A value between 0-23
   *
   * @return int    hour of the day for this object
   */
  public int getHour24() {
    if (date.getDateType()) {
      return 0;
    }

    try {
      return Integer.parseInt(date.getDtval().substring(9, 11));
    } catch (Throwable t) {
      return -1;
    }
  }

  /** Get a two-digit representation of the 24 hour day hour
   *
   * @return String   two-digit representation of the hour for this object.
   */
  public String getTwoDigitHour24() {
    if (date.getDateType()) {
      return "00";
    }

    try {
      return date.getDtval().substring(9, 11);
    } catch (Throwable t) {
      return "XX";
    }
  }

  /** Get the hour of the day for this object. A value between 1-12
   *
   * @return int    hour of the day for this object
   */
  public int getHour() {
    int hr = getHour24();

    if (hr == 0) {
      return 12; // midnight+
    }

    if (hr < 13) {
      return hr;
    }

    return hr - 12;
  }

  /** Get a two-digit representation of the hour
   *
   * @return String   two-digit representation of the hour for this object.
   */
  public String getTwoDigitHour() {
    String hr = String.valueOf(getHour());

    if (hr.length() == 2) {
      return hr;
    }

    return "0" + hr;
  }

  /** Get the minute of the hour for this object. A value between 0-59
   *
   * @return int    minute of the hour for this object
   */
  public int getMinute() {
    if (date.getDateType()) {
      return 0;
    }

    try {
      return Integer.parseInt(date.getDtval().substring(11, 13));
    } catch (Throwable t) {
      return -1;
    }
  }

  /** Get a two-digit representation of the minutes
   *
   * @return String   two-digit representation of the minutes for this object.
   */
  public String getTwoDigitMinute() {
    if (date.getDateType()) {
      return "00";
    }

    try {
      return date.getDtval().substring(11, 13);
    } catch (Throwable t) {
      return "XX";
    }
  }

  /** Get the am/pm value
   *
   * @return int   am/pm for this object.
   */
  public int getAmPm() {
    return cal.get(Calendar.AM_PM);
  }

  /**  Get a short String representation of the day represented by the parameter
   *
   * @param  val           Date
   * @param  loc           Locale
   * @return String        Short representation of the day
   *                       represented by this object.
   */
  public static String getShortDayName(Date val, Locale loc) {
    Formatters fmt = getFormatters(loc);
    
    synchronized (fmt) {
      return fmt.shortDayFormatter.format(val);
    }
  }

  /**  Get a String representation of the day represented by the parameter
   *
   * @param  val           Date
   * @param  loc           Locale
   * @return String        Representation of the day represented by this object.
   */
  public static String getDayName(Date val, Locale loc) {
    Formatters fmt = getFormatters(loc);
    
    synchronized (fmt) {
      return fmt.dayFormatter.format(val);
    }
  }

  /**  Get a short String representation of the date
   *
   * @return String        Short representation of the date
   *            represented by this object.
   */
  public String getDateString() {
    Formatters fmt = getFormatters();

    synchronized (fmt) {
      return fmt.shortDateFormatter.format(cal.getTime());
    }
  }

  /**  Get a long String representation of the date
   *
   * @return String        long representation of the date
   *            represented by this object.
   */
  public String getLongDateString() {
    Formatters fmt = getFormatters();

    synchronized (fmt) {
      return fmt.longDateFormatter.format(cal.getTime());
    }
  }

  /**  Get a short String representation of the time of day
   *
   * @return String        Short representation of the time of day
   *            represented by this object.
   *            If there is no time, returns a zero length string.
   */
  public String getTimeString() {
    Formatters fmt = getFormatters();

    synchronized (fmt) {
      return fmt.shortTimeFormatter.format(cal.getTime());
    }
  }

  private Formatters getFormatters() {
    Locale loc = calInfo.getLocale();
    
    return getFormatters(loc);
  }

  private static Formatters getFormatters(Locale loc) {
    synchronized (formattersTbl) {
      Formatters fmt = (Formatters)formattersTbl.get(loc);
      
      if (fmt == null) {
        fmt = new Formatters(loc);
        formattersTbl.put(loc, fmt);
      }
    
      return fmt;
    }
  }
}
