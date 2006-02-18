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

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calsvci.CalSvcI;

import org.apache.log4j.Logger;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

/** This class represents a view of the calendar from a startDate to an
 * endDate. The getTimePeriodInfo method always returns a tree structure
 * with a single year as the root containing months, weeks, then days.
 *
 * <p>Each day element can return data for that day.
 *
 * <p>This structure facilitates the production of calendar like views as
 * each month and week is padded out at the start and end with filler
 * elements.
 *
 * <p>The calendar is represented as a sequence of, possibly overlapping,
 * events which must be rendered in some manner by the display.
 *
 * @author  Mike Douglass douglm@rpi.edu
 */
public class TimeView implements Serializable {
  protected boolean debug;
  protected CalendarInfo calInfo;
  protected MyCalendarVO curDay;
  protected CalSvcI cal;
  protected String periodName;
  protected MyCalendarVO firstDay;
  protected MyCalendarVO lastDay;
  protected String prevDate;
  protected String nextDate;
  protected boolean showData;

  /* Fetched at initialisation
   */
  protected Collection events;

  /** set on the first call to getTimePeriodInfo
   */
  private TimeViewDailyInfo[] tvdis;

  /** Constructor:
   *
   * @param  calInfo   Object providing calendaring information
   * @param  curDay    MyCalendarVO representing current day.
   * @param  periodName Name of period, capitalized, e.g. Week
   * @param  cal       CalSvcI calendar service interface
   * @param  firstDay  MyCalendar representing first day of period.
   * @param  lastDay   MyCalendar representing last day of period.
   * @param  prevDate  previous date for this time period in YYYYMMDD form
   * @param  nextDate  next date for this time period in YYYYMMDD form
   * @param  showData  boolean true if this TimeView can be used to
   *                   display events or if it is used for structure only.
   *                   For example we may use the year for navigation only
   *                   to reduce the amount of data retrieved.
   * @param  debug     true for some debugging output
   * @throws CalFacadeException
   */
  public TimeView(CalendarInfo calInfo,
                  MyCalendarVO curDay,
                  String periodName,
                  CalSvcI cal,
                  MyCalendarVO firstDay,
                  MyCalendarVO lastDay,
                  String prevDate,
                  String nextDate,
                  boolean showData,
                  boolean debug) throws CalFacadeException {
    this.calInfo = calInfo;
    this.curDay = curDay;
    this.periodName = periodName;
    this.cal = cal;
    this.firstDay = firstDay;
    this.lastDay = lastDay;
    this.curDay = curDay;
    this.prevDate = prevDate;
    this.nextDate = nextDate;
    this.showData = showData;
    this.debug = debug;

    /*
    events = cal.getEvents(null, null, CalFacadeUtil.getDateTime(firstDay.getDateDigits()),
                      CalFacadeUtil.getDateTime(lastDay.getDateDigits()));
                      */
  }

  /**
   * @return CalTimezones
   * @throws CalFacadeException
   */
  public CalTimezones getTimezones() throws CalFacadeException {
    return cal.getTimezones();
  }

  /** Override this for a single day view
   *
   * @return true for multi-day
   */
  public boolean isMultiDay() {
    return true;
  }

  /** This method returns the period name (week, month etc)
   *
   * @return  String  period name
   */
  public String getPeriodName() {
    return periodName;
  }

  /**
   * @return MyCalendarVO first day
   */
  public MyCalendarVO getFirstDay() {
    return firstDay;
  }

  /**
   * @return MyCalendarVO current day
   */
  public MyCalendarVO getCurDay() {
    return curDay;
  }

  /**
   * @return MyCalendarVO last day
   */
  public MyCalendarVO getLastDay() {
    return lastDay;
  }

  /**
   * @param date MyCalendarVO
   * @return boolean true if date is first day
   */
  public boolean isFirstDay(MyCalendarVO date) {
    return firstDay.isSameDate(date);
  }

  /**
   * @param date MyCalendarVO
   * @return boolean true if date is last day
   */
  public boolean isLastDay(MyCalendarVO date) {
    return lastDay.isSameDate(date);
  }

  /** This method returns the first day in YYYYMMDD format.
   *
   * @return  String  first date
   */
  public String getFirstDate() {
    return firstDay.getDateDigits();
  }

  /** This method returns the last day in YYYYMMDD format.
   *
   * @return  String  last date
   */
  public String getLastDate() {
    return lastDay.getDateDigits();
  }

