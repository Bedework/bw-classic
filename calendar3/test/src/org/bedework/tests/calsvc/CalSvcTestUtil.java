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

import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calfacade.util.CalFacadeUtil;
import org.bedework.calsvci.CalSvcI;

import java.util.Hashtable;
import junit.framework.AssertionFailedError;
import junit.framework.TestCase;

import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.property.Created;
import net.fortuna.ical4j.model.property.DtStamp;
import net.fortuna.ical4j.model.property.LastModified;

/** Conveneience classes for test suite
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class CalSvcTestUtil extends TestCase {
  Hashtable svcis = new Hashtable();

  private boolean debug = true;

  /**
   * @param debug
   */
  public CalSvcTestUtil(boolean debug) {
    this.debug = debug;
  }

  /* ====================================================================
   *                       Misc methods.
   * ==================================================================== */

  /**
   * @param user
   * @param access
   * @param publicEvents
   * @return svci
   */
  public CalSvcI getSvci(String user,
                        int access,
                        boolean publicEvents) {
    try {
      CalSvcI svci = getSvci(user);

      if (svci == null) {
        svci = new CalSvcTestWrapper(user, access, publicEvents, debug);

        svcis.put(user, svci);
      }

      return svci;
    } catch (Throwable t) {
      t.printStackTrace();
      fail(t.getMessage());

      return null;
    }
  }

  /**
   * @param user
   * @return svci wrapper
   */
  public CalSvcTestWrapper getSvci(String user) {
    return (CalSvcTestWrapper)svcis.get(user);
  }

  /**
   * @param user
   */
  public void openFlushed(String user) {
    try {
      CalSvcTestWrapper svci = getSvci(user);
      assertNotNull(svci);

      svci.openFlushed();
    } catch (Throwable t) {
      t.printStackTrace();
      fail(t.getMessage());
    }
  }

  /**
   * @param user
   */
  public void open(String user) {
    try {
      CalSvcTestWrapper svci = getSvci(user);
      assertNotNull(svci);

      svci.openIt();
    } catch (Throwable t) {
      t.printStackTrace();
      fail(t.getMessage());
    }
  }

  /**
   * @param user
   */
  public void close(String user) {
    try {
      CalSvcTestWrapper svci = getSvci(user);
      assertNotNull(svci);

      svci.closeIt();
    } catch (Throwable t) {
      t.printStackTrace();
      fail(t.getMessage());
    }
  }

  /**
   * @param user
   */
  public void closeFlushAll(String user) {
    try {
      CalSvcTestWrapper svci = getSvci(user);
      assertNotNull(svci);

      svci.closeFlushAll();
    } catch (Throwable t) {
      t.printStackTrace();
      fail(t.getMessage());
    }
  }

  /* ====================================================================
   *                       location methods.
   * ==================================================================== */

  /** Add a single location for later use
   *
   * @param svci
   * @param address
   * @param subaddress
   * @param link
   * @param creator
   * @return int  key of first added (remainder should follow)
   */
  public int addLocation(CalSvcTestWrapper svci,
                         String address,
                         String subaddress,
                         String link,
                         BwUser creator) {
    try {
      int key = svci.addLocation(address,
                                 subaddress,
                                 link,
                                 creator);
      log("Created location, id=" + key);

      return key;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception adding location");
      return CalFacadeDefs.unsavedItemKey;
    }
  }

  /** Get a location which must exist
   *
   * @param svci
   * @param id           int key of object
   * @return LocationVO  or null for failure
   */
  public BwLocation getLocation(CalSvcTestWrapper svci,
                               int id) {
    return getLocation(svci, id, true);
  }

  /** Get a location which may or may not exist
   *
   * @param svci
   * @param id           int key of object
   * @param mustExist    boolean true if object is required to exist
   * @return LocationVO  or null for failure
   */
  public BwLocation getLocation(CalSvcTestWrapper svci,
                                int id, boolean mustExist) {
    try {
      BwLocation obj = svci.getLocation(id);
      if (mustExist && (obj == null)) {
        fail("Location " + id + " does not exist");
      }

      return obj;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting location: " + id);
      return null;
    }
  }

  /* ====================================================================
   *                       sponsor methods.
   * ==================================================================== */

  /** Add a single sponsor for later use
   *
   * @param svci
   * @param name
   * @param phone
   * @param email
   * @param link
   * @param creator
   * @return int  key of first added (remainder should follow)
   */
  public int addSponsor(CalSvcTestWrapper svci,
                        String name,
                        String phone,
                        String email,
                        String link,
                        BwUser creator) {
    try {
      int key = svci.addSponsor(name,
                                phone,
                                email,
                                link,
                                creator);

      log("Created sponsor, id=" + key);
      return key;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception adding sponsor");
      return CalFacadeDefs.unsavedItemKey;
    }
  }

  /** Get a sponsor which must exist
   *
   * @param svci
   * @param id           int key of object
   * @return LocationVO  or null for failure
   */
  public BwSponsor getSponsor(CalSvcTestWrapper svci,
                              int id) {
    return getSponsor(svci, id, true);
  }

  /** Get a sponsor which may or may not exist
   *
   * @param svci
   * @param id           int key of object
   * @param mustExist    boolean true if object is required to exist
   * @return LocationVO  or null for failure
   */
  public BwSponsor getSponsor(CalSvcTestWrapper svci,
                              int id, boolean mustExist) {
    try {
      BwSponsor obj = svci.getSponsor(id);
      if (mustExist && (obj == null)) {
        fail("Sponsor " + id + " does not exist");
      }

      return obj;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting sponsor: " + id);
      return null;
    }
  }

  /* ====================================================================
   *                       category methods.
   * ==================================================================== */

  /** Add a single category for later use
   *
   * @param svci
   * @param word
   * @param description
   * @param creator
   * @return int  key of first added (remainder should follow)
   */
  public int addCategory(CalSvcTestWrapper svci,
                         String word,
                         String description,
                         BwUser creator) {
    try {
      int key = svci.addCategory(word,
                                 description,
                                 creator);

      log("Created category, id=" + key);
      return key;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception adding category");
      return CalFacadeDefs.unsavedItemKey;
    }
  }

  /** Get a category which must exist
   *
   * @param svci
   * @param id           int key of object
   * @return BwCategory  or null for failure
   */
  public BwCategory getCategory(CalSvcTestWrapper svci, int id) {
    return getCategory(svci, id, true);
  }

  /** Find a category which must exist
   *
   * @param svci
   * @param wd           String word
   * @return BwCategory    or null for failure
   */
  public BwCategory getCategory(CalSvcTestWrapper svci, String wd) {
    try {
      BwCategory obj = svci.getCategory(wd);
      if (obj == null) {
        fail("Category " + wd + " does not exist");
      }

      return obj;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting category: " + wd);
      return null;
    }
  }

  /** Get a category which may or may not exist
   *
   * @param svci
   * @param id           int key of object
   * @param mustExist    boolean true if object is required to exist
   * @return LocationVO  or null for failure
   */
  public BwCategory getCategory(CalSvcTestWrapper svci,
                                int id, boolean mustExist) {
    try {
      BwCategory obj = svci.getCategory(id);
      if (mustExist && (obj == null)) {
        fail("Category " + id + " does not exist");
      }

      return obj;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting category: " + id);
      return null;
    }
  }

  /* ====================================================================
   *                       calendar methods.
   * ==================================================================== * /

  /** Add a single calendar for later use
   *
   * @return BwCalendar  added object
   * /
  public BwCalendar addCalendar(CalSvcTestWrapper svci,
                                String word,
                                String description,
                                String creator) {
    try {
      int key = svci.addCategory(word,
                                 description,
                                 creator);

      log("Created category, id=" + key);
      return key;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception adding category");
      return CalFacadeDefs.unsavedItemKey;
    }
  }*/

  /* ====================================================================
   *                       event methods.
   * ==================================================================== */

  /** Add a single event for later use. Dates should be of form
   * yyyy-MM-dd HH:mm:ss
   *
   * @param svci
   * @param sdesc
   * @param ldesc
   * @param sdatetime
   * @param edatetime
   * @param loc
   * @param sp
   * @param cat
   * @param link
   * @param creator
   * @return int  key of new entity
   */
  public int addEvent(CalSvcTestWrapper svci,
                      String sdesc,
                      String ldesc,
                      String sdatetime,
                      String edatetime,
                      BwLocation loc,
                      BwSponsor sp,
                      BwCategory cat,
                      String link,
                      String creator) {
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

    try {
      BwDateTime stdt = CalFacadeUtil.getDateTime(sdatetime, svci.getTimezones());

      BwDateTime edt = CalFacadeUtil.getDateTime(edatetime, svci.getTimezones());

      ev.setDtstart(stdt);
      ev.setDtend(edt);

      ev.setDtstamp(new DtStamp(new DateTime(true)).getValue());
      ev.setLastmod(new LastModified(new DateTime(true)).getValue());
      ev.setCreated(new Created(new DateTime(true)).getValue());

      if (cat != null) {
        ev.addCategory(cat);
      }

      svci.addEvent(svci.getCalendar(), ev, null);
      log("Created event, id=" + ev.getId());
      return ev.getId();
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception adding evnt: " + ev);
      return CalFacadeDefs.unsavedItemKey;
    }
  }

  /** Add an event for later use
   *
   * @param svci
   * @param n         int number of event (to flag descriptions)
   * @param locn      location id - <= 0 for no location
   * @param spn       sponsor id - <= 0 for no sponsor
   * @param desc      some identifying text
   * @return int      key of added event
   */
  public int addEvent(CalSvcTestWrapper svci,
                      int n, int locn, int spn,
                      String desc) {
    try {
      BwLocation loc = null;
      BwSponsor sp = null;

      if (locn > 0) {
        loc = getLocation(svci, locn, true);
      }

      if (spn > 0) {
        sp = getSponsor(svci, spn, true);
      }

      return svci.addEvent(n, loc, sp, desc);
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception adding evnt: " + n);
      return CalFacadeDefs.unsavedItemKey;
    }
  }

  /** Get an event which may or may not exist
   *
   * @param svci
   * @param id           int key of object
   * @param mustExist    boolean true if object is required to exist
   * @return LocationVO  or null for failure
   */
  public BwEvent getEvent(CalSvcTestWrapper svci,
                          int id, boolean mustExist) {
    try {
      EventInfo obj = svci.getEvent(id);
      if (obj == null) {
        if (mustExist) {
          fail("Event " + id + " does not exist");
        }

        return null;
      }

      return obj.getEvent();
    } catch (AssertionFailedError afe) {
      throw afe;
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting Event: " + id);
      return null;
    }
  }

  private void log(String msg) {
    System.out.println(this.getClass().getName() + ": " + msg);
  }
}
