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

package org.bedework.webclient.groups;

import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.ifs.Groups;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webcommon.BwAbstractAction;
import org.bedework.webcommon.BwActionFormBase;
import org.bedework.webcommon.BwSession;

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.log.MessageEmit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** This action updates an admin group
 *
 * <p>Forwards to:<ul>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"notFound"     no such event.</li>
 *      <li>"continue"     continue on to update page.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class UpdateAction extends BwAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webadmin.PEAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webadmin.PEActionForm)
   */
  public String doAction(HttpServletRequest request,
                         HttpServletResponse response,
                         BwSession sess,
                         BwActionFormBase form) throws Throwable {
    /* Check access
     */
    if (!form.getUserAuth().isSuperUser()) {
      return "noAccess";
    }

    String reqpar = request.getParameter("delete");

    if (reqpar != null) {
      return "delete";
    }

    Groups grps = form.getCalSvcI().getGroups();
    boolean add = form.getAddingGroup();

    BwGroup updgrp = form.getUpdGroup();

    if (!validateGroup(updgrp, form.getErr())) {
      return "retry";
    }

    if (updgrp == null) {
      // That's not right
      return "done";
    }

    CalSvcI svci = form.getCalSvcI();

    if (request.getParameter("addGroupMember") != null) {
      /** Add a user to the group we are updating.
       */
      String mbr = form.getUpdGroupMember();
      if (mbr != null) {
        BwUser u = svci.findUser(mbr);

        if (u != null) {
          /* Ensure the authorised user exists - create an entry if not
           *
           * @param val      BwUser account
           */
          UserAuth uauth = svci.getUserAuth();

          BwAuthUser au = uauth.getUser(u.getAccount());

          if ((au != null) && (au.getUsertype() == UserAuth.noPrivileges)) {
            return "notAllowed";
          }

          if (au == null) {
            au = new BwAuthUser(u,
                                UserAuth.publicEventUser,
                                "",
                                "",
                                "",
                                "",
                                "");
            uauth.updateUser(au);
          }

          grps.addMember(updgrp, u);
        }
      }
    } else if (request.getParameter("removeGroupMember") != null) {
      /** Remove a user from the group we are updating.
       */
      String mbr = form.getUpdGroupMember();

      if (mbr != null) {
        BwUser u = form.getCalSvcI().findUser(mbr);

        if (u != null) {
          grps.removeMember(updgrp, u);
        }
      }
    } else if (add) {
      grps.addGroup(updgrp);
    } else {
      grps.updateGroup(updgrp);
    }

    /** Refetch the group
     */
    form.setUpdGroup(grps.findGroup(updgrp.getAccount()));

    return "continue";
  }

  /**
   * @param updgrp    BwAdminGroup object to validate
   * @param err       MessageEmit object for errors.
   * @return boolean  false means something wrong, message emitted
   * @throws Throwable
   */
  public boolean validateGroup(BwGroup updgrp, MessageEmit err) throws Throwable {
    boolean ok = true;

    if (updgrp == null) {
      // bogus call.
      return false;
    }

    updgrp.setAccount(Util.checkNull(updgrp.getAccount()));

    if (updgrp.getAccount() == null) {
      err.emit("org.bedework.pubevents.error.missingfield",
               "Name");
      ok = false;
    }

    return ok;
  }
}

