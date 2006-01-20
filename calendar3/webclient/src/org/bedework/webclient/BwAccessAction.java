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

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calsvci.CalSvcI;

import edu.rpi.cct.uwcal.access.Ace;
import edu.rpi.cct.uwcal.access.Acl;
import edu.rpi.cct.uwcal.access.PrivilegeDefs;

import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

/**
 * Action to update access rights to an entity. Note this will change as we
 * develop the user interface (and the access methods).
 *
 * Currently this provides a basic level of access control modification.
 *
 * <p>Request parameters:<ul>
 *      <li>  cal:      id of calendar or...</li>.
 *      <li>  event:    id of event</li>.
 *      <li>  how:      r for read, w for write, f for free/busy, d for default</li>.
 *      <li>  whoType:  user (default), group</li>.
 *      <li>  who:      name of principal - default to owner</li>.
 * </ul>
 * <p>Forwards to:<ul>
 *      <li>"doNothing"    input error or we want to ignore the request.</li>
 *      <li>"notFound"     entity not found.</li>
 *      <li>"error"        input error - correct and retry.</li>
 *      <li>"success"      OK.</li>
 * </ul>
 *
 * <p>If no period is given return this week. If no interval and intunit is
 * supplied default to 1 hour intervals during the workday.
 *
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class BwAccessAction extends BwCalAbstractAction {
  /**  Used for creating ace objects */
  private static Acl acl = new Acl();

  /* (non-Javadoc)
   * @see org.bedework.webclient.BwCalAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webclient.BwActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwActionForm form) throws Throwable {
    if (form.getGuest()) {
      return "doNothing";
    }

    String idstr = request.getParameter("cal");
    boolean calid = idstr != null;

    if (!calid) {
      idstr = request.getParameter("event");
    }

    if (idstr == null) {
      form.getErr().emit("org.bedework.error.noentityid");
      return "error";
    }

    int id;

    try {
      id = Integer.parseInt(idstr);
    } catch (Throwable t) {
      form.getErr().emit("org.bedework.error.badentityid");
      return "error";
    }

    CalSvcI svci = form.getCalSvcI();
    BwCalendar cal = null;
    BwEvent ev = null;

    if (calid) {
      cal = svci.getCalendar(id);

      if (cal == null) {
        // Do nothing
        form.getErr().emit("org.bedework.error.nosuchcalendar", id);
        return "doNothing";
      }
    } else {
      EventInfo ei = svci.getEvent(id);

      if (ei == null) {
        // Do nothing
        form.getErr().emit("org.bedework.error.nosuchevent", id);
        return "doNothing";
      }

      ev = ei.getEvent();
    }

    String how = request.getParameter("how");

    if (how == null) {
      form.getErr().emit("org.bedework.error.noentityid");
      return "error";
    }

    int desiredAccess = -1;
    //boolean defaultAccess = false;

    if (how.equals("r")) {
      desiredAccess = PrivilegeDefs.privRead;
    } else if (how.equals("w")) {
      desiredAccess = PrivilegeDefs.privWrite;
    } else if (how.equals("f")) {
      desiredAccess = PrivilegeDefs.privReadFreeBusy;
    } else if (how.equals("d")) {
      //defaultAccess = true;
      form.getErr().emit("org.bedework.error.unimplemented");
      return "error";
    } else {
      form.getErr().emit("org.bedework.error.badhow");
      return "error";
    }

    String whoTypeStr = request.getParameter("whoType");
    int whoType = -1;

    if (whoTypeStr == null) {
      whoType = Ace.whoTypeOwner;
    } else if (whoTypeStr.equals("user")) {
      whoType = Ace.whoTypeUser;
    } else if (whoTypeStr.equals("group")) {
      whoType = Ace.whoTypeGroup;
      form.getErr().emit("org.bedework.error.unimplemented");
      return "error";
    } else if (whoTypeStr.equals("unauth")) {
      whoType = Ace.whoTypeUnauthenticated;
    } else if (whoTypeStr.equals("other")) {
      whoType = Ace.whoTypeOther;
    } else {
      form.getErr().emit("org.bedework.error.badwhotype");
      return "error";
    }

    String who = request.getParameter("who");

    if (who != null) {
      BwUser user = svci.findUser(who);
      if (user == null) {
        form.getErr().emit("org.bedework.error.usernotfound");
        return "notFound";
      }
    } else {
      who = null;
    }

    Vector v = new Vector();
    v.add(new Ace(who, false, whoType, acl.makePriv(desiredAccess)));

    if (calid) {
      svci.changeAccess(cal, v);
      svci.updateCalendar(cal);
    } else {
      svci.changeAccess(ev, v);
      svci.updateEvent(ev);
    }
    return "success";
  }
}
