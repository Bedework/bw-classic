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

package org.bedework.webclient;

import org.bedework.appcommon.CheckData;
import org.bedework.appcommon.EventFormatter;
import org.bedework.appcommon.MyCalendarVO;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.webcommon.DurationBean;
import org.bedework.webcommon.BwActionFormBase;
import org.bedework.webcommon.TimeDateComponents;

import edu.rpi.sss.util.Util;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionMapping;

/**
 * @author Mike Douglass     doulgm@rpi.edu
 */
public class BwActionForm extends BwActionFormBase {
  private String date;

  /* * We retrieve this to see if the public events were updated allowing us
      to force a refresh
   * /
  private long publicLastmod; */

  private TimeDateComponents viewStartDate;

  /** ...................................................................
   *                   Event fields
   *  ................................................................... */

  /** Formatter for the current event
   */
  private EventFormatter curEventFmt;

  private String evSummary;
  private String evLink;

  /* ....................................................................
   *                   Location fields
   * .................................................................... */

  /** (New) Location address for event
   */
  private String laddress;

  /** Location id for event update
   */
  private int eventLocationId;

  /* ....................................................................
   *                   Alarm fields
   * .................................................................... */

  /* The trigger is a date/time or a duration.
   */

  private TimeDateComponents triggerDateTime;

  private DurationBean triggerDuration;

  /** Specified trigger is relative to the start of event or todo, otherwise
   * it's the end.
   */
  private boolean alarmRelStart = true;

  private DurationBean alarmDuration;

  private int alarmRepeatCount;

  private boolean alarmTriggerByDate;

  private BwFreeBusy freeBusy;

  /* ====================================================================
   *                   Methods
   * ==================================================================== */

  /**
   * @return time date
   */
  public TimeDateComponents getViewStartDate() {
    if (viewStartDate == null) {
      viewStartDate = getNowTimeComponents();
    }

    return viewStartDate;
  }

  /** This often appears as the request parameter specifying the date for an
   * action. Always YYYYMMDD format
   *
   * @param  val   String date in YYYYMMDD format
   */
  public void setDate(String val) {
    if (!CheckData.checkDateString(val)) {
      date = new MyCalendarVO().getDateDigits();
    } else {
      date = val;
    }
  }

  /**
   * @return date
   */
  public String getDate() {
    return date;
  }

  /* ====================================================================
   *                   Searching
   * ==================================================================== */

  /** Return the current search string
   *
   * @return  String     search parameters
   */
  public String getSearch() {
    try {
      return getCalSvcI().getSearch();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /* ====================================================================
   *                   Subscriptions
   * ==================================================================== */

  /** Allows us to generate checkboxes showing subscribed status
   *
   * @param  i         int key of calendar
   * @return boolean   true is user is subscribed to indicated calendar
   */
  public boolean getSubscribed(int i) {
    try {
      BwCalendar cal = getCalSvcI().getCalendar(i);

      if (cal == null) {
        return false;
      }
      return getCalSvcI().getSubscribed(cal);
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /* ====================================================================
   *                   Events
   * ==================================================================== */

  /**
   * @param val
   */
  public void setCurEventFmt(EventFormatter val) {
    curEventFmt = val;
  }

  /**
   * @return event formatter
   */
  public EventFormatter getCurEventFmt() {
    return curEventFmt;
  }

  /**
   * @param val
   */
  public void setEvSummary(String val) {
    evSummary = Util.checkNull(val);
  }

  /**
   * @return event summary
   */
  public String getEvSummary() {
    return evSummary;
  }

  /**
   * @param val
   */
  public void setEvLink(String val) {
    evLink = Util.checkNull(val);
  }

  /**
   * @return event link
   */
  public String getEvLink() {
    return evLink;
  }

  /* * ===================================================================
   *                   Alerts
   *  =================================================================== * /

  public EventVO[] getTodaysAlerts() {
    try {
      EventVO[] alerts = getCalSvcI().getDaysAlerts(getToday());

      if (alerts == null) {
        return new EventVO[0];
      }

      return alerts;
    } catch (Throwable t) {
      err.emit(t);
      return new EventVO[0];
    }
  }*/

  /* ====================================================================
   *                   Locations
   * ==================================================================== */

  /**
   * @param val
   */
  public void setLaddress(String val) {
    laddress = Util.checkNull(val);
  }

  /**
   * @return location address
   */
  public String getLaddress() {
    return laddress;
  }

  /**
   * @param val
   */
  public void setEventLocationId(int val) {
    eventLocationId = val;
  }

  /**
   * @return event locid
   */
  public int getEventLocationId() {
    return eventLocationId;
  }

  /**
   * @param val
   */
  public void assignFreeBusy(BwFreeBusy val) {
    freeBusy = val;
  }

  /**
   * @return free/busy
   */
  public BwFreeBusy getFreeBusy() {
    return freeBusy;
  }

  /* ====================================================================
   *                   Alarm fields
   * ==================================================================== */

  /* *
   * @param val
   * /
  private void setTriggerDateTime(TimeDateComponents val) {
    triggerDateTime = val;
  } */

  /**
   * @return time date
   */
  public TimeDateComponents getTriggerDateTime() {
    if (triggerDateTime == null) {
      triggerDateTime = getNowTimeComponents();
    }

    return triggerDateTime;
  }

  /**
   * @param val
   */
  public void setTriggerDuration(DurationBean val) {
    triggerDuration = val;
  }

  /**
   * @return duration
   */
  public DurationBean getTriggerDuration() {
    if (triggerDuration == null) {
      triggerDuration = new DurationBean();
    }

    return triggerDuration;
  }

  /**
   * @param val
   */
  public void setAlarmRelStart(boolean val) {
    alarmRelStart = val;
  }

  /**
   * @return alarm rel start
   */
  public boolean getAlarmRelStart() {
    return alarmRelStart;
  }

  /**
   * @param val
   */
  public void setAlarmDuration(DurationBean val) {
    alarmDuration = val;
  }

  /**
   * @return duration
   */
  public DurationBean getAlarmDuration() {
    if (alarmDuration == null) {
      alarmDuration = new DurationBean();
    }

    return alarmDuration;
  }

  /**
   * @param val
   */
  public void setAlarmRepeatCount(int val) {
    alarmRepeatCount = val;
  }

  /**
   * @return int
   */
  public int getAlarmRepeatCount() {
    return alarmRepeatCount;
  }

  /**
   * @param val
   */
  public void setAlarmTriggerByDate(boolean val) {
    alarmTriggerByDate = val;
  }

  /**
   * @return  bool
   */
  public boolean getAlarmTriggerByDate() {
    return alarmTriggerByDate;
  }

  /**
   * Reset properties to their default values.
   *
   * @param mapping The mapping used to select this instance
   * @param request The servlet request we are processing
   */
  public void reset(ActionMapping mapping, HttpServletRequest request) {
    if (debug) {
      getLog().debug("--" + getClass().getName() + ".reset--");
    }

    super.reset(mapping, request);

    date = null;
    laddress = null;
  }
}

