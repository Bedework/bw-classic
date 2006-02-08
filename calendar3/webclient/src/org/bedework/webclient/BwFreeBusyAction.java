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

//import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwFreeBusyComponent;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calsvci.CalSvcI;



import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import javax.servlet.http.HttpServletRequest;

/**
 * Action to fetch free busy information
 * <p>Request parameters - all optional:<ul>
 *      <li>  userid:   whose free busy we want - default to current user</li>.
 *      <li>  calendar: name of the calendar - default to main calendar</li>.
 *      <li>  start:    start of period - default to beginning of this week</li>.
 *      <li>  end:      end of period - default to end of this week</li>.
 *      <li>  interval: default entire period or a number</li>.
 *      <li>  intunit:  default to hours, "minutes", "hours, "days", "weeks"
 *                      "months"</li>.
 * </ul>
 * <p>Forwards to:<ul>
 *      <li>"doNothing"    input error or we want to ignore the request.</li>
 *      <li>"notFound"     event not found.</li>
 *      <li>"error"        input error - correct and retry.</li>
 *      <li>"success"      fetched OK.</li>
 * </ul>
 *
 * <p>If no period is given return this week. If no interval and intunit is
 * supplied default to 1 hour intervals during the workday.
 */
public class BwFreeBusyAction extends BwCalAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webclient.BwCalAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webclient.BwActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwActionForm form) throws Throwable {
    String userId = request.getParameter("userid");
    BwUser user;
    CalSvcI svci = form.fetchSvci();

    if (userId != null) {
      user = svci.findUser(userId);
      if (user == null) {
        form.getErr().emit("org.bedework.client.error.usernotfound");
        return "notFound";
      }
    } else {
      user = svci.getUser();
    }

    Calendar start = Calendar.getInstance(request.getLocale());
    //BwDateTime startDt = form.getEventStartDate().getDateTime();

    Calendar end = Calendar.getInstance(request.getLocale());
    //BwDateTime endDt = form.getEventEndDate().getDateTime();

    int interval = 1;
    String intstr = request.getParameter("interval");

    if (intstr != null) {
      try {
        interval = Integer.parseInt(intstr);
      } catch (Throwable t) {
        form.getErr().emit("org.bedework.client.error.badinterval");
        return "error";
      }
    }

    if (interval <= 0) {
      form.getErr().emit("org.bedework.client.error.badinterval");
      return "error";
    }

    int intunit = Calendar.HOUR;
    String intunitStr = request.getParameter("intunit");

    if (intunitStr != null) {
      if ("minutes".equals(intunitStr)) {
        intunit = Calendar.MINUTE;
      } else if ("hours".equals(intunitStr)) {
        intunit = Calendar.HOUR;
      } else if ("days".equals(intunitStr)) {
        intunit = Calendar.DAY_OF_MONTH;
      } else if ("weeks".equals(intunitStr)) {
        intunit = Calendar.WEEK_OF_YEAR;
      } else if ("months".equals(intunitStr)) {
        intunit = Calendar.MONTH;
      } else {
        form.getErr().emit("org.bedework.client.error.badintervalunit");
        return "error";
      }
    }

    //int maxRequests = 1000;

    BwFreeBusy fb = null;
    while (start.before(end)) {
      Date sdt = start.getTime();
      start.add(intunit, interval);

      if (debug) {
        debugMsg("getFreeBusy for start =  " + sdt +
                 " end = " + start.getTime());
      }
      BwFreeBusy fb1 = svci.getFreeBusy(null, user,
                          CalFacadeUtil.getDateTime(sdt, false, true,
                                                    svci.getTimezones()),
                          CalFacadeUtil.getDateTime(start.getTime(), false, true,
                                                    svci.getTimezones()));

      if (fb == null) {
        fb = fb1;
      } else {
        Iterator it = fb1.iterateTimes();
        while (it.hasNext()) {
          BwFreeBusyComponent fbc = (BwFreeBusyComponent)it.next();

          if (!fbc.getEmpty()) {
            fb.addTime(fbc);
          }
        }
      }
    }

    fb.setEnd(form.getEventEndDate().getDateTime());

    form.assignFreeBusy(fb);

    return "success";
  }
}
