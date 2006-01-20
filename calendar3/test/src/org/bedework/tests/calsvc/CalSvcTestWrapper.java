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

package org.bedework.tests.calsvc;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calsvc.CalSvc;
import org.bedework.calsvci.CalSvcIPars;

import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.property.Created;
import net.fortuna.ical4j.model.property.DtStamp;
import net.fortuna.ical4j.model.property.LastModified;

/** Conveneience classes for test suite
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class CalSvcTestWrapper extends CalSvc {
  boolean isPublic;
  String user;

  /* for public set to a calendar we create to hold created events.
   */
  BwCalendar publicCal;

  //private boolean debug = true;

  /**
   * @param user
   * @param access
   * @param publicEvents
   * @param debug
   * @throws Throwable
   */
  public CalSvcTestWrapper(String user,
                           int access,
                           boolean publicEvents,
                           boolean debug) throws Throwable {
    super();
    //this.debug = debug;
    isPublic = publicEvents;
    this.user = user;

    CalSvcIPars pars = new CalSvcIPars(user, access, user, publicEvents,
                                       false,    // caldav
                                       null, // synch
                                       debug);
    init(pars);
  }

  /**
   * @throws Throwable
   */
  public void openFlushed() throws Throwable {
    flushAll();
    open();
    beginTransaction();
  }

  /**
   * @throws Throwable
   */
  public void openIt() throws Throwable {
    open();
    beginTransaction();
  }

  /**
   * @throws Throwable
   */
  public void closeIt() throws Throwable {
    endTransaction();
    close();
  }

  /**
   * @throws Throwable
   */
  public void closeFlushAll() throws Throwable {
    endTransaction();
    close();
    flushAll();
  }

  /* ====================================================================
   *                       location methods.
   * ==================================================================== */

  /** Add a single location for later use
   *
   * @param address
   * @param subaddress
   * @param link
   * @param creator
   * @return int  key of first added (remainder should follow)
   * @throws Throwable
   */
  public int addLocation(String address,
                         String subaddress,
                         String link,
                         BwUser creator) throws Throwable {
    BwLocation loc = new BwLocation(creator,
                                    isPublic,
                                    creator,
                                    null,
                                    address,
                                    subaddress,
                                    link);
    addLocation(loc);

    return loc.getId();
  }

  /* ====================================================================
   *                       sponsor methods.
   * ==================================================================== */

  /** Add a single sponsor for later use
   *
   * @param name
   * @param phone
   * @param email
   * @param link
   * @param creator
   * @return int  key of first added (remainder should follow)
   * @throws Throwable
   */
  public int addSponsor(String name,
                        String phone,
                        String email,
                        String link,
                        BwUser creator) throws Throwable {
    BwSponsor sp = new BwSponsor(creator,
                                 isPublic,
                                 creator,
                                 null,
                                 name,
                                 phone,
                                 email,
                                 link);

    addSponsor(sp);

    return sp.getId();
  }

  /* ====================================================================
   *                       category methods.
   * ==================================================================== */

  /** Add a single category for later use
   *
   * @param word
   * @param description
   * @param creator
   * @return int  key of first added (remainder should follow)
   * @throws Throwable
   */
  public int addCategory(String word,
                         String description,
                         BwUser creator) throws Throwable {
    BwCategory key = new BwCategory(creator,
                                    isPublic,
                                    creator,
                                    null,
                                    word,
                                    description);

    addCategory(key);

    return key.getId();
  }

  /** Find a category
   *
   * @param wd             String word
   * @return BwCategory    or null for failure
   * @throws Throwable
   */
  public BwCategory getCategory(String wd) throws Throwable {
    BwCategory par = new BwCategory();
    par.setWord(wd);
    BwCategory obj = findCategory(par);

    return obj;
  }

  /* ====================================================================
   *                       calendar methods.
   * ==================================================================== */

  /** get a single calendar for an event
   *
   * @return BwCalendar  added object
   * @throws Throwable
   */
  public BwCalendar getCalendar() throws Throwable {
    if (!isPublic) {
      return getDefaultCalendar();
    }

    if (publicCal != null) {
      return publicCal;
    }

    String calName = "Test public calendar";

    BwCalendar root = getPublicCalendars();

    // See if we already created the test calendar earler

    publicCal = getCalendar(root.getPath() + "/" + calName);

    if (publicCal != null) {
      return publicCal;
    }

    publicCal = new BwCalendar();
    publicCal.setName(calName);
    publicCal.setPublick(true);
    publicCal.setCalendarCollection(true);

    addCalendar(publicCal, root);

    return publicCal;
  }

  /* ====================================================================
   *                       event methods.
   * ==================================================================== */

  /** Add a single event for later use. Dates should be of form
   * yyyy-MM-dd HH:mm:ss
   *
   * @param sdesc
   * @param ldesc
   * @param sdatetime
   * @param edatetime
   * @param loc
   * @param sp
   * @param key
   * @param link
   * @param creator
   * @return int  key of new entity
   * @throws Throwable
   */
  public int addEvent(String sdesc,
                      String ldesc,
                      String sdatetime,
                      String edatetime,
                      BwLocation loc,
                      BwSponsor sp,
                      BwCategory key,
                      String link,
                      String creator) throws Throwable {
    BwEvent ev = new BwEventObj(null,    //new UserVO(owner),
                                false,   // publick
                                null,    //new UserVO(creator),
                                null,    // access
                                sdesc,
                                ldesc,
                                null,
                                null,
                                link,
                                "free",
                                null,    // organizer
                                loc,
                                sp,
                                null,    // guid
                                null,    // transparency
                                null,    // dtstamp
                                null,    // lastmod
                                null,    // created
                                0,
                                0,
                                null);

    BwDateTime stdt = CalFacadeUtil.getDateTime(sdatetime, getTimezones());
    BwDateTime edt = CalFacadeUtil.getDateTime(edatetime, getTimezones());

    ev.setDtstart(stdt);
    ev.setDtend(edt);

    ev.setDtstamp(new DtStamp(new DateTime(true)).getValue());
    ev.setLastmod(new LastModified(new DateTime(true)).getValue());
    ev.setCreated(new Created(new DateTime(true)).getValue());

    if (key != null) {
      ev.addCategory(key);
    }

    if (ev.getCalendar() == null) {
      log("About to set event calendar for user " + user +
          " public = " + isPublic);
      ev.setCalendar(getCalendar());
      log("Set event calendar to " + ev.getCalendar());
    }

    addEvent(ev, null);

    return ev.getId();
  }

  /** Add an event for later use
   *
   * @param n         int number of event (to flag descriptions)
   * @param loc       location  - null for no location
   * @param sp        sponsor  - null for no sponsor
   * @param desc      some identifying text
   * @return int      key of added event
   * @throws Throwable
   */
  public int addEvent(int n, BwLocation loc, BwSponsor sp,
                      String desc) throws Throwable {
    return addEvent("Dummy event " + n,
                     "Dummy event description "  + n + ": " + desc,
                     "20040506T130000",
                     "20040506T140000",
                     loc,
                     sp,
                     null,
                     "http://dummy.link" + n + ".edu",
                     user);
  }

  protected void log(String msg) {
    System.out.println(this.getClass().getName() + ": " + msg);
  }
}
