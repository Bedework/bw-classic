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
package org.bedework.dumprestore.restore;

import org.bedework.appcommon.TimeZonesParser;
import org.bedework.appcommon.configs.DumpRestoreConfig;
import org.bedework.calfacade.BwAttendee;
import org.bedework.calfacade.BwEventAnnotation;
import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwOrganizer;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwSystem;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.BwUserInfo;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwSubscription;
import org.bedework.calfacade.svc.BwView;

import edu.rpi.cct.uwcal.access.Access;
import edu.rpi.cct.uwcal.access.Ace;
import edu.rpi.cct.uwcal.access.Acl;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

/** Globals for the restore phase
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class RestoreGlobals {
  /** This is not the way to use the digester. We could possibly build the xml
   * rules directly from the hibernate schema or from java annotations.
   *
   * For the moment I just need to get this going.
   */
  public boolean inOwnerKey;

  /** Set false at start of entity, set true on entity error
   */
  public boolean entityError;

  /** Config properties from options file.
   */
  public DumpRestoreConfig config;

  /** Map user with id of zero on to this id - fixes oversight */
  public static int mapUser0 = 1;

  /** System parameters object */
  public BwSystem syspars = new BwSystem();

  /* Used when processing timezones */
  private CalTimezones tzcache;

  /** The super admin group */
  public BwGroup superGroup;

  /** */
  public BwCalendar publicCalRoot;
  /** */
  public int nextCalKey = 1;

  /** Even number of elements, old-name followd by new-name
   */
  public ArrayList fixedCalendarNames = new ArrayList();

  /** */
  public BwCalendar defaultPublicCal;

  /** User entry for owner of public entities.
   */
  public BwUser publicUser;

  private String defaultPublicAccess;
  private String defaultPersonalAccess;

  /** Incremented if we can't map something */
  public int calMapErrors = 0;

  /** Integer filter key -> cal object */
  public HashMap filterToCal = new HashMap();

  /** For each of these we update events to have the appropriate calendar id.
   * Any event which already has a calendar id turned up in two calendars.
   */
  public Collection calLeaves = new ArrayList();

  /** If true stop restore on any error, otherwise just flag it.
   */
  public boolean failOnError = false;

  /** Incremented for each start datetime but end date. We drop the end.
   */
  public int fixedNoEndTime;

  /** Used when converting from 2.3.2 */
  public BwUserInfo userInfo; /* 2.3.2 */

  /** counter */
  public int filters;

  /** counter */
  public int users;

  /** counter */
  public int timezones;

  /** counter */
  public int subscribedUsers;

  /** counter */
  public int calendars;

  /** counter */
  public int subscriptions;

  /** counter */
  public int views;

  /** counter */
  public int locations;

  /** counter */
  public int sponsors;

  /** counter */
  public int organizers;

  /** counter */
  public int attendees;

  /** counter */
  public int valarms;

  /** counter */
  public int categories;

  /** counter */
  public int authusers;

  /** counter */
  public int events;
  /** counter */
  public int eventRefs;

  /** counter */
  public int adminGroups;

  /** counter */
  public int userPrefs;

  /** counter */
  public int alarms;

  /** If true we should discard all but users in onlyUsers
   * This helps when building demo data
   */
  public boolean onlyUsers;

  /** Users we preserve */
  public HashMap onlyUsersMap = new HashMap();

  /**
   */
  public static class EventKeyMap extends HashMap {
    /**
     * @param keyid
     * @param eventid
     */
    public void put(int keyid, int eventid) {
      Integer key = new Integer(keyid);

      ArrayList al = (ArrayList)get(key);
      if (al == null) {
        al = new ArrayList();
        put(key, al);
      }

      al.add(new Integer(eventid));
    }

    /**
     * @param keyid
     * @return Collection
     */
    public Collection getEventids(int keyid) {
      return (Collection)get(new Integer(keyid));
    }
  }

  /** For 2.3.2 conversion. Map a category integer key to a calendar object.
   * As we restore events we retrieve the calendar based on the keyword set
   * in the event.
   */
  public static class CatCalMap extends HashMap {
    /**
     * @param keyid
     * @param cal
     */
    public void put(int keyid, BwCalendar cal) {
      Integer key = new Integer(keyid);

      put(key, cal);
    }

    /**
     * @param keyid
     * @return BwCalendar
     */
    public BwCalendar get(int keyid) {
      return (BwCalendar)get(new Integer(keyid));
    }
  }

  /** Save ids of alias events and their targets
   */
  public static class AliasMap extends HashMap {
    /**
     * @param val
     */
    public void put(BwEventAnnotation val) {
      put(new Integer(val.getId()), new Integer(val.getTarget().getId()));
    }
  }

  /**
   */
  public static class UserMap extends HashMap {
    HashMap nameMap = new HashMap();

    /**
     * @param val
     */
    public void put(BwUser val) {
      int id = val.getId();
      if (id ==0) {
        id = mapUser0;
        val.setId(id);
      }

      Integer keyid = new Integer(id);
      if (get(keyid) != null) {
        throw new RuntimeException("User already in table with id " + id);
      }
      put(keyid, val);
      nameMap.put(val.getAccount(), val);
    }

    /**
     * @param id
     * @return BwUser
     */
    public BwUser get(int id) {
      if (id ==0) {
        id = mapUser0;
      }
      return (BwUser)get(new Integer(id));
    }

    /**
     * @param account
     * @return BwUser
     */
    public BwUser get(String account) {
      return (BwUser)nameMap.get(account);
    }
  }

  /**
   */
  public static class CalendarMap extends HashMap {
    /**
     * @param val
     */
    public void put(BwCalendar val) {
      put(val.getPath(), val);
    }

    /**
     * @param path
     * @return BwCalendar
     */
    public BwCalendar get(String path) {
      return (BwCalendar)get(path);
    }
  }

  /**
   */
  public static class CategoryMap extends HashMap {
    /**
     * @param val
     */
    public void put(BwCategory val) {
      put(new Integer(val.getId()), val);
    }

    /**
     * @param id
     * @return BwCategory
     */
    public BwCategory get(int id) {
      return (BwCategory)get(new Integer(id));
    }
  }

  /**
   */
  public static class LocationMap extends HashMap {
    /**
     * @param val
     */
    public void put(BwLocation val) {
      put(new Integer(val.getId()), val);
    }

    /**
     * @param id
     * @return BwLocation
     */
    public BwLocation get(int id) {
      return (BwLocation)get(new Integer(id));
    }
  }

  /**
   */
  public static class SponsorMap extends HashMap {
    /**
     * @param val
     */
    public void put(BwSponsor val) {
      put(new Integer(val.getId()), val);
    }

    /**
     * @param id
     * @return BwSponsor
     */
    public BwSponsor get(int id) {
      return (BwSponsor)get(new Integer(id));
    }
  }

  /**
   */
  public static class AttendeeMap extends HashMap {
    /**
     * @param val
     */
    public void put(BwAttendee val) {
      put(new Integer(val.getId()), val);
    }

    /**
     * @param id
     * @return BwAttendee
     */
    public BwAttendee get(int id) {
      return (BwAttendee)get(new Integer(id));
    }
  }

  /**
   */
  public static class OrganizerMap extends HashMap {
    /**
     * @param val
     */
    public void put(BwOrganizer val) {
      put(new Integer(val.getId()), val);
    }

    /**
     * @param id
     * @return BwOrganizer
     */
    public BwOrganizer get(int id) {
      return (BwOrganizer)get(new Integer(id));
    }
  }

  /**
   */
  public static class FilterMap extends HashMap {
    /**
     * @param val
     */
    public void put(BwFilter val) {
      put(new Integer(val.getId()), val);
    }

    /**
     * @param id
     * @return BwFilter
     */
    public BwFilter get(int id) {
      return (BwFilter)get(new Integer(id));
    }
  }

  /** */
  public SubscriptionsMap subscriptionsTbl = new SubscriptionsMap();
  /** */
  public EventKeyMap eventKeysTbl = new EventKeyMap();

  /** */
  public CatCalMap catCalTbl = new CatCalMap();
  /** */
  public AliasMap aliasTbl = new AliasMap();

  /** < 3.1? */
  public UserMap usersTbl = new UserMap();

  /** */
  public OwnerMap ownersTbl = new OwnerMap();
  /** */
  public FilterMap filtersTbl = new FilterMap();
  /** */
  public CategoryMap categoriesTbl = new CategoryMap();
  /** */
  public LocationMap locationsTbl = new LocationMap();
  /** */
  public SponsorMap sponsorsTbl = new SponsorMap();
  /** */
  public OrganizerMap organizersTbl = new OrganizerMap();
  /** */
  public AttendeeMap attendeesTbl = new AttendeeMap();

  /** for 2.3.2 */
  public HashMap defaultCalendars = new HashMap();
  /** for 2.3.2 */
  public HashMap trashCalendars = new HashMap();

  /** */
  public CalendarMap calendarsTbl = new CalendarMap();

  /** Subscription we are currently restoring */
  public BwSubscription curSub;

  /** View we are currently restoring */
  public BwView curView;

  /** Classes to stand in for 2.3.2 classes */
  public static class AliasFilter extends BwFilter {
  }

  /** */
  public RestoreIntf rintf;

  RestoreGlobals() {
  }

  /** This must be called after syspars has been initialised.
   *
   * @return CalTimezones object
   * @throws Throwable
   */
  public CalTimezones getTzcache() throws Throwable {
    if (tzcache != null) {
      return tzcache;
    }

    if (syspars.getTzid() == null) {
      throw new Exception("syspars.tzid not initialised");
    }

    tzcache = new TimezonesImpl(config.getDebug(), getPublicUser(), rintf);
    tzcache.setDefaultTimeZoneId(syspars.getTzid());

    if (config.getFrom2p3px() && (config.getTimezonesFilename() != null)) {
      // Populate from a file
      TimeZonesParser tzp = new TimeZonesParser(
             new FileInputStream(config.getTimezonesFilename()),
             config.getDebug());

      Collection tzis = tzp.getTimeZones();

      Iterator it = tzis.iterator();
      while (it.hasNext()) {
        TimeZonesParser.TimeZoneInfo tzi = (TimeZonesParser.TimeZoneInfo)it.next();

        tzcache.saveTimeZone(tzi.tzid, tzi.timezone);
        timezones++;
      }
    }

    return tzcache;
  }

  /** Get the account which owns public entities
   *
   * @return BwUser account
   * @throws Throwable if account name not defined
   */
  public BwUser getPublicUser() throws Throwable {
    if (publicUser != null) {
      return publicUser;
    }

    /* See if it's in the user map first. */

    if (syspars.getPublicUser() == null) {
      throw new Exception("publicUserAccount must be defined");
    }

    publicUser = usersTbl.get(syspars.getPublicUser());

    if (publicUser == null) {
      // Create it
      publicUser = new BwUser(syspars.getPublicUser());
      publicUser.setInstanceOwner(true);
      publicUser.setCategoryAccess(getDefaultPublicAccess());
      publicUser.setLocationAccess(getDefaultPublicAccess());
      publicUser.setSponsorAccess(getDefaultPublicAccess());

      // Reserved id 1 for this user.
      publicUser.setId(1);

      if (rintf != null) {
        rintf.restoreUser(publicUser);
      }

      usersTbl.put(publicUser);
    }

    return publicUser;
  }

  /** Get the super admin group
   *
   * @return BwGroup group
   * @throws Throwable if account name not defined
   */
  public BwGroup getSuperGroup() throws Throwable {
    if (superGroup != null) {
      return superGroup;
    }

    if (config.getSuperGroupName() == null) {
      throw new Exception("superGroupName must be defined");
    }

    // Create it
    BwAdminGroup sg = new BwAdminGroup(config.getSuperGroupName());
    sg.setGroupOwner(getPublicUser());
    sg.setOwner(getPublicUser());
    superGroup = sg;

    return superGroup;
  }

  /** Get the default public access
   *
   * @return String value for default access
   */
  public String getDefaultPublicAccess() {
    if (defaultPublicAccess == null) {
      try {
        Access a = new Access(config.getDebug());
        defaultPublicAccess = a.getDefaultPublicAccess();
        defaultPersonalAccess = a.getDefaultPublicAccess();
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }

    return defaultPublicAccess;
  }

  /**
   *
   * @return String default user access
   */
  public String getDefaultPersonalAccess() {
    if (defaultPersonalAccess == null) {
      // Use the other method to init.
      getDefaultPublicAccess();
    }

    return defaultPersonalAccess;
  }

  /** Used when creating a new system or updating from 2.3.2
   * Default access is set in the root and should give write content access
   * to admin groups.
   *
   * @return String default user access
   * @throws Throwable
   */
  public String getDefaultPublicCalendarsAccess() throws Throwable {
    Acl acl = new Acl(config.getDebug());

    /** all owner, read others, read unauthenticated, (read,writeContent) group=superGroup */
    acl.clear();
    acl.addAce(new Ace(null, false, Ace.whoTypeOwner, Access.all));
    acl.addAce(new Ace(null, false, Ace.whoTypeOther, Access.read));
    acl.addAce(new Ace(null, false, Ace.whoTypeUnauthenticated, Access.read));

    Ace rwcont = new Ace(config.getSuperGroupName(), false,
                        Ace.whoTypeGroup, Access.writeContent);
    rwcont.addPriv(Access.read);
    acl.addAce(rwcont);
    return new String(acl.encode());
  }

  /**
   *
   */
  public void stats() {
    System.out.println("              users: " + users);
    System.out.println("          timezones: " + timezones);
    System.out.println("    subscribedUsers: " + subscribedUsers);
    System.out.println("          calendars: " + calendars);
    System.out.println("      subscriptions: " + subscriptions);
    System.out.println("              views: " + views);
    System.out.println("          locations: " + locations);
    System.out.println("           sponsors: " + sponsors);
    System.out.println("         organizers: " + organizers);
    System.out.println("          attendees: " + attendees);
    System.out.println("             alarms: " + valarms);
    System.out.println("         categories: " + categories);
    System.out.println("          authusers: " + authusers);
    System.out.println("             events: " + events);
    System.out.println("          eventRefs: " + eventRefs);
    System.out.println("            filters: " + filters);
    System.out.println("        adminGroups: " + adminGroups);
    System.out.println("          userPrefs: " + userPrefs);
    System.out.println("             alarms: " + alarms);
    System.out.println(" ");
    System.out.println("    Fixed end times: " + fixedNoEndTime);
    System.out.println(" ");
    if (fixedCalendarNames.size() > 0) {
      System.out.println(" Following calendar names were fixed (old->new):");

      Iterator it = fixedCalendarNames.iterator();
      while (it.hasNext()) {
        System.out.println("\"" + it.next() + "\" -> \"" + it.next() + "\"");
      }
    }
  }

  /**
   * @param config
   */
  public void init(DumpRestoreConfig config) {
    this.config = config;
  }
}
