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

import org.bedework.calenv.CalEnv;
import org.bedework.calfacade.BwAlarm;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calsvci.CalSvcI;
import org.bedework.mail.MailerIntf;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Timer;

import org.apache.log4j.Logger;

/** A class which schedules timers for a timed events service. At startup
 * all timeable events, e.g. alarms, are retrieved and queued. This service
 * may be invoked for a single user or for all users.
 *
 * <p>We include a time period for the retrieval. This should be longer than
 * the update period. This time interval serves toreduce the number of alarms
 * we set.
 *
 * <p>Calls on addXXX methods will queue the supplied events.
 *
 * <p>Calls on update will result in an attempt to update the list from the
 * database.
 *
 * @author Mike Douglass     doulgm@rpi.edu
 */
public class Timers {
  private boolean debug;
  private CalSvcI svci;
  private BwUser user;

  /* Seconds */
  //private long timeInterval = 60;

  private Timer timer;

  /* Possibly large collection of alarms.
   */
  Collection alarms;

  /** So we can locate the queued alarm
   */
  private HashMap tasks = new HashMap();

  private transient Logger log;

  private AlarmTask.CallBack cb;

  private class TimersCallBack implements AlarmTask.CallBack {
    private MailerIntf mailer;

    public CalSvcI getSvci() {
      return svci;
    }

    public MailerIntf getMailer() {
      if (mailer != null) {
        return mailer;
      }

      try {
        mailer = (MailerIntf)CalEnv.getGlobalObject("mailerclass",
                                                    MailerIntf.class);
        mailer.init(svci, debug);
      } catch (Throwable t) {
        error(t);
      }

      return mailer;
    }

    public void expired(AlarmTask task) {
      tasks.remove(new Integer(task.getAlarm().getId()));
    }

    public void reSchedule(AlarmTask task) throws Throwable {
      addAlarm(task.getAlarm());
    }
  }

  /** Setup timers for all users.
   *
   * @param svci            CalSvcI object
   * @param timeInterval    Get all unexpired alarms before this time
   * @param debug           trun on/off debugging
   * @throws CalFacadeException
   */
  public Timers(CalSvcI svci, long timeInterval,
                boolean debug) throws CalFacadeException {
    this(svci, timeInterval, null, debug);
  }

  /** Setup timers for given user.
   *
   * @param svci            CalSvcI object
   * @param timeInterval    Get all unexpired alarms before this time
   * @param user            User who's timers we should set.
   * @param debug           trun on/off debugging
   * @throws CalFacadeException
   */
  public Timers(CalSvcI svci, long timeInterval,
                BwUser user, boolean debug) throws CalFacadeException {
    this.svci = svci;
    //this.timeInterval = timeInterval;
    this.user = user;
    this.debug = debug;

    cb = new TimersCallBack();

    timer = new Timer();
    Collection alarms = null;

    try {
      svci.open();
      svci.beginTransaction();
      alarms = svci.getUnexpiredAlarms(user,
            System.currentTimeMillis() + (timeInterval * 1000));
      svci.endTransaction();
    } finally {
      svci.close();
    }

    if (alarms == null) {
      log("No alarms found");
      return;
    }

    log("Processing " + alarms.size() + " alarms");

    Iterator it = alarms.iterator();
    while (it.hasNext()) {
      addAlarm((BwAlarm)it.next());
    }
  }

  /**
   * @param val
   * @throws CalFacadeException
   */
  public void addAlarm(BwAlarm val) throws CalFacadeException {
    if (debug) {
      trace("Adding alarm " + val);
    }

    if (user == null) {
      /* We can only handle email alarms here */
      if (val.getAlarmType() != BwAlarm.alarmTypeEmail) {
        if (debug) {
          trace("Ignoring non email alarm");
        }

        return;
      }
    }

    AlarmTask atsk = new AlarmTask(cb, val, debug);
    tasks.put(new Integer(val.getId()), atsk);

    /* TODO
       Ensure the recipient gets at least one notification even if we passed
       the time because we weren't running - or whatever
       */

    timer.schedule(atsk, val.getNextTriggerDate());
  }

  /**
   *
   */
  public void close() {
    if (timer != null) {
      timer.cancel();
    }
  }

  /* Get a logger for messages
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

  protected void warn(String msg) {
    getLogger().warn(msg);
  }

  protected void log(String msg) {
    getLogger().info(msg);
  }

  protected void trace(String msg) {
    getLogger().debug(msg);
  }
}

