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
package org.bedework.tools.dumprestore.restore;

import org.bedework.appcommon.TimeZonesParser;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwPreferences;
import org.bedework.calfacade.svc.BwSubscription;
import org.bedework.calfacade.svc.BwView;
import org.bedework.tools.dumprestore.Defs;
import org.bedework.tools.dumprestore.restore.rules.RestoreRuleSet;

import java.io.FileInputStream;
import java.io.FileReader;
import java.util.Collection;
import java.util.Iterator;

import org.apache.commons.digester.Digester;
import org.apache.commons.digester.RegexMatcher;
import org.apache.commons.digester.RegexRules;
import org.apache.commons.digester.SimpleRegexMatcher;
import org.apache.log4j.Logger;

/** Application to restore from an XML calendar dump..
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class Restore implements Defs {
  private transient Logger log;

  //private boolean concatdesc = false;

  //private boolean printData = false;

  /** The dump file
   */
  private String fileName;

  /* runtime arg -i (id) */
  private String id = "sa";

  /* runtime arg -p (password) */
  private String pw = "";

  /* runtime arg -u  (url) */
  private String url = "jdbc:hsqldb:hsql://localhost:8887";

  /* runtime arg -d  (driver) */
  private String driver = "org.hsqldb.jdbcDriver";

  private int dbType = dbTypeHsql;

  private RestoreGlobals globals = new RestoreGlobals();

  private BwView curView;

  private Digester digester;

  /** ===================================================================
   *                       Constructor
   *  =================================================================== */

  public Restore() {
  }

  /** ===================================================================
   *                       Restore methods
   *  =================================================================== */

  void open() throws Throwable {
    if (globals.rintf == null) {
//      globals.rintf = new JdbcRestore();
      globals.rintf = new HibRestore(globals.debug);
      globals.rintf.init(url, driver, id, pw, dbType, globals);
      globals.rintf.open();
    }

    globals.timezones = new TimezonesImpl(globals.debug,
                                          globals.getPublicUser(),
                                          globals.rintf);
    globals.timezones.setDefaultTimeZoneId(globals.syspars.getTzid());

    if (globals.from2p3px) {
      // System prefs are set up by run time pars

      globals.rintf.restoreSyspars(globals.syspars);
    }

    if (globals.timezonesFilename != null) {
      TimeZonesParser tzp = new TimeZonesParser(
             new FileInputStream(globals.timezonesFilename),
             globals.debug);

      Collection tzis = tzp.getTimeZones();

      Iterator it = tzis.iterator();
      while (it.hasNext()) {
        TimeZonesParser.TimeZoneInfo tzi = (TimeZonesParser.TimeZoneInfo)it.next();

        globals.timezones.saveTimeZone(tzi.tzid, tzi.timezone);
      }
    }
  }

  void close() throws Throwable {
    if (globals.rintf != null) {
      globals.rintf.close();
    }
  }

  void doRestore() throws Throwable {
    digester = new Digester();

    RegexMatcher m = new SimpleRegexMatcher();
    digester.setRules(new RegexRules(m));

    digester.addRuleSet(new RestoreRuleSet(globals));
    digester.parse(new FileReader(fileName));

    if (globals.from2p3px) {
      makePrefs();
      if (globals.rintf != null) {
        globals.rintf.restoreAdminGroup((BwAdminGroup)globals.getSuperGroup());
      }
    }

    error("Need to implement eventrefs fixup");
  }

  void stats() {
    globals.stats();
  }

  /** ===================================================================
   *                 Make prefs for 2.3.2
   *  =================================================================== */

  /** Called to finish off by writing out prefs.
   */
  private void makePrefs() throws Throwable {
    Iterator it = globals.usersTbl.values().iterator();
    int nextId = 1;

    if (globals.publicUser == null) {
      throw new Exception("Public user must be defined");
    }

    while (it.hasNext()) {
      BwUser o = (BwUser)it.next();
      BwPreferences p = new BwPreferences();

      p.setId(nextId);
      nextId++;
      p.setOwner(o);

      if (globals.publicUser.equals(o)) {
        /* Subscribe to all top level collections
         */
        BwCalendar root = globals.publicCalRoot;

        Iterator calit = root.iterateChildren();
        while (calit.hasNext()) {
          BwCalendar cal = (BwCalendar)calit.next();
          addSubscription(p, globals.publicUser, cal, true);
        }
      } else {
        BwCalendar cal = (BwCalendar)globals.defaultCalendars.get(
            new Integer(o.getId()));
        p.setDefaultCalendar(cal);

        // Add default subscription for default calendar.
        BwSubscription sub = BwSubscription.makeSubscription(cal, cal.getName(),
                                                             true, true, false);
        sub.setOwner(o);
        p.addSubscription(sub);

        Collection s = globals.subscriptionsTbl.getCalendarids(o);

        if (s != null) {
          Iterator subit = s.iterator();
          globals.subscribedUsers++;

          while (subit.hasNext()) {
            /* Fixing up calendars for move from 2.3.2. Table value is the
             * id of a calendar
             * Make up a subscription.
             */
            Integer calid = (Integer)subit.next();

            cal = (BwCalendar)globals.filterToCal.get(calid);
            addSubscription(p, o, cal, true);
          }
        }
      }

      if (globals.rintf != null) {
        globals.rintf.restoreUserPrefs(p);
      }
    }
  }

  /** Add a subscription to the current users entry.
   *
   * @param p
   * @param user     BwUser object
   * @param cal      BwCalendar object
   * @param toplevel
   * @throws Throwable
   */
  public void addSubscription(BwPreferences p, BwUser user, BwCalendar cal,
                              boolean toplevel) throws Throwable {
    globals.subscriptions++;
    BwSubscription sub = BwSubscription.makeSubscription(cal, cal.getName(), true, false, false);
    sub.setOwner(user);
    p.addSubscription(sub);
    if (curView == null) {
      // One-shot.
      curView = new BwView();
      curView.setName(cal.getName());
      curView.setOwner(user);
      curView.addSubscription(sub);
      p.addView(curView);
      curView = null;
    } else {
      curView.addSubscription(sub);
    }
  }

  boolean processArgs(String[] args) throws Throwable {
    if (args == null) {
      return true;
    }

    for (int i = 0; i < args.length; i++) {
      if (args[i].equals("-debug")) {
        globals.debug = true;
      } else if (args[i].equals("-ndebug")) {
        globals.debug = false;
      } else if (args[i].equals("-debugentity")) {
        globals.debugEntity = true;
      } else if (args[i].equals("-ndebugentity")) {
        globals.debugEntity = false;
      } else if (args[i].equals("-noarg")) {
        globals.debug = false;
      } else if (argpar("-supergroup", args, i)) {
        i++;
        globals.superGroupName = args[i];
      } else if (argpar("-defaultpubliccal", args, i)) {
        i++;
        globals.defaultPublicCalPath = args[i];
        trace("Setting null event calendars to " + args[i]);
      } else if (argpar("-fixOwner", args, i)) {
        i++;
        globals.fixOwnerAccount = args[i];
      } else if (args[i].equals("-from2p3px")) {
        globals.from2p3px = true;
      } else if (argpar("-d", args, i)) {
        i++;
        driver = args[i];
      } else if (argpar("-i", args, i)) {
        i++;
        id = args[i];
      } else if (argpar("-p", args, i)) {
        i++;
        pw = args[i];
      } else if (argpar("-u", args, i)) {
        i++;
        url = args[i];
      } else if (argpar("-f", args, i)) {
        i++;
        fileName = args[i];
      } else if (argpar("-timezones", args, i)) {
        i++;
        globals.timezonesFilename = args[i];

        /* System parameters */
      } else if (argpar("-sysname", args, i)) {
        i++;
        globals.syspars.setName(args[i]);
      } else if (argpar("-tzid", args, i)) {
        i++;
        globals.syspars.setTzid(args[i]);
      } else if (argpar("-sysid", args, i)) {
        i++;
        globals.syspars.setSystemid(args[i]);
      } else if (argpar("-publiccalroot", args, i)) {
        i++;
        globals.syspars.setPublicCalendarRoot(args[i]);
      } else if (argpar("-usercalroot", args, i)) {
        i++;
        globals.syspars.setUserCalendarRoot(args[i]);
      } else if (argpar("-defusercal", args, i)) {
        i++;
        globals.syspars.setUserDefaultCalendar(args[i]);
      } else if (argpar("-deftrashcal", args, i)) {
        i++;
        globals.syspars.setDefaultTrashCalendar(args[i]);
      } else if (argpar("-definbox", args, i)) {
        i++;
        globals.syspars.setUserInbox(args[i]);
      } else if (argpar("-defoutbox", args, i)) {
        i++;
        globals.syspars.setUserOutbox(args[i]);

      } else if (argpar("-pu", args, i)) {
        i++;
        globals.syspars.setPublicUser(args[i]);

      } else if (argpar("-dirbrowsing-disallowed", args, i)) {
        i++;
        globals.syspars.setDirectoryBrowsingDisallowed("true".equals(args[i]));

      } else if (argpar("-httpconnsperuser", args, i)) {
        i++;
        globals.syspars.setHttpConnectionsPerUser(intPar(args[i]));
      } else if (argpar("-httpconnsperhost", args, i)) {
        i++;
        globals.syspars.setHttpConnectionsPerHost(intPar(args[i]));
      } else if (argpar("-httpconns", args, i)) {
        i++;
        globals.syspars.setHttpConnections(intPar(args[i]));

      } else if (argpar("-userauthClass", args, i)) {
        i++;
        globals.syspars.setUserauthClass(args[i]);
      } else if (argpar("-mailerClass", args, i)) {
        i++;
        globals.syspars.setMailerClass(args[i]);
      } else if (argpar("-admingroupsClass", args, i)) {
        i++;
        globals.syspars.setAdmingroupsClass(args[i]);
      } else if (argpar("-usergroupsClass", args, i)) {
        i++;
        globals.syspars.setUsergroupsClass(args[i]);
      } else {
        error("Illegal argument: " + args[i]);
        usage();
        return false;
      }
    }

    return true;
  }

  private int intPar(String par) throws Throwable {
    return Integer.parseInt(par);
  }

  void usage() {
    System.out.println("Usage:");
    System.out.println("args   -debug");
    System.out.println("       -ndebug");
    System.out.println("       -f filename");
    System.out.println("            define name of input file");
    System.out.println("       -concatdesc");
    System.out.println("            put all event description in one field");
    System.out.println("       -jdbc");
    System.out.println("            Update the database via jdbc");
    System.out.println("       -printdata");
    System.out.println("            print the data before restore");
    System.out.println("");
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

  protected Logger getLog() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void error(String msg) {
    getLog().error(msg);
  }

  protected void trace(String msg) {
    getLog().debug(msg);
  }

  /** Main
   *
   * @param args
   */
  public static void main(String[] args) {
    Restore r = null;

    try {
      r = new Restore();

      if (!r.processArgs(args)) {
        return;
      }

      r.open();

      r.doRestore();

      r.close();

      r.stats();

    } catch (Throwable t) {
      t.printStackTrace();
    } finally {
      try {
        r.close();
      } catch (Throwable t1) {
        t1.printStackTrace();
      }
    }
  }
}

