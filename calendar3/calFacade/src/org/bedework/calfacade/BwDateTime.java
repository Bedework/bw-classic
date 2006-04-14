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

import org.bedework.calfacade.ifs.CalTimezones;

import java.io.Serializable;
import java.util.Comparator;

import net.fortuna.ical4j.model.Date;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Dur;
import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.parameter.TzId;
import net.fortuna.ical4j.model.parameter.Value;
import net.fortuna.ical4j.model.property.DateProperty;
import net.fortuna.ical4j.model.property.DtEnd;
import net.fortuna.ical4j.model.property.DtStart;

/** Class to represent an RFC2554 date and datetime type. These are not stored
 * in separate tables but as components of the including class.
 *
 * <p>DateTime values take 3 forms:
 * <br/>Floating time - not timezone e.g. DTSTART:19980118T230000
 * <br/>UTC time no timezone e.g. DTSTART:19980118T230000Z
 * <br/>Local time with timezone e.g. DTSTART;TZID=US-Eastern:19980119T020000
 *
 * @author Mike Douglass   douglm@rpi.edu
 *  @version 1.0
 */
public class BwDateTime implements Comparable, Comparator, Serializable {
  /** If true this represents a date - not datetime.
   */
  private boolean dateType;

  /** Non-null if one was specified.
   */
  private String tzid;

  private String dtval; // rfc2554 date or datetime value

  private static Dur oneDayForward = new Dur(1, 0, 0, 0);
  private static Dur oneDayBack = new Dur(-1, 0, 0, 0);

  /** This is a UTC datetime value to make searching easier. There are a number of
   * complications to dates, the end date is specified as non-inclusive
   * but there are a number of boundary problems to watch out for.
   *
   * <p>For date only values this field has a zero time appended so that simple
   * string comparisons will work.
   */
  private String date; // For indexing

  /** Constructor
   */
  public BwDateTime() {
  }

  /** Set the dateType for this timezone
   *
   * @param val   boolean dateType
   */
  public void setDateType(boolean val) {
    dateType = val;
  }

  /** Get the timezone's dateType
   *
   * @return boolean    true for a date type
   */
  public boolean getDateType() {
    return dateType;
  }

  /**  Set the tzid
   *
   * @param val    String tzid
   */
  public void setTzid(String val) {
    tzid = val;
  }

  /** Get the tzid
   *
   * @return String    tzid
   */
  public String getTzid() {
    return tzid;
  }

  /** Set the dtval
   *
   * @param val    String dtval
   */
  private void setDtval(String val) {
    dtval = val;
    if (val == null) {
      setDate(null);
    }
  }

  /** Get the dtval
   *
   * @return String   dtval
   */
  public String getDtval() {
    return dtval;
  }

  /** Set the date as a datetime value for comparisons.
   *
   * @param val
   */
  public void setDate(String val) {
    date = val;
  }

  /** Return the date
   *
   * @return String date
   * @throws CalFacadeException
   */
  public String getDate() throws CalFacadeException {
    return date;
  }

  /* ====================================================================
   *                        Conversion methods
   * ==================================================================== */

