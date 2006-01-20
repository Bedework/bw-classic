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

import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calsvci.CalSvcI;

import javax.servlet.http.HttpServletRequest;

/**
 * Action to delete an event
 * <p>Request parameters:<ul>
 *      <li>  eventId</li>.
 * </ul>
 * <p>Forwards to:<ul>
 *      <li>"doNothing"    for guest mode.</li>
 *      <li>"success"      deleted ok.</li>
 * </ul>
 * <p>Errors:<ul>
 *      <li>org.bedework.message.deleted.events - when
 *            event is deleted - 1 parameter: count</li>
 *      <li>org.bedework.message.deleted.locations - when
 *            location is deleted - 1 parameter: count</li>
 *      <li>org.bedework.message.nosuchevent</li>
 * </ul>
 */
public class BwDelEventAction extends BwCalAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webclient.BwCalAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webclient.BwActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwActionForm form) throws Throwable {
    if (form.getGuest()) {
      return "doNothing";
    }

    int id = form.getEventId();

    if (id < 0) {
      // Do nothing
      form.getErr().emit("org.bedework.error.nosuchevent", id);
      return "doNothing";
    }

    CalSvcI svci = form.getCalSvcI();

    EventInfo ei = svci.getEvent(id);

    if (ei == null) {
      // Do nothing
      form.getErr().emit("org.bedework.error.nosuchevent", id);
      return "doNothing";
    }

    CalSvcI.DelEventResult delResult = form.getCalSvcI().deleteEvent(ei.getEvent(), true);

    if (!delResult.eventDeleted) {
      form.getMsg().emit("org.bedework.message.nosuchevent", id);
      return "doNothing";
    }

    if (delResult.locationDeleted) {
      form.getMsg().emit("org.bedework.message.deleted.locations", 1);
    }

    form.getMsg().emit("org.bedework.message.deleted.events", 1);
    form.refreshIsNeeded();

    return "success";
  }
}
