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
package org.bedework.calcore.hibernate;

import edu.rpi.cct.uwcal.access.PrivilegeDefs;
import edu.rpi.cct.uwcal.access.Acl.CurrentAccess;

import org.bedework.calenv.CalEnv;
import org.bedework.calfacade.BwAlarm;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwDuration;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwFreeBusyComponent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.BwRWStats;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwStats;
import org.bedework.calfacade.BwSynchData;
import org.bedework.calfacade.BwSynchInfo;
import org.bedework.calfacade.BwSynchState;
import org.bedework.calfacade.BwSystem;
import org.bedework.calfacade.BwTimeZone;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeAccessException;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CoreEventInfo;
import org.bedework.calfacade.base.BwShareableDbentity;
import org.bedework.calfacade.base.CalintfBase;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.ifs.CalintfInfo;
import org.bedework.calfacade.ifs.EventsI;
import org.bedework.calfacade.ifs.Groups;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calfacade.util.Granulator;
import org.bedework.calfacade.util.Granulator.EventPeriod;
import org.bedework.calfacade.util.Granulator.GetPeriodsPars;
import org.bedework.icalendar.IcalTranslator;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.component.VTimeZone;

import org.apache.log4j.Logger;

import org.hibernate.cfg.Configuration;
import org.hibernate.stat.Statistics;
import org.hibernate.SessionFactory;

