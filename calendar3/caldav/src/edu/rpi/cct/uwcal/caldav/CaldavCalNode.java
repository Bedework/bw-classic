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

package edu.rpi.cct.uwcal.caldav;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.svc.BwSubscription;
import org.bedework.calsvci.CalSvcI;
import org.bedework.icalendar.IcalTranslator;
import org.bedework.icalendar.VFreeUtil;

import edu.rpi.cct.uwcal.access.Acl.CurrentAccess;
import edu.rpi.cct.webdav.servlet.shared.WebdavIntfException;

import java.util.ArrayList;
import java.util.Collection;

import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.component.VFreeBusy;

/** Class to represent a calendar in caldav.
 *
 *   @author Mike Douglass   douglm@rpi.edu
 */
public class CaldavCalNode extends CaldavBwNode {
  private Calendar ical;

  private String vfreeBusyString;

  /** Place holder for status
   *
   * @param status
   * @param debug
   */
  public CaldavCalNode(int status, boolean debug) {
    super(null, null, null, debug);
    setStatus(status);
  }

  /**
   * @param cdURI
   * @param svci
   * @param trans
   * @param debug
   */
  public CaldavCalNode(CaldavURI cdURI, CalSvcI svci,
                       IcalTranslator trans, boolean debug) {
    super(cdURI, svci, trans, debug);

    this.name = cdURI.getCalName();
    collection = true;
    allowsGet = false;

    if (!uri.endsWith("/")) {
      uri += "/";
    }

    contentLang = "en";
    contentLen = 0;
  }

  public Collection getChildren() throws WebdavIntfException {
    /* For the moment we're going to do this the inefficient way.
       We really need to have calendar defs that can be expressed as a search
       allowing us to retrieve all the ids of objects within a calendar.
       */

    try {
      BwCalendar cal = cdURI.getCal();

      if (cal.hasChildren()) {
        if (debug) {
          debugMsg("POSSIBLE SEARCH: getChildren for cal " + cal.getId());
        }
        return cal.getChildren();
      }

      /* Othewise, return the events in this calendar */
      if (debug) {
        debugMsg("SEARCH: getEvents in calendar " + cal.getId());
      }

      BwSubscription sub = BwSubscription.makeSubscription(cal);

      Collection events = getSvci().getEvents(sub, CalFacadeDefs.retrieveRecurExpanded);

      if (events == null) {
        return new ArrayList();
      }

      return events;
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  /**
   * @param fb
   * @throws WebdavIntfException
   */
  public void setFreeBusy(BwFreeBusy fb) throws WebdavIntfException {
    try {
      VFreeBusy vfreeBusy = VFreeUtil.toVFreeBusy(fb);
      if (vfreeBusy != null) {
        ical = IcalTranslator.newIcal();
        ical.getComponents().add(vfreeBusy);
        vfreeBusyString = ical.toString();
        contentLen = vfreeBusyString.length();
      } else {
        vfreeBusyString = null;
        contentLen = 0;
      }
      allowsGet = true;
    } catch (Throwable t) {
      if (debug) {
        error(t);
      }
      throw new WebdavIntfException(t);
    }
  }

  public String getContentString() throws WebdavIntfException {
    init(true);

    if (ical == null) {
      return null;
    }

    return vfreeBusyString;
  }

  /* ====================================================================
   *                   Abstract methods
   * ==================================================================== */

  public CurrentAccess getCurrentAccess() throws WebdavIntfException {
    BwCalendar cal = getCDURI().getCal();
    if (cal == null) {
      return null;
    }

    return cal.getCurrentAccess();
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("CaldavCalNode{cduri=");
    sb.append(getCDURI());
    sb.append(", isCalendar()=");
    sb.append(isCalendar());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    return new CaldavCalNode(getCDURI(), getSvci(), trans, debug);
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */
}
