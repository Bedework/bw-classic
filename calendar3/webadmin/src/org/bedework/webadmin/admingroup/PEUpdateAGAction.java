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

package org.bedework.webadmin.admingroup;

import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.Groups;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webadmin.PEAbstractAction;
import org.bedework.webadmin.PEActionForm;
import org.bedework.webcommon.BwSession;

import edu.rpi.sss.util.Util;


import javax.servlet.http.HttpServletRequest;

/** This action updates an admin group
 *
 * <p>Parameters are:<ul>
 *      <li>"delete"           Delete current admin group</li>
 *      <li>"addGroupMember"   Add member to current group</li>
 *      <li>"removeGroupMember"  Remove member from current group.</li>
 *      <li>"kind"             Kind of member, "group" or "user".</li>
 *      <li>"view"             Optional name of view to which we add subscription.</li>
 *      <li>"addtodefaultview" Optional y/n to add to default view.</li>
 * </ul>
 *
 * <p>Forwards to:<ul>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"notFound"     no such event.</li>
 *      <li>"continue"     continue on to update page.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class PEUpdateAGAction extends PEAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webadmin.PEAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webadmin.PEActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwSession sess,
                         PEActionForm form) throws Throwable {
    /* Check access
     */
    if (!form.getUserAuth().isSuperUser()) {
      return "noAccess";
    }

    if (getReqPar(request, "delete") != null) {
      return "delete";
    }

    Groups adgrps = form.fetchSvci().getGroups();
    form.assignChoosingGroup(false); // reset
    boolean add = form.getAddingAdmingroup();

    BwAdminGroup updgrp = form.getUpdAdminGroup();

    if (updgrp == null) {
      // That's not right
      return "done";
    }

    CalSvcI svci = form.fetchSvci();

    if (request.getParameter("addGroupMember") != null) {
      /** Add a user to the group we are updating.
       */
      String mbr = form.getUpdGroupMember();
      if (mbr == null) {
        return "continue";
      }

      String kind = getReqPar(request, "kind");
      if (!validateKind(kind, form)) {
        return "retry";
      }

      if (updgrp.isMember(mbr, "group".equals(kind))) {
        form.getErr().emit("org.bedework.error.alreadymember", mbr);
        return "retry";
      }
        
      BwPrincipal newMbr = null;
      
      if ("user".equals(kind)) {
        BwUser u = svci.findUser(mbr);
        
        if (u == null) {
          u = new BwUser(mbr);
          svci.addUser(u);
          u = svci.findUser(mbr);
        }
        
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
          au = new BwAuthUser(u, UserAuth.publicEventUser);
          uauth.updateUser(au);
        }
        
        newMbr = u;
      } else {
        // group
        newMbr = (BwAdminGroup)adgrps.findGroup(mbr);
        
        if (newMbr == null) {
          form.getErr().emit("org.bedework.error.unknowgroup", mbr);
          return "retry";
        }
      }
      
      adgrps.addMember(updgrp, newMbr);
      updgrp.addGroupMember(newMbr);
    } else if (getReqPar(request, "removeGroupMember") != null) {
      /** Remove a user or group from the group we are updating.
       */
      String mbr = getReqPar(request, "removeGroupMember");

      String kind = getReqPar(request, "kind");
      if (!validateKind(kind, form)) {
        return "retry";
      }

      BwPrincipal oldMbr = null;

      if ("user".equals(kind)) {
        oldMbr = form.fetchSvci().findUser(mbr);
      } else {
        // group
        oldMbr = (BwAdminGroup)adgrps.findGroup(mbr);
      }

      if (oldMbr != null) {
        adgrps.removeMember(updgrp, oldMbr);
        updgrp.removeGroupMember(oldMbr);
      }
    } else if (add) {
      if (!validateNewAdminGroup(form)) {
        return "retry";
      }

      try {
        adgrps.addGroup(updgrp);
      } catch (CalFacadeException cfe) {
        if (CalFacadeException.duplicateAdminGroup.equals(cfe.getMessage())) {
          form.getErr().emit("org.bedework.error.duplicate.admingroup", 
                             updgrp.getAccount());
          return "retry";
        } else {
          throw cfe;
        }
      }
      
      form.assignAddingAdmingroup(false);
    } else {
      if (!validateAdminGroup(form)) {
        return "retry";
      }

      if (debug) {
        debugMsg("About to update " + updgrp);
      }
      adgrps.updateGroup(updgrp);
    }

    /** Refetch the group
     * /

    updgrp = (BwAdminGroup)adgrps.findGroup(updgrp.getAccount());

    adgrps.getMembers(updgrp);

    form.setUpdAdminGroup(updgrp);
    */

    form.getMsg().emit("org.bedework.client.message.admingroup.updated");
    return "continue";
  }

  private boolean validateNewAdminGroup(PEActionForm form) throws Throwable {
    boolean ok = true;
    CalSvcI svci = form.fetchSvci();

    BwAdminGroup updAdminGroup = form.getUpdAdminGroup();

    if (updAdminGroup == null) {
      // bogus call.
      return false;
    }

    updAdminGroup.setAccount(Util.checkNull(updAdminGroup.getAccount()));

    if (updAdminGroup.getAccount() == null) {
      form.getErr().emit("org.bedework.client.error.missingfield", "Name");
      ok = false;
    }

    updAdminGroup.setDescription(Util.checkNull(updAdminGroup.getDescription()));

    if (updAdminGroup.getDescription() == null) {
      form.getErr().emit("org.bedework.client.error.missingfield",
               "description");
      ok = false;
    }

    String adminGroupGroupOwner = Util.checkNull(form.getAdminGroupGroupOwner());
    if (adminGroupGroupOwner == null) {
      form.getErr().emit("org.bedework.client.error.missingfield",
               "groupOwnerid");
      ok = false;
    } else {
      updAdminGroup.setGroupOwner(getUser(svci, adminGroupGroupOwner));
    }

    String adminGroupEventOwner = Util.checkNull(form.getAdminGroupEventOwner());
    if (adminGroupEventOwner == null) {
      adminGroupEventOwner = updAdminGroup.getAccount();
    }
    if (adminGroupEventOwner == null) {
      form.getErr().emit("org.bedework.client.error.missingfield",
               "eventOwnerid");
      ok = false;
    } else {
      String prefix = form.getEnv().getAppProperty("admingroupsidprefix");

      if (!adminGroupEventOwner.startsWith(prefix)) {
        adminGroupEventOwner = prefix + adminGroupEventOwner;
      }

      updAdminGroup.setOwner(getUser(svci, adminGroupEventOwner));
    }

    return ok;
  }

  private boolean validateAdminGroup(PEActionForm form) throws Throwable {
    boolean ok = true;
    CalSvcI svci = form.fetchSvci();

    BwAdminGroup updAdminGroup = form.getUpdAdminGroup();

    if (updAdminGroup == null) {
      // bogus call.
      return false;
    }

    /* We should see if somebody tried to change the name of the group */

    updAdminGroup.setDescription(Util.checkNull(updAdminGroup.getDescription()));

    if (updAdminGroup.getDescription() == null) {
      form.getErr().emit("org.bedework.client.error.missingfield",
               "description");
      ok = false;
    }

    String adminGroupGroupOwner = Util.checkNull(form.getAdminGroupGroupOwner());
    if ((adminGroupGroupOwner != null) &&
        (!adminGroupGroupOwner.equals(updAdminGroup.getGroupOwner().getAccount()))) {
      BwUser aggo = svci.findUser(adminGroupGroupOwner);

      if (aggo == null) {
        form.getErr().emit("org.bedework.client.error.usernotfound",
                           adminGroupGroupOwner);
        return false;
      }

      updAdminGroup.setGroupOwner(aggo);
    }

    String adminGroupEventOwner = Util.checkNull(form.getAdminGroupEventOwner());
    if (adminGroupEventOwner == null) {
      // no change
      return ok;
    }

    if (adminGroupEventOwner.equals(updAdminGroup.getOwner().getAccount())) {
      // no change
      return ok;
    }

    String prefix = form.getEnv().getAppProperty("admingroupsidprefix");

    if (!adminGroupEventOwner.startsWith(prefix)) {
      adminGroupEventOwner = prefix + adminGroupEventOwner;
    }

    if (!adminGroupEventOwner.equals(updAdminGroup.getOwner().getAccount())) {
      BwUser ageo = svci.findUser(adminGroupEventOwner);

      if (ageo == null) {
        form.getErr().emit("org.bedework.client.error.usernotfound",
                           adminGroupEventOwner);
        return false;
      }

      updAdminGroup.setOwner(ageo);
    }

    return ok;
  }
  
  private boolean validateKind(String kind, PEActionForm form) {
    if (kind == null) {
      form.getErr().emit("org.bedework.error.missingreqpar", "kind");
      return false;
    }

    if ("group".equals(kind) || "user".equals(kind)) {
      return true;
    }
    
    form.getErr().emit("org.bedework.error.badrequest", kind);
    return false;
  }

  private BwUser getUser(CalSvcI svci, String account) throws Throwable {
    BwUser u = svci.findUser(account);

    if (u != null) {
      return u;
    }

    u = new BwUser(account);
    svci.addUser(u);

    return u;
  }
}

