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

package org.bedework.webadmin.event;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webadmin.PEAbstractAction;
import org.bedework.webadmin.PEActionForm;
import org.bedework.webcommon.BwSession;
import org.bedework.webcommon.BwWebUtil;

import edu.rpi.sss.util.log.MessageEmit;



import javax.servlet.http.HttpServletRequest;

/** This action adds or updates events or alerts.
 *
 * <p>Forwards to:<ul>
 *      <li>"doNothing"    input error or we want to ignore the request.</li>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"retry"        invalid entitly.</li>
 *      <li>"copy"         User wants to duplicate event.</li>
 *      <li>"delete"       User wants to delete event.</li>
 *      <li>"continue"     continue on update page.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class PEUpdateEventAction extends PEAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webadmin.PEAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webadmin.PEActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwSession sess,
                         PEActionForm form) throws Throwable {
    boolean alerts = form.getAlertEvent();

    /** Check access and set request parameters
     */
    if (alerts) {
      if (!form.getUserAuth().isAlertUser()) {
        return "noAccess";
      }
    } else {
      if (!form.getAuthorisedUser()) {
        return "noAccess";
      }
    }

    String reqpar = request.getParameter("delete");

    if (reqpar != null) {
      return "delete";
    }

    BwEvent event = form.getEditEvent();

    reqpar = request.getParameter("copy");

    if (reqpar != null) {
      /* Refetch the event and switch it for a cloned copy.
       * guid must be set to null to avoid dup guid.
       */
      EventInfo ei = fetchEvent(event, form);
      BwEvent evcopy = new BwEventObj();
      ei.getEvent().shallowCopyTo(evcopy);

      evcopy.setId(CalFacadeDefs.unsavedItemKey);
      evcopy.setGuid(null);

      if (debug) {
        BwLocation l = evcopy.getLocation();
        if (l == null) {
          debugMsg("Copied event has null location");
        } else {
          debugMsg("Copied event has location with id " + l.getId());
        }
      }

      ei.setEvent(evcopy);

      form.setEventInfo(ei);
      resetEvent(form);
      form.assignAddingEvent(true);

      return "copy";
    }

    CalSvcI svci = form.fetchSvci();
    if (!validateEvent(form, svci, event, form.getErr())) {
      return "retry";
    }

    /* Validation set up the form so that any selected contact, location
     * and or categories are available.
     */

    event.setPublick(true);

    if (form.getAddingEvent()) {
      svci.addEvent(event.getCalendar(), event, null);
    } else {
      svci.updateEvent(event);
    }

    if (!alerts) {
      updateAuthPrefs(form, event.getCategories(), event.getSponsor(),
                      event.getLocation(),
                      event.getCalendar());
    }

    resetEvent(form);

    if (form.getAddingEvent()) {
      form.getMsg().emit("org.bedework.client.message.event.added");
    } else {
      form.getMsg().emit("org.bedework.client.message.event.updated");
    }

    form.assignAddingEvent(false);

    return "continue";
  }

  /* Ensure the event has all required fields and all are valid.
   *
   * <p>This method will retrieve any selected contacts, locations and
   * categories and embed them in the form and event.
   */
  private boolean validateEvent(PEActionForm form, CalSvcI svci,
                                BwEvent event, MessageEmit err)
          throws Throwable {
    boolean ok = validateEventCategory(form, svci, event, err);

    if (!validateEventSponsor(form, svci, event, err)) {
      ok = false;
    }

    if (!validateEventLocation(form, svci, event, err)) {
      ok = false;
    }

    if (!validateEventCalendar(form, svci, event, err)) {
      ok = false;
    }

    if (!form.getEventDates().updateEvent(event, svci.getTimezones())) {
      ok = false;
    } else if (!BwWebUtil.validateEvent(svci, event, true, // ENUM  descriptionRequired
                                        err)) {
      ok = false;
    }

    return ok;
  }

  /** Validate the calendar provided for an event and embed it in the event and
   * the form.
   *
   * @return boolean  true OK, false not OK and message(s) emitted.
   */
  private boolean validateEventCalendar(PEActionForm form, CalSvcI svci,
                                        BwEvent event, MessageEmit err)
          throws Throwable {
    if (!form.retrieveCalendarId().getChanged()) {
      if (event.getCalendar() == null) {
        err.emit("org.bedework.client.error.missingfield", "Calendar");
        return false;
      }

      return true;
    }

    // The user selected one from the list

    try {
      int id = form.retrieveCalendarId().getVal();

      BwCalendar c = svci.getCalendar(id);

      if ((c == null) || !c.getPublick() || !c.getCalendarCollection()) {
        // Somebody's faking
        form.setCalendar(null);
        err.emit("org.bedework.client.error.missingfield", "Calendar");
        return false;
      }

      event.setCalendar(c);
      form.setCalendar(c);
      return true;
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /**
   *
   * @return boolean  false means something wrong, message emitted
   * @throws Throwable
   */
  private boolean validateEventCategory(PEActionForm form, CalSvcI svci,
                                        BwEvent event, MessageEmit err)
          throws Throwable {
    int id = form.retrieveCategoryId().getVal();

    if (id <= 0) {
      if (form.getEnv().getAppBoolProperty("categoryOptional")) {
        return true;
      }

      err.emit("org.bedework.client.error.missingfield", "Category");
      return false;
    }

    try {
      BwCategory cat = svci.getCategory(id);

      if (cat == null) {
        err.emit("org.bedework.client.error.missingcategory", id);
        return false;
      }

      if (!form.retrieveCategoryId().getChanged()) {
        return true;
      }

//    oldCategory = getEvent().getCategory(0);


      /* Currently we replace the only category if it exists
       */
      event.clearCategories();
      event.addCategory(cat);

      form.setCategory(cat);

      return true;
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /** Validate the sponsor provided for an event and embed it in the event and
   * the form.
   *
   * @return boolean  true OK, false not OK and message(s) emitted.
   * @throws Throwable
   */
  private boolean validateEventSponsor(PEActionForm form, CalSvcI svci,
                                       BwEvent event, MessageEmit err)
          throws Throwable {
    if (!form.retrieveSpId().getChanged()) {
      if (form.getAutoCreateSponsors()) {
        BwSponsor s = form.getSponsor();
        if (!BwWebUtil.validateSponsor(s, err)) {
          return false;
        }

        svci.ensureSponsorExists(s);

        form.setSponsor(s);
        event.setSponsor(s);
      }

      if (event.getSponsor() == null) {
        err.emit("org.bedework.client.error.missingfield", "Sponsor");
        return false;
      }

      return true;
    }

    // The user selected one from the list
    int id = form.retrieveSpId().getVal();

    try {
      BwSponsor s = svci.getSponsor(id);
      if (s == null) {
        // Somebody's faking
        form.setSponsor(null);
        err.emit("org.bedework.client.error.missingfield", "Sponsor");
        return false;
      }

      event.setSponsor(s);

      form.setSponsor(s);
      return true;
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /** Validate the location provided for an event and embed it in the event and
   * the form.
   *
   * @return boolean  true OK, false not OK and message(s) emitted.
   * @throws Throwable
   */
  private boolean validateEventLocation(PEActionForm form, CalSvcI svci,
                                        BwEvent event, MessageEmit err)
          throws Throwable {
    if (!form.retrieveLocId().getChanged()) {
      if (form.getAutoCreateLocations()) {
        BwLocation l = form.getLocation();

        if (!BwWebUtil.validateLocation(l, err)) {
          return false;
        }

        svci.ensureLocationExists(l);

        form.setLocation(l);
        event.setLocation(l);
      }

      if (event.getLocation() == null) {
        err.emit("org.bedework.client.error.missingfield", "Location");
        return false;
      }

      return true;
    }

    // The user selected one from the list

    try {
      int id = form.retrieveLocId().getVal();
      BwLocation l = svci.getLocation(id);

      if ((l == null) || !l.getPublick()) {
        // Somebody's faking
        form.setLocation(null);
        err.emit("org.bedework.client.error.missingfield", "Location");
        return false;
      }

      event.setLocation(l);
      form.setLocation(l);

      return true;
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }
}
