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

import org.bedework.calfacade.BwAlarm;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAlarm;
import org.bedework.calsvci.CalSvcI;

import edu.rpi.sss.util.Util;

import javax.servlet.http.HttpServletRequest;
import net.fortuna.ical4j.model.parameter.Related;
import net.fortuna.ical4j.model.ParameterList;
import net.fortuna.ical4j.model.property.Trigger;

/**
 * Action to set an alarm.
 * <p>No request parameters (other than updates to email and subject)
 * <p>Forwards to:<ul>
 *      <li>"retry"        email options still not valid.</li>
 *      <li>"noEvent"      no event was selected.</li>
 *      <li>"expired"      Event has already taken place.</li>
 *      <li>"success"      mailed (or queued) ok.</li>
 * </ul>
 */
public class BwSetAlarmAction extends BwCalAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webclient.BwCalAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webclient.BwActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwActionForm form) throws Throwable {
    BwEvent ev = form.retrieveCurrentEvent();

    if (ev == null) {
      return "noevent";
    }

    CalSvcI svci = form.fetchSvci();

    BwEventAlarm alarm = new BwEventAlarm();

    Trigger tr;
    //boolean trDuration = false;

    if (form.getAlarmTriggerByDate()) {
      /*XXX this needs changing */
      throw new Exception("Unimplemented");
//      tr = new Trigger(form.getTriggerDateTime().getDateTime());
    } else {
      //trDuration = true;

      Related rel;
      if (form.getAlarmRelStart()) {
        rel = Related.START;
      } else {
        rel = Related.END;
      }
      ParameterList plist = new ParameterList();
      plist.add(rel);
      tr = new Trigger(plist, form.getTriggerDuration().toString());
      tr.setValue(form.getTriggerDuration().toString());
    }

    String recipient = form.getLastEmail();
    if (!Util.present(recipient)) {
      form.getErr().emit("org.bedework.client.error.mail.norecipient", 1);
      return "retry";
    }

    String subject = form.getLastSubject();
    if (!Util.present(subject)) {
      subject = ev.getSummary();
    }

    /* temporarily just fix the alarm time as 5 mins before the associated event.
     * start. We need to add options for start or end time, period, how often etc.
     */

    alarm.setAlarmType(BwAlarm.alarmTypeEmail);
    alarm.setTrigger(tr.getValue());
    alarm.setTriggerStart(true);
    alarm.setSummary(subject);
    alarm.setDescription(ev.getDescription());

    alarm.addAttendeeEmail("MAILTO:" + recipient);

    svci.setAlarm(ev, alarm);

    form.getMsg().emit("org.bedework.client.message.eventalarmset");

    return "success";
  }
}
