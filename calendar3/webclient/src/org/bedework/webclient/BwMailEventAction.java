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

import org.bedework.calfacade.BwEvent;
import org.bedework.calsvci.CalSvcI;
import org.bedework.icalendar.IcalTranslator;
import org.bedework.mail.Message;
import org.bedework.mail.ObjectAttachment;

import edu.rpi.sss.util.Util;

import javax.servlet.http.HttpServletRequest;

/**
 * Action to mail an Event.
 * <p>No request parameters (other than updates to email and subject)
 * <p>Forwards to:<ul>
 *      <li>"retry"        email options still not valid.</li>
 *      <li>"noEvent"      no event was selected.</li>
 *      <li>"success"      mailed (or queued) ok.</li>
 * </ul>
 */
public class BwMailEventAction extends BwCalAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webclient.BwCalAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webclient.BwActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwActionForm form) throws Throwable {
    BwEvent ev = form.retrieveCurrentEvent();

    if (ev == null) {
      return "noevent";
    }

    String recipient = form.getLastEmail();
    if (recipient == null) {
      form.getErr().emit("org.bedework.client.error.mail.norecipient", 1);
      return "retry";
    }

    String subject = form.getLastSubject();
    if (!Util.present(subject)) {
      subject = ev.getSummary();
    }

    Message emsg = new Message();
    String[] to = new String[]{recipient};

    CalSvcI svci = form.getCalSvcI();

    emsg.setMailTo(to);
    emsg.setSubject(ev.getSummary());

    IcalTranslator trans = new IcalTranslator(svci.getIcalCallback(), debug);

    mailMessage(emsg, trans.toStringIcal(ev), "event.ics", "text/calendar", form);

    form.getMsg().emit("org.bedework.client.message.event.mailed");

    return "success";
  }

  /** Mail a message to somebody.
   *
   * <p>All required message fields are set. The message will be mailed via
   * the system dependent mailer. If the Object is non-null it will be
   * converted to the appropriate external form and sent as an attachment.
   *
   * @param val      Message to mail
   * @param att      String val to attach - e.g event, todo
   * @param name     name for attachment
   * @param type     mimetype for attachment
   */
  private void mailMessage(Message val,
                           String att,
                           String name,
                           String type,
                           BwActionForm form) throws Throwable {
    ObjectAttachment oa = new ObjectAttachment();

    oa.setOriginalName(name);
    oa.setVal(att);
    oa.setMimeType(type);

    val.addAttachment(oa);

    if (val.getFrom() == null) {
      // This should be a property
      val.setFrom("donotreply-" + form.getCalSvcI().getSysid());
    }

    form.getMailer().post(val);
  }
}
