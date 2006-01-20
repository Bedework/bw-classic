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

package org.bedework.webadmin;


import org.bedework.webcommon.BwAbstractAction;
import org.bedework.webcommon.BwActionFormBase;
import org.bedework.webcommon.BwSession;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** This provides some pubevents specific services to subclasses
 *
 * <p>Forwards to the name returned by the subclass or to:<ul>
 *      <li>"error"        some form of fatal error.</li>
 *      <li>"accessError"  error setting up service interface.</li>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"cancelled"    for a cancelled request.</li>
 *      <li>"success"      added ok.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public abstract class PEAbstractAction extends BwAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webcommon.BwAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webcommon.BwActionFormBase)
   */
  public String doAction(HttpServletRequest request,
                         HttpServletResponse response,
                         BwSession sess,
                         BwActionFormBase frm) throws Throwable {
    PEActionForm form = (PEActionForm)frm;

    /*
    CalEnv env = getEnv(frm);

    / * Set some options from the environment * /
    form.setAutoCreateSponsors(env.getAppBoolProperty("app.autocreatesponsors"));
    form.setAutoCreateLocations(env.getAppBoolProperty("app.autocreatelocations"));
    form.setAutoDeleteSponsors(env.getAppBoolProperty("app.autodeletesponsors"));
    form.setAutoDeleteLocations(env.getAppBoolProperty("app.autodeletelocations"));

    if (debug) {
      logIt("form.getGroupSet()=" + form.getGroupSet());
    }

    / ** Show the owner we are administering * /
    form.setAdminUserId(form.getCalSvcI().getUser().getAccount());

    if (debug) {
      logIt("-------- isSuperUser: " + form.getUserAuth().isSuperUser());
    }

    if (!form.getAuthorisedUser()) {
      return "noAccess";
    }

    String temp = checkGroup(request, form, true);
    if (temp != null) {
      if (debug) {
        logIt("form.getGroupSet()=" + form.getGroupSet());
      }
      return temp;
    }

    / ** Ensure we have prefs and other values for the AuthUser
     * /
    setAuthUser(form);

    String reqpar = request.getParameter("cancelled");

    if (reqpar != null) {
      / ** Set the objects to null so we get new ones.
       * / 
      form.initFields();
      form.setEvent(null);

      form.getMsg().emit("org.bedework.message.cancelled");
      return "cancelled";
    }
    */

    return doAction(request, sess, form);
  }

  /** This is the abstract routine which does the work.
   *
   * @param request   Needed to locate session
   * @param sess      UWCalSession calendar session object
   * @param form      Action form
   * @return String   forward name
   * @throws Throwable
   */
  public abstract String doAction(HttpServletRequest request,
                                  BwSession sess,
                                  PEActionForm form) throws Throwable;

  /* ********************************************************************
                             package methods
     ******************************************************************** */

  /* * Return null if group is chosen else return a forward name.
   *
   * @param request   Needed to locate session
   * @param form      Action form
   * @param initCheck true if this is a check to see if we're initialised,
   *                  otherwise this is an explicit request to change group.
   * @return String   forward name
   * /
  protected String checkGroup(HttpServletRequest request,
                    PEActionForm form,
                    boolean initCheck) throws Throwable {
    if (form.getGroupSet()) {
      return null;
    }

    CalSvcI svci = form.getCalSvcI();

    try {
      Groups adgrps = svci.getGroups();

      if (form.retrieveChoosingGroup()) {
        /* * This should be the response to presenting a list of groups.
            We handle it here rather than in a separate action to ensure our
            client is not trying to bypass the group setting.
         * /

        String reqpar = request.getParameter("adminGroupName");
        if (reqpar == null) {
          // Make them do it again.

          return "chooseGroup";
        }

        return setGroup(request, form, adgrps, reqpar);
      }

      /* * If the user is in no group or in one group we just go with that,
          otherwise we ask them to select the group
       * /

      Collection adgs;

      BwUser user = svci.findUser(form.getCurrentUser());
      if (user == null) {
        return "noAccess";
      }

      if (initCheck || !form.getUserAuth().isSuperUser()) {
        // Always restrict to groups we're a member of
        adgs = adgrps.getGroups(user);
      } else {
        adgs = adgrps.getAll();
      }

      if (adgs.isEmpty()) {
        /* * If we require that all users be in a group we return to an error
            page. The only exception will be superUser.
         * /

        boolean noGroupAllowed =
            form.getEnv().getAppBoolProperty("app.nogroupallowed");
        if (form.getUserAuth().isSuperUser() || noGroupAllowed) {
          form.assignAdminGroup(null);
          return null;
        }

        return "noGroupAssigned";
      }

      if (adgs.size() == 1) {
        Iterator adgsit = adgs.iterator();

        BwAdminGroup adg = (BwAdminGroup)adgsit.next();

        form.assignAdminGroup(adg);
        String s = setAdminUser(request, form, adg.getOwner().getAccount(), true);

        if (s != null) {
          return s;
        }

        form.setAdminUserId(svci.getUser().getAccount());
        return null;
      }

      /* * Go ahead and present the possible groups
       * /
      form.setUserAdminGroups(adgs);
      form.assignChoosingGroup(true); // reset

      return "chooseGroup";
    } catch (Throwable t) {
      form.getErr().emit(t);
      return "error";
    }
  }*/

  /* ********************************************************************
                             protected methods
     ******************************************************************** */
