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

import org.bedework.appcommon.BedeworkDefs;
import org.bedework.appcommon.MyCalendarVO;
import org.bedework.appcommon.TimeView;
import org.bedework.calfacade.util.CalFacadeUtil;
import org.bedework.webcommon.BwAbstractAction;
import org.bedework.webcommon.BwActionFormBase;
import org.bedework.webcommon.BwSession;
import org.bedework.webcommon.TimeDateComponents;

import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** Does nothing but narrow the form class.
 *
 */
public abstract class BwCalAbstractAction extends BwAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webcommon.BwAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webcommon.BwActionFormBase)
   */
  public String doAction(HttpServletRequest request,
                         HttpServletResponse response,
                         BwSession sess,
                         BwActionFormBase frm) throws Throwable {
    BwActionForm form = (BwActionForm)frm;

    String forward = doAction(request, form);

    return forward;
  }

  /** This is the routine which does the work.
   *
   * @param request   Needed to locate session
   * @param form      Action form
   * @return String   forward name
   * @throws Throwable
   */
  public abstract String doAction(HttpServletRequest request,
                                  BwActionForm form) throws Throwable;


  /** Set the current date and/or view. The date may be null indicating we
   * should switch to a new view based on the current date.
   *
   * <p>newViewTypeI may be less than 0 indicating we stay with the current
   * view but switch to a new date.
   *
   * @param action
   * @param form         UWCalActionForm
   * @param date         String yyyymmdd date or null
   * @param newViewTypeI new view index or -1
   * @param debug
   * @throws Throwable
   */
  protected static void gotoDateView(BwCalAbstractAction action,
                                     BwActionForm form,
                                     String date,
                                     int newViewTypeI,
                                     boolean debug) throws Throwable {
    /* We get a new view if either the date changed or the view changed.
     */
    boolean newView = false;

    if (debug) {
      action.logIt("ViewTypeI=" + newViewTypeI);
    }

    MyCalendarVO dt;
    TimeView tv = form.getCurTimeView();
    Locale loc = Locale.getDefault();  // XXX Locale

    if (newViewTypeI == BedeworkDefs.todayView) {
      // dt = new MyCalendarVO(new Date(System.currentTimeMillis()));
      Date jdt = new Date(System.currentTimeMillis());
      dt = new MyCalendarVO(jdt, loc);
      newView = true;
      newViewTypeI = BedeworkDefs.dayView;
    } else if (date == null) {
      if (newViewTypeI == BedeworkDefs.dayView) {
        // selected specific day to display from personal event entry screen.

        Date jdt = CalFacadeUtil.getDate(form.getViewStartDate().getDateTime());
        dt = new MyCalendarVO(jdt, loc);
        newView = true;
      } else {
        if (debug) {
          action.logIt("No date supplied: go with current date");
        }

        // Just stay here
        dt = tv.getCurDay();
      }
    } else {
      if (debug) {
        action.logIt("Date=" + date + ": go with that");
      }

      Date jdt = CalFacadeUtil.fromISODate(date);
      dt = new MyCalendarVO(jdt, loc);
      if (!checkDateInRange(form, dt.getYear())) {
        // Set it to today
        jdt = new Date(System.currentTimeMillis());
        dt = new MyCalendarVO(jdt, loc);
      }
      newView = true;
    }

    if ((newViewTypeI >= 0) &&
        (newViewTypeI != form.getCurViewPeriod())) {
      // Change of view
      newView = true;
    }

    if (newView && (newViewTypeI < 0)) {
      newViewTypeI = form.getCurViewPeriod();
      if (newViewTypeI < 0) {
        newViewTypeI = BedeworkDefs.defaultView;
      }
    }

    TimeDateComponents viewStart = form.getViewStartDate();

    if (!newView) {
      /* See if we were given an explicit date as view start date components.
         If so we'll set a new view of the same period as the current.
       */
      int year = viewStart.getCalYear();

      if (checkDateInRange(form, year)) {
        String vsdate = viewStart.getDateTime().getDtval().substring(0, 8);
        if (debug) {
          action.logIt("vsdate=" + vsdate);
        }

        if (!(vsdate.equals(form.getCurTimeView().getFirstDay().getDateDigits()))) {
          newView = true;
          newViewTypeI = form.getCurViewPeriod();
          Date jdt = CalFacadeUtil.fromISODate(vsdate);
          dt = new MyCalendarVO(jdt, loc);
        }
      }
    }

    if (newView) {
      form.setCurViewPeriod(newViewTypeI);
      form.setViewMcDate(dt);
      form.refreshIsNeeded();
    }

    tv = form.getCurTimeView();
    // dt = tv.getCurDay();

    /** Set first day, month and year
     */

    MyCalendarVO firstDay = tv.getFirstDay();

    viewStart.setDay(firstDay.getTwoDigitDay());
    viewStart.setMonth(firstDay.getTwoDigitMonth());
    viewStart.setYear(firstDay.getFourDigitYear());

    form.getEventStartDate().setDateTime(tv.getCurDay().getTime());
    form.getEventEndDate().setDateTime(tv.getCurDay().getTime());
  }

  private static boolean checkDateInRange(BwActionForm form,
                                   int year) throws Throwable {
    // XXX make system parameters for allowable start/end year
    int thisYear = form.getToday().getYear();

    if ((year < thisYear - 10) || (year > thisYear + 10)) {
      form.getErr().emit("org.bedework.client.error.baddate");
      return false;
    }

    return true;
  }
}
