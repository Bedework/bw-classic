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

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calsvci.CalSvcI;
import org.bedework.icalendar.BwEventUtil;

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.log.MessageEmit;

import net.fortuna.ical4j.model.Dur;
import net.fortuna.ical4j.model.property.Duration;
import net.fortuna.ical4j.model.property.DtEnd;
import net.fortuna.ical4j.model.property.DtStart;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

/** Useful shared web utility routines
 *
 * @author  Mike Douglass  douglm@rpi.edu
 */
public class BwWebUtil {
  /** Name of the session attribute holding our session state
   */
  static final String sessStateAttr = "edu.washington.cac.uwcal.sessstate";

  /** Name of the session attribute holding our calendar interface
   */
  static final String sessCalSvcIAttr = "edu.washington.cac.uwcal.calsvci";

  /** Try to get the session state object  embedded in
   *  the current session.
   *
   * @param request  Needed to locate session
   * @return UWCalSession null on failure
   */
  public static BwSession getState(HttpServletRequest request) {
    HttpSession sess = request.getSession(false);

    if (sess != null) {
      Object o = sess.getAttribute(sessStateAttr);
      if ((o != null) && (o instanceof BwSession)) {
        return (BwSession)o;
      }
    } else {
      noSession();
    }

    return null;
  }

  /** Set the session state object into the current session.
   *
   * @param request  HttpServletRequest Needed to locate session
   * @param s        UWCalSession session object
   */
  public static void setState(HttpServletRequest request,
                              BwSession s) {
    HttpSession sess = request.getSession(false);

    if (sess != null) {
      sess.setAttribute(sessStateAttr, s);
    } else {
      noSession();
    }
  }

  /** Try to get the CalSvcI object  embedded in
   *  the current session.
   *
   * @param request  Needed to locate session
   * @return CalSvcI  null on failure
   */
  public static CalSvcI getCalSvcI(HttpServletRequest request) {
    HttpSession sess = request.getSession(false);

    if (sess != null) {
      Object o = sess.getAttribute(sessCalSvcIAttr);
      if ((o != null) && (o instanceof CalSvcI)) {
        return (CalSvcI)o;
      }
    } else {
      noSession();
    }

    return null;
  }

  /** Set the CalSvcI object into the current session.
   *
   * @param request        HttpServletRequest Needed to locate session
   * @param svci           CalSvcI object
   */
  public static void setCalSvcI(HttpServletRequest request,
                                CalSvcI svci) {
    HttpSession sess = request.getSession(false);

    if (sess != null) {
      sess.setAttribute(sessCalSvcIAttr, svci);
    } else {
      noSession();
    }
  }

  /** Validate the properties of the event.
   *
   * @param svci
   * @param ev
   * @param descriptionRequired
   * @param err
   * @return boolean true for ok
   * @throws CalFacadeException
   */
  public static boolean validateEvent(CalSvcI svci, BwEvent ev, boolean descriptionRequired,
                                      MessageEmit err) throws CalFacadeException {
    boolean ok = true;

    ev.setSummary(checkNull(ev.getSummary()));
    ev.setDescription(checkNull(ev.getDescription()));

    if (ev.getSummary() == null) {
      err.emit("org.bedework.validation.error.notitle");
      ok = false;
    }

    if (ev.getDescription() == null) {
      if (descriptionRequired) {
        err.emit("org.bedework.validation.error.nodescription");
        ok = false;
      }
    } else if (ev.getDescription().length() > BwEvent.maxDescriptionLength) {
      err.emit("org.bedework.validation.error.toolong.description", String.valueOf(BwEvent.maxDescriptionLength));
      ok = false;
    }

    BwDateTime evstart = ev.getDtstart();
    DtStart start = evstart.makeDtStart();
    DtEnd end = null;
    Duration dur = null;

    char endType = ev.getEndType();

    if (endType == BwEvent.endTypeNone) {
    } else if (endType == BwEvent.endTypeDate) {
      BwDateTime evend = ev.getDtend();

      if (evstart.after(evend)) {
        err.emit("org.bedework.validation.error.event.startafterend");
        ok = false;
      } else {
        end = evend.makeDtEnd();
      }
    } else if (endType == BwEvent.endTypeDuration) {
      dur = new Duration(new Dur(ev.getDuration()));
    } else {
      err.emit("org.bedework.validation.error.invalid.endtype");
      ok = false;
    }

    if (ok) {
      BwEventUtil.setDates(svci.getTimezones(), ev, start, end, dur);
    }

    return ok;
  }

  /** Delete an event and optionally delete the old location and/or sponsor
   * entries if now unused.
   *
   * @param form       Action form
   * @param event      BwEvent object to be added
   * @throws Throwable
   */
  public static void deleteEvent(BwActionFormBase form,
                          BwEvent event) throws Throwable {
    CalSvcI svci = form.getCalSvcI();

    svci.deleteEvent(event, false);

    /* If we auto delete and if sponsor id no longer exists in events
       table then delete this sponsor.
     */
    if (form.getAutoDeleteSponsors() &&
        svci.getSponsorRefs(event.getSponsor()).size() == 0) {
      svci.deleteSponsor(event.getSponsor());
    }

    /* If we auto delete and if location id no longer exists in events
       table then delete this location.
     */
    if (form.getAutoDeleteLocations() &&
        svci.getLocationRefs(event.getLocation()).size() == 0) {
      svci.deleteLocation(event.getLocation());
    }
  }

  /**
   *
   * @param  l        BwLocation to validate
   * @param  err      MessageEmit object for errors
   * @return boolean  false means something wrong, message emitted
   * @throws Throwable
   */
  public static boolean validateLocation(BwLocation l,
                                         MessageEmit err) throws Throwable {
    boolean ok = true;

    l.setAddress(checkNull(l.getAddress()));

    if (l.getAddress() == null) {
      err.emit("org.bedework.validation.error.nolocationaddress");
      ok = false;
    }

    l.setSubaddress(checkNull(l.getSubaddress()));
    l.setLink(fixLink(l.getLink()));

    return ok;
  }

  /**
   *
   * @param  s        BwSponsor to validate
   * @param  err      MessageEmit object for errors
   * @return boolean  false means something wrong, message emitted
   * @throws CalFacadeException
   */
  public static boolean validateSponsor(BwSponsor s,
                                        MessageEmit err) throws CalFacadeException {
    boolean ok = true;

    if (Util.checkNull(s.getName()) == null) {
      err.emit("org.bedework.validation.error.nosponsorname");
      ok = false;
    }

    s.setPhone(Util.checkNull(s.getPhone()));
    s.setEmail(Util.checkNull(s.getEmail()));
    s.setLink(Util.checkNull(s.getLink()));

    s.setLink(fixLink(s.getLink()));

    return ok;
  }

  /** Return either null (for null or all whitespace) or a url
   * prefixed with http://
   *
   * @param val  String urlk to fix up
   * @return String  fixed up
   */
  public static String fixLink(String val) {
    val = checkNull(val);

    if (val == null) {
      return val;
    }

    if (val.indexOf("://") > 0) {
      return val;
    }

    return "http://" + val;
  }

  /** We get a lot of zero length strings in the web world. This will return
   * null for a zero length.
   *
   * @param  val    String request parameter value
   * @return String null for null or zero lengt val, val otherwise.
   */
  public static String checkNull(String val) {
    if (val == null) {
      return null;
    }

    if (val.length() == 0) {
      return null;
    }

    return val;
  }

  private static void noSession() {
    Logger.getLogger("edu.rpi.cct.uwcal.webcommon.UWCalWebUtil").warn(
            "No session!!!!!!!");
  }
}

