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

import org.bedework.calfacade.BwUserInfo;
//import org.bedework.calsvci.CalSvcI;
import org.bedework.webcommon.BwAbstractAction;
import org.bedework.webcommon.BwActionFormBase;
import org.bedework.webcommon.BwSession;

import edu.rpi.sss.util.Util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Action to update user info. This may be disabled for sites that use a
 * directory.
 *
 * <p>Request parameters<ul>
 * </ul>
 *
 * <p>Forwards to:<ul>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"retry"        validation error.</li>
 *      <li>"continue"     ok.</li>
 * </ul>
 */
public class UpdateUserInfoAction extends BwAbstractAction {
  public String doAction(HttpServletRequest request,
                         HttpServletResponse response,
                         BwSession sess,
                         BwActionFormBase form) throws Throwable {
    /** Check access
     */
    if (!form.getCurUserSuperUser()) {
      return "noAccess";
    }

//    CalSvcI svci = form.getCalSvcI();

    /** We are just updating from the current form values.
     */
    BwUserInfo ui = validateUserInfo(form);
    if (ui == null) {
      return "retry";
    }

    if (debug) {
      debugMsg("Update userInfo " + ui);
    }

    //svci.getUserAuth().updateUser(au);

    form.getMsg().emit("org.bedework.client.message.userinfo.updated");

    return "continue";
  }

  /**
   *
   * @param form
   * @return BwAuthUser  null means something wrong, message emitted
   * @throws Throwable
   */
  public BwUserInfo validateUserInfo(BwActionFormBase form) throws Throwable {
    BwUserInfo ui = /*form.getUserInfo(); */null;

    ui.setLastname(Util.checkNull(ui.getLastname()));
    ui.setFirstname(Util.checkNull(ui.getFirstname()));
    ui.setPhone(Util.checkNull(ui.getPhone()));
    ui.setEmail(Util.checkNull(ui.getEmail()));
    ui.setDept(Util.checkNull(ui.getDept()));

    return ui;
  }
}
