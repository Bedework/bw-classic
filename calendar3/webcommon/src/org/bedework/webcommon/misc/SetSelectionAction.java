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

package org.bedework.webcommon.misc;

import org.bedework.appcommon.BedeworkDefs;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.svc.BwSubscription;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webcommon.BwAbstractAction;
import org.bedework.webcommon.BwActionFormBase;
import org.bedework.webcommon.BwSession;

import java.util.Collection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Action to select what will be displayed. If no request par values are found
 * will switch to default view.
 *
 * <p>Request parameters<ul>
 *      <li>"viewName"       Use named view</li>
 *      <li>"calUrl"         URL of calendar</li>
 *      <li>"subname"        Name of subscription.</li>
 * </ul>
 * <p>Forwards to:<ul>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"notFound"     no event was found.</li>
 *      <li>"success"      exported ok.</li>
 * </ul>
 */
public class SetSelectionAction extends BwAbstractAction {
  public String doAction(HttpServletRequest request,
                         HttpServletResponse response,
                         BwSession sess,
                         BwActionFormBase form) throws Throwable {
    CalSvcI svci = form.fetchSvci();

    String name = getReqPar(request, "subname");
    if (name != null) {
      BwSubscription sub = svci.findSubscription(name);

      if (sub == null) {
        form.getErr().emit("org.bedework.client.error.unknownsubscription");
        return "notFound";
      }

      Collection c = new Vector();
      c.add(sub);
      svci.setCurrentSubscriptions(c);
      form.setSelectionType(BedeworkDefs.selectionTypeSubscription);

      return "success";
    }

    String url = getReqPar(request, "calUrl");
    if (url != null) {
      BwCalendar cal = findCalendar(url, form);

      if (cal == null) {
        form.getErr().emit("org.bedework.client.error.unknowncalendar");
        return "notFound";
      }

      BwSubscription sub = BwSubscription.makeSubscription(cal);

      Collection c = new Vector();
      c.add(sub);
      svci.setCurrentSubscriptions(c);
      form.setSelectionType(BedeworkDefs.selectionTypeCalendar);

      return "success";
    }

    name = getReqPar(request, "viewName");

    if (name == null) {
      name = svci.getUserPrefs().getPreferredView();
    }

    if (name == null) {
      form.getErr().emit("org.bedework.client.error.nodefaultview");
      return "noViewDef";
    }

    if (!svci.setCurrentView(name)) {
      form.getErr().emit("org.bedework.client.error.unknownview");
      return "noViewDef";
    }

    form.refreshIsNeeded();
    return "success";
  }
}
