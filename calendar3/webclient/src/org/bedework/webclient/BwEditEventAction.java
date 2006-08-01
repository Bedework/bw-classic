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

import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webcommon.BwWebUtil;

import javax.servlet.http.HttpServletRequest;

/**
 * Action to edit an Event
 *
 * <p>Request parameters<ul>
 *      <li>"updateEvent=anything" means we should try to update the current
 * event in form.editEvent.</li>
 *      <li>"eventId=nnn" id of event to fetch for editing.</li>
 * </ul>
 *.
 * <p>Forwards to:<ul>
 *      <li>"doNothing"    for guest mode/invalid id or non-existing event.</li>
 *      <li>"edit"         to edit the event.</li>
 *      <li>"success"      changes made.</li>
 * </ul>
 *
 * <p>Errors:<ul>
 *      <li>org.bedework.error.noaccess - when user has insufficient
 *            access (tries to edit public event)</li>
 * </ul>
 *
 * <p>Messages:<ul>
 *      <li>org.bedework.message.deleted.locations - when location is
 *            deleted</li>
 *      <li>org.bedework.message.added.locations - when location is
 *            added</li>
 * </ul>
 */
public class BwEditEventAction extends BwCalAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webclient.BwCalAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webclient.BwActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwActionForm form) throws Throwable {
    if (form.getGuest()) {
      // Just ignore this
      return "doNothing";
    }

    String reqpar = request.getParameter("updateEvent");
    if (reqpar != null) {
      return updateEvent(request, form);
    }

    return refreshEvent(findEvent(request, form), request, form);
  }

  /** Update the db with the event in editEvent.
   *
   * @param request   Needed to locate session
   * @param form      Action form
   * @return String   forward name
   * @throws Throwable
   */
  public String updateEvent(HttpServletRequest request,
                            BwActionForm form) throws Throwable {
    CalSvcI svci = form.fetchSvci();
    BwEvent ev = form.getEditEvent();

    String fwd = setEventCalendar(request, form, ev);
    if (fwd != null) {
      return fwd;
    }

    if (!form.getEventDates().updateEvent(ev, svci.getTimezones()) ||
        !BwWebUtil.validateEvent(svci, ev, false, //  public
                                 form.getErr())) {
      return "doNothing";
    }

    BwLocation loc = null;

    if (form.getLaddress() != null) {
      // explicitly provided location overrides all others
      loc = new BwLocation();
      loc.setAddress(form.getLaddress());
      loc = form.tidyLocation(loc);
    }

    if (loc == null) {
      if (form.getEventLocationId() != CalFacadeDefs.defaultLocationId) {
        loc = form.fetchSvci().getLocation(form.getEventLocationId());
      }
    }

    if (loc != null) {
      BwLocation l = svci.ensureLocationExists(loc);

      boolean added = true;
      if (l != null) {
        loc = l;
        added = false;
      }

      ev.setLocation(loc);

      if (added) {
        form.getMsg().emit("org.bedework.client.message.locations.added", 1);
      }
    }

    svci.updateEvent(ev);

    form.refreshIsNeeded();

    return "success";
  }
}
