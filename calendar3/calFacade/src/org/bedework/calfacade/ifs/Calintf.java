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
package org.bedework.calfacade.ifs;

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
import org.bedework.calfacade.BwSynchInfo;
import org.bedework.calfacade.BwSynchState;
import org.bedework.calfacade.BwSystem;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.base.BwShareableDbentity;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.ifs.Groups;

import edu.rpi.cmt.access.Acl.CurrentAccess;

import java.util.Collection;
import java.util.List;

import net.fortuna.ical4j.model.component.VTimeZone;

/** This is the low level interface to the calendar database.
 *
 * <p>This interface provides a view of the data as seen by the supplied user
 * id. This may or may not be the actual authenticated user of whatever
 * application is driving it.
 *
 * <p>This is of particular use for public events administration. A given
 * authenticated user may be the member of a number of groups, and this module
 * will be initialised with the id of one of those groups. At some point
 * the authenticated user may choose to switch identities to manage a different
 * group.
 *
 * <p>The UserAuth object returned by getUserAuth usually represents the
 * authenticated user and determines the rights that user has.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public interface Calintf extends CalendarsI, EventsI {
  /** Must be called to initialise the new object.
   *
   * @param systemName  Used to retrieve configuration about systems.
   * @param url         String url to which we are connecting
   * @param authenticatedUser    String authenticated user of the application
   *                             or null for guest
   * @param user        String user we are acting as. If null we use authUser
   * @param publicAdmin boolean true if this is a public events admin app
   * @param groups      Object allowing interface to determine user groups.
   * @param synchId     non-null if this is for synchronization. Identifies the
   *                    client end.
   * @param debug       boolean true to turn on debugging trace
   * @return boolean    true if the authUser was added to the db
   * @throws CalFacadeException
   */
  public boolean init(String systemName,
                      String url,
                      String authenticatedUser,
                      String user,
                      boolean publicAdmin,
                      Groups groups,
                      String synchId,
                      boolean debug) throws CalFacadeException;

  /** Retrieve systemName supplied at init
   *
   * @return String name
   */
  public String getSystemName();

  /** Can be called after init to flag the arrival of a user.
   *
   * @param val       true for a super user
   * @throws CalFacadeException
   */
  public void logon(BwUser val) throws CalFacadeException;

  /** Called after init to flag this user as a super user.
   *
   * @param val       true for a super user
   */
  public void setSuperUser(boolean val);

  /** Called after init to flag this user as a super user.
   *
   * @return boolean true if super user
   */
  public boolean getSuperUser();

  /** Get the current system (not db) stats
   *
   * @return BwStats object
   * @throws CalFacadeException if not admin
   */
  public BwStats getStats() throws CalFacadeException;

  /** Enable/disable db statistics
   *
   * @param enable       boolean true to turn on db statistics collection
   * @throws CalFacadeException if not admin
   */
  public void setDbStatsEnabled(boolean enable) throws CalFacadeException;

  /**
   *
   * @return boolean true if statistics collection enabled
   * @throws CalFacadeException if not admin
   */
  public boolean getDbStatsEnabled() throws CalFacadeException;

  /** Dump db statistics
   *
   * @throws CalFacadeException if not admin
   */
  public void dumpDbStats() throws CalFacadeException;

  /** Get db statistics
   *
   * @return Collection of BwStats.StatsEntry objects
   * @throws CalFacadeException if not admin
   */
  public Collection getDbStats() throws CalFacadeException;

  /** Get the system pars using name supplied at init
   *
   * @return BwSystem object
   * @throws CalFacadeException if not admin
   */
  public BwSystem getSyspars() throws CalFacadeException;

  /** Get the system pars given name
   *
   * @param name
   * @return BwSystem object
   * @throws CalFacadeException if not admin
   */
  public BwSystem getSyspars(String name) throws CalFacadeException;

  /** Update the system pars
   *
   * @param val BwSystem object
   * @throws CalFacadeException if not admin
   */
  public void updateSyspars(BwSystem val) throws CalFacadeException;

  /** Get the timezones cache object
   *
   * @return CalTimezones object
   * @throws CalFacadeException if not admin
   */
  public CalTimezones getTimezonesHandler() throws CalFacadeException;

  /** Get information about this interface
   *
   * @return CalintfInfo
   * @throws CalFacadeException
   */
  public CalintfInfo getInfo() throws CalFacadeException;

  /** Get the state of the debug flag
   *
   * @return boolean
   * @throws CalFacadeException
   */
  public boolean getDebug() throws CalFacadeException;

  /** Switch to the given non-null user. The access rights are determined by
   * the previous call to init.
   *
   * @param val         String user id
   * @throws CalFacadeException
   */
  public void setUser(String val) throws CalFacadeException;

  /** Flush any backend data we may be hanging on to ready for a new
   * sequence of interactions. This is intended to help with web based
   * applications, especially those which follow the action/render url
   * pattern used in portlets.
   *
   * <p>A flushAll can discard a back end session allowing open to get a
   * fresh one. close() can then be either a no-op or something like a
   * hibernate disconnect.
   *
   * <p>This method should be called before calling open (or after calling
   * close).
   *
   * @throws CalFacadeException
   */
  public void flushAll() throws CalFacadeException;

  /** Signal the start of a sequence of operations. These overlap transactions
   * in that there may be 0 to many transactions started and ended within an
   * open/close call and many open/close calls within a transaction.
   *
   * <p>The open close methods are mainly associated with web style requests
   * and open will usually be called early in the incoming request handling
   * and close will always be called on the way out allowing the interface an
   * opportunity to reacquire (on open) and release (on close) any resources
   * such as connections.
   *
   * @throws CalFacadeException
   */
  public void open() throws CalFacadeException;

  /** Call on the way out after handling a request..
   *
   * @throws CalFacadeException
   */
  public void close() throws CalFacadeException;

  /** Start a (possibly long-running) transaction. In the web environment
   * this might do nothing. The endTransaction method should in some way
   * check version numbers to detect concurrent updates and fail with an
   * exception.
   *
   * @throws CalFacadeException
   */
  public void beginTransaction() throws CalFacadeException;

  /** End a (possibly long-running) transaction. In the web environment
   * this should in some way check version numbers to detect concurrent updates
   * and fail with an exception.
   *
   * @throws CalFacadeException
   */
  public void endTransaction() throws CalFacadeException;

  /** Call if there has been an error during an update process.
   *
   * @throws CalFacadeException
   */
  public void rollbackTransaction() throws CalFacadeException;

  /** An implementation specific method allowing access to the underlying
   * persisitance engine. This may return, for example, a Hibernate session,
   *
   * @return Object
   * @throws CalFacadeException
   */
  public Object getDbSession() throws CalFacadeException;

  /** Refresh the users events cache
   *
   * @throws CalFacadeException
   */
  public void refreshEvents() throws CalFacadeException;

  /* ====================================================================
   *                   Users
   * ==================================================================== */

  /** Returns a value object representing the current user.
   *
   * @return BwUser       representing the current user
   * @throws CalFacadeException
   */
  public BwUser getUser() throws CalFacadeException;

  /** Update the current user entry
   *
   * @throws CalFacadeException
   */
  public void updateUser() throws CalFacadeException;

  /** Update the given user entry
   *
   * @param user   BwUser object to add.
   * @throws CalFacadeException
   */
  public void updateUser(BwUser user) throws CalFacadeException;

  /** Add a user to the database
   *
   * @param user   BwUser object to add.
   * @throws CalFacadeException
   */
  public void addUser(BwUser user) throws CalFacadeException;

  /** Returns a value object representing the user with the given id.
   *
   * @param id            int id of user entry
   * @return UserVO       representing the current user
   * @throws CalFacadeException
   */
  public BwUser getUser(int id) throws CalFacadeException;

  /** Returns a value object representing the user with the given account name.
   *
   * @param account       string account name of user entry
   * @return UserVO       representing the current user
   * @throws CalFacadeException
   */
  public BwUser getUser(String account) throws CalFacadeException;

  /** Returns a Collection of instance owners.
   *
   * @return Collection    of BwUser
   * @throws CalFacadeException
   */
  public Collection getInstanceOwners() throws CalFacadeException;

  /* ====================================================================
   *                   Global parameters
   * ==================================================================== */

  /** Get the value of the current public events timestamp.
   *
   * @return long       current timestamp value
   * @throws CalFacadeException
   */
  public long getPublicLastmod() throws CalFacadeException;

  /** Get a name uniquely.identifying this system. This should take the form <br/>
   *   name@host
   * <br/>where<ul>
   * <li>name identifies the particular calendar system at the site</li>
   * <li>host part identifies the domain of the site.</li>..
   * </ul>
   *
   * @return String    globally unique system identifier.
   * @throws CalFacadeException
   */
  public String getSysid() throws CalFacadeException;

  /* ====================================================================
   *                   Access
   * ==================================================================== */

  /** Change the access to the given calendar entity.
   *
   * @param ent      BwShareableDbentity
   * @param aces     Collection of ace
   * @throws CalFacadeException
   */
  public void changeAccess(BwShareableDbentity ent,
                           Collection aces) throws CalFacadeException;

  /** Check the access for the given entity. Returns the current access
   * or null or optionally throws a no access exception.
   *
   * @param ent
   * @param desiredAccess
   * @param returnResult
   * @return CurrentAccess
   * @throws CalFacadeException if returnResult false and no access
   */
  public CurrentAccess checkAccess(BwShareableDbentity ent, int desiredAccess,
                                   boolean returnResult) throws CalFacadeException;

  /* ====================================================================
   *                   Timezones
   * ==================================================================== */

  /** Save a timezone definition in the database. The timezone is in the
   * form of a complete calendar definition containing a single VTimeZone
   * object.
   *
   * <p>The calendar must be on a path from a timezone root
   *
   * @param tzid
   * @param vtz
   * @throws CalFacadeException
   */
  public void saveTimeZone(String tzid, VTimeZone vtz
                           ) throws CalFacadeException;

  /** Get a vtimezone object given the id and the owner of the event.
   *
   * <p>For a user will search local timezone defs first then public defs.
   *
   * <p>For public events searches only public.
   *
   * @param id
   * @param owner     expected owner of private timezone or null for current user
   * @return VTimeZone
   * @throws CalFacadeException
   */
  public VTimeZone getTimeZone(final String id,
                               BwUser owner) throws CalFacadeException;

  /** Get all known vtimezone objects.
   *
   * <p>For a user will replace public defs with local timezone defs with the
   * same id.
   *
   * <p>For public events return only public.
   *
   * @return Collection
   * @throws CalFacadeException
   */
  public Collection getTimeZones() throws CalFacadeException;

  /** Get all user vtimezone objects.
   *
   * @return Collection
   * @throws CalFacadeException
   */
  public Collection getUserTimeZones() throws CalFacadeException;

  /** Get all public vtimezone objects.
   *
   * @return Collection
   * @throws CalFacadeException
   */
  public Collection getPublicTimeZones() throws CalFacadeException;

  /* * Add a timezone collection object
   *
   * <p>We use calendar objects which will be added to the db. For a public
   * object the root must be the public timezones root. For a user it must be
   * below the user timezone root.
   *
   * <p>We do not apply those restrictions which are in place for calendar
   * collections. These collections of timezone objects are for internal use
   * only.
   *
   * <p>Name must be unique at this level, i.e. all paths must be unique
   *
   * @param  val     CalendarVO new object
   * @param  parent  CalendarVO object
   * /
  public void addTimezoneCollection(CalendarVO val, CalendarVO parent)
          throws CalFacadeException;*/

  /** Clear all public timezone collection objects
   *
   * <p>Will remove all public timezones in preparation for a replacement
   * (presumably)
   *
   * @throws CalFacadeException
   */
  public void clearPublicTimezones() throws CalFacadeException;

  /** Get all of the timezone ids.
   *
   * @return List  of TimeZoneInfo
   * @throws CalFacadeException
   */
  public List getTimeZoneIds() throws CalFacadeException;

  /* ====================================================================
   *                   Filters and search
   * ==================================================================== */

  /** Set a search filter using the suppplied search string
   *
   * @param val    String search parameters
   * @throws CalFacadeException
   */
  public void setSearch(String val) throws CalFacadeException;

  /** Return the current search string.
   *
   * @return  String     search parameters
   * @throws CalFacadeException
   */
  public String getSearch() throws CalFacadeException;

  /** Add a filter to the database. All references must be set.
   *
   * @param val
   * @throws CalFacadeException
   */
  public void addFilter(BwFilter val) throws CalFacadeException;

  /** Update a filter
   *
   * @param  val           FilterVO object to upate
   * @exception CalFacadeException If there's a problem
   */
  public void updateFilter(BwFilter val) throws CalFacadeException;

  /* ====================================================================
   *                   Categories
   * ==================================================================== */

  /** Return all categories satisfying the conditions.
   *
   * <p>Returns an empty collection for no categories.
   *
   * <p>The returned objects are not persistant objects but the result of a
   * report query.
   *
   * @param  owner          non-null means limit to this
   * @param  creator        non-null means limit to this
   * @return Collection     of category value objects
   * @throws CalFacadeException
   */
  public Collection getCategories(BwUser owner, BwUser creator)
        throws CalFacadeException;

  /** Return a category with the given id
   *
   * @param id     int id of the category
   * @return BwCategory object representing the category in question
   *                     null if it doesn't exist.
   * @throws CalFacadeException
   */
  public BwCategory getCategory(int id) throws CalFacadeException;

  /** Return a category matching the given value or null. This requires the
   * key fields, word and owner to be set.
   *
   * @param val    BwCategory object
   * @return BwCategory object representing the category in question
   *                     null if it doesn't exist.
   * @throws CalFacadeException
   */
  public BwCategory findCategory(BwCategory val) throws CalFacadeException;

  /** Add a Category to the database. The id will be set in the parameter
   * object.
   *
   * @param val   BwCategory object to be added
   * @throws CalFacadeException
   */
  public void addCategory(BwCategory val) throws CalFacadeException;

  /** Update a category in the database.
   *
   * @param val   BwCategory object to be replaced
   * @throws CalFacadeException
   */
  public void updateCategory(BwCategory val) throws CalFacadeException;

  /** Delete the given category
   *
   * @param val      BwCategory object to be deleted
   * @return boolean false if it didn't exist, true if it was deleted.
   * @throws CalFacadeException
   */
  public boolean deleteCategory(BwCategory val) throws CalFacadeException;

  /** Return ids of events referencing the given entity
   *
   * @param val      BwCategory object to be checked
   * @return Collection of Integer
   * @throws CalFacadeException
   */
  public Collection getCategoryRefs(BwCategory val) throws CalFacadeException;

  /* ====================================================================
   *                   Locations
   * ==================================================================== */

  /** Return all locations satisfying the conditions.
   *
   * <p>Returns an empty collection for no locations.
   *
   * <p>The returned objects are not persistant objects but the result of a
   * report query.
   *
   * @param  owner          non-null means limit to this
   * @param  creator        non-null means limit to this
   * @return Collection     of location value objects
   * @throws CalFacadeException
   */
  public Collection getLocations(BwUser owner, BwUser creator)
        throws CalFacadeException;

  /** Return a location with the given id
   *
   * @param id     int id of the location
   * @return LocationVO object representing the location in question
   *                     null if it doesn't exist.
   * @throws CalFacadeException
   */
  public BwLocation getLocation(int id) throws CalFacadeException;

  /** Return a location matching the given value or null. This requires the
   * key fields, address and owner to be set.
   *
   * @param val    BwLocation object
   * @return BwLocation object representing the location in question
   *                     null if it doesn't exist.
   * @throws CalFacadeException
   */
  public BwLocation findLocation(BwLocation val) throws CalFacadeException;

  /** Add a location to the database. The id will be set in the parameter
   * object.
   *
   * @param val   BwLocation object to be added
   * @throws CalFacadeException
   */
  public void addLocation(BwLocation val) throws CalFacadeException;

  /** Update a location in the database.
   *
   * @param val   LocationVO object to be replaced
   * @throws CalFacadeException
   */
  public void updateLocation(BwLocation val) throws CalFacadeException;

  /** Delete a location
   *
   * @param val      LocationVO object to be deleted
   * @return boolean false if it din't exist, true if it was deleted.
   * @throws CalFacadeException
   */
  public boolean deleteLocation(BwLocation val) throws CalFacadeException;

  /** Return ids of events referencing the given location
   *
   * @param val      BwLocation object to be checked
   * @return Collection of Integer
   * @throws CalFacadeException
   */
  public Collection getLocationRefs(BwLocation val) throws CalFacadeException;

  /* ====================================================================
   *                   Sponsors
   * ==================================================================== */

  /** Return all sponsors satisfying the conditions.
   *
   * <p>Returns an empty collection for no sponsors.
   *
   * <p>The returned objects are not persistant objects but the result of a
   * report query.
   *
   * @param  owner          non-null means limit to this
   * @param  creator        non-null means limit to this
   * @return Collection     of sponsor value objects
   * @throws CalFacadeException
   */
  public Collection getSponsors(BwUser owner, BwUser creator)
        throws CalFacadeException;

  /** Return a sponsor with the given id
   *
   * @param id     int id of the sponsor
   * @return SponsorVo object representing the sponsor in question
   *                     null if it doesn't exist.
   * @throws CalFacadeException
   */
  public BwSponsor getSponsor(int id) throws CalFacadeException;

  /** Return a sponsor matching the given value or null. This requires the
   * key fields, name and owner to be set.
   *
   * @param val    BwSponsor object
   * @return BwSponsor object representing the sponsor in question
   *                     null if it doesn't exist.
   * @throws CalFacadeException
   */
  public BwSponsor findSponsor(BwSponsor val) throws CalFacadeException;

  /** Add a sponsor to the database. The id will be set in the parameter
   * object.
   *
   * @param val   SponsorVO object to be added
   * @throws CalFacadeException
   */
  public void addSponsor(BwSponsor val) throws CalFacadeException;

  /** Update a sponsor in the database.
   *
   * @param val   SponsorVO object to be replaced
   * @throws CalFacadeException
   */
  public void updateSponsor(BwSponsor val) throws CalFacadeException;

  /** Delete a sponsor
   *
   * @param val      SponsorVO object to be deleted
   * @return boolean false if it didn't exist, true if it was deleted.
   * @throws CalFacadeException
   */
  public boolean deleteSponsor(BwSponsor val) throws CalFacadeException;

  /** Return ids of events referencing the given sponsor
   *
   * @param val      BwSponsor object to be checked
   * @return Collection of Integer
   * @throws CalFacadeException
   */
  public Collection getSponsorRefs(BwSponsor val) throws CalFacadeException;

  /* ====================================================================
   *                   Free busy
   * ==================================================================== */

  /**
   * @param cal
   * @param who
   * @param start
   * @param end
   * @param granularity
   * @param returnAll
   * @param ignoreTransparency
   * @return  BwFreeBusy object representing the calendar (or principals)
   *          free/busy
   * @throws CalFacadeException
   */
  public BwFreeBusy getFreeBusy(BwCalendar cal, BwPrincipal who,
                                BwDateTime start, BwDateTime end,
                                BwDuration granularity,
                                boolean returnAll,
                                boolean ignoreTransparency)
          throws CalFacadeException;

  /* ====================================================================
   *                   Synchronization
   * ==================================================================== */

  /** XXX temp I think
   * Retrieve event proxies in the given calendar - they will be used to remove events
   * from result sets.
   *
   * @return Collection of CoreEventInfo objects
   * @throws CalFacadeException
   */
  public Collection getDeletedProxies() throws CalFacadeException;

  /* ====================================================================
   *                   Synchronization
   * ==================================================================== */

  /** Get the synch info for the current device and user.
   *
   * @return SynchInfoVO object or null.
   * @throws CalFacadeException
   */
   public BwSynchInfo getSynchInfo() throws CalFacadeException;

  /** Add the synch info for the current device and user.
   *
   * @param val    SynchInfoVO object to add
   * @throws CalFacadeException
   */
  public void addSynchInfo(BwSynchInfo val) throws CalFacadeException;

  /** Update the synch info for the current device and user. There must be
   * exactly one object to update.
   *
   * @param val    SynchInfoVO object to update
   * @throws CalFacadeException
   */
  public void updateSynchInfo(BwSynchInfo val)
      throws CalFacadeException;

  /** Return synchronization state for the given event in the current
   * synchronization context as defined by the initialisation parameters,
   * that is the user and synchId. If the event has never been involved in a
   * synch process there will be no related synch state object.
   *
   * @param ev            EventVO object .
   * @return SynchStateVO object or null.
   * @throws CalFacadeException
   */
  public BwSynchState getSynchState(BwEvent ev)
      throws CalFacadeException;

  /** Get the deleted synch states for the current synch.
   *
   * @return Collection of synch state objects (possibly empty)
   * @throws CalFacadeException
   */
  public Collection getDeletedSynchStates() throws CalFacadeException;

  /** Add the synch state for the given event and user.
   *
   * @param val      SynchStateVO object.
   * @throws CalFacadeException
   */
  public void addSynchState(BwSynchState val)
      throws CalFacadeException;

  /** Update the synch state for the given event and user. There must be
   * exactly one object to update.
   *
   * @param val    SynchStateVO object with associated event and user
   * @throws CalFacadeException
   */
  public void updateSynchState(BwSynchState val)
      throws CalFacadeException;

  /** Update the synch state for the given event. There may be many objects
   * to update.
   *
   * <p>In general it only makes sense to call this method to set the state
   * to modified or deleted. A modified event is modified for any user who
   * has access to it. On the other hand, an event can only be synchronized
   * for a single user.
   *
   * @param ev     EventVO representing associated event
   * @param state  int new state - defined in SynchStateVO
   * @return int   number of updated entries.
   * @throws CalFacadeException
   */
  public int setSynchState(BwEvent ev, int state)
        throws CalFacadeException;

  /** Get the synch data associated with the given object..
   *
   * @param val    SynchStateVO object
   * @throws CalFacadeException
   */
  public void getSynchData(BwSynchState val) throws CalFacadeException;

  /** Set the synch state and data for the given user and event.
   * There may be zero to many objects to update.
   *
   * @param val    SynchStateVO object with associated event and user
   * @throws CalFacadeException
   */
  public void setSynchData(BwSynchState val) throws CalFacadeException;

  /** Update the synch states for the current user and device.
   *
   * <p>This is called at the termination of synchronization to set any state
   * objects appropriately.
   *
   * <p><table cols="2">
   * <th><td>Old state</td><td>New state</td></th>
   * <tr><td>UNKNOWN</td><td>SYNCHRONIZED</td></tr>
   * <tr><td>SYNCHRONIZED</td><td>SYNCHRONIZED</td></tr>
   * <tr><td>NEW</td><td>SYNCHRONIZED</td></tr>
   * <tr><td>MODIFIED</td><td>SYNCHRONIZED</td></tr>
   * <tr><td>DELETED</td><td>entry deleted</td></tr>
   * <tr><td>CLIENT_DELETED</td><td>unchanged</td></tr>
   * <tr><td>CLIENT_DELETED_UNDELIVERED</td><td>CLIENT_DELETED</td></tr>
   * <tr><td>CLIENT_MODIFIED</td><td>unchanged</td></tr>
   * <tr><td>CLIENT_MODIFIED_UNDELIVERED</td><td>CLIENT_MODIFIED</td></tr>
   * </table>
   *
   * @throws CalFacadeException
   */
  public void updateSynchStates() throws CalFacadeException;

  /* ====================================================================
   *                       Alarms
   * This is currently under development at RPI
   * ==================================================================== */

  /** Get any alarms for the given event and user.
   *
   * @param event      EventVO event
   * @param user       UserVO representing user
   * @return Collection of ValarmVO.
   * @throws CalFacadeException
   */
  public Collection getAlarms(BwEvent event, BwUser user) throws CalFacadeException;

  /** Create an alarm.
   *
   * @param val   ValarmVO  object .
   * @throws CalFacadeException
   */
  public void addAlarm(BwAlarm val) throws CalFacadeException;

  /** Update an alarm.
   *
   * @param val   ValarmVO  object .
   * @throws CalFacadeException
   */
  public void updateAlarm(BwAlarm val) throws CalFacadeException;

  /** Return all unexpired alarms. If user is null all unexpired alarms will
   * be retrieved.
   *
   * @param user
   * @return Collection
   * @throws CalFacadeException
   */
  public Collection getUnexpiredAlarms(BwUser user) throws CalFacadeException;

  /** Return all unexpired alarms before a given time. If user is null all
   * unexpired alarms will be retrieved.
   *
   * @param user
   * @param triggerTime
   * @return Collection
   * @throws CalFacadeException
   */
  public Collection getUnexpiredAlarms(BwUser user, long triggerTime)
          throws CalFacadeException;
}