/*
  protected String setAdminUser(HttpServletRequest request,
                                PEActionForm form,
                                String user,
                                boolean isMember) throws Throwable {
    int access = getAccess(request, getMessages());

//    if (form.getCalSvcI() != null) {
//      form.getCalSvcI().close();
//    }

    if (!checkSvci(request, form, form.getSession(), access, user, true,
                   isMember, debug)) {
      return "accessError";
    }

    return null;
  }

  protected BwAuthUser getAuthUser(PEActionForm form) throws CalFacadeException {
    UserAuth ua = form.retrieveUserAuth();
    return ua.getUser(form.getCurrentUser());
  }
*/
  /* ********************************************************************
                             private methods
     ******************************************************************** */

  /*
  private boolean isMember(BwAdminGroup ag,
                           PEActionForm form) throws Throwable {
    return ag.isMember(String.valueOf(form.getCurrentUser()));
  }

  / * Set information associated witht he current auth user.
   * Set the prefs on each request to reflect other session changes
   * /
  private void setAuthUser(PEActionForm form) throws CalFacadeException {
    BwAuthUser au = getAuthUser(form);
    BwAuthUserPrefs prefs = au.getPrefs();
    if (prefs == null) {
      prefs = new BwAuthUserPrefs();
    }

    form.setAuthUserPrefs(prefs);

    int rights = au.getUsertype();

    form.assignAuthUserAlerts((rights & UserAuth.alertUser) != 0);
    form.assignAuthUserPublicEvents((rights & UserAuth.publicEventUser) != 0);
    form.assignAuthUserSuperUser((rights & UserAuth.superUser) != 0);
  }

  private String setGroup(HttpServletRequest request,
                          PEActionForm form,
                          Groups adgrps,
                          String groupName) throws Throwable {
    if (groupName == null) {
      // We require a name
      return "chooseGroup";
    }

    BwAdminGroup ag = (BwAdminGroup)adgrps.findGroup(groupName);

    if (debug) {
      if (ag == null) {
        logIt("No user admin group with name " + groupName);
      } else {
        logIt("Retrieved user admin group " + ag.getAccount());
      }
    }

    form.assignAdminGroup(ag);

    String s = setAdminUser(request, form, ag.getOwner().getAccount(),
                            isMember(ag, form));

    if (s != null) {
      return s;
    }

    form.setAdminUserId(form.getCalSvcI().getUser().getAccount());

    return null;
  }
  */
}

