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

package org.bedework.webadmin;

import org.bedework.appcommon.IntSelectId;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.webcommon.BwActionFormBase;

import edu.rpi.sss.util.Util;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionMapping;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class PEActionForm extends BwActionFormBase implements PEDefs {
  /** ...................................................................
   *                   Flagged items - order not significant
   *  ................................................................... */

  private HashMap flags;

  /** ...................................................................
   *                   Application state
   *  ................................................................... */


  /** True if we are adding an alert
   */
  private boolean alertEvent;

  /** True if we are adding a new alert/event
   */
  private boolean addingEvent;

  /** True if we should list all events
   */
  private boolean listAllEvents;

  /** True if we are adding a new sponsor
   */
  private boolean addingSponsor;

  /** True if we are adding a new location
   */
  private boolean addingLocation;

  /** True if we are adding a new category
   */
  private boolean addingCategory;

  /** True if we are adding a new administrative group
   */
  private boolean addingAdmingroup;

  /** True to show members in list
   */
  private boolean showAgMembers;

  /* ....................................................................
   *                   Timezones
   * .................................................................... */

  private boolean uploadingTimeZones;

  /* ....................................................................
   *                   Categories
   * .................................................................... */

  private BwCategory category;

  /** Set if we appear to be changing the event category.
   */

  private IntSelectId categoryId = new IntSelectId(-1, IntSelectId.AHasPrecedence);

  /* ....................................................................
   *                   Sponsor fields
   * .................................................................... */

  private BwSponsor sponsor;

  private IntSelectId spId = new IntSelectId(-1, IntSelectId.AHasPrecedence);

  /* ....................................................................
   *                   Locations
   * .................................................................... */

  private BwLocation location;

  private IntSelectId locId = new IntSelectId(-1, IntSelectId.AHasPrecedence);

  /* ....................................................................
   *                   Calendars
   * .................................................................... */

  private IntSelectId calendarId = new IntSelectId(-1, IntSelectId.AHasPrecedence);

  /* ....................................................................
   *                   Events
   * .................................................................... */

  private Collection formattedEvents;

  /* ....................................................................
   *                   Authorised user fields
   * .................................................................... */

  /** Auth users for list or mod
   */
  private Collection authUsers;

  /** Value built out of checked boxes.
   */
  private int editAuthUserType;

  /** User we want to fetch or modify
   */
  private String editAuthUserId;

  /** User object we are creating or modifying
   */
  private BwAuthUser editAuthUser;

  /* ....................................................................
   *                   Admin group fields
   * .................................................................... */

  private BwAdminGroup updAdminGroup;

  /** Group owner and group event owner */
  private String adminGroupGroupOwner;
  private String adminGroupEventOwner;

  /** Group member to add/delete
   */
  private String updGroupMember;

  /**
   * @return int
   */
  public int getMaxDescriptionLength() {
    try {
      return fetchSvci().getSyspars().getMaxPublicDescriptionLength();
    } catch (Throwable t) {
      err.emit(t);
      return 0;
    }
  }

  /* ====================================================================
   *                   Flags - indexed checkboxes
   * ==================================================================== */

  /**
   * @param i
   * @param val
   */
  public void setDelFlag(int i, boolean val) {
    if (!val) {
      return;
    }

    if (flags == null) {
      flags = new HashMap();
    }

    flags.put(new Integer(i), null);
  }

  /**
   * @param i
   * @return flag
   */
  public boolean getDelFlag(int i) {
    if (flags == null) {
      return false;
    }

    return flags.containsKey(new Integer(i));
  }

  /**
   * @return flags
   */
  public int[] getFlags() {
    if ((flags == null) || (flags.size() == 0)) {
      return null;
    }

    int[] flagArray = new int[flags.size()];

    Iterator it = flags.keySet().iterator();
    int i = 0;

    while (it.hasNext()) {
      flagArray[i] = ((Integer)it.next()).intValue();
      i++;
    }

    return flagArray;
  }

  /* ====================================================================
   *                   Timezones
   * ==================================================================== */

  /** Not set - invisible to jsp
   *
   * @param val
   */
  public void assignUploadingTimezones(boolean val) {
    uploadingTimeZones = val;
  }

  /**
   * @return true if uploading timezones
   */
  public boolean getUploadingTimezones() {
    return uploadingTimeZones;
  }

  /* ====================================================================
   *                   Events
   * ==================================================================== */


  /** XXX Remove this when the jsp is pointed at the common actions.
   *
   * @param val
   */
  public void setEvent(BwEvent val) {
    setEditEvent(val);
  }

  /**
   * @return event
   */
  public BwEvent getEvent() {
    return getEditEvent();
  }

  /** Not set - invisible to jsp
   */
  /**
   * @param val
   */
  public void assignAlertEvent(boolean val) {
    alertEvent = val;
  }

  /**
   * @return bool
   */
  public boolean getAlertEvent() {
    return alertEvent;
  }

  /** Not set - invisible to jsp
   */
  /**
   * @param val
   */
  public void assignAddingEvent(boolean val) {
    addingEvent = val;
  }

  /**
   * @return bool
   */
  public boolean getAddingEvent() {
    return addingEvent;
  }

  /**
   * @param val
   */
  public void setListAllEvents(boolean val) {
    listAllEvents = val;
  }

  /**
   * @return bool
   */
  public boolean getListAllEvents() {
    return listAllEvents;
  }

  /**
   *
   * @param val Collection of formatted events
   */
  public void setFormattedEvents(Collection val) {
    formattedEvents = val;
  }

  /** Return a formatted events object. If doing alerts we pick them out
   * otherwise exclude them
   *
   * @return Collection  populated event value objects
   */
  public Collection getFormattedEvents() {
    return formattedEvents;
  }

  /* ====================================================================
   *                   Categories
   * ==================================================================== */

  /** Not set - invisible to jsp
   *
   * @param val
   */
  public void assignAddingCategory(boolean val) {
    addingCategory = val;
  }

  /**
   * @return boolean
   */
  public boolean getAddingCategory() {
    return addingCategory;
  }

  /**
   * @param val
   */
  public void setCategory(BwCategory val) {
    category = val;
  }

  /** If a Category object exists, return that otherwise create an empty one.
   *
   * @return CategoryVO  Category value object
   */
  public BwCategory getCategory() {
    if (category == null) {
      category = new BwCategory();
    }

    return category;
  }

  /**
   * @return IntSelectId id object
   */
  public IntSelectId retrieveCategoryId() {
    return categoryId;
  }

  /** We have a preferred and all categories form field. One of them will be
   * unset so we ignore negative values.
   *
   * @see org.bedework.webcommon.BwActionFormBase#setCategoryId(int)
   */
  public void setCategoryId(int val) {
    if (val >= 0) {
      categoryId.setA(val);
    }
  }

  public int getCategoryId() {
    return getCategory().getId();
  }

  /**
   * @return int
   */
  public int getOriginalCategoryId() {
    if (categoryId == null) {
      return 0;
    }

    return categoryId.getOriginalVal();
  }

  /**
   * @param val
   */
  public void setPrefCategoryId(int val) {
    if (val >= 0) {
      categoryId.setB(val);
    }
  }

  /**
   * @return int
   */
  public int getPrefCategoryId() {
    return getCategory().getId();
  }

  /** Return categories
   */
  /**
   * @return categories
   */
  public Collection getCategories() {
    try {
      Collection ks = fetchSvci().getCategories();
      if (ks == null) {
        return new Vector();
      }

      return ks;
   } catch (Throwable t) {
      err.emit(t);
      return new Vector();
    }
  }

  /** Get the preferred categories for the current user
   *
   * @return Collection  preferred categories
   */
  public Collection getPreferredCategories() {
    return getCurAuthUserPrefs().getPreferredCategories();
  }

  /* ====================================================================
   *                   Sponsors
   * ==================================================================== */

  /** Not set - invisible to jsp
   *
   * @param val
   */
  public void assignAddingSponsor(boolean val) {
    addingSponsor = val;
  }

  /**
   * @return bool
   */
  public boolean getAddingSponsor() {
    return addingSponsor;
  }

  /**
   * @return int
   */
  public int getMaxReservedSponsorId() {
    return CalFacadeDefs.maxReservedSponsorId;
  }

  /**
   * @param val
   */
  public void setSponsor(BwSponsor val) {
    sponsor = val;
  }

  /** If a sponsor object exists, return that otherwise create an empty one.
   *
   * @return SponsorVO  sponsor value object
   */
  public BwSponsor getSponsor() {
    if (sponsor == null) {
      sponsor = new BwSponsor();
    }

    return sponsor;
  }

  /**
   * @return IntSelectId id object
   */
  public IntSelectId retrieveSpId() {
    return spId;
  }

  /** We have a preferred and all sponsors form field. One of them may be
   * unset so we ignore negative values.
   * @see org.bedework.webcommon.BwActionFormBase#setSponsorId(int)
   */
  public void setSponsorId(int val) {
    if (val >= 0) {
      spId.setA(val);
    }
  }

  /** This is the current sponsor, usually out of the current event. It is
   * used to select a particular sponsor in seleect lists.
   * @see org.bedework.webcommon.BwActionFormBase#getSponsorId()
   */
  public int getSponsorId() {
    return getSponsor().getId();
  }

  /**
   * @return int
   */
  public int getOriginalSponsorId() {
    if (spId == null) {
      return 0;
    }

    return spId.getOriginalVal();
  }

  /**
   * @param val
   */
  public void setPrefSponsorId(int val) {
    if (val >= 0) {
      spId.setB(val);
    }
  }

  /** This is the current sponsor, usually out of the current event. It is
   * used to select a particular sponsor in seleect lists.
   *
   * @return int
   */
  public int getPrefSponsorId() {
    return getSponsor().getId();
  }

  /** Get the preferred sponsors for the current user
   *
   * @return Collection  preferred sponsors
   */
  public Collection getPreferredSponsors() {
    return getCurAuthUserPrefs().getPreferredSponsors();
  }

  /* ====================================================================
   *                   Locations
   * ==================================================================== */

  /** Not set - invisible to jsp
   */
  /**
   * @param val
   */
  public void assignAddingLocation(boolean val) {
    addingLocation = val;
  }

  /**
   * @return bool
   */
  public boolean getAddingLocation() {
    return addingLocation;
  }

  /**
   * @param val
   */
  public void setLocation(BwLocation val) {
    location = val;
  }

  /** If a location object exists, return that otherwise create an empty one.
   *
   * @return LocationVO  populated location value object
   */
  public BwLocation getLocation() {
    if (location == null) {
      location = new BwLocation();
    }

    return location;
  }

  /**
   * @return IntSelectId id object
   */
  public IntSelectId retrieveLocId() {
    return locId;
  }

  /** We have a preferred and all locations form field. One of them will be
   * unset so we ignore negative values.
   *
   * @see org.bedework.webcommon.BwActionFormBase#setLocationId(int)
   */
  public void setLocationId(int val) {
    if (val >= 0) {
      locId.setA(val);
    }
  }

  public int getLocationId() {
    return getLocation().getId();
  }

  /**
   * @return int
   */
  public int getOriginalLocationId() {
    if (locId == null) {
      return 0;
    }

    return locId.getOriginalVal();
  }

  /**
   * @param val
   */
  public void setPrefLocationId(int val) {
    if (val >= 0) {
      locId.setB(val);
    }
  }

  /**
   * @return int
   */
  public int getPrefLocationId() {
    return getLocation().getId();
  }

  /** Get the preferred locations for the current user
   *
   * @return Collection  preferred locations
   */
  public Collection getPreferredLocations() {
    return getCurAuthUserPrefs().getPreferredLocations();
  }

  /* ====================================================================
   *                   Calendars
   * ==================================================================== */

  /**
   * @return IntSelectId id object
   */
  public IntSelectId retrieveCalendarId() {
    return calendarId;
  }

  /** We have a preferred and all calendars form field. One of them will be
   * unset so we ignore negative values.
   */
  /**
   * @param val
   */
  public void setCalendarId(int val) {
    if (val >= 0) {
      calendarId.setA(val);
    }
  }

  /**
   * @return cal id
   */
  public int getCalendarId() {
    return getCalendar().getId();
  }

  /**
   * @return cal id
   */
  public int getOriginalCalendarId() {
    if (calendarId == null) {
      return 0;
    }

    return calendarId.getOriginalVal();
  }

  /**
   * @param val
   */
  public void setPrefCalendarId(int val) {
    if (val >= 0) {
      calendarId.setB(val);
    }
  }

  /**
   * @return id
   */
  public int getPrefCalendarId() {
    return getCalendar().getId();
  }

  /** Get the preferred calendars for the current user
   *
   * @return Collection  preferred calendars
   */
  public Collection getPreferredCalendars() {
    return getCurAuthUserPrefs().getPreferredCalendars();
  }

  /* ====================================================================
   *                   Authorised user maintenance
   * ==================================================================== */

  /** Show whether user entries can be displayed or modified with this
   * class. Some sites may use other mechanisms.
   *
   * @return boolean    true if user maintenance is implemented.
   */
  public boolean getUserMaintOK() {
    try {
      return fetchSvci().getUserAuth().getUserMaintOK();
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /**
   * @param val list of auth users
   */
  public void setAuthUsers(Collection val) {
    authUsers = val;
  }

  /**
   * @return list of auth users
   */
  public Collection getAuthUsers() {
    return authUsers;
  }

  /** Only called if the flag is set - it's a checkbox.
   *
   * @param val
   */
  public void setEditAuthUserAlerts(boolean val) {
    editAuthUserType |= UserAuth.alertUser;
  }

  /**
   *
   * @return boolean
   */
  public boolean getEditAuthUserAlerts() {
    return (editAuthUser.getUsertype() & UserAuth.alertUser) != 0;
  }

  /** Only called if the flag is set - it's a checkbox.
   *
   * @param val
   */
  public void setEditAuthUserPublicEvents(boolean val) {
    editAuthUserType |= UserAuth.publicEventUser;
  }

  /**
   *
   * @return boolean
   */
  public boolean getEditAuthUserPublicEvents() {
    return (editAuthUser.getUsertype() & UserAuth.publicEventUser) != 0;
  }

  /** Only called if the flag is set - checkbox.
   *
   * @param val
   */
  public void setEditAuthUserSuperUser(boolean val) {
    editAuthUserType |= UserAuth.superUser;
  }

  /**
   *
   * @return boolean
   */
  public boolean getEditAuthUserSuperUser() {
    return (editAuthUser.getUsertype() & UserAuth.superUser) != 0;
  }

  /** New auth user rights
  *
   * @return int rights
   */
  public int getEditAuthUserType() {
    return editAuthUserType;
  }

  /**
   * @param val
   */
  public void setEditAuthUserId(String val) {
    editAuthUserId = val;
  }

  /**
   * @return id
   */
  public String getEditAuthUserId() {
    return editAuthUserId;
  }

  /**
   * @param val
   */
  public void setEditAuthUser(BwAuthUser val) {
    editAuthUser = val;
  }

  /**
   * @return auth user object
   */
  public BwAuthUser getEditAuthUser() {
    return editAuthUser;
  }

  /* ====================================================================
   *                   Admin groups
   * ==================================================================== */

  /** Not set - invisible to jsp
   *
   * @param val
   */
  public void assignAddingAdmingroup(boolean val) {
    addingAdmingroup = val;
  }

  /**
   * @return adding group
   */
  public boolean getAddingAdmingroup() {
    return addingAdmingroup;
  }

  /**
   * @param val
   */
  public void setShowAgMembers(boolean val) {
    showAgMembers = val;
  }

  /**
   * @return group members
   */
  public boolean getShowAgMembers() {
    return showAgMembers;
  }

  /** Show whether admin group maintenance is available.
   * Some sites may use other mechanisms.
   *
   * @return boolean    true if admin group maintenance is implemented.
   */
  public boolean getAdminGroupMaintOK() {
    try {
      return fetchSvci().getAdminGroups().getGroupMaintOK();
   } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /**
   * @return groups
   */
  public Collection getAdminGroups() {
    try {
      return fetchSvci().getAdminGroups().getAll(showAgMembers);
   } catch (Throwable t) {
      err.emit(t);
      return new Vector();
    }
  }

  /**
   * @param val
   */
  public void setUpdAdminGroup(BwAdminGroup val) {
    if (val == null) {
      updAdminGroup = new BwAdminGroup();
    } else {
      updAdminGroup = val;
    }

    try {
      BwUser u = updAdminGroup.getGroupOwner();

      if (u != null) {
        setAdminGroupGroupOwner(u.getAccount());
      }

      u = updAdminGroup.getOwner();

      if (u != null) {
        setAdminGroupEventOwner(u.getAccount());
      }
   } catch (Throwable t) {
      err.emit(t);
    }
  }

  /**
   * @return group
   */
  public BwAdminGroup getUpdAdminGroup() {
    if (updAdminGroup == null) {
      updAdminGroup = new BwAdminGroup();
    }

    return updAdminGroup;
  }

  /**
   * @param val
   */
  public void setAdminGroupGroupOwner(String val) {
    adminGroupGroupOwner = val;
  }

  /**
   * @return group owner
   */
  public String getAdminGroupGroupOwner() {
    return adminGroupGroupOwner;
  }

  /**
   * @param val
   */
  public void setAdminGroupEventOwner(String val) {
    adminGroupEventOwner = val;
  }

  /**
   * @return owner
   */
  public String getAdminGroupEventOwner() {
    return  adminGroupEventOwner;
  }

  /**
   * @param val
   */
  public void setUpdGroupMember(String val) {
    updGroupMember = val;
  }

  /**
   * @return group member
   */
  public String getUpdGroupMember() {
    return updGroupMember;
  }

  /* ====================================================================
   *                   Validation methods
   * ==================================================================== */

  /** Validate a category entry after add/mod
   *
   * @return bool
   * @throws Throwable
   */
  public boolean validateCategory() throws Throwable {
    boolean ok = true;

    BwCategory k = getCategory();

    k.setWord(Util.checkNull(k.getWord()));
    k.setDescription(Util.checkNull(k.getDescription()));

    if (k.getWord() == null) {
      err.emit("org.bedework.client.error.missingfield", "Category");
      ok = false;
    }

    return ok;
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  /**
   * Reset properties to their default values.
   *
   * @param mapping The mapping used to select this instance
   * @param request The servlet request we are processing
   */
  public void reset(ActionMapping mapping, HttpServletRequest request) {
    if (debug) {
      servlet.log("--" + getClass().getName() + ".reset--");
    }

    editAuthUserType = 0;
  }
}

