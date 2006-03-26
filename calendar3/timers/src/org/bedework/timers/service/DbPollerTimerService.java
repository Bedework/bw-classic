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

package org.bedework.timers.service;

import org.bedework.calsvc.CalSvc;
import org.bedework.calsvci.CalSvcI;
import org.bedework.calsvci.CalSvcIPars;
import org.bedework.timers.Timers;

import org.apache.log4j.Logger;

/** Simple implementation of a timer service for the calendar.
 * This task fetches twice the poll interval of timed events (alarms etc)
 * waits for the poll interval, then cancels them all and does it again.
 *
 * <p>The poll interval is the minimum time somebody willhave to wait to see
 * an alarm. And, yes, there are probably better ways to do this.
 *
 * @author  Mike Douglass douglm@rpi.edu
 */
public class DbPollerTimerService {
  private boolean debug;

  private CalSvcI svci;

  // Time in seconds.
  private long timeInterval = 5 * 60;

  private String account = "caladmin";

  private transient Logger log;

  /**
   * @param args
   */
  public static void main(String[] args) {
    try {
      DbPollerTimerService ts = new DbPollerTimerService();

      ts.processArgs(args);

      ts.init();

      ts.start();
    } catch (Throwable t) {
      t.printStackTrace();
      System.exit(-1);
    }
  }

  void processArgs(String[] args) throws Throwable {
    if (args == null) {
      return;
    }

    for (int i = 0; i < args.length; i++) {
      if (args[i].equals("-debug")) {
        debug = true;
      } else if (args[i].equals("-ndebug")) {
        debug = false;
      } else if (args[i].equals("-noarg")) {
      } else if (argpar("--interval", args, i)) {
        i++;
        timeInterval = Integer.parseInt(args[i]);
      } else if (argpar("-i", args, i)) {
        i++;
        account = args[i];
      } else {
        error("Illegal argument: " + args[i]);
        throw new Exception("Invalid args");
      }
    }
  }

  boolean argpar(String n, String[] args, int i) throws Exception {
    if (!args[i].equals(n)) {
      return false;
    }

    if ((i + 1) == args.length) {
      throw new Exception("Invalid args");
    }
    return true;
  }

  private void init() throws Throwable {
    svci = new CalSvc();
    CalSvcIPars pars = new CalSvcIPars(account, 
                                       account,
                                       null,   // XXX needs envPrefix
                                       true,    // public
                                       false,    // caldav
                                       null, // synchId
                                       debug);
    svci.init(pars);
  }

  private void start() throws Throwable {
    /* Fire a timer service up to retrieve twice our interval of alarms.
       Every interval seconds wake up and cancel it and then redo.
     */

    long fetchInterval = timeInterval * 2;

    for (;;) {
      Timers tmr = new Timers(svci, fetchInterval, debug);

      try {
        Thread.sleep(timeInterval * 1000);
      } finally {
        tmr.close();
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

  protected void trace(String msg) {
    getLogger().debug(msg);
  }

  protected void debugMsg(String msg) {
    getLogger().debug(msg);
  }

  protected void log(String msg) {
    getLogger().info(msg);
  }

  protected void error(String msg) {
    getLogger().error(msg);
  }
}

