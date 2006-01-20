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

package org.bedework.tests.synchml;

import edu.rpi.cct.uwcal.common.URIgen;
import edu.rpi.cct.uwcal.synchml.common.IcalSynchState;
import edu.rpi.cct.uwcal.synchml.common.Synchml;

import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.calsvci.CalSvcI;
import org.bedework.icalendar.IcalTranslator;
import org.bedework.tests.calsvc.CalSvcTestUtil;
import org.bedework.tests.calsvc.CalSvcTestWrapper;
import org.bedework.webcommon.BwWebURIgen;

import net.fortuna.ical4j.model.component.VEvent;

import java.util.Collection;
import java.util.Iterator;

/** Stand alone package to drive the synchronization interface. This can
 * set up the database in a known state in preparation for tests then run
 * some basic tests and check the end state.
 *
 * <p>We'd probably do better to drive a subset of the junit test suite.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class TestSynchml {
  private boolean debug = true;

  /** If true we (re)initialise the db by adding some specific events for
   * a known set of users.
   */
  private boolean initdb = false;

  /** if true we run a set of tests on the data. Implies initdb.
   *
   * <p>Use -runtest -noinitdb to prevent reinitialisation of the data.
   */
  private boolean runtest = false;

  private String deviceId1 = "SynchTest1";

  private String deviceId2 = "SynchTest2";

  private URIgen urigen;

  private Synchml synch;

  /* data for the public calendar
   */
  private static String publicOwner = "caladmin";

  private static final int numPublicEvents = 10;

  /** There are numPublicEvents of each of these starting with this id
   */
  private int firstPublicLoc;
  private int firstPublicSp;
  private int firstPublicEvent;

  /* data for the private calendar
   */
  private static String privateUser = "caluser";

  private int firstPrivateEvent;
  private int numPrivateEvents;

  private int firstReffedEvent;

  private static String[] userCalText = {
    "BEGIN:VCALENDAR",
    "PRODID:-//Jahia Solutions//iCalendar SyncClient 1.0 MIMEDIR//EN",
    "VERSION:2.0",
    "METHOD:PUBLISH",
    "BEGIN:VEVENT",
    "DTSTART;VALUE=DATE:20050116",
    "DTEND;VALUE=DATE:20050116",
    "SUMMARY:Dummy SyncItem 0 (data0)",
    "UID:DUMMY-SYNC-ITEM-20-FOR-TESTING",
    "DTSTAMP:20040707T140415Z",
    "END:VEVENT",
    "BEGIN:VEVENT",
    "DTSTART;VALUE=DATE:20050116",
    "DTEND;VALUE=DATE:20050116",
    "SUMMARY:Dummy SyncItem 1 (data1)",
    "UID:DUMMY-SYNC-ITEM-20-FOR-TESTING",
    "DTSTAMP:20040707T140415Z",
    "END:VEVENT",
    "BEGIN:VEVENT",
    "DTSTART;VALUE=DATE:20050217",
    "DTEND;VALUE=DATE:20050218",
    "SUMMARY:Dummy SyncItem 2 (data2)",
    "UID:DUMMY-SYNC-ITEM-30-FOR-TESTING",
    "DTSTAMP:20040707T140415Z",
    "END:VEVENT",
    "BEGIN:VEVENT",
    "DTSTART;VALUE=DATE:20050215",
    "DTEND;VALUE=DATE:20050216",
    "SUMMARY:Dummy SyncItem 3 (data3)",
    "UID:9DE4B99A-D020-11D8-9530-000A958A3252",
    "DTSTAMP:20040707T140415Z",
    "END:VEVENT",
    "END:VCALENDAR",
  };

  private BwCategory concertKey;
  private BwCategory forumsKey;

  /* -------------------------- Admin (public) stuff        ---------------*/

  private CalSvcTestUtil svciUtil;

  //private static String adminUser = "caladmin";

  /** Called after parameters are set
   */
  public void testSynch() {
    String state = "";

    try {
      urigen = new BwWebURIgen("http://cal.rpi.edu");

      if (initdb) {
        state = "initdb";

        doInitdb();
      }

      if (runtest) {
        state = "runtest";

        doRuntest();
      }
    } catch (Throwable t) {
      log("Exception: state=" + state);
      t.printStackTrace();
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
      } else if (args[i].equals("-initdb")) {
        initdb = true;
      } else if (args[i].equals("-noinitdb")) {
        initdb = false;
      } else if (args[i].equals("-runtest")) {
        runtest = true;
        initdb = true;
      } else {
        log("Illegal argument: " + args[i]);
        usage();
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

  /**
   * @param args
   */
  public static void main(String[] args) {
    TestSynchml st = null;

    try {
      st = new TestSynchml();

      st.processArgs(args);

      st.testSynch();
    } catch (Throwable t) {
      t.printStackTrace();
    } finally {
      try {
//        d.close();
      } catch (Throwable t1) {
        t1.printStackTrace();
      }
    }
  }

  /* ====================================================================
   *                       Private methods.
   * ==================================================================== */

  private void usage() {
    log("Usage:");
    log("  -[n]debug     set debugging on [off]");
    log("  -initdb       set some initial data in the db");
    log("  -runtest      run some tests - implies initdb.");
    log("                Use -runtest -noinitdb to prevent reinitialisation of the data.");
    log("");
  }

  /* ====================================================================
   *                       Private location methods.
   * ==================================================================== */

  /** Add a bunch of locations for later use
   *
   * @param n     int number of locations
   * @return int  key of first added (remainder should follow)
   */
  private int addLocations(int n,
                            boolean isPublic) throws Throwable {
    int first = -1;
    String user;

    if (isPublic) {
      user = publicOwner;
    } else {
      user = privateUser;
    }

    for (int i = 1; i <= n; i++) {
      int key = svciUtil.addLocation(svciUtil.getSvci(user),
                                     "Dummy location address " + i,
                                     "Dummy location subaddress " + i,
                                     "http://dummy.link" + i + ".edu",
                                     svciUtil.getSvci(user).findUser(user));

      if (key < 0) {
        // failure
        return key;
      }

      if (first < 0) {
        first = key;
      }
    }

    return first;
  }

  /* ====================================================================
   *                       Private sponsor methods.
   * ==================================================================== */

  /** Add a bunch of sponsors for later use
   *
   * @param n     int number of sponsors
   * @return int  key of first added (remainder should follow)
   */
  private int addSponsors(int n,
                          boolean isPublic) throws Throwable {
    int first = -1;
    String user;

    if (isPublic) {
      user = publicOwner;
    } else {
      user = privateUser;
    }

    for (int i = 1; i <= n; i++) {
      int key = svciUtil.addSponsor(svciUtil.getSvci(user),
                                    "Dummy sponsor name " + i,
                                    "Dummy sponsor phone " + i,
                                    "Dummy sponsor email " + i,
                                    "http://dummy.link" + i + ".edu",
                                    svciUtil.getSvci(user).findUser(user));

      if (key < 0) {
        // failure
        return key;
      }

      if (first < 0) {
        first = key;
      }
    }

    return first;
  }

  /* ====================================================================
   *                       Private category methods.
   * ==================================================================== */

  /* Add a bunch of categories for later use
   *
   * @param n     int number of sponsors
   * @param isPublic
   * @return int  key of first added (remainder should follow)
   * /
  private int addCategories(int n, boolean isPublic) {
    int first = -1;
    String user;

    if (isPublic) {
      user = publicOwner;
    } else {
      user = privateUser;
    }

    for (int i = 1; i <= n; i++) {
      int key = svciUtil.addCategory(svciUtil.getSvci(user),
                                     "Dummy category " + i,
                                    "Dummy category description " + i,
                                    user);

      if (key < 0) {
        // failure
        return key;
      }

      if (first < 0) {
        first = key;
      }
    }

    return first;
  } */

  private void addCalendars() throws Throwable {
    /* XXX FIX FIX FIX
    CalSvcI svci = svciUtil.getSvci(publicOwner);

    BwFilter filterRoot = new BwOrFilter(2, "Main Calendars", null);

    svciUtil.open(publicOwner);
    svci.addFilter(filterRoot);
    svciUtil.close(publicOwner);

    BwFilter filterArts = new BwOrFilter(110, "Arts (all)", filterRoot);
    BwFilter filterMeetings =
        new BwOrFilter(120, "Conferences/Meetings (all)", filterRoot);

    svciUtil.open(publicOwner);
    filterRoot.addChild(filterArts);
    filterRoot.addChild(filterMeetings);
    svci.addFilter(filterArts);
    svci.addFilter(filterMeetings);
    svci.updateFilter(filterRoot);
    svciUtil.close(publicOwner);

    BwCategoryFilter filterConcerts =
        new BwCategoryFilter(1400, "Concerts", filterArts, concertKey);

    BwCategoryFilter filterForums =
        new BwCategoryFilter(2200, "Forums", filterMeetings, forumsKey);

    svciUtil.open(publicOwner);
    svci.addFilter(filterConcerts);
    filterArts.addChild(filterConcerts);
    svci.updateFilter(filterArts);
    svciUtil.close(publicOwner);

    svciUtil.open(publicOwner);
    svci.addFilter(filterForums);
    filterMeetings.addChild(filterForums);
    svci.updateFilter(filterMeetings);
    svciUtil.close(publicOwner);
    */
  }

  /* ====================================================================
   *                       Private event methods.
   * ==================================================================== */

  /** Add a bunch of events for later use
   *
   * @param n         int number of events
   * @param locn      int first location id
   * @param spn       int first sponsor id
   * @param isPublic  true to create public events
   * @return int      key of first added (remainder should follow)
   */
  private int addEvents(int n, int locn, int spn,
                        boolean isPublic) throws Throwable {
    int first = -1;
    String user;

    if (isPublic) {
      user = publicOwner;
    } else {
      user = privateUser;
    }

    for (int i = 1; i <= n; i++) {
      BwCategory keywd;
      if (i < 3) {
        keywd = concertKey;
      } else {
        keywd = forumsKey;
      }

      CalSvcTestWrapper svci = svciUtil.getSvci(user);

      int key = svciUtil.addEvent(svci,
                                  "Dummy event " + i,
                                  "Dummy event description " + i,
                                  "20050206T130000",
                                  "20050206T140000",
                                  svciUtil.getLocation(svci, locn - 1 + i, true),
                                  svciUtil.getSponsor(svci, spn - 1 + i, true),
                                  keywd,
                                  "http://dummy.link" + i + ".edu",
                                  user);

      if (key < 0) {
        // failure
        return key;
      }

      if (first < 0) {
        first = key;
      }
    }

    return first;
  }

  private void updatePublic(int evid) throws Throwable {
    logResult("updatePublic event " + evid);

    CalSvcI svci = svciUtil.getSvci(publicOwner, UserAuth.superUser, true);
    svciUtil.open(publicOwner);

    BwEvent ev = getEvent(svci, evid);
    ev.setDescription(String.valueOf(ev.getDescription()) + "X");
    svci.updateEvent(ev);

    svciUtil.close(publicOwner);
  }

  /*
  private void updatePublicSynch(int evid) throws Throwable {
    logResult("updatePublicSynch event " + evid);

    CalSvcI svci = svciUtil.getSvci(publicOwner, UserAuth.superUser, true);
    svciUtil.open(publicOwner);

    BwEvent ev = getEvent(svci, evid);
    ev.setDescription(String.valueOf(ev.getDescription()) + "X");
    svci.updateEvent(ev);

    svciUtil.close(publicOwner);
  }
  */

  private void addRef(int evid) throws Throwable {
    logResult("addRef for event " + evid);

    CalSvcI svci = svciUtil.getSvci(privateUser, 0, false);
    svciUtil.open(privateUser);

    BwEvent ev = getEvent(svci, evid);

    /* Create an event to act as a reference tothe targeted event and copy
     * the appropriate fields from the target
     */
    BwEvent ref = new BwEvent();

    ref.setDtstart(ev.getDtstart());
    ref.setDtend(ev.getDtend());
    ref.setEndType(ev.getEndType());
    ref.setDuration(ev.getDuration());

    svci.addEvent(ev);

    svciUtil.close(privateUser);
  }

  private void deleteRef(int evid) throws Throwable {
    logResult("deleteRef for event " + evid);

    CalSvcI svci = svciUtil.getSvci(privateUser, 0, false);
    svciUtil.open(privateUser);

    BwEvent ev = getEvent(svci, evid);
    svci.deleteEvent(ev, true);

    svciUtil.close(privateUser);
  }

  /** Add an event to the db for the current user. We will get a guid and
   * merge the new guid into the supplied data
   *
   * @param  calText    String icalendar format events
   */
  private void addEvents(String[] calText) throws Throwable {
    StringBuffer sb = new StringBuffer();
    firstPrivateEvent = -1;
    String guid = null;

    for (int i = 0; i < calText.length; i++) {
      String ln = calText[i];

      sb.append(ln);
      sb.append("\r\n");
    }

    IcalTranslator trans = synch.getTranslator();

    Collection vevs = trans.toVEvent(sb.toString());

    Iterator it = vevs.iterator();

    while (it.hasNext()) {
      guid = synch.getNewGuid();
      log("Obtained new guid: " + guid);

      synch.updateEvent((VEvent)it.next(), guid);
      numPrivateEvents++;
    }
  }

  /* ====================================================================
   *                       Private test methods.
   * ==================================================================== */

  private void doInitdb() throws Throwable {
    /* Public stuff first so we can refer to it for private user.
     */
    svciUtil = new CalSvcTestUtil(debug);

    svciUtil.getSvci(publicOwner, UserAuth.superUser, true);

    addMoreData();

    svciUtil.open(publicOwner);

    concertKey = getCategory("Concerts");
    forumsKey = getCategory("Forums");

    svciUtil.close(publicOwner);

    /* Add the calendar defs */
    addCalendars();

    svciUtil.open(publicOwner);

    /* Add a bunch of public locations */
    int numLocs = numPublicEvents;
    firstPublicLoc = addLocations(numLocs, true);

    svciUtil.close(publicOwner);
    svciUtil.open(publicOwner);

    /* Add a bunch of public sponsors */
    int numSps = numPublicEvents;
    firstPublicSp = addSponsors(numSps, true);

    svciUtil.close(publicOwner);
    svciUtil.open(publicOwner);

    /* Add a bunch of public events */
    int numEvs = numPublicEvents;
    firstPublicEvent = addEvents(numEvs, firstPublicLoc, firstPublicSp, true);

    svciUtil.close(publicOwner);

    /* Now private stuff.
     */

    /* get a synch object for the private user.
     */

    getSynch(deviceId1);
    synch.open();
    synch.beginTransaction();

    addEvents(userCalText);
    logResult("Added " + numPrivateEvents + " starting at " + firstPrivateEvent);
    synch.commit();
    synch.close();

    /** Add two event refs */

    firstReffedEvent = firstPublicEvent + 3;
    addRef(firstReffedEvent);

    addRef(firstReffedEvent + 1);

    /* Subscribe to the concerts calendar

       Doesn't work now. Instead we need to:

        find the calendar to subscribe to
        call svci.addSubscription(cal)

    CalSvcI userSvci = svciUtil.getSvci(privateUser, 0, false);
    svciUtil.open(privateUser);

    TreeSet subs = new TreeSet();
    subs.add(new Integer(1400));

    userSvci.fixSubscriptions(subs);
    */

    svciUtil.close(privateUser);

    /* *** temp ... make this a unit test - test checkCategoryRefs indirectly
    svciUtil.open(true);
    svciUtil.getSvci(true).deleteCategory(concertKey);
    svciUtil.close(true);
    */
  }

  private BwCategory getCategory(String wd) throws Throwable {
    return svciUtil.getSvci(publicOwner).getCategory(wd);
  }

  private void addMoreData() throws Throwable {
    svciUtil.open(publicOwner);
    CalSvcTestWrapper svci = svciUtil.getSvci(publicOwner);

    svci.addCategory("Concerts", "Concerts", svci.findUser(publicOwner));
    svci.addCategory("Forums", "Forums", svci.findUser(publicOwner));

    svciUtil.close(publicOwner);
  }

  /** We're set up with:
   *   a number of personal events +
   *       2  events from subscriptions +
   *       2  events from references.
   */
  private void doRuntest() throws Throwable {
    /** A get all from any device should give us numPrivateEvents + 4
       (personal events + 2 subscriptions + 2 references).
     */
    getEvents(deviceId1, true);

    /** A get all from any device should give us numPrivateEvents + 4
       (personal events + 2 subscriptions + 2 references).
     */
    getEvents(deviceId2, true);

    /* Try again - should get nothing */
    getEvents(deviceId1, false);

    /* Modify the public event */
    updatePublic(firstPublicEvent);

    /* Try again - should get one */
    getEvents(deviceId1, false);

    /* Delete the second public event (ref) */
    deleteRef(firstReffedEvent + 1);

    /* Try again - should get a deleted notification */
    getEvents(deviceId1, false);

    /* Try again - should get nothing */
    getEvents(deviceId1, false);

//    /* Delete a subscribed event via synch */
 //   deleteEvent(firstPublicEvent);

    /* Update the public event via synch */
    updatePublicSynch(firstPublicEvent, deviceId1);

    /* Try again - should get nothing */
    getEvents(deviceId1, false);

    /* Try for device 2 - should get the mod and the deleted */
    getEvents(deviceId2, false);

    /* Try again - should get nothing */
    getEvents(deviceId2, false);
  }

  private void getEvents(String dev, boolean all) throws Throwable {
    getSynch(dev);
    synch.open();
    synch.beginTransaction();

    Collection c;
    if (all) {
      c = synch.getAllVevents();
    } else {
      c = synch.getAllChangedVevents();
    }

    logResult("getEvents (all=" + all + ") for " + dev + " returned " + c.size());

    Iterator it = c.iterator();
    while (it.hasNext()) {
      IcalSynchState iss = (IcalSynchState)it.next();

      logResult("Got " + iss);
    }
    synch.commit();
    synch.close();
  }

  private void updatePublicSynch(int evid, String dev) throws Throwable {
    logResult("updatePublicSynch event " + evid);

    CalSvcI svci = svciUtil.getSvci(publicOwner, UserAuth.superUser, true);
    svci.open();

    BwEvent ev = getEvent(svci, evid);

    svci.close();

    getSynch(dev);
    synch.open();
    synch.beginTransaction();

    IcalTranslator trans = synch.getTranslator();

    ev.setDescription(String.valueOf(ev.getDescription()) + "XXXX");
    BwLocation loc = ev.getLocation();
    if (loc != null) {
      loc.setAddress("Synchtest modified value");
    }

    VEvent vev = trans.toIcalEvent(ev);

    synch.updateEvent(vev, ev.getGuid());

    synch.commit();
    synch.close();
  }

  /* ====================================================================
   *                       Misc private methods.
   * ==================================================================== */

  private BwEvent getEvent(CalSvcI svci, int id) throws Throwable {
    EventInfo ei = svci.getEvent(id);
    if (ei == null) {
      return null;
    }

    return ei.getEvent();
  }
  private void getSynch(String devid) throws Throwable {
    synch = new Synchml(privateUser, devid, urigen, debug);
  }

  private void logResult(String msg) {
    log("-----------------------------------------------------------------");
    log("-- " + msg);
    log("-----------------------------------------------------------------");
  }

  private void log(String msg) {
    System.out.println(msg);
  }
}