  /** This method returns the previous date in YYYYMMDD format.
   *
   * @return  String  previous date
   */
  public String getPrevDate() {
    return prevDate;
  }

  /** This method returns the current date in YYYYMMDD format.
   *
   * @return  String  current date
   */
  public String getCurDate() {
    return curDay.getDateDigits();
  }

  /** This method returns the next date in YYYYMMDD format.
   *
   * @return  String  next date
   */
  public String getNextDate() {
    return nextDate;
  }

  /** Return showData flag.
   *
   * @return  boolean  true if we should show data
   */
  public boolean getShowData() {
    return showData;
  }

  /** Return the events for the given day as an array of value objects
   *
   * @param   date    MyCalendar object defining day
   * @return  Collection of EventInfo being one days events or empty for no events.
   * @throws Throwable
   */
  public Collection getDaysEvents(MyCalendarVO date) throws Throwable {
    Vector v = new Vector();
//    Dur oneDay = new Dur(1, 0, 0, 0);
    BwDateTime startDt = CalFacadeUtil.getDateTime(date.getDateDigits(),
                                                   cal.getTimezones());

//    BwDateTime endDt = BwDateTime.makeDateTime(startDt.makeDtStart(), true, oneDay);
    BwDateTime endDt = startDt.getNextDay(cal.getTimezones());
    String start = startDt.getDate();
    String end = endDt.getDate();

    //if (debug) {
    //  debugMsg("Get days events in range " + start + " to " + end);
    //}
    if (events == null) {
      events = cal.getEvents(null, null,
                             CalFacadeUtil.getDateTime(firstDay.getDateDigits(),
                                  cal.getTimezones()),
                             CalFacadeUtil.getDateTime(lastDay.getTomorrow().getDateDigits(),
                                  cal.getTimezones()),
                                  CalFacadeDefs.retrieveRecurExpanded);
    }

    Iterator it = events.iterator();
    while (it.hasNext()) {
      EventInfo ei = (EventInfo)it.next();
      BwEvent ev = ei.getEvent();

      String evStart = ev.getDtstart().getDate();
      String evEnd = ev.getDtend().getDate();

      /* Event is within range if:
         1.   (((evStart <= :start) and (evEnd > :start)) or
         2.    ((evStart >= :start) and (evStart < :end)) or
         3.    ((evEnd > :start) and (evEnd <= :end)))
         
         XXX followed caldav which might be wrong. Try
         3.    ((evEnd > :start) and (evEnd < :end)))
      */

      int evstSt = evStart.compareTo(start);
      int evendSt = evEnd.compareTo(start);

      //debugMsg("                   event " + evStart + " to " + evEnd);

      if (((evstSt <= 0) && (evendSt > 0)) ||
          ((evstSt >= 0) && (evStart.compareTo(end) < 0)) ||
          //((evendSt > 0) && (evEnd.compareTo(end) <= 0))) {
          ((evendSt > 0) && (evEnd.compareTo(end) < 0))) {
        // Passed the tests.
        if (debug) {
          debugMsg("Event passed range " + start + "-" + end +
                   " with dates " + evStart + "-" + evEnd +
                   ": " + ev.getSummary());
        }
        v.add(ei);
      }
    }

    return v;
  }

  /** Return an array of the days of the week indexed from 0
   * Elements have been adjusted so that the first day of the week is at 0
   *
   * @return String[]  days of week
   */
  public String[] getDayNamesAdjusted() {
    return calInfo.getDayNamesAdjusted();
  }

  /** Return an array of the short days of the week indexed from 0
   * Elements have been adjusted so that the first day of the week is at 0
   *
   * @return String[]  days of week
   */
  public String[] getShortDayNamesAdjusted() {
    return calInfo.getShortDayNamesAdjusted();
  }

  /** Return the dayOfWeek regarded as the first day
   *
   * @return int   firstDayOfWeek
   */
  public int getFirstDayOfWeek() {
    return calInfo.getFirstDayOfWeek();
  }

  /** Class to hold data needed while we build this thing
   */
  static class GtpiData {
    /** True if we've done the last entry
     */
    boolean isLast;

    /** True if we're doing the first entry
     */
    boolean isFirst = true;

    /** True if we're starting a new month
     */
    boolean newMonth = true;

    MyCalendarVO currentDay;

    MyCalendarVO first;
    MyCalendarVO last;
    boolean multi;

    String monthName = null;

