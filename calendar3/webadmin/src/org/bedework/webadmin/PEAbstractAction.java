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


import org.bedework.appcommon.IntSelectId;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
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
                             protected methods
     ******************************************************************** */

  protected void initFields(BwActionFormBase frm) {
    PEActionForm form = (PEActionForm)frm;
    super.initFields(frm);
    form.setEventInfo(null);
    resetEvent(form);

    form.setCategory(null);
    form.setSponsor(null);
    form.setLocation(null);
    form.setUpdGroupMember(null);
  }

  protected void resetEvent(PEActionForm form) {
    BwEvent event = form.getEditEvent();

    /* Implant the current id(s) in new entries */
    int id = 0;
    BwCategory k = event.getFirstCategory();
    if (k != null) {
      id = k.getId();
      form.setCategory(k);
    }

    /* A is the All box, B is the user preferred values. */
    form.assignCategoryId(new IntSelectId(id, IntSelectId.AHasPrecedence));

    BwSponsor s = event.getSponsor();
    id = 0;
    if (s != null) {
      id = s.getId();
      form.setSponsor(s);
    }

    form.assignSpId(new IntSelectId(id, IntSelectId.AHasPrecedence));

    BwLocation l = event.getLocation();
    id = 0;
    if (l != null) {
      id = l.getId();
      form.setLocation(l);
    }

    form.assignLocId(new IntSelectId(id, IntSelectId.AHasPrecedence));

    BwCalendar c = event.getCalendar();
    id = 0;
    if (c != null) {
      id = c.getId();
      form.setCalendar(c);
    }

    form.assignCalendarId(new IntSelectId(id, IntSelectId.AHasPrecedence));
  }

}

