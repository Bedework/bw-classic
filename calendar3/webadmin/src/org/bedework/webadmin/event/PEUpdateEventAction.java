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

import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webadmin.PEAbstractAction;
import org.bedework.webadmin.PEActionForm;
import org.bedework.webcommon.BwSession;



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

    reqpar = request.getParameter("copy");

    if (reqpar != null) {
      BwEvent evcopy = new BwEventObj();
      form.getEvent().copyTo(evcopy);

      evcopy.setId(CalFacadeDefs.unsavedItemKey);
      form.setEvent(evcopy);
      form.assignAddingEvent(true);

      return "copy";
    }

    CalSvcI svci = form.getCalSvcI();
    if (!form.validateEvent()) {
      return "retry";
    }

    /* Validation set up the form so that any selected contact, location
     * and or categories are available.
     */

    BwEvent ev = form.getEvent();

    ev.setPublick(true);

    if (form.getAddingEvent()) {
      svci.addEvent(ev, null);
    } else {
      svci.updateEvent(ev);
    }

    if (!alerts) {
      updateAuthPrefs(form, ev.getCategories(), ev.getSponsor(), ev.getLocation(),
                      ev.getCalendar());
    }

    form.resetEvent();

    form.assignAddingEvent(false);

    if (form.getAddingEvent()) {
      form.getMsg().emit("org.bedework.client.message.event.added");
    } else {
      form.getMsg().emit("org.bedework.client.message.event.updated");
    }
    return "continue";
  }
}

