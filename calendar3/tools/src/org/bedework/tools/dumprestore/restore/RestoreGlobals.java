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

import org.bedework.calfacade.BwAttendee;
import org.bedework.calfacade.BwEventAnnotation;
import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwOrganizer;
import org.bedework.calfacade.BwSponsor;
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

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

/** Globals for the restore phase
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class RestoreGlobals {
  /** */
  public boolean debug;

  /** */
  public boolean debugEntity;

  /** */
  public CalTimezones timezones;

  /** True if we doing the conversion from 2.3.2 to hibernate (V3) */
  public boolean toHibernate;

  /** When converting put all admin groups into the new group with this name */
  public String superGroupName;

  /** The super admin group */
  public BwGroup superGroup;

  /** */
  public BwCalendar publicCalRoot;
  /** */
  public int nextCalKey = 1;

  /** Even number of elements, old-name followd by new-name
   */
  public Vector fixedCalendarNames = new Vector();

  /** If non-null we will set any events with no calendar to this one.
   * This is mainly to fix errors in the data. All events should have a calendar.
   */
  public String defaultPublicCalPath;
  /** */
  public BwCalendar defaultPublicCal;

  /* names from env properties */

  /** */
  public String publicCalendarRoot;
  /** */
  public String userCalendarRoot;
  /** */
  public String userDefaultCalendar;
  /** */
  public String defaultTrashCalendar;

  /** Account name for owner of public entities*/
  public String publicUserAccount;

  /** User entry for owner of public entities.
   */
  public BwUser publicUser;

  private String defaultPublicAccess;
  private String defaultPersonalAccess;

  /** Incremented if we can't map something */
  public int calMapErrors = 0;

  /** Integer filter key -> cal object */
  public HashMap filterToCal = new HashMap();

  /** Account name used to fix missing or changed owners */
  public String fixOwnerAccount;

  /** Account used to fix missing or changed owners */
  public BwUser fixOwner;

  /** For each of these we update events to have the appropriate calendar id.
   * Any event which already has a calendar id turned up in tow calendars.
   */
  public Vector calLeaves = new Vector();

  /** If true stop restore on any error, otherwise just flag it.
   */
  public boolean failOnError = false;

  /** Incremented for each start datetime but end date. We drop the end.
   */
  public int fixedNoEndTime;

  /** */
  public String systemId; // required for fixing guids

  /** Used when converting from 2.3.2 */
  public BwUserInfo userInfo; /* 2.3.2 */

  /** counter */
  public int filters;
  /** counter */
  public int users;

  /** counter */
  public int subscribedUsers;

  /** counter */
  public int subscriptions;

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
  public static class SubscriptionsMap extends HashMap {
    /** For 2.3.2 conversion
     *
     * @param owner
     * @param calid
     */
    public void put(BwUser owner, int calid) {
      Integer key = new Integer(owner.getId());

      Vector v = (Vector)get(key);
      if (v == null) {
        v = new Vector();
        put(key, v);
      }

      v.add(new Integer(calid));
    }

    /**
     * @param owner
     * @param sub
     */
    public void put(BwUser owner, BwSubscription sub) {
      Integer key = new Integer(owner.getId());

      Vector v = (Vector)get(key);
      if (v == null) {
        v = new Vector();
        put(key, v);
      }

      v.add(sub);
    }

    /** 2.3.2
     *
     * @param owner
     * @return Collection
     */
    public Collection getCalendarids(BwUser owner) {
      return (Vector)get(new Integer(owner.getId()));
    }

    /**
     * @param owner
     * @return Collection
     */
    public Collection getSubs(BwUser owner) {
      return (Vector)get(new Integer(owner.getId()));
    }

    /**
     * @param owner
     * @param subid
     * @return BwSubscription
     */
    public BwSubscription getSub(BwUser owner, int subid) {
      Collection subs = getSubs(owner);

      if (subs == null) {
        return null;
      }

      Iterator it = subs.iterator();
      while (it.hasNext()) {
        BwSubscription sub = (BwSubscription)it.next();
        if (sub.getId() == subid) {
          return sub;
        }
      }

      return null;
    }
  }

  /**
   */
  public static class EventKeyMap extends HashMap {
    /**
     * @param keyid
     * @param eventid
     */
    public void put(int keyid, int eventid) {
      Integer key = new Integer(keyid);

      Vector v = (Vector)get(key);
      if (v == null) {
        v = new Vector();
        put(key, v);
      }

      v.add(new Integer(eventid));
    }

    /**
     * @param keyid
     * @return Collection
     */
    public Collection getEventids(int keyid) {
      return (Vector)get(new Integer(keyid));
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
      put(new Integer(val.getId()), val);
      nameMap.put(val.getAccount(), val);
    }

    /**
     * @param id
     * @return BwUser
     */
    public BwUser get(int id) {
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
  /** */
  public UserMap usersTbl = new UserMap();
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

  /** */
  public HashMap calendars = new HashMap();

  /** Subscription we are currently restoring */
  public BwSubscription curSub;

  /** View we are currently restoring */
  public BwView curView;

  /** Link tag-name to calendar class
   */
  public static final HashMap classes = new HashMap();

  /** Classes to stand in for 2.3.2 classes */
  public static class AliasFilter extends BwFilter {
  }

  static {
    classes.put("aliasFilter", "org.bedework.tools.dumprestore.restore.RestoreGlobals$AliasFilter");
    classes.put("andFilter", "org.bedework.calfacade.filter.BwAndFilter");
    classes.put("creatorFilter", "org.bedework.calfacade.filter.BwCreatorFilter");
    classes.put("keyFilter", "org.bedework.calfacade.filter.BwCategoryFilter");
    classes.put("locationFilter", "org.bedework.calfacade.filter.BwLocationFilter");
    classes.put("notFilter", "org.bedework.calfacade.filter.BwNotFilter");
    classes.put("orFilter", "org.bedework.calfacade.filter.BwOrFilter");
    classes.put("sponsorFilter", "org.bedework.calfacade.filter.BwSponsorFilter");

    classes.put("user", "org.bedework.calfacade.BwUser");
    classes.put("location", "org.bedework.calfacade.BwLocation");
    classes.put("sponsor", "org.bedework.calfacade.BwSponsor");
    classes.put("organizer", "org.bedework.calfacade.BwOrganizer");
    classes.put("attendee", "org.bedework.calfacade.BwAttendee");
    classes.put("alarm", "org.bedework.calfacade.BwAlarm");
    classes.put("keyword", "org.bedework.calfacade.BwCategory");
    classes.put("category", "org.bedework.calfacade.BwCategory");
    classes.put("authuser", "org.bedework.calfacade.svc.BwAuthUser");
    classes.put("event", "org.bedework.calfacade.BwEvent");
    classes.put("adminGroup", "org.bedework.calfacade.svc.BwAdminGroup");
    classes.put("user-prefs", "org.bedework.calfacade.svc.BwPreferences");
    classes.put("dblastmod", "org.bedework.tools.dumprestore.BwDbLastmod");

    /* 2.3.2 */
    classes.put("eventRef", "org.bedework.calfacade.BwEvent");
  }

  /** */
  public RestoreIntf rintf;

  RestoreGlobals() {
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

    if (publicUserAccount == null) {
      throw new Exception("publicUserAccount must be defined");
    }

    publicUser = usersTbl.get(publicUserAccount);

    if (publicUser == null) {
      // Create it
      publicUser = new BwUser(publicUserAccount);
      publicUser.setInstanceOwner(true);
      publicUser.setCategoryAccess(getDefaultPublicAccess());
      publicUser.setLocationAccess(getDefaultPublicAccess());
      publicUser.setSponsorAccess(getDefaultPublicAccess());

      publicUser.setId(0);

      if (rintf != null) {
        rintf.restoreUser(publicUser);
      }

      usersTbl.put(publicUser);
    }

    return publicUser;
  }

  /** Get the account used to fix creators and owners of entities
   *
   * @return BwUser account
   * @throws Throwable if account name not defined
   */
  public BwUser getFixOwner() throws Throwable {
    if (fixOwner != null) {
      return fixOwner;
    }

    /* See if it's in the user map first. */

    if (fixOwnerAccount == null) {
      throw new Exception("fixOwnerAccount must be defined");
    }

    fixOwner = usersTbl.get(fixOwnerAccount);

    if (fixOwner == null) {
      // Create it
      fixOwner = new BwUser(fixOwnerAccount);
      fixOwner.setCategoryAccess(getDefaultPersonalAccess());
      fixOwner.setLocationAccess(getDefaultPersonalAccess());
      fixOwner.setSponsorAccess(getDefaultPersonalAccess());

      fixOwner.setId(1);

      if (rintf != null) {
        rintf.restoreUser(fixOwner);
      }

      usersTbl.put(fixOwner);
    }

    return fixOwner;
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

    if (superGroupName == null) {
      throw new Exception("superGroupName must be defined");
    }

    // Create it
    BwAdminGroup sg = new BwAdminGroup(superGroupName);
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
        Access a = new Access(debug);
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
    Acl acl = new Acl(debug);

    /** all owner, read others, read unauthenticated, (read,writeContent) group=superGroup */
    acl.clear();
    acl.addAce(new Ace(null, false, Ace.whoTypeOwner, Access.all));
    acl.addAce(new Ace(null, false, Ace.whoTypeOther, Access.read));
    acl.addAce(new Ace(null, false, Ace.whoTypeUnauthenticated, Access.read));

    Ace rwcont = new Ace(getSuperGroup().getAccount(), false,
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
    System.out.println("    subscribedUsers: " + subscribedUsers);
    System.out.println("      subscriptions: " + subscriptions);
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
}
