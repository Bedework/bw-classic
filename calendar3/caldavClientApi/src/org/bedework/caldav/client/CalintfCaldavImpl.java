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
package org.bedework.caldav.client;

//import org.bedework.calenv.CalEnv;
import org.bedework.calfacade.BwAlarm;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwDuration;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwStats;
import org.bedework.calfacade.BwSystem;
import org.bedework.calfacade.CoreEventInfo;
//import org.bedework.calfacade.BwSynchData;
import org.bedework.calfacade.BwSynchInfo;
import org.bedework.calfacade.BwSynchState;
//import org.bedework.calfacade.BwTimeZone;
import org.bedework.calfacade.BwUser;
//import org.bedework.calfacade.CalFacadeAccessException;
import org.bedework.calfacade.CalFacadeUnimplementedException;
//import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalintfDefs;
import org.bedework.calfacade.base.BwShareableDbentity;
import org.bedework.calfacade.base.CalintfBase;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.ifs.CalintfInfo;
import org.bedework.calfacade.ifs.Groups;
import org.bedework.http.client.HttpManager;

import edu.rpi.cct.uwcal.access.Acl.CurrentAccess;

import java.util.Collection;
import java.util.TreeSet;

//import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.component.VTimeZone;

/** Implementation of CalIntf which interacts with a caldav server.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class CalintfCaldavImpl extends CalintfBase {
  private static volatile HttpManager httpManager;

  private static CalintfInfo info = new CalintfInfo(
       false,     // handlesLocations
       false,     // handlesSponsors
       false      // handlesCategories
     );

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
    boolean userAdded = super.init(url, authenticatedUser, user, publicAdmin,
                                   groups, synchId, debug);

    if (httpManager == null) {
      synchronized (this) {
        if (httpManager == null) {
          httpManager = new HttpManager("org.bedework.http.client.caldav.CaldavClient");
        }
      }
    }

    return userAdded;
  }

  public void logon(BwUser val) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public void setSuperUser(boolean val) {
  }

  public boolean getSuperUser() {
    return false;
  }

  public BwStats getStats() throws CalFacadeException {
    return null;
  }

  public void setDbStatsEnabled(boolean enable) throws CalFacadeException {
  }

  public boolean getDbStatsEnabled() throws CalFacadeException {
    return false;
  }

  public void dumpDbStats() throws CalFacadeException {
  }

  public Collection getDbStats() throws CalFacadeException {
    return null;
  }

  public BwSystem getSyspars() throws CalFacadeException {
    return null;
  }

  public void updateSyspars(BwSystem val) throws CalFacadeException {
  }

  public CalTimezones getTimezones() throws CalFacadeException {
    return null;
  }

  public CalintfInfo getInfo() throws CalFacadeException {
    return info;
  }

  public void setUser(String val) throws CalFacadeException {
    refreshEvents();

    user = getUser(val);
    if (this.user == null) {
      throw new CalFacadeException("User " + val + " does not exist.");
    }

    logon(user);

    if (debug) {
      getLogger().debug("User " + val + " set in calintf");
    }
  }

  /* ====================================================================
   *                   Misc methods
   * ==================================================================== */

  public void flushAll() throws CalFacadeException {
    if (debug) {
      getLogger().debug("flushAll for " + objTimestamp);
    }
  }

  public void beginTransaction() throws CalFacadeException {
    checkOpen();
  }

  public void endTransaction() throws CalFacadeException {
  }

  public void rollbackTransaction() throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public Object getDbSession() throws CalFacadeException {
    return null;
  }

  /* ====================================================================
   *                   General data methods
   * ==================================================================== */

  public void refreshEvents() throws CalFacadeException {
    checkOpen();
  }

  /* ====================================================================
   *                   Global parameters
   * ==================================================================== */

  public long getPublicLastmod() throws CalFacadeException {
    checkOpen();
    return 0; // for the moment
  }

  public String getSysid() throws CalFacadeException {
    return "";
  }

  /* ====================================================================
   *                   Users
   * ==================================================================== */

  public void updateUser(BwUser user) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public void addUser(BwUser user) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwUser getUser(int id) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public BwUser getUser(String user) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public Collection getInstanceOwners() throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                   Access
   * ==================================================================== */

  public void changeAccess(BwShareableDbentity ent,
                           Collection aces) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public CurrentAccess checkAccess(BwShareableDbentity ent, int desiredAccess,
                                   boolean returnResult) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                   Timezones
   * ==================================================================== */

  public void saveTimeZone(String tzid, VTimeZone vtz) throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public VTimeZone getTimeZone(final String id,
                               BwUser owner) throws CalFacadeException {
    return null;
  }

  public Collection getTimeZones() throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public Collection getPublicTimeZones() throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public void clearPublicTimezones() throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                   Calendars and search
   * ==================================================================== */

  public BwCalendar getPublicCalendars() throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public Collection getPublicCalendarCollections() throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwCalendar getCalendars() throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public BwCalendar getCalendars(BwUser user,
                                 int desiredAccess) throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public Collection getCalendarCollections() throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public Collection getAddContentPublicCalendarCollections()
          throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public Collection getAddContentCalendarCollections()
          throws CalFacadeException {
    if (currentMode == CalintfDefs.guestMode) {
      return new TreeSet();
    }

    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwCalendar getCalendar(int val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwCalendar getCalendar(String path,
                                int desiredAccess) throws CalFacadeException{
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwCalendar getDefaultCalendar(BwUser user) throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public BwCalendar getSpecialCalendar(BwUser user,
                                       int calType,
                                       boolean create) throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public void addCalendar(BwCalendar val, String parentPath) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void updateCalendar(BwCalendar val) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public void changeAccess(BwCalendar cal,
                           Collection aces) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public boolean deleteCalendar(BwCalendar val) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public boolean checkCalendarRefs(BwCalendar val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
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
    throw new CalFacadeUnimplementedException();
  }

  public void updateFilter(BwFilter val) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                   Categories
   * ==================================================================== */

  public Collection getCategories(BwUser owner, BwUser creator)
        throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwCategory getCategory(int id) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwCategory findCategory(BwCategory val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void addCategory(BwCategory val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void updateCategory(BwCategory val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public boolean deleteCategory(BwCategory val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public Collection getCategoryRefs(BwCategory val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                   Locations
   * ==================================================================== */

  public Collection getLocations(BwUser owner, BwUser creator)
        throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwLocation getLocation(int id) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwLocation findLocation(BwLocation val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void addLocation(BwLocation val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void updateLocation(BwLocation val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public boolean deleteLocation(BwLocation val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public Collection getLocationRefs(BwLocation val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                   Sponsors
   * ==================================================================== */

  public Collection getSponsors(BwUser owner, BwUser creator)
        throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwSponsor getSponsor(int id) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwSponsor findSponsor(BwSponsor val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void addSponsor(BwSponsor val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void updateSponsor(BwSponsor val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public boolean deleteSponsor(BwSponsor val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public Collection getSponsorRefs(BwSponsor val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
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
    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                   Events
   * ==================================================================== */

  public CoreEventInfo getEvent(int id) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public Collection getEvent(BwCalendar calendar, String guid, String rid,
                             int recurRetrieval) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public Collection getEvents(BwCalendar calendar, BwFilter filter,
                              BwDateTime startDate, BwDateTime endDate,
                              int recurRetrieval,
                              boolean freeBusy,
                              boolean allCalendars) throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public void addEvent(BwEvent val,
                       Collection overrides) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public void updateEvent(BwEvent val) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public DelEventResult deleteEvent(BwEvent val) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public Collection getDeletedProxies() throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  public Collection getDeletedProxies(BwCalendar cal) throws CalFacadeException {
    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                       Caldav support
   * Caldav as it stands at the moment requires that we save the arbitary
   * names clients might assign to events.
   * ==================================================================== */

  public Collection getEventsByName(BwCalendar cal, String val)
          throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
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

    throw new CalFacadeUnimplementedException();
  }

  public void addSynchInfo(BwSynchInfo val) throws CalFacadeException {
    checkOpen();

    if (debug) {
      getLogger().debug("addSynchInfo for user=" + val.getUser() +
                        " deviceId=" + val.getDeviceId());
    }

    throw new CalFacadeUnimplementedException();
  }

  public void updateSynchInfo(BwSynchInfo val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public BwSynchState getSynchState(BwEvent ev)
      throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public Collection getDeletedSynchStates() throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void addSynchState(BwSynchState val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void updateSynchState(BwSynchState val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public int setSynchState(BwEvent ev, int state)
        throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void getSynchData(BwSynchState val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void setSynchData(BwSynchState val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void updateSynchStates() throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                       Alarms
   * ==================================================================== */

  public Collection getAlarms(BwEvent event, BwUser user) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void addAlarm(BwAlarm val) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public void updateAlarm(BwAlarm val) throws CalFacadeException {
    checkOpen();
    throw new CalFacadeUnimplementedException();
  }

  public Collection getUnexpiredAlarms(BwUser user) throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  public Collection getUnexpiredAlarms(BwUser user, long triggerTime)
          throws CalFacadeException {
    checkOpen();

    throw new CalFacadeUnimplementedException();
  }

  /* ====================================================================
   *                   Free busy
   * ==================================================================== */
}

