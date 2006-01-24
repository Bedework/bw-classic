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

import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.svc.EventInfo;

import java.io.Serializable;

import org.apache.log4j.Logger;

/** Object to provide formatting services for a BwEvent.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class EventFormatter implements Serializable {
  /** The event
   */
  private EventInfo eventInfo;

  private CalendarInfo calInfo;

  private CalTimezones ctz;

  /** The view currently in place.
   */
  //private TimeView view;

  /** Set so that questions can be asked about the time */
  private MyCalendarVO today;

  /** Set dynamically on request to represent start date/time */
  private DateTimeFormatter start;

  /** Set dynamically on request to represent end date/time */
  private DateTimeFormatter end;

  /** Constructor
   *
   * @param eventInfo
   * @param calInfo
   * @param view
   * @param ctz
   */
  public EventFormatter(EventInfo eventInfo, TimeView view,
                        CalendarInfo calInfo, CalTimezones ctz) {
    this.eventInfo = eventInfo;
    this.calInfo = calInfo;
    this.ctz= ctz;
  }

  /** =====================================================================
   *                     Property methods
   *  ===================================================================== */

  /**
   * @return EventInfo
   */
  public EventInfo getEventInfo() {
    return eventInfo;
  }

  /**
   * @return CalendarInfo
   */
  public CalendarInfo getCalInfo() {
    return calInfo;
  }

  /**
   * @return BwEvent
   */
  public BwEvent getEvent() {
    return eventInfo.getEvent();
  }

  /** ===================================================================
                      Convenience methods
      =================================================================== */

      /*
  public void setToday(MyCalendarVO val) {
    today = val;
  }*/

  /** Get today as a calendar object
   *
   * @return MyCalendarVO
   */
  public MyCalendarVO getToday() {
    if (today == null) {
      // XXX Locale?
      today = new MyCalendarVO();
    }

    return today;
  }

  /** Get the event's starting day and time
   *
   * @return DateTimeFormatter  object corresponding to the event's
   *                     starting day and time
   */
  public DateTimeFormatter getStart() {
    try {
      if (start == null) {
        start = new DateTimeFormatter(getCalInfo(),
                                      getEvent().getDtstart(), ctz);
      }
    } catch (Throwable t) {
      error(t);
    }

    return start;
  }

  /** Get the event's ending date and time. If the value is a date only object
   * we decrement the date by 1 day to comply with accepted practice - that i,
   * the displayed date for a 1 day event has the end date equal to the start.
   *
   * <p>Internally we store a 1 day event with the end date 1 day after the
   * start date
   *
   * @return DateTimeFormatter  object corresponding to the event's
   *                     ending day and time
   */
  public DateTimeFormatter getEnd() {
    try {
      if (end == null) {
        end = new DateTimeFormatter(getCalInfo(),
                                    getEvent().getDtend(),
                                    ctz);
      }
    } catch (Throwable t) {
      error(t);
    }

    return end;
  }

  /* ===================================================================
                      Private methods
     ==================================================================== */

  private void error(Throwable t) {
    Logger.getLogger(this.getClass()).error(this, t);
  }

}

