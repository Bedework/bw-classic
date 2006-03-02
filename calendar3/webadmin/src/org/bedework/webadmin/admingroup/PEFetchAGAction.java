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

import org.bedework.calfacade.ifs.Groups;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.webadmin.PEAbstractAction;
import org.bedework.webadmin.PEActionForm;
import org.bedework.webcommon.BwSession;



import javax.servlet.http.HttpServletRequest;

/** This action fetches an admin group
 *
 * <p>Forwards to:<ul>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"notFound"     no such event.</li>
 *      <li>"continue"     continue on to update page.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class PEFetchAGAction extends PEAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webadmin.PEAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webadmin.PEActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwSession sess,
                         PEActionForm form) throws Throwable {
    /** Check access
     */
    if (!form.getUserAuth().isSuperUser()) {
      return "noAccess";
    }

    Groups adgrps = form.fetchSvci().getAdminGroups();
    form.assignChoosingGroup(false); // reset

    /** User requested an admin group from the list or by entering the name.
     */
    String account = request.getParameter("adminGroupName");
    if (account == null) {
      return "notFound";
    }

    BwAdminGroup ag = (BwAdminGroup)adgrps.findGroup(account);

    if (debug) {
      if (ag == null) {
        logIt("No group with name " + account);
      } else {
        logIt("Retrieved admin group " + ag.getAccount());
      }
    }

    if (ag == null) {
      return "notFound";
    }

    adgrps.getMembers(ag);
    form.setUpdAdminGroup(ag);
    form.assignAddingAdmingroup(false);

    return "continue";
  }
}

