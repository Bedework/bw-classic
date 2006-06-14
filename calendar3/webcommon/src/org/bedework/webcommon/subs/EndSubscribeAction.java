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
package org.bedework.webcommon.subs;

import org.bedework.calfacade.svc.BwPreferences;
import org.bedework.calfacade.svc.BwSubscription;
import org.bedework.calfacade.svc.BwView;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webcommon.BwAbstractAction;
import org.bedework.webcommon.BwActionFormBase;
import org.bedework.webcommon.BwSession;

import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** Complete or update a subscription to a calendar.
 *
 * <p>Parameters are:<ul>
 *      <li>"name"             Name of subscription</li>
 *      <li>"email"            y/n for email .</li>
 *      <li>"freebusy"         y/n for affects free busy.</li>
 *      <li>"view"             Optional name of view to which we add subscription.</li>
 *      <li>"addtodefaultview" Optional y/n to add to default view.</li>
 * </ul>
 *
 * <p>Forwards to:<ul>
 *      <li>"error"        some form of fatal error.</li>
 *      <li>"reffed"       subscription is referenced.</li>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"cancelled"    for a cancelled request.</li>
 *      <li>"success"      subscribed ok.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class EndSubscribeAction extends BwAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webcommon.BwAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webcommon.BwActionFormBase)
   */
  public String doAction(HttpServletRequest request,
                         HttpServletResponse response,
                         BwSession sess,
                         BwActionFormBase form) throws Throwable {
    if (form.getGuest()) {
      return "noAccess"; // First line of defence
    }

    int result;

    if (getReqPar(request, "delete") != null) {
      result = unsubscribe(request, form);
    } else {
      result = finishSubscribe(request, form.getSubscription(), form);
    }

    resetSelection(form);

    return forwards[result];
  }

  private int unsubscribe(HttpServletRequest request,
                          BwActionFormBase form) throws Throwable {
    CalSvcI svc = form.fetchSvci();

    String name = request.getParameter("name");

    if (name == null) {
      // Assume no access
      form.getErr().emit("org.bedework.client.error.missingfield", "name");
      return forwardError;
    }

    BwSubscription sub = svc.findSubscription(name);

    if (sub == null) {
      form.getErr().emit("org.bedework.client.error.nosuchsubscription", name);
      return forwardNotFound;
    }

    if (sub.getUnremoveable() && !form.getCurUserSuperUser()) {
      return forwardNoAccess; // Only super user can remove the unremovable
    }

    /* Check for references in views. For user extra simple mode only we will
     * automatically remove the subscription. For others we list the references
     */

    Iterator it = svc.getViews().iterator();
    boolean reffed = false;
    boolean autoRemove = !getPublicAdmin(form) &&
      (svc.getUserPrefs().getUserMode() == BwPreferences.basicMode);

    while (it.hasNext()) {
      BwView v = (BwView)it.next();
      if (v.getSubscriptions().contains(sub)) {
        if (autoRemove) {
          if (!svc.removeViewSubscription(v.getName(), sub)) {
            form.getErr().emit("org.bedework.client.error.viewnotfound",
                               v.getName());
            return forwardError;
          }
        } else {
          form.getErr().emit("org.bedework.client.error.subscription.reffed",
                             v.getName());
          reffed = true;
        }
      }
    }

    if (reffed) {
      return forwardReffed;
    }

    svc.removeSubscription(sub);
    form.getMsg().emit("org.bedework.client.message.subscription.removed");

    /* Refetch to tidy up */
    getSubscriptions(form);

    return forwardSuccess;
  }
}