  /** Make a DtEnd from this object
   *
   * @return DtEnd
   * @throws CalFacadeException
   */
  public DtEnd makeDtEnd() throws CalFacadeException {
    try {
      DtEnd dt = new DtEnd(makeDate());
      if (getDateType()) {
        dt.getParameters().add(Value.DATE);
      } else {
        // The default
        //dt.getParameters().add(Value.DATE_TIME);

        String tzid = getTzid();
        if (tzid != null) {
          dt.getParameters().add(new TzId(tzid));
        }
      }

      return dt;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  public BwDateTime copy(CalTimezones timezones) throws CalFacadeException {
    return makeDateTime(makeDtEnd(), timezones);
  }

  /** Make a DtStart from this object
   *
   * @return DtStart
   * @throws CalFacadeException
   */
  public DtStart makeDtStart() throws CalFacadeException {
    try {
      DtStart dt = new DtStart(makeDate());
      if (getDateType()) {
        dt.getParameters().add(Value.DATE);
      } else {
        // The default
        //dt.getParameters().add(Value.DATE_TIME);

        String tzid = getTzid();
        if (tzid != null) {
          dt.getParameters().add(new TzId(tzid));
        }
      }

      return dt;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /** Return an ical DateTime or Date object
   *
   * @return Date
   * @throws CalFacadeException
   */
  public Date makeDate() throws CalFacadeException {
    try {
      if (getDateType()) {
        return new Date(getDtval());
      }

      /** Ignore tzid for the moment */
      return new DateTime(getDtval());
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /** Make an ical Dur from a start and end
   *
   * @param start
   * @param end
   * @return Dur
   * @throws CalFacadeException
   */
  public static Dur makeDuration(BwDateTime start, BwDateTime end)
          throws CalFacadeException {
    return new Dur(start.makeDate(), end.makeDate());
  }

  /** Make a new date time value based on the dtStart value + the duration.
   *
   * @param dtStart
   * @param dateOnly
   * @param dur
   * @param timezones
   * @return BwDateTime
   * @throws CalFacadeException
   */
  public static BwDateTime makeDateTime(DateProperty dtStart,
                                        boolean dateOnly,
                                        Dur dur, CalTimezones timezones) throws CalFacadeException {
    DtEnd dtEnd;
    java.util.Date endDt = dur.getTime(dtStart.getDate());

    if (dateOnly) {
      dtEnd = new DtEnd(new Date(endDt));
      CalFacadeUtil.addIcalParameter(dtEnd, Value.DATE);
    } else {
      DateTime d = new DateTime(endDt);

      Parameter tzid = CalFacadeUtil.getIcalParameter(dtStart, "TZID");
      if (tzid != null) {
        DateTime sd = (DateTime)dtStart.getDate();

        d.setTimeZone(sd.getTimeZone());
      }
//          dtEnd = new DtEnd(d, dtStart.isUtc());
      dtEnd = new DtEnd(d);
      if (tzid != null) {
        CalFacadeUtil.addIcalParameter(dtEnd, tzid);
      } else if (dtStart.isUtc()) {
        dtEnd.setUtc(true);
      }
    }

    return makeDateTime(dtEnd, timezones);
  }

  /** Return a value based on this value plus a duration.
   *
   * @param val
   * @param timezones
   * @return BwDateTime
   * @throws CalFacadeException
   */
  public BwDateTime addDuration(BwDuration val, CalTimezones timezones) throws CalFacadeException {
    DtEnd dtEnd;
    Dur dur = val.makeDuration().getDuration();
    java.util.Date endDt = dur.getTime(makeDate());
    DtStart dtStart = makeDtStart();

    if (getDateType()) {
      dtEnd = new DtEnd(new Date(endDt));
      CalFacadeUtil.addIcalParameter(dtEnd, Value.DATE);
    } else {
      DateTime d = new DateTime(endDt);

      Parameter tzid = CalFacadeUtil.getIcalParameter(dtStart, "TZID");
      if (tzid != null) {
        DateTime sd = (DateTime)dtStart.getDate();

        d.setTimeZone(sd.getTimeZone());
      }
//          dtEnd = new DtEnd(d, dtStart.isUtc());
      dtEnd = new DtEnd(d);
      if (tzid != null) {
        CalFacadeUtil.addIcalParameter(dtEnd, tzid);
      } else if (dtStart.isUtc()) {
        dtEnd.setUtc(true);
      }
    }

    return makeDateTime(dtEnd, timezones);
  }

  /** Make date time based on ical property
   *
   * @param val
   * @param timezones
   * @return BwDateTime
   * @throws CalFacadeException
   */
  public static BwDateTime makeDateTime(DateProperty val, CalTimezones timezones) throws CalFacadeException {
    BwDateTime dtv = new BwDateTime();
    dtv.initFromDateTime(val, timezones);

    return dtv;
  }

  /**
   * @param val
   * @param timezones
   * @throws CalFacadeException
   */
  public void initFromDateTime(DateProperty val, CalTimezones timezones) throws CalFacadeException {
    Parameter par = CalFacadeUtil.getIcalParameter(val, "VALUE");

    init((par != null) && (par.equals(Value.DATE)),
         val.getValue(),
         CalFacadeUtil.getTzid(val),
         timezones);
  }

  /**
   * @param val
   * @param timezones
   * @throws CalFacadeException
   */
  public void initFromDateTime(Date val, CalTimezones timezones) throws CalFacadeException {
    boolean dateOnly = true;
    String tzid = null;

    if (val instanceof DateTime) {
      DateTime dt = (DateTime)val;

      dateOnly = false;
      tzid = dt.getTimeZone().getID();
    }

    init(dateOnly, val.toString(), tzid, timezones);
  }

  /** Set utc time
   *
   * @param dateType
   * @param date
   * @throws CalFacadeException
   */
  public void initUTC(boolean dateType, String date) throws CalFacadeException {
    if (!dateType && !date.endsWith("Z")) {
      throw new CalFacadeBadDateException();
    }
    setDateType(dateType);
    setDtval(date);
    setTzid(null);

    if (dateType) {
      setDate(date + "T000000Z");
    } else {
      setDate(date);
    }
  }

  /**
   * @param dateType
   * @param date
   * @param tzid
   * @param timezones
   * @throws CalFacadeException
   */
  public void init(boolean dateType, String date, String tzid, CalTimezones timezones) throws CalFacadeException {
    setDateType(dateType);
    setDtval(date);
    setTzid(tzid);

    setDate(timezones.getUtc(date, tzid, null));
  }

  /** For a date only object returns a date 1 day in advance of this date.
   * Used when moving between displayed and internal values and also when
   * breaking a collection of events up into days.
   *
   * @param timezones
   * @return BwDateTime tomorrow
   * @throws CalFacadeException
   */
  public BwDateTime getNextDay(CalTimezones timezones) throws CalFacadeException {
    if (!getDateType()) {
      throw new CalFacadeException("Must be a date only value");
    }

    return makeDateTime(makeDtStart(), true, oneDayForward, timezones);
  }

  /** For a date only object returns a date 1 day previous to this date.
   * Used when moving between displayed and internal values.
   *
   * @param timezones
   * @return BwDateTime yesterday
   * @throws CalFacadeException
   */
  public BwDateTime getPreviousDay(CalTimezones timezones) throws CalFacadeException {
    if (!getDateType()) {
      throw new CalFacadeException("Must be a date only value");
    }

    return makeDateTime(makeDtStart(), true, oneDayBack, timezones);
  }

  /* ====================================================================
   *                        Object methods
   * ==================================================================== */

  public int compare(Object o1, Object o2) {
    if (o1 == o2) {
      return 0;
    }

    if (!(o1 instanceof BwDateTime)) {
      return -1;
    }

    if (!(o2 instanceof BwDateTime)) {
      return 1;
    }

    BwDateTime dt1 = (BwDateTime)o1;
    BwDateTime dt2 = (BwDateTime)o2;

    try {
      return dt1.getDate().compareTo(dt2.getDate());
    } catch (CalFacadeException cfe) {
      throw new RuntimeException(cfe);
    }
  }

  public int compareTo(Object o2) {
    return compare(this, o2);
  }

  /** Return true if this is before val
   *
   * @param val
   * @return boolean this before val
   */
  public boolean before(BwDateTime val) {
    return compare(this, val) < 0;
  }

  /** Return true if this is after val
   *
   * @param val
   * @return boolean this after val
   */
  public boolean after(BwDateTime val) {
    return compare(this, val) > 0;
  }

  public int hashCode() {
    int hc = 1;

    if (getDateType()) {
      hc = 3;
    }

    if (getTzid() != null) {
      hc *= getTzid().hashCode();
    }

    if (getDtval() != null) {
      hc *= getDtval().hashCode();
    }

    return hc;
  }

  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (!(obj instanceof BwDateTime)) {
      return false;
    }

    BwDateTime that = (BwDateTime)obj;

    if (getDateType() != that.getDateType()) {
      return false;
    }

    if (!CalFacadeUtil.eqObjval(getTzid(), that.getTzid())) {
      return false;
    }

    return CalFacadeUtil.eqObjval(getDtval(), that.getDtval());
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwDateTime{dateType=");
    sb.append(getDateType());
    sb.append(", tzid=");
    sb.append(getTzid());
    sb.append(", dtval=");
    sb.append(getDtval());
    sb.append("}");

    return sb.toString();
  }
}
