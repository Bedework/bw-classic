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

package org.bedework.webadmin.sponsor;

import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calsvci.CalSvcI;
import org.bedework.webadmin.PEAbstractAction;
import org.bedework.webadmin.PEActionForm;
import org.bedework.webcommon.BwSession;
import org.bedework.webcommon.BwWebUtil;



import javax.servlet.http.HttpServletRequest;

/** This action updates a sponsor.
 *
 * <p>Forwards to:<ul>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"retry"        invalid entitly.</li>
 *      <li>"notFound"     no such event.</li>
 *      <li>"continue"     continue on to update page.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class PEUpdateSponsorAction extends PEAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webadmin.PEAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webadmin.PEActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwSession sess,
                         PEActionForm form) throws Throwable {
    /** Check access
     */
    if (!form.getAuthorisedUser()) {
      return "noAccess";
    }

    String reqpar = request.getParameter("delete");

    if (reqpar != null) {
      return "delete";
    }

    CalSvcI svci = form.getCalSvcI();
    boolean add = form.getAddingSponsor();

    /** We are just updating from the current form values.
     */

    BwSponsor sp = form.getSponsor();

    if (!BwWebUtil.validateSponsor(sp, form.getErr())) {
      return "retry";
    }

    /* if the sponsor exists use it otherwise add one.
     */

    if (!add && (sp.getId() <= CalFacadeDefs.maxReservedSponsorId)) {
      // claim it doesn't exist
      form.getErr().emit("org.bedework.client.error.nosuchsponsor",
               sp.getId());
      return "noSuchSponsor";
    }

    boolean added = false;

    if (add) {
      added = svci.addSponsor(sp);
    } else {
      svci.replaceSponsor(sp);
    }

    updateAuthPrefs(form, null, sp, null, null);

    if (add) {
      if (added) {
        form.getMsg().emit("org.bedework.client.message.sponsor.added");
      } else {
        form.getErr().emit("org.bedework.client.error.sponsor.alreadyexists");
      }
    } else {
      form.getMsg().emit("org.bedework.client.message.sponsor.updated");
    }

    return "continue";
  }
}

