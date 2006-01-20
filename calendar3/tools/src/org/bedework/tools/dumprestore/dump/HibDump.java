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
package org.bedework.tools.dumprestore.dump;

import org.bedework.calcore.hibernate.HibSession;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.Collection;
import java.util.Iterator;

/** Class which implements the dataVO functions needed to dump the
 * calendar dataVO using a jdbc connection.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class HibDump implements DumpIntf {
  //private boolean debug;

  private HibSession sess;
  private SessionFactory sessFactory;

  private Logger log;

  /**
   * @param debug
   * @throws Throwable
   */
  public HibDump(boolean debug) throws Throwable {
    //this.debug = debug;
    log = Logger.getLogger(getClass());
    try {
      sessFactory = new Configuration().configure().buildSessionFactory();
    } catch (Throwable t) {
      log.error("Failed to get session factory", t);
    }
  }

  public void open() throws Throwable {
    openSess();
    beginTransaction();
  }

  public void close() throws Throwable {
    endTransaction();
    closeSess();
  }

  public Iterator getCalendars() throws Throwable {
    return getObjects("org.bedework.calfacade.BwCalendar");
  }

  public Iterator getFilters() throws Throwable {
    return getObjects("org.bedework.calfacade.filter.BwFilter");
  }

  public Iterator getUsers() throws Throwable {
    return getObjects("org.bedework.calfacade.BwUser");
  }

  public Iterator getLocations() throws Throwable {
    return getObjects("org.bedework.calfacade.BwLocation");
  }

  public Iterator getSponsors() throws Throwable {
    return getObjects("org.bedework.calfacade.BwSponsor");
  }

  public Iterator getAttendees() throws Throwable {
    return getObjects("org.bedework.calfacade.BwAttendee");
  }

  public Iterator getOrganizers() throws Throwable {
    return getObjects("org.bedework.calfacade.BwOrganizer");
  }

  public Iterator getAlarms() throws Throwable {
    return getObjects("org.bedework.calfacade.BwAlarm");
  }

  public Iterator getCategories() throws Throwable {
    return getObjects("org.bedework.calfacade.BwCategory");
  }

  public Iterator getAuthUsers() throws Throwable {
    return getObjects("org.bedework.calfacade.svc.BwAuthUser");
  }

  public Iterator getEvents() throws Throwable {
    return getObjects("org.bedework.calfacade.BwEvent");
  }

  public Iterator getEventRefs() throws Throwable {
    return getObjects("org.bedework.calfacade.BwEventRef");
  }

  public Iterator getAdminGroups() throws Throwable {
    return getObjects("org.bedework.calfacade.svc.BwAdminGroup");
  }

  public Iterator getUserPrefs() throws Throwable {
    return getObjects("org.bedework.calfacade.svc.BwPreferences");
  }

  public Iterator getDbLastmods() throws Throwable {
    return getObjects("org.bedework.calfacade.BwDbLastmod");
  }

  private Iterator getObjects(String className) throws Throwable {
    sess.createQuery("from " + className);

    Collection c = sess.getList();

    return c.iterator();
  }

  private synchronized void openSess() throws Throwable {
    if (sess == null) {
      sess = new HibSession(sessFactory, log);
    } else {
      sess.reconnect();
    }
  }

  private synchronized void closeSess() throws Throwable {
    try {
//      sess.close();
      if (sess != null) {
        sess.disconnect();
      }
    } catch (Throwable t) {
      // Discard session if we get errors on close.
      sess = null;
    } finally {
    }
  }

  /** Start a (possibly long-running) transaction. In the web environment
   * this might do nothing. The endTransaction method should in some way
   * check version numbers to detect concurrent updates and fail with an
   * exception.
   *
   * @throws Throwable
   */
  public void beginTransaction() throws Throwable {
    sess.beginTransaction();
  }

  /** End a (possibly long-running) transaction. In the web environment
   * this should in some way check version numbers to detect concurrent updates
   * and fail with an exception.
   *
   * @throws Throwable
   */
  public void endTransaction() throws Throwable {
    /* Just commit */
    sess.commit();
  }
}