    String shortMonthName = null;

    /** Cuurent month we are processing
     */
    int curMonth;

    /** todays month
     */
    String todaysMonth;

    /** True if we are in the current month */
    boolean inThisMonth = false;

    String year;

    int weekOfYear = 1;

    /** Need this so we can flag end of month
     */
    TimeViewDailyInfo prevTvdi;
  }

  /** Return an array of TimeViewDailyInfo describing the period this
   * view covers. This will not include events
   *
   * @return TimeViewDailyInfo[]  array of info - one entry per day
   */
  public TimeViewDailyInfo[] getTimePeriodInfo() {
    /* In the following code we assume that we never cross year boundaries
      so that the year is always constant.
     */
    if (tvdis != null) {
      return tvdis;
    }

    try {
      GtpiData gtpi = new GtpiData();

      Vector months = new Vector();
      Vector weeks = new Vector();

      gtpi.first = getFirstDay();
      gtpi.last = getLastDay();
      gtpi.multi = !gtpi.last.isSameDate(gtpi.first);
      gtpi.currentDay = new MyCalendarVO(gtpi.first.getTime(),
      		                               calInfo.getLocale());
      gtpi.year = String.valueOf(gtpi.currentDay.getYear());

      gtpi.todaysMonth = new MyCalendarVO().getTwoDigitMonth();

      if (debug) {
        debugMsg("getFirstDayOfWeek() = " + getFirstDayOfWeek());
        debugMsg("gtpi.first.getFirstDayOfWeek() = " +
        		     calInfo.getFirstDayOfWeek());
      }

      initGtpiForMonth(gtpi);

      /* Our month entry */
      TimeViewDailyInfo monthTvdi = new TimeViewDailyInfo(calInfo);
      initTvdi(monthTvdi, gtpi);

      /* Create a year entry */
      TimeViewDailyInfo yearTvdi = new TimeViewDailyInfo(calInfo);
      yearTvdi.setCal(gtpi.currentDay);
      yearTvdi.setYear(gtpi.year);
      yearTvdi.setDate(gtpi.currentDay.getDateDigits());
      yearTvdi.setDateShort(gtpi.currentDay.getDateString());
      yearTvdi.setDateLong(gtpi.currentDay.getLongDateString());

      for (;;) {
        TimeViewDailyInfo weekTvdi = new TimeViewDailyInfo(calInfo);

        initTvdi(weekTvdi, gtpi);

        weekTvdi.setEntries(getOneWeekTvdi(gtpi));
        weeks.addElement(weekTvdi);

        if (getFirstDayOfWeek() == gtpi.currentDay.getDayOfWeek()) {
          gtpi.weekOfYear++;
        }

        if (gtpi.isLast || gtpi.newMonth) {
          /** First add all the weeks to this month
           */

          if (gtpi.prevTvdi != null) {
            gtpi.prevTvdi.setLastDayOfMonth(true);
          }

          monthTvdi.setEntries(
             (TimeViewDailyInfo[])weeks.toArray(new TimeViewDailyInfo[
                  weeks.size()]));
          months.addElement(monthTvdi);

          if (gtpi.isLast) {
            break;
          }

          /** Set up for a new month.
           */

          initGtpiForMonth(gtpi);

          monthTvdi = new TimeViewDailyInfo(calInfo);
          initTvdi(monthTvdi, gtpi);
          weeks = new Vector();
        }
      }

      yearTvdi.setEntries(
              (TimeViewDailyInfo[])months.toArray(new TimeViewDailyInfo[months.size()]));

      tvdis = new TimeViewDailyInfo[1];
      tvdis[0] = yearTvdi;

      return tvdis;
    } catch (Throwable t) {
      Logger.getLogger(this.getClass()).error("getTimePeriodInfo", t);
      //XXX We need an error object

      return null;
    }
  }

  private void initGtpiForMonth(GtpiData gtpi) {
    gtpi.curMonth = gtpi.currentDay.getMonth();
    gtpi.monthName = gtpi.currentDay.getMonthName();
    gtpi.shortMonthName = gtpi.currentDay.getShortMonthName();
    gtpi.inThisMonth = gtpi.todaysMonth.equals(gtpi.currentDay.getTwoDigitMonth());
  }

