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
package org.bedework.calfacade.svc;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.CalFacadeDefs;

import java.io.Serializable;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

/** Base object which is closest to the db representation.
 * Possibly used for ejb or hibernate mapping generation.
 *
 * <p>Value object to represent authorised calendar user preferences.
 * These should really be in the same table.
 *
 *  @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwAuthUserPrefs implements Serializable {
  /* key */
  private int id = CalFacadeDefs.unsavedItemKey;

  protected BwAuthUser authUser;

  /** If true automatically add categories to the preferred list
   */
  protected boolean autoAddCategories = true;

  /** Users preferred categories.
   */
  protected Set preferredCategories;

  /** If true automatically add locations to the preferred list
   */
  protected boolean autoAddLocations = true;

  /** Users preferred locations.
   */
  protected Set preferredLocations;

  /** If true automatically add sponsors to the preferred list
   */
  protected boolean autoAddSponsors = true;

  /** Users preferred sponsors.
   */
  protected Set preferredSponsors;

  /** If true automatically add calendars to the preferred list
   */
  protected boolean autoAddCalendars = true;

  /** Users preferred calendars.
   */
  protected Set preferredCalendars;

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

  /**
   * @param val
   */
  public void setId(int val) {
    id = val;
  }

  /**
   * @return int db id
   */
  public int getId() {
    return id;
  }

  /**
   * @param val
   */
  public void setAuthUser(BwAuthUser val) {
    authUser = val;
  }

  /**
   * @return BwAuthUser associated auth user
   */
  public BwAuthUser getAuthUser() {
    return authUser;
  }

  /** If true we automatically add categories to the preferred list
   *
   * @param val
   */
  public void setAutoAddCategories(boolean val) {
    autoAddCategories = val;
  }

  /**
   * @return boolean true if we automatically add categories to the preferred list
   */
  public boolean getAutoAddCategories() {
    return autoAddCategories;
  }

  /**
   * @param val
   */
  public void setPreferredCategories(Set val) {
    preferredCategories = val;
  }

  /**
   * @return Set of preferred categories
   */
  public Set getPreferredCategories() {
    if (preferredCategories == null) {
      preferredCategories = new TreeSet();
    }

    return preferredCategories;
  }

  /** If true automatically add locations to the preferred list
   *
   * @param val
   */
  public void setAutoAddLocations(boolean val) {
    autoAddLocations = val;
  }

  /**
   * @return boolean true if we automatically add locations to the preferred list
   */
  public boolean getAutoAddLocations() {
    return autoAddLocations;
  }

  /**
   * @param val
   */
  public void setPreferredLocations(Set val) {
    preferredLocations = val;
  }

  /**
   * @return Set of preferred locations
   */
  public Set getPreferredLocations() {
    if (preferredLocations == null) {
      preferredLocations = new TreeSet();
    }

    return preferredLocations;
  }

  /** If true automatically add sponsors to the preferred list
   *
   * @param val
   */
  public void setAutoAddSponsors(boolean val) {
    autoAddSponsors = val;
  }

  /**
   * @return boolean true if we automatically add sponsors to the preferred list
   */
  public boolean getAutoAddSponsors() {
    return autoAddSponsors;
  }

  /**
   * @param val
   */
  public void setPreferredSponsors(Set val) {
    preferredSponsors = val;
  }

  /**
   * @return Set of preferred sponsors
   */
  public Set getPreferredSponsors() {
    if (preferredSponsors == null) {
      preferredSponsors = new TreeSet();
    }
    return preferredSponsors;
  }

  /** If true automatically add calendars to the preferred list
   *
   * @param val
   */
  public void setAutoAddCalendars(boolean val) {
    autoAddCalendars = val;
  }

  /**
   * @return boolean true if we automatically add calendars to the preferred list
   */
  public boolean getAutoAddCalendars() {
    return autoAddCalendars;
  }

  /**
   * @param val
   */
  public void setPreferredCalendars(Set val) {
    preferredCalendars = val;
  }

  /**
   * @return Set of preferred calendars
   */
  public Set getPreferredCalendars() {
    if (preferredCalendars == null) {
      preferredCalendars = new TreeSet();
    }
    return preferredCalendars;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /** Add the category to the preferred categories. Return true if it was
   * added, false if it was in the list
   *
   * @param val        BwCategory to add
   * @return boolean   true if added
   */
  public boolean addCategory(BwCategory val) {
    if (getPreferredCategories().contains(val)) {
      return false;
    }

    getPreferredCategories().add(val);
    return true;
  }

  /** Remove the category from the preferred categories. Return true if it was
   * removed, false if it was not in the list
   *
   * @param val        BwCategory to remove
   * @return boolean   true if removed
   */
  public boolean removeCategory(BwCategory val) {
    Set cats = getPreferredCategories();

    if (!cats.contains(val)) {
      return false;
    }

    cats.remove(val);

    return true;
  }

  /** Add the location to the preferred categories. Return true if it was
   * added, false if it was in the list
   *
   * @param l          BwLocation to add
   * @return boolean   true if added
   */
  public boolean addLocation(BwLocation l) {
    if (getPreferredLocations().contains(l)) {
      return false;
    }

    getPreferredLocations().add(l);
    return true;
  }

  /** Remove the location from the preferred locations. Return true if it was
   * removed, false if it was not in the list
   *
   * @param l          BwLocation to remove
   * @return boolean   true if removed
   */
  public boolean removeLocation(BwLocation l) {
    Set locs = getPreferredLocations();

    if (!locs.contains(l)) {
      return false;
    }

    locs.remove(l);

    return true;
  }

  /** Add the sponsor to the preferred sponsors. Return true if it was
   * added, false if it was in the list
   *
   * @param s          BwSponsor to add
   * @return boolean   true if added
   */
  public boolean addSponsor(BwSponsor s) {
    if (getPreferredSponsors().contains(s)) {
      return false;
    }

    getPreferredSponsors().add(s);
    return true;
  }

  /** Remove the sponsor from the preferred sponsors. Return true if it was
   * removed, false if it was not in the list
   *
   * @param s          BwSponsor to remove
   * @return boolean   true if removed
   */
  public boolean removeSponsor(BwSponsor s) {
    Set sps = getPreferredSponsors();

    if (!sps.contains(s)) {
      return false;
    }

    sps.remove(s);

    return true;
  }

  /** Add the calendar to the preferred calendars. Return true if it was
   * added, false if it was in the list
   *
   * @param val        CalendarVO to add
   * @return boolean   true if added
   */
  public boolean addCalendar(BwCalendar val) {
    if (getPreferredCalendars().contains(val)) {
      return false;
    }

    getPreferredCalendars().add(val);
    return true;
  }

  /** Remove the calendar from the preferred calendars. Return true if it was
   * removed, false if it was not in the list
   *
   * @param val        CalendarVO to remove
   * @return boolean   true if removed
   */
  public boolean removeCalendar(BwCalendar val) {
    Set cals = getPreferredCalendars();

    if (!cals.contains(val)) {
      return false;
    }

    cals.remove(val);

    return true;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (!(obj instanceof BwAuthUserPrefs)) {
      return false;
    }

    BwAuthUserPrefs that = (BwAuthUserPrefs)obj;

    return getAuthUser().equals(that.getAuthUser());
  }

  public int hashCode() {
    return getAuthUser().hashCode();
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwAuthUserPrefs{id=");
    sb.append(id);
    sb.append(", autoAddCategories=");
    sb.append(getAutoAddCategories());
    sb.append(", autoAddLocations=");
    sb.append(getAutoAddLocations());
    sb.append(", autoAddSponsors=");
    sb.append(getAutoAddSponsors());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    BwAuthUserPrefs aup = new BwAuthUserPrefs();

    aup.setId(getId());

    // Don't clone the authuser - sets up a loop

    aup.setAutoAddCategories(getAutoAddCategories());

    TreeSet nts = new TreeSet();
    Set ts = getPreferredCategories();

    if (ts != null) {
      Iterator it = ts.iterator();

      while (it.hasNext()) {
        nts.add((BwCategory)((BwCategory)it.next()).clone());
      }
    }

    aup.setPreferredCategories(nts);

    aup.setAutoAddLocations(getAutoAddLocations());

    nts = new TreeSet();
    ts = getPreferredLocations();

    if (ts != null) {
      Iterator it = ts.iterator();

      while (it.hasNext()) {
        nts.add((BwLocation)((BwLocation)it.next()).clone());
      }
    }

    aup.setPreferredLocations(nts);

    aup.setAutoAddSponsors(getAutoAddSponsors());

    nts = new TreeSet();
    ts = getPreferredSponsors();

    if (ts != null) {
      Iterator it = ts.iterator();

      while (it.hasNext()) {
        nts.add((BwSponsor)((BwSponsor)it.next()).clone());
      }
    }

    aup.setPreferredSponsors(nts);

    aup.setAutoAddCalendars(getAutoAddCalendars());

    nts = new TreeSet();
    ts = getPreferredCalendars();

    if (ts != null) {
      Iterator it = ts.iterator();

      while (it.hasNext()) {
        nts.add((BwCalendar)((BwCalendar)it.next()).shallowClone());
      }
    }

    aup.setPreferredCalendars(nts);

    return aup;
  }
}
