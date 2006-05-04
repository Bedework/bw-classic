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

package org.bedework.webadmin.system;

import org.bedework.calfacade.BwSystem;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webadmin.PEAbstractAction;
import org.bedework.webadmin.PEActionForm;
import org.bedework.webcommon.BwSession;

import javax.servlet.http.HttpServletRequest;

/** This action updates the system parameters
 *
 * <p>Parameters are:<ul>
 *      <li>updateCancelled</li>
 *      <li>admingroupsClass</li>
 *      <li>usergroupsClass</li>
 *      <li>defaultUserViewName</li>
 *      <li>directoryBrowsingDisallowed</li>
 *      <li>httpConnectionsPerUser</li>
 *      <li>httpConnectionsPerHost</li>
 *      <li>httpConnections</li>
 *      <li>defaultUserQuota</li>
 * </ul>
 *
 * <p>Forwards to:<ul>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"notFound"     no such user.</li>
 *      <li>"continue"     continue on to update page.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class UpdateSysparsAction extends PEAbstractAction {
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

    CalSvcI svci = form.fetchSvci();
    BwSystem syspars = svci.getSyspars();
    boolean changed = false;

    String str = getReqPar(request, "updateCancelled");
    if (str != null) {
      // refetch
      form.setSyspars(svci.getSyspars());
      return "cancelled";
    }

    str = getReqPar(request, "admingroupsClass");
    if (str != null) {
      syspars.setAdmingroupsClass(str);
      changed = true;
    }

    str = getReqPar(request, "usergroupsClass");
    if (str != null) {
      syspars.setUsergroupsClass(str);
      changed = true;
    }

    str = getReqPar(request, "defaultUserViewName");
    if (str != null) {
      syspars.setDefaultUserViewName(str);
      changed = true;
    }

    int intVal = getIntReqPar(request, "httpConnectionsPerUser", -1);
    if (intVal >= 0) {
      syspars.setHttpConnectionsPerUser(intVal);
      changed = true;
    }

    intVal = getIntReqPar(request, "httpConnectionsPerHost", -1);
    if (intVal >= 0) {
      syspars.setHttpConnectionsPerHost(intVal);
      changed = true;
    }

    intVal = getIntReqPar(request, "httpConnections", -1);
    if (intVal >= 0) {
      syspars.setHttpConnections(intVal);
      changed = true;
    }

    long longVal = getLongReqPar(request, "defaultUserQuota", -1);
    if (longVal >= 0) {
      syspars.setDefaultUserQuota(longVal);
      changed = true;
    }

    if (!changed) {
      return "nochange";
    }

    str = getReqPar(request, "updateConfirmed");
    if (str != null) {
      svci.updateSyspars(syspars);

      form.setSyspars(svci.getSyspars());

      form.getMsg().emit("org.bedework.client.message.syspars.updated");
      return "success";
    }

    return "continue";
  }
}