  private void initTvdi(TimeViewDailyInfo tvdi, GtpiData gtpi) {
    tvdi.setView(this);
    tvdi.setCal(gtpi.currentDay);
    tvdi.setMultiDay(gtpi.multi);
    tvdi.setMonth(gtpi.currentDay.getTwoDigitMonth());
    tvdi.setShortMonthName(gtpi.shortMonthName);
    tvdi.setMonthName(gtpi.monthName);
    tvdi.setYear(gtpi.year);
    tvdi.setDate(gtpi.currentDay.getDateDigits());
    tvdi.setDateShort(gtpi.currentDay.getDateString());
    tvdi.setDateLong(gtpi.currentDay.getLongDateString());
    tvdi.setCurrentMonth(gtpi.inThisMonth);
    tvdi.setWeekOfYear("" + gtpi.weekOfYear);
  }

  /** Build up to one weeks worth of days info. We assume that at least one
   * day will go into the current week. We exit at the end of the week, the
   * end of the month or the end of the time period.
   *
   * @param gtpi     GtpiData object supplying many parameters
   * @return TimeViewDailyInfo[] array of entries for this week.
   * @throws Throwable
   */
  private TimeViewDailyInfo[] getOneWeekTvdi(GtpiData gtpi) throws Throwable {
    Vector days = new Vector();
    TimeViewDailyInfo tvdi;

    /** First see if we need to insert leading fillers */
    int dayOfWeek = gtpi.currentDay.getDayOfWeek();
    int dayNum = getFirstDayOfWeek();

    if (debug) {
      debugMsg("dayOfWeek=" + dayOfWeek + " dayNum = " + dayNum);
    }

    while (dayNum != dayOfWeek) {
      tvdi = new TimeViewDailyInfo(calInfo);
      tvdi.setFiller(true);

      days.addElement(tvdi);
      dayNum++;

      if (debug) {
        debugMsg("dayNum = " + dayNum);
      }

      if (dayNum > 7) {
        dayNum = 1;
      }

      // Check we got this right
      if (days.size() > 7) {
        throw new Exception("Programming error in getOneWeekTvdi");
      }
    }

    for (;;) {
      dayOfWeek = gtpi.currentDay.getDayOfWeek();

      if (gtpi.currentDay.getMonth() != gtpi.curMonth) {
        gtpi.newMonth = true;
        break;
      }

      gtpi.isLast = gtpi.last.isSameDate(gtpi.currentDay);

      /* Create a day entry */
      tvdi = new TimeViewDailyInfo(calInfo);

      initTvdi(tvdi, gtpi);

      tvdi.setDayEntry(true);

      tvdi.setFirstDay(gtpi.isFirst);
      tvdi.setLastDay(gtpi.isLast);
      tvdi.setDayOfMonth(gtpi.currentDay.getDay());
      tvdi.setDayOfWeek(dayOfWeek);

      /** Is this correct? The days of the week are rotated to adjust for
       *   first day differences. */
      tvdi.setDayName(calInfo.getDayName(dayOfWeek));
      tvdi.setFirstDayOfMonth(gtpi.newMonth);
      gtpi.newMonth = false;

      tvdi.setFirstDayOfWeek(getFirstDayOfWeek() == dayOfWeek);
      tvdi.setLastDayOfWeek(calInfo.getLastDayOfWeek() == dayOfWeek);

      days.addElement(tvdi);
      gtpi.isFirst = false;

      gtpi.prevTvdi = tvdi;

      gtpi.currentDay = gtpi.currentDay.getTomorrow();

      if (gtpi.isLast || tvdi.isLastDayOfWeek()) {
        // Watch for it also being the last day of the month
        if (gtpi.currentDay.getMonth() != gtpi.curMonth) {
          gtpi.newMonth = true;
        }

        break;
      }
    }

    /** Pad it out to seven days
     */
    while (days.size() < 7) {
      tvdi = new TimeViewDailyInfo(calInfo);
      tvdi.setFiller(true);

      days.addElement(tvdi);
    }

    return (TimeViewDailyInfo[])days.toArray(new TimeViewDailyInfo[
                    days.size()]);
  }

  /**
   * @param msg
   */
  public void debugMsg(String msg) {
    Logger.getLogger(this.getClass()).debug(msg);
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("TimeView{");
    sb.append(periodName);
    sb.append(", cur=");
    sb.append(String.valueOf(curDay));
    sb.append(", firstDay=");
    sb.append(String.valueOf(firstDay));
    sb.append(", lastDay=");
    sb.append(String.valueOf(lastDay));
    sb.append("}");

    return sb.toString();
  }
}

