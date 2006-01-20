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

package org.bedework.timers;

import org.bedework.calfacade.BwAlarm;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAlarm;
import org.bedework.calfacade.BwTodo;
import org.bedework.calfacade.BwTodoAlarm;
import org.bedework.calsvci.CalSvcI;
import org.bedework.icalendar.IcalTranslator;
import org.bedework.mail.MailerIntf;
import org.bedework.mail.MailUtil;
import org.bedework.mail.Message;

import java.util.TimerTask;

import org.apache.log4j.Logger;

/** An alarm task for the Timers implementation.
 *
 * @author Mike Douglass     doulgm@rpi.edu
 */
class AlarmTask extends TimerTask {
  private boolean debug;
  private BwAlarm alarm;
  private CallBack cb;

  private transient Logger log;

  interface CallBack {
    /**
     * @return svci object
     */
    CalSvcI getSvci();

    /**
     * @return a mailer
     */
    MailerIntf getMailer();

    /**
     * @param task
     */
    void expired(AlarmTask task);

    /**
     * @param task
     * @throws Throwable
     */
    void reSchedule(AlarmTask task) throws Throwable;
  }

  AlarmTask(CallBack cb, BwAlarm val, boolean debug) {
    this.cb = cb;
    alarm = val;
    this.debug = debug;
  }

  /**
   * @return BwAlarm
   */
  public BwAlarm getAlarm() {
    return alarm;
  }

  public void run() {
    try {
      sendNotification();

      /* Update the alarm - if we're done cancel it */
      String duration = alarm.getDuration();
      boolean expireAlarm = true;
      if (duration != null) {
        int repCt = alarm.getRepeatCount() + 1;

        if (repCt <= alarm.getRepeat()) {
          // Another repeat
          expireAlarm = false;

          alarm.setRepeatCount(repCt);
        }
      }

      if (expireAlarm) {
        alarm.setExpired(true);
      }

      CalSvcI svci = cb.getSvci();

      svci.open();
      svci.beginTransaction();
      svci.updateAlarm(alarm);
      svci.endTransaction();

      if (expireAlarm) {
        cb.expired(this);
      } else {
        cb.reSchedule(this);
      }
    } catch (Throwable t) {
      /* Now what do we do. We could stop - leaving an alarm that has not
         been sent.
       */
      error(t);
    } finally {
      if (cb.getSvci().isOpen()) {
        try {
          cb.getSvci().close();
        } catch (Throwable t) {}
      }
    }
  }

  /**
   * @throws Throwable
   */
  public void sendNotification() throws Throwable {
    int atype = alarm.getAlarmType();

    if (atype == BwAlarm.alarmTypeEmail) {
      if (debug) {
        trace("Send email(s) to " + alarm.getAttendees());
      }

      Message msg = new Message();
      BwEvent ev = null;
      IcalTranslator trans = new IcalTranslator(cb.getSvci().getIcalCallback(), debug);

      msg.setMailTo(alarm.getAttendeeEmailList());
      msg.setSubject(alarm.getSummary());

      String desc = alarm.getDescription();
      if (desc == null) {
        if (alarm instanceof BwEventAlarm) {
          BwEventAlarm evalarm = (BwEventAlarm)alarm;
          ev = evalarm.getEvent();

          desc = MailUtil.displayableEvent(ev).toString();
        } else {
          BwTodoAlarm tdalarm = (BwTodoAlarm)alarm;
          BwTodo todo = tdalarm.getTodo();

        }
      }

      msg.setContent(desc);

      String att;
      String name;

      if (ev != null) {
        att = trans.toStringIcal(ev);
        name = "event.ics";
      } else {
        att = null;
        name = "todo.ics";
      }

      CalSvcI svci = cb.getSvci();

      try {
        svci.open();
        svci.beginTransaction();
        MailUtil.mailMessage(cb.getMailer(), msg, att, name, "text/calendar",
                             cb.getSvci().getSysid());
        svci.endTransaction();
      } catch (Throwable t) {
        error(t);
      } finally {
        if (svci.isOpen()) {
          try {
            svci.close();
          } catch (Throwable t) {}
        }
      }
    }
  }

  /** Get a logger for messages
   */
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void error(Throwable t) {
    getLogger().error(this, t);
  }

  protected void trace(String msg) {
    getLogger().debug(msg);
  }
}