/** Implementation of CalIntf which uses hibernate as its persistance engine.
 *
 * <p>We assume this interface is accessing public events or private events.
 * In either case it may be read-only or read/write. It is up to the caller
 * to set the appropriate access.
 *
 * <p>Write access to public objects may be restricted to only those owned
 * by the supplied owner. It is up to the caller to determine the setting for
 * the modifyAll flag.
 *
 * <p>The following methods always work within the above context, e.g. 'all'
 * for an object initialised for public access means all public objects of
 * a requested class. For a personal object it means all objects owned by
 * the current user.
 *
 * <p>Currently some classes are only available as public objects. This
 * might change.
 *
 * <p>A public object in readonly mode will deliver all public objects
 * within the given constraints, regardless of ownership, e.g all events for
 * given day or all public categories.
 *
 * <p>A public object in read/write will enforce ownership on display and
 * on update. This might require a client to obtain two or more objects to
 * get the appropriate behaviour. For example, an admin client will only
 * allow update of events owned by the current user but must display all
 * public categories for use.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class CalintfImpl extends CalintfBase implements PrivilegeDefs {
  private BwSystem syspars;

  private BwStats stats = new BwRWStats();

  private CalTimezonesImpl timezones;

  private static CalintfInfo info = new CalintfInfo(
       true,     // handlesLocations
       true,     // handlesSponsors
       true      // handlesCategories
     );

  /** For evaluating access control
   */
  private AccessUtil access;

  private EventsI events;

  private Calendars calendars;

  private EventProperties categories;

  private EventProperties locations;

  private EventProperties sponsors;

  /** Prevent updates.
   */
  //sprivate boolean readOnly;

  /** Current hibernate session - exists only across one user interaction
   */
  private HibSession sess;

  /** We make this static for this implementation so that there is only one
   * SessionFactory per server for the calendar.
   *
   * <p>static fields used this way are illegal in the j2ee specification
   * though we might get away with it here as the session factory only
   * contains parsed mappings for the calendar configuration. This should
   * be the same for any machine in a cluster so it might work OK.
   *
   * <p>It might be better to find some other approach for the j2ee world.
   */
  private static SessionFactory sessFactory;
  private static Statistics dbStats;

  static {
    /** Get a new hibernate session factory. This is configured from an
     * application resource hibernate.cfg.xml
     */
    try {
      sessFactory = new Configuration().configure().buildSessionFactory();
    } catch (Throwable t) {
      Logger.getLogger(CalintfImpl.class).error("Failed to get session factory", t);
    }
  }

  /* ====================================================================
   *                   initialisation
   * ==================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.calfacade.Calintf#init(org.bedework.calfacade.BwUser, java.lang.String, boolean, boolean, boolean, java.lang.String, boolean)
   */
  public boolean init(String url,
                      String authenticatedUser,
                      String user,
                      boolean publicAdmin,
                      Groups groups,
                      String synchId,
                      boolean debug) throws CalFacadeException {
    super.init(url, authenticatedUser, user, publicAdmin,
               groups, synchId, debug);

    boolean userCreated = false;

    BwUser authUser;

    try {
      access = new AccessUtil(debug);

      if ((synchId != null) && publicAdmin) {
        throw new CalFacadeException("synch only valid for non admin");
      }
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }

    if (user == null) {
      user = authenticatedUser;
    }

    if (authenticatedUser == null) {
      // Unauthenticated use
      // Ensure no guest mods
//      this.readOnly = true;
      currentMode = CalintfUtil.guestMode;
      authUser = new BwUser();
      this.user = getUser(user);
    } else {
//      this.readOnly = false;

      authUser = getUser(authenticatedUser);
      if (authUser == null) {
        /* Add the user to the database. Presumably this is first logon
         */
        getLogger().info("Add new user " + authenticatedUser);
        addNewUser(new BwUser(authenticatedUser));
        authUser = getUser(authenticatedUser);
        userCreated = true;
      }

      if (!publicAdmin) {
        currentMode = CalintfUtil.userMode;
      } else {
        currentMode = CalintfUtil.publicAdminMode;
      }

      logon(authUser);

      getLogger().info("Authenticated user " + authenticatedUser +
                       " logged on");

      if (authenticatedUser.equals(user)) {
        this.user = authUser;
      } else {
        this.user = getUser(user);
        if (this.user == null) {
          throw new CalFacadeException("User " + user + " does not exist.");
        }
      }
    }

    authUser.setGroups(groups.getAllGroups(authUser));
    access.setAuthUser(authUser);
    access.setSyspars((BwSystem)getSyspars().clone());

    events = new Events(this, access, currentMode, debug);

    calendars = new Calendars(this, access, currentMode, debug);

    categories = new EventProperties(this, access, currentMode,
                                     "word", BwCategory.class.getName(),
                                     "getCategoryRefs",
                                     -1, debug);
    locations = new EventProperties(this, access, currentMode,
                                    "address", BwLocation.class.getName(),
                                    "getLocationRefs",
                                     CalFacadeDefs.maxReservedLocationId, debug);
    sponsors = new EventProperties(this, access, currentMode,
                                   "name", BwSponsor.class.getName(),
                                   "getSponsorRefs",
                                   CalFacadeDefs.maxReservedSponsorId, debug);

    timezones = new CalTimezonesImpl(this, getStats(), publicAdmin, debug);
    timezones.setDefaultTimeZoneId(getSyspars().getTzid());

    if (userCreated) {
      calendars.addNewCalendars(authUser);
    }

    return userCreated;
  }

  public void logon(BwUser val) throws CalFacadeException {
    checkOpen();
    Timestamp now = new Timestamp(System.currentTimeMillis());

    val.setLogon(now);
    val.setLastAccess(now);
    sess.update(val);
  }

  public void setSuperUser(boolean val) {
    access.setSuperUser(val);
  }

  public boolean getSuperUser() {
    return access.getSuperUser();
  }

  public BwStats getStats() throws CalFacadeException {
    if (stats == null) {
      return null;
    }

    BwRWStats rwstats = (BwRWStats)stats;

    if (timezones != null) {
      rwstats.setDateCacheHits(timezones.getDateCacheHits());
      rwstats.setDateCacheMisses(timezones.getDateCacheMisses());
      rwstats.setDatesCached(timezones.getDatesCached());
    }

    return stats;
  }

  public void setDbStatsEnabled(boolean enable) throws CalFacadeException {
    if (!enable && (dbStats == null)) {
      return;
    }

    if (dbStats == null) {
      dbStats = sessFactory.getStatistics();
    }

    dbStats.setStatisticsEnabled(enable);
  }

  public boolean getDbStatsEnabled() throws CalFacadeException {
    if (dbStats == null) {
      return false;
    }

    return dbStats.isStatisticsEnabled();
  }

  public void dumpDbStats() throws CalFacadeException {
    DbStatistics.dumpStats(dbStats);
  }

  public Collection getDbStats() throws CalFacadeException {
    return DbStatistics.getStats(dbStats);
  }

  public BwSystem getSyspars() throws CalFacadeException {
    if (syspars == null) {
      String name;

      try {
        name = CalEnv.getGlobalProperty("system.name");
      } catch (Throwable t) {
        throw new CalFacadeException(t);
      }

      sess.namedQuery("getSystemPars");

      sess.setString("name", name);

      syspars = (BwSystem)sess.getUnique();

      if (syspars == null) {
        throw new CalFacadeException("No system parameters with name " + name);
      }

      if (debug) {
        trace("Read system parameters: " + syspars);
      }
    }
    return syspars;
  }

  public void updateSyspars(BwSystem val) throws CalFacadeException {
    checkOpen();
    sess.update(val);
    syspars = null; // Force refresh
    access.setSyspars((BwSystem)getSyspars().clone());
  }

  public CalTimezones getTimezonesHandler() throws CalFacadeException {
    return timezones;
  }

  public CalintfInfo getInfo() throws CalFacadeException {
    return info;
  }

  /* ====================================================================
   *                   Misc methods
   * ==================================================================== */

  public void flushAll() throws CalFacadeException {
    if (debug) {
      debug("flushAll for " + objTimestamp);
    }
    if (sess == null) {
      return;
    }

    try {
    if (sess.isOpen()) {
      sess.reconnect();  // for close
      sess.close();
    }
    } finally {
      isOpen = false;
      sess = null;
    }
  }

  public synchronized void open() throws CalFacadeException {
    if (isOpen) {
      throw new CalFacadeException("Already open");
    }

    isOpen = true;

    if (sess == null) {
      if (debug) {
        debug("New hibernate session for " + objTimestamp);
      }
      sess = new HibSession(sessFactory, getLogger());
    } else {
      if (debug) {
        debug("Reconnect hibernate session for " + objTimestamp);
      }
      sess.reconnect();
    }

    if (access != null) {
      access.open();
    }

//    personalModified = new Vector();
  }

  public synchronized void close() throws CalFacadeException {
    if (!isOpen) {
      if (debug) {
        debug("Close for " + objTimestamp + " closed session");
      }
      return;
    }

    if (debug) {
      debug("Close for " + objTimestamp);
    }

    try {
      if (sess != null) {
        if (sess.transactionStarted()) {
          sess.rollback();
        }
        sess.disconnect();
      }
    } catch (Throwable t) {
      try {
        sess.close();
      } finally {}
      sess = null; // Discard on error
    } finally {
      isOpen = false;
    }

    if (access != null) {
      access.close();
    }
  }

  public void beginTransaction() throws CalFacadeException {
    checkOpen();
//    sess.close();
    if (debug) {
      debug("Begin transaction for " + objTimestamp);
    }
    sess.beginTransaction();
  }

  public void endTransaction() throws CalFacadeException {
    checkOpen();

    if (debug) {
      debug("End transaction for " + objTimestamp);
    }

    /* Update the lastmods for any changed users
     * /

    Iterator it = personalModified.iterator();

    while (it.hasNext()) {
      BwUser u = (BwUser)it.next();
    }*/

    /* Just commit */
    sess.commit();
//    sess.flush();
  }

  public void rollbackTransaction() throws CalFacadeException {
    checkOpen();
    sess.rollback();
  }

  public Object getDbSession() throws CalFacadeException {
    return sess;
  }

  /* ====================================================================
   *                   General data methods
   * ==================================================================== */

  /*
  public void refresh() throws CalFacadeException {
    checkOpen();
    sess.flush();
  }*/

  public void refreshEvents() throws CalFacadeException {
    checkOpen();
//    sess.flush();
  }

  /*
  public void lockRead(Object val) throws CalFacadeException {
    checkOpen();
    sess.lockRead(val);
  }

  public void lockMod(Object val) throws CalFacadeException {
    checkOpen();
    sess.lockUpdate(val);
  }
  */

  /* ====================================================================
   *                   Global parameters
   * ==================================================================== */

  public long getPublicLastmod() throws CalFacadeException {
    checkOpen();
    return 0; // for the moment
  }

  public String getSysid() throws CalFacadeException {
    return getSyspars().getSystemid();
  }

  /* ====================================================================
   *                   Users
   * ==================================================================== */

  public BwUser getUser(int id) throws CalFacadeException {
    checkOpen();
    StringBuffer q = new StringBuffer();

    q.append("from ");
    q.append(BwUser.class.getName());
    q.append(" as u where u.userid = :userid");

    sess.createQuery(q.toString());

    sess.setInt("userid", id);

    return (BwUser)sess.getUnique();
  }


  public BwUser getUser(String user) throws CalFacadeException {
    checkOpen();
    StringBuffer q = new StringBuffer();

    q.append("from ");
    q.append(BwUser.class.getName());
    q.append(" as u where u.account = :account");
    sess.createQuery(q.toString());

    sess.setString("account", user);

    return (BwUser)sess.getUnique();
  }

  public void addUser(BwUser user) throws CalFacadeException {
    addNewUser(user);
    calendars.addNewCalendars(user);
  }

  private void addNewUser(BwUser user) throws CalFacadeException {
    checkOpen();

    user.setCategoryAccess(access.getDefaultPersonalAccess());
    user.setLocationAccess(access.getDefaultPersonalAccess());
    user.setSponsorAccess(access.getDefaultPersonalAccess());

    user.setQuota(getSyspars().getDefaultUserQuota());

    sess.save(user);
  }

  public void updateUser(BwUser user) throws CalFacadeException {
    checkOpen();
    sess.update(user);
  }

  public Collection getInstanceOwners() throws CalFacadeException {
    checkOpen();
    StringBuffer q = new StringBuffer();

    q.append("from ");
    q.append(BwUser.class.getName());
    q.append(" as u where u.instanceOwner=true");
    sess.createQuery(q.toString());

    return sess.getList();
  }

  /*
  public void deleteUser(BwUser user) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeException("Unimplemented");
  }*/

  /* ====================================================================
   *                   Access
   * ==================================================================== */

  public void changeAccess(BwShareableDbentity ent,
                           Collection aces) throws CalFacadeException {
    if (ent instanceof BwCalendar) {
      changeAccess((BwCalendar)ent, aces);
      return;
    }
    checkOpen();
    checkAccess(ent, privWriteAcl, false);
    access.changeAccess(ent, aces);
    sess.saveOrUpdate(ent);
  }

  public void changeAccess(BwCalendar cal,
                           Collection aces) throws CalFacadeException {
    checkOpen();
    calendars.changeAccess(cal, aces);
  }

  public CurrentAccess checkAccess(BwShareableDbentity ent, int desiredAccess,
                                   boolean returnResult) throws CalFacadeException {
    return access.checkAccess(ent, desiredAccess, returnResult);
  }

  /* ====================================================================
   *                   Timezones
   * ==================================================================== */

  public void saveTimeZone(String tzid, VTimeZone vtz) throws CalFacadeException {
    checkOpen();

    BwTimeZone tz = new BwTimeZone();

    if (currentMode == CalintfUtil.guestMode) {
      throw new CalFacadeAccessException();
    }

    tz.setTzid(tzid);
    tz.setPublick(currentMode == CalintfUtil.publicAdminMode);
    tz.setOwner(user);

    StringBuffer sb = new StringBuffer();

    sb.append("BEGIN:VCALENDAR\n");
    sb.append("PRODID:-//RPI//BEDEWORK//US\n");
    sb.append("VERSION:2.0\n");
    sb.append(vtz.toString());
    sb.append("END:VCALENDAR\n");

    tz.setVtimezone(sb.toString());

    sess.save(tz);
  }

  public VTimeZone getTimeZone(final String id, BwUser owner) throws CalFacadeException {
    if (currentMode == CalintfUtil.publicAdminMode ||
        currentMode == CalintfUtil.guestMode) {
      sess.namedQuery("getPublicTzByTzid");
    } else {
      if (owner == null) {
        owner = user;
      }
      sess.namedQuery("getTzByTzid");
      sess.setEntity("owner", owner);
    }

    sess.setString("tzid", id);

    BwTimeZone tz = (BwTimeZone)sess.getUnique();

    if (tz == null) {
      return null;
    }

    Calendar cal = IcalTranslator.getCalendar(tz.getVtimezone());

    VTimeZone vtz = (VTimeZone)cal.getComponents().getComponent(Component.VTIMEZONE);
    if (vtz == null) {
      throw new CalFacadeException("Incorrectly stored timezone");
    }

    return vtz;
  }

  public Collection getTimeZones() throws CalFacadeException {
    if (currentMode == CalintfUtil.publicAdminMode ||
        currentMode == CalintfUtil.guestMode) {
      sess.namedQuery("getPublicTimezones");

      return sess.getList();
    }

    sess.namedQuery("getMergedTimezones");
    sess.setEntity("owner", user);

    return sess.getList();
  }

  public Collection getUserTimeZones() throws CalFacadeException {
    sess.namedQuery("getUserTimezones");
    sess.setEntity("owner", user);

    return sess.getList();
  }

  public Collection getPublicTimeZones() throws CalFacadeException {
    sess.namedQuery("getPublicTimezones");

    return sess.getList();
  }

  public void clearPublicTimezones() throws CalFacadeException {
    checkOpen();

    /* Delete all public timezones */
    sess.namedQuery("deleteAllPublicTzs");
    /*int numDeleted =*/ sess.executeUpdate();
  }

  /* ====================================================================
   *                       Calendars
   * ==================================================================== */

  public BwCalendar getPublicCalendars() throws CalFacadeException {
    checkOpen();

    return calendars.getPublicCalendars();
  }

  public Collection getPublicCalendarCollections() throws CalFacadeException {
    checkOpen();

    return calendars.getPublicCalendarCollections();
  }

  public BwCalendar getCalendars() throws CalFacadeException {
    if (currentMode == CalintfUtil.guestMode) {
      return getPublicCalendars();
    }

    checkOpen();

    return calendars.getCalendars();
  }

  public BwCalendar getCalendars(BwUser user,
                                 int desiredAccess) throws CalFacadeException {
    checkOpen();

    return calendars.getCalendars(user, desiredAccess);
  }

  public Collection getCalendarCollections() throws CalFacadeException {
    checkOpen();

    return calendars.getCalendarCollections();
  }

  public Collection getAddContentPublicCalendarCollections()
          throws CalFacadeException {
    checkOpen();

    return calendars.getAddContentPublicCalendarCollections();
  }

  public Collection getAddContentCalendarCollections()
          throws CalFacadeException {
    if (currentMode == CalintfUtil.guestMode) {
      return new TreeSet();
    }

    checkOpen();

    return calendars.getAddContentCalendarCollections();
  }

  public BwCalendar getCalendar(int val) throws CalFacadeException {
    checkOpen();

    return calendars.getCalendar(val);
  }

  public BwCalendar getCalendar(String path,
                                int desiredAccess) throws CalFacadeException{
    checkOpen();

    return calendars.getCalendar(path, desiredAccess);
  }

  public BwCalendar getDefaultCalendar(BwUser user) throws CalFacadeException {
    return calendars.getDefaultCalendar(user);
  }

  public BwCalendar getSpecialCalendar(BwUser user,
                                       int calType,
                                       boolean create) throws CalFacadeException {
    return calendars.getSpecialCalendar(user, calType, create);
  }

  public void addCalendar(BwCalendar val, String parentPath) throws CalFacadeException {
    checkOpen();

    if (val.getCalendarCollection()) {
      val.setCalType(BwCalendar.calTypeCollection);
    } else {
      val.setCalType(BwCalendar.calTypeFolder);
    }
    calendars.addCalendar(val, parentPath);
  }

  public void updateCalendar(BwCalendar val) throws CalFacadeException {
    checkOpen();
    calendars.updateCalendar(val);
  }

  public boolean deleteCalendar(BwCalendar val) throws CalFacadeException {
    checkOpen();

    return calendars.deleteCalendar(val);
  }

  public boolean checkCalendarRefs(BwCalendar val) throws CalFacadeException {
    checkOpen();

    return calendars.checkCalendarRefs(val);
  }

  /* ====================================================================
   *                   Filters and search
   * ==================================================================== */

  public void setSearch(String val) throws CalFacadeException {
    checkOpen();
  }

  public String getSearch() throws CalFacadeException {
    checkOpen();

    return null;
  }

  public void addFilter(BwFilter val) throws CalFacadeException {
    checkOpen();
    sess.save(val);
  }

  public void updateFilter(BwFilter val) throws CalFacadeException {
    checkOpen();
    sess.saveOrUpdate(val);
  }

  /* ====================================================================
   *                   Categories
   * ==================================================================== */

  public Collection getCategories(BwUser owner, BwUser creator)
        throws CalFacadeException {
    checkOpen();

    return access.checkAccess(categories.get(owner, creator), privRead, true);
  }

  public BwCategory getCategory(int id) throws CalFacadeException {
    checkOpen();

    return (BwCategory)categories.get(id);
  }

  public BwCategory findCategory(BwCategory val) throws CalFacadeException {
    checkOpen();

    return (BwCategory)categories.find(val.getWord(), val.getOwner());
  }

  public void addCategory(BwCategory val) throws CalFacadeException {
    checkOpen();

    categories.add(val);
  }

  public void updateCategory(BwCategory val) throws CalFacadeException {
    checkOpen();

    categories.update(val);
  }

  public boolean deleteCategory(BwCategory val) throws CalFacadeException {
    checkOpen();

    categories.delete(val);

    return true;
  }

  public Collection getCategoryRefs(BwCategory val) throws CalFacadeException {
    checkOpen();

    return categories.getRefs(val);
  }

  /* ====================================================================
   *                   Locations
   * ==================================================================== */

  public Collection getLocations(BwUser owner, BwUser creator)
        throws CalFacadeException {
    checkOpen();

    return access.checkAccess(locations.get(owner, creator), privRead, true);
  }

  public BwLocation getLocation(int id) throws CalFacadeException {
    checkOpen();

    return (BwLocation)locations.get(id);
  }

  public BwLocation findLocation(BwLocation val) throws CalFacadeException {
    checkOpen();

    return (BwLocation)locations.find(val.getAddress(), val.getOwner());
  }

  public void addLocation(BwLocation val) throws CalFacadeException {
    checkOpen();

    locations.add(val);
  }

  public void updateLocation(BwLocation val) throws CalFacadeException {
    checkOpen();

    locations.update(val);
  }

  public boolean deleteLocation(BwLocation val) throws CalFacadeException {
    checkOpen();

    locations.delete(val);

    return true;
  }

  public Collection getLocationRefs(BwLocation val) throws CalFacadeException {
    checkOpen();

    return locations.getRefs(val);
  }

  /* ====================================================================
   *                   Sponsors
   * ==================================================================== */

  public Collection getSponsors(BwUser owner, BwUser creator)
        throws CalFacadeException {
    checkOpen();

    return access.checkAccess(sponsors.get(owner, creator), privRead, true);
  }

  public BwSponsor getSponsor(int id) throws CalFacadeException {
    checkOpen();

    return (BwSponsor)sponsors.get(id);
  }

  public BwSponsor findSponsor(BwSponsor val) throws CalFacadeException {
    checkOpen();

    return (BwSponsor)sponsors.find(val.getName(), val.getOwner());
  }

  public void addSponsor(BwSponsor val) throws CalFacadeException {
    checkOpen();

    sponsors.add(val);
  }

  public void updateSponsor(BwSponsor val) throws CalFacadeException {
    checkOpen();

    sponsors.update(val);
  }

  public boolean deleteSponsor(BwSponsor val) throws CalFacadeException {
    checkOpen();

    sponsors.delete(val);

    return true;
  }

  public Collection getSponsorRefs(BwSponsor val) throws CalFacadeException {
    checkOpen();

    return sponsors.getRefs(val);
  }

  /* ====================================================================
   *                   Free busy
   * ==================================================================== */

  public BwFreeBusy getFreeBusy(BwCalendar cal, BwPrincipal who,
                                BwDateTime start, BwDateTime end,
                                BwDuration granularity,
                                boolean returnAll,
                                boolean ignoreTransparency)
          throws CalFacadeException {
    if (!(who instanceof BwUser)) {
      throw new CalFacadeException("Unsupported: non user principal for free-busy");
    }

    Collection events = getFreeBusyEntities(cal, start, end, ignoreTransparency);
    BwFreeBusy fb = new BwFreeBusy(who, start, end);

    try {
      if (granularity != null) {
        // chunked.
        GetPeriodsPars gpp = new GetPeriodsPars();

        gpp.periods = events;
        gpp.startDt = start;
        gpp.dur = granularity;
        gpp.tzcache = getTimezonesHandler();

        BwFreeBusyComponent fbc = null;

        if (!returnAll) {
          // One component
          fbc = new BwFreeBusyComponent();
          fb.addTime(fbc);
        }

        int limit = 10000; // XXX do this better

        /* endDt is null first time through, then represents end of last
         * segment.
         */
        while ((gpp.endDt == null) || (gpp.endDt.before(end))) {
          //if (debug) {
          //  trace("gpp.startDt=" + gpp.startDt + " end=" + end);
          //}
          if (limit < 0) {
            throw new CalFacadeException("org.bedework.svci.limit.exceeded");
          }
          limit--;

          Collection periodEvents = Granulator.getPeriodsEvents(gpp);

          if (returnAll) {
            fbc = new BwFreeBusyComponent();
            fb.addTime(fbc);

            DateTime psdt = new DateTime(gpp.startDt.getDtval());
            DateTime pedt = new DateTime(gpp.endDt.getDtval());

            psdt.setUtc(true);
            pedt.setUtc(true);
            fbc.addPeriod(new Period(psdt, pedt));
            if (periodEvents.size() == 0) {
              fbc.setType(BwFreeBusyComponent.typeFree);
            }
          } else if (periodEvents.size() != 0) {
            /* Some events fall in the period. Add an entry.
             * We eliminated cancelled events earler. Now we should set the
             * free/busy type based on the events status.
             */

            DateTime psdt = new DateTime(gpp.startDt.getDtval());
            DateTime pedt = new DateTime(gpp.endDt.getDtval());

            psdt.setUtc(true);
            pedt.setUtc(true);

            if (fbc == null) {
              fbc = new BwFreeBusyComponent();
              fb.addTime(fbc);
            }

            fbc.addPeriod(new Period(psdt, pedt));
          }
        }

        return fb;
      }

      Iterator it = events.iterator();

      TreeSet eventPeriods = new TreeSet();

      while (it.hasNext()) {
        EventInfo ei = (EventInfo)it.next();
        BwEvent ev = ei.getEvent();

        if (BwEvent.statusCancelled.equals(ev.getStatus())) {
          // Ignore this one.
          continue;
        }

        // Ignore if times were specified and this event is outside the times

        BwDateTime estart = ev.getDtstart();
        BwDateTime eend = ev.getDtend();

        /* Don't report out of the requested period */

        String dstart;
        String dend;

        if (estart.before(start)) {
          dstart = start.getDtval();
        } else {
          dstart = estart.getDtval();
        }

        if (eend.after(end)) {
          dend = end.getDtval();
        } else {
          dend = eend.getDtval();
        }

        DateTime psdt = new DateTime(dstart);
        DateTime pedt = new DateTime(dend);

        psdt.setUtc(true);
        pedt.setUtc(true);

        int type = BwFreeBusyComponent.typeBusy;

        if (BwEvent.statusTentative.equals(ev.getStatus())) {
          type = BwFreeBusyComponent.typeBusyTentative;
       }

        eventPeriods.add(new EventPeriod(psdt, pedt, type));
      }

      /* iterate through the sorted periods combining them where they are
       adjacent or overlap */

      Period p = null;

      /* For the moment just build a single BwFreeBusyComponent
       */
      BwFreeBusyComponent fbc = null;
      int lastType = 0;

      it = eventPeriods.iterator();
      while (it.hasNext()) {
        EventPeriod ep = (EventPeriod)it.next();

        if (debug) {
          trace(ep.toString());
        }

        if (p == null) {
          p = new Period(ep.getStart(), ep.getEnd());
          lastType = ep.getType();
        } else if ((lastType != ep.getType()) || ep.getStart().after(p.getEnd())) {
          // Non adjacent periods
          if (fbc == null) {
            fbc = new BwFreeBusyComponent();
            fbc.setType(lastType);
            fb.addTime(fbc);
          }
          fbc.addPeriod(p);

          if (lastType != ep.getType()) {
            fbc = null;
          }

          p = new Period(ep.getStart(), ep.getEnd());
          lastType = ep.getType();
        } else if (ep.getEnd().after(p.getEnd())) {
          // Extend the current period
          p = new Period(p.getStart(), ep.getEnd());
        } // else it falls within the existing period
      }

      if (p != null) {
        if ((fbc == null) || (lastType != fbc.getType())) {
          fbc = new BwFreeBusyComponent();
          fbc.setType(lastType);
          fb.addTime(fbc);
        }
        fbc.addPeriod(p);
      }
    } catch (Throwable t) {
      if (debug) {
        error(t);
      }
      throw new CalFacadeException(t);
    }

    return fb;
  }

  /* ====================================================================
   *                   Events
   * ==================================================================== */

  public Collection getEvents(BwCalendar calendar, BwFilter filter,
                              BwDateTime startDate, BwDateTime endDate,
                              int recurRetrieval,
                              boolean freeBusy,
                              boolean allCalendars) throws CalFacadeException {
    return events.getEvents(calendar, filter,
                            startDate, endDate, recurRetrieval,
                            freeBusy, allCalendars);
  }

  public CoreEventInfo getEvent(int id) throws CalFacadeException {
    checkOpen();
    return events.getEvent(id);
  }

 public Collection getEvent(BwCalendar calendar, String guid, String rid,
                           int recurRetrieval) throws CalFacadeException {
    checkOpen();
    return events.getEvent(calendar, guid, rid, recurRetrieval);
  }

  public void addEvent(BwEvent val,
                       Collection overrides) throws CalFacadeException {
    checkOpen();
    events.addEvent(val, overrides);
  }

  public void updateEvent(BwEvent val) throws CalFacadeException {
    checkOpen();
    events.updateEvent(val);
  }

  public DelEventResult deleteEvent(BwEvent val) throws CalFacadeException {
    checkOpen();
    return events.deleteEvent(val);
  }

  /*public boolean editable(BwEvent val) throws CalFacadeException {
    checkOpen();

    return events.editable(val);
  }*/

  public Collection getEventsByName(BwCalendar cal, String val)
          throws CalFacadeException {
    checkOpen();
    return events.getEventsByName(cal, val);
  }

  public Collection getDeletedProxies() throws CalFacadeException {
    BwCalendar cal = getSpecialCalendar(user, BwCalendar.calTypeDeleted, false);

    if (cal == null) {
      // Not supported or never deleted anything
      return new ArrayList();
    }

    return events.getDeletedProxies(cal);
  }

  public Collection getDeletedProxies(BwCalendar cal) throws CalFacadeException {
    return events.getDeletedProxies(cal);
  }

  /* ====================================================================
   *                   Synchronization
   * ==================================================================== */

  public BwSynchInfo getSynchInfo() throws CalFacadeException {
    checkOpen();

    if (debug) {
      getLogger().debug("getSynchInfo for user=" + user +
                        " deviceId=" + synchId);
    }

    sess.namedQuery("getSynchInfo");
    sess.setEntity("user", user);
    sess.setString("deviceId", synchId);

    BwSynchInfo si = (BwSynchInfo)sess.getUnique();

    return si;
  }

  public void addSynchInfo(BwSynchInfo val) throws CalFacadeException {
    checkOpen();

    if (debug) {
      getLogger().debug("addSynchInfo for user=" + val.getUser() +
                        " deviceId=" + val.getDeviceId());
    }

    sess.save(val);
  }

  public void updateSynchInfo(BwSynchInfo val) throws CalFacadeException {
    checkOpen();

    sess.saveOrUpdate(val);
  }

  public BwSynchState getSynchState(BwEvent ev)
      throws CalFacadeException {
    checkOpen();

    sess.namedQuery("getSynchState");
    sess.setEntity("event", ev);
    sess.setEntity("user", user);
    sess.setString("deviceId", synchId);

    BwSynchState ss = (BwSynchState)sess.getUnique();

    return ss;
  }

  public Collection getDeletedSynchStates() throws CalFacadeException {
    checkOpen();

    sess.namedQuery("getDeletedSynchStates");
    sess.setEntity("user", user);
    sess.setString("deviceId", synchId);
    sess.setInt("synchState", BwSynchState.DELETED);

    return sess.getList();
  }

  public void addSynchState(BwSynchState val) throws CalFacadeException {
    checkOpen();

    sess.save(val);
  }

  public void updateSynchState(BwSynchState val) throws CalFacadeException {
    checkOpen();

    sess.saveOrUpdate(val);
  }

  public int setSynchState(BwEvent ev, int state)
        throws CalFacadeException {
    checkOpen();

    sess.namedQuery("setSynchState");
    sess.setInt("state", state);
    sess.setInt("eventid", ev.getId());

    return sess.executeUpdate();
  }

  private int setSynchStateUser(BwEvent ev, int state)
        throws CalFacadeException {
    checkOpen();

    sess.namedQuery("setSynchStateUser");
    sess.setInt("state", state);
    sess.setEntity("user", user);
    sess.setInt("eventid", ev.getId());

    return sess.executeUpdate();
  }

  public void getSynchData(BwSynchState val) throws CalFacadeException {
    checkOpen();

    sess.namedQuery("getSynchData");
    sess.setEntity("user", val.getUser());
    sess.setInt("eventid", val.getEvent().getId());

    BwSynchData sd = (BwSynchData)sess.getUnique();

    val.setSynchData(sd);
  }

  public void setSynchData(BwSynchState val) throws CalFacadeException {
    checkOpen();

    sess.saveOrUpdate(val);
    setSynchStateUser(val.getEvent(), BwSynchState.CLIENT_MODIFIED_UNDELIVERED);
    sess.saveOrUpdate(val.getSynchData());
  }

  public void updateSynchStates() throws CalFacadeException {
    checkOpen();

    sess.namedQuery("updateSynchStates1");
    sess.setInt("newstate", BwSynchState.SYNCHRONIZED);
    sess.setInt("userid", user.getId());
    sess.setString("deviceid", synchId);
    sess.setInt("state", BwSynchState.MODIFIED);

    sess.namedQuery("updateSynchStates2");
    sess.setInt("newstate", BwSynchState.CLIENT_DELETED);
    sess.setInt("userid", user.getId());
    sess.setString("deviceid", synchId);
    sess.setInt("state", BwSynchState.CLIENT_DELETED_UNDELIVERED);

    sess.namedQuery("updateSynchStates2");
    sess.setInt("newstate", BwSynchState.CLIENT_MODIFIED);
    sess.setInt("userid", user.getId());
    sess.setString("deviceid", synchId);
    sess.setInt("state", BwSynchState.CLIENT_MODIFIED_UNDELIVERED);
  }

  /* ====================================================================
   *                       Alarms
   * ==================================================================== */

  public Collection getAlarms(BwEvent event, BwUser user) throws CalFacadeException {
    checkOpen();

    sess.namedQuery("getAlarms");
    sess.setEntity("ev", event);
    sess.setEntity("user", user);

    return sess.getList();
  }

  public void addAlarm(BwAlarm val) throws CalFacadeException {
    checkOpen();

    sess.save(val);
  }

  public void updateAlarm(BwAlarm val) throws CalFacadeException {
    checkOpen();
    sess.saveOrUpdate(val);
  }

  public Collection getUnexpiredAlarms(BwUser user) throws CalFacadeException {
    checkOpen();

    if (user == null) {
      sess.namedQuery("getUnexpiredAlarms");
    } else {
      sess.namedQuery("getUnexpiredAlarmsUser");
      sess.setEntity("user", user);
    }

    return sess.getList();
  }

  public Collection getUnexpiredAlarms(BwUser user, long triggerTime)
          throws CalFacadeException {
    checkOpen();

    sess.namedQuery("getUnexpiredAlarmsUserTime");
    sess.setEntity("user", user);
    sess.setLong("tt", triggerTime);

    return sess.getList();
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private Collection getFreeBusyEntities(BwCalendar cal,
                                         BwDateTime start, BwDateTime end,
                                         boolean ignoreTransparency)
          throws CalFacadeException {
    Collection evs = getEvents(cal, null, start, end,
                               CalFacadeDefs.retrieveRecurExpanded, true,
                               true);

    // Filter out transparent and cancelled events
    Iterator evit = evs.iterator();

    Collection events = new TreeSet();

    while (evit.hasNext()) {
      EventInfo ei = (EventInfo)evit.next();
      BwEvent ev = ei.getEvent();

      if (!ignoreTransparency &&
          BwEvent.transparencyTransparent.equals(ev.getTransparency())) {
        // Ignore this one.
        continue;
      }

      if (BwEvent.statusCancelled.equals(ev.getStatus())) {
        // Ignore this one.
        continue;
      }

      events.add(ei);
    }

    return events;
  }
}

