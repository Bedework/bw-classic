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
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.webcommon.BwActionFormBase;
import org.bedework.webcommon.BwWebUtil;

import edu.rpi.sss.util.Util;

//import java.sql.Date;
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

  private EventInfo eventInfo;
  private BwEvent event;

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
//  private CategoryVO oldCategory;

  private IntSelectId keyId;

  /* ....................................................................
   *                   Sponsor fields
   * .................................................................... */

  private BwSponsor sponsor;

  private IntSelectId spId;

  /* ....................................................................
   *                   Locations
   * .................................................................... */

  private BwLocation location;

  private IntSelectId locId;

  /* ....................................................................
   *                   Calendars
   * .................................................................... */

  private IntSelectId calendarId;

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
    return BwEvent.maxDescriptionLength;
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
   * @param val
   */
  public void setEventInfo(EventInfo val) {
    eventInfo = val;
    if (val == null) {
      setEvent(null);
    } else {
      setEvent(val.getEvent());
    }
  }

  /**
   * @return EventInfo
   */
  public EventInfo getEventInfo() {
    return eventInfo;
  }

  /**
   * @param val
   */
  public void setEvent(BwEvent val) {
    event = val;

    try {
      if (val == null) {
        getEventDates().setNewEvent(getEvent(), getCalSvcI().getTimezones());
      } else {
        getEventDates().setFromEvent(getEvent(), getCalSvcI().getTimezones());
      }
    } catch (Throwable t) {
      err.emit(t);
    }

    if (debug) {
      debugMsg("setEvent(), dates=" + getEventDates());
    }

    resetEvent();
  }

  /**
   *
   */
  public void resetEvent() {
    getEvent(); // Make sure we have one

    /* Implant the current id(s) in new entries */
    int id = 0;
    BwCategory k = event.getFirstCategory();
    if (k != null) {
      id = k.getId();
      setCategory(k);
    }

    /* A is the All box, B is the user preferred values. */
    keyId = new IntSelectId(id, IntSelectId.AHasPrecedence);

    BwSponsor s = event.getSponsor();
    id = 0;
    if (s != null) {
      id = s.getId();
      setSponsor(s);
    }

    spId = new IntSelectId(id, IntSelectId.AHasPrecedence);

    BwLocation l = event.getLocation();
    id = 0;
    if (l != null) {
      id = l.getId();
      setLocation(l);
    }

    locId = new IntSelectId(id, IntSelectId.AHasPrecedence);

    BwCalendar c = event.getCalendar();
    id = 0;
    if (c != null) {
      id = c.getId();
      setCalendar(c);
    }

    calendarId = new IntSelectId(id, IntSelectId.AHasPrecedence);
  }

  /** If an event object exists, return that otherwise create an empty one.
   *
   * @return BwEvent  populated event value object
   */
  public BwEvent getEvent() {
    if (event == null) {
      event = new BwEventObj();
      eventInfo = new EventInfo(event);
    }
    return event;
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

  /* * Get the i'th category id from the event object. Return &lt; 0 for none.
   *
   * @param i        int index into events vector of categories
   * @return int     Category index or -1
   * /
  public int getEventCategoryId(int i) {
    CategoryVO k = getEvent().getCategory(i);

    if (k == null) {
      return -1;
    }

    return k.getId();
  }

  /* * Get the i'th category from the event object. Return null for none.
   *
   * @param i           int index into events vector of keywors
   * @return CategoryVO  Category object or null
   * /
  public CategoryVO getEventCategory(int i) {
    return getEvent().getCategory(i);
  }
  */

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

  /** We have a preferred and all categories form field. One of them will be
   * unset so we ignore negative values.
   *
   * @see org.bedework.webcommon.BwActionFormBase#setCategoryId(int)
   */
  public void setCategoryId(int val) {
    if (val >= 0) {
      keyId.setA(val);
    }
  }

  public int getCategoryId() {
    return getCategory().getId();
  }

  /**
   * @return int
   */
  public int getOriginalCategoryId() {
    if (keyId == null) {
      return 0;
    }

    return keyId.getOriginalVal();
  }

  /**
   * @param val
   */
  public void setPrefCategoryId(int val) {
    if (val >= 0) {
      keyId.setB(val);
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
      Collection ks = getCalSvcI().getCategories();
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
    return getAuthUserPrefs().getPreferredCategories();
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
    return getAuthUserPrefs().getPreferredSponsors();
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
    return getAuthUserPrefs().getPreferredLocations();
  }

  /* ====================================================================
   *                   Calendars
   * ==================================================================== */

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
    return getAuthUserPrefs().getPreferredCalendars();
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
    return retrieveUserAuth().getUserMaintOK();
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
      return getCalSvcI().getAdminGroups().getGroupMaintOK();
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
      return getCalSvcI().getAdminGroups().getAll(showAgMembers);
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

  /** Ensure the event has all required fields and all are valid.
   *
   * <p>This method will retrieve any selected contacts, locations and
   * categories and embed them in the form and event.
   *
   * @return boolean   true   event looks OK
   * @throws Throwable
   */
  public boolean validateEvent() throws Throwable {
    boolean ok = validateEventCategory();
    BwEvent ev = getEvent();

    if (!validateEventSponsor()) {
      ok = false;
    }

    if (!validateEventLocation()) {
      ok = false;
    }

    if (!validateEventCalendar()) {
      ok = false;
    }

    if (!getEventDates().updateEvent(ev, getCalSvcI().getTimezones())) {
      ok = false;
    } else {
      ok = BwWebUtil.validateEvent(this.getCalSvcI(), ev, true, //  descriptionRequired
                                   err);
    }

    return ok;
  }

  /**
   *
   * @return boolean  false means something wrong, message emitted
   * @throws Throwable
   */
  public boolean validateEventCategory() throws Throwable {
    int id = keyId.getVal();

    if (id <= 0) {
      if (getEnv().getAppBoolProperty("app.categoryOptional")) {
        return true;
      }

      err.emit("org.bedework.pubevents.error.missingfield",
               "Category");
      return false;
    }

    try {
      BwCategory k = getCalSvcI().getCategory(id);

      if (k == null) {
        err.emit("org.bedework.pubevents.error.missingcategory", id);
        return false;
      }

      if (!keyId.getChanged()) {
        return true;
      }

//    oldCategory = getEvent().getCategory(0);


      /* Currently we replace the only category if it exists
       */
      BwEvent ev = getEvent();
      ev.clearCategories();
      ev.addCategory(k);

      setCategory(k);

      return true;
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /** Validate the sponsor provided for an event and embed it in the event and
   * the form.
   *
   * @return boolean  true OK, false not OK and message(s) emitted.
   * @throws Throwable
   */
  public boolean validateEventSponsor() throws Throwable {
    boolean ok = true;

    if (!spId.getChanged()) {
      if (getAutoCreateSponsors()) {
        BwSponsor s = getSponsor();
        if (!BwWebUtil.validateSponsor(s, err)) {
          return false;
        }

        getCalSvcI().ensureSponsorExists(s);

        setSponsor(s);
        getEvent().setSponsor(s);
      }

      if (event.getSponsor() == null) {
        err.emit("org.bedework.pubevents.error.missingfield",
                 "Sponsor");
        return false;
      }

      return ok;
    }

    // The user selected one from the list
    int id = spId.getVal();

    try {
      BwSponsor s = getCalSvcI().getSponsor(id);
      if (s == null) {
        // Somebody's faking
        setSponsor(null);
        err.emit("org.bedework.pubevents.error.missingfield",
                 "Sponsor");
        return false;
      }

      getEvent().setSponsor(s);

      setSponsor(s);
      return true;
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /** Validate the location provided for an event and embed it in the event and
   * the form.
   *
   * @return boolean  true OK, false not OK and message(s) emitted.
   * @throws Throwable
   */
  public boolean validateEventLocation() throws Throwable {
    boolean ok = true;

    if (!locId.getChanged()) {
      if (getAutoCreateLocations()) {
        BwLocation l = getLocation();

        if (!BwWebUtil.validateLocation(l, err)) {
          return false;
        }


        getCalSvcI().ensureLocationExists(l);

        setLocation(l);
        getEvent().setLocation(l);
      }

      if (event.getLocation() == null) {
        err.emit("org.bedework.pubevents.error.missingfield",
                 "Location");
        return false;
      }

      return ok;
    }

    // The user selected one from the list

    try {
      int id = locId.getVal();
      BwLocation l = getCalSvcI().getLocation(id);

      if ((l == null) || !l.getPublick()) {
        // Somebody's faking
        setLocation(null);
        err.emit("org.bedework.pubevents.error.missingfield",
                 "Location");
        return false;
      }

      getEvent().setLocation(l);
      setLocation(l);

      return true;
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

  /** Validate the calendar provided for an event and embed it in the event and
   * the form.
   *
   * @return boolean  true OK, false not OK and message(s) emitted.
   */
  public boolean validateEventCalendar() {
    boolean ok = true;

    if (!calendarId.getChanged()) {
      if (event.getCalendar() == null) {
        err.emit("org.bedework.pubevents.error.missingfield",
                 "Calendar");
        return false;
      }

      return ok;
    }

    // The user selected one from the list

    try {
      int id = calendarId.getVal();

      BwCalendar c = getCalSvcI().getCalendar(id);

      if ((c == null) || !c.getPublick() || !c.getCalendarCollection()) {
        // Somebody's faking
        setCalendar(null);
        err.emit("org.bedework.pubevents.error.missingfield",
                 "Calendar");
        return false;
      }

      getEvent().setCalendar(c);
      setCalendar(c);
      return true;
    } catch (Throwable t) {
      err.emit(t);
      return false;
    }
  }

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
      err.emit("org.bedework.pubevents.error.missingfield",
               "Category");
      ok = false;
    }

    return ok;
  }

  /**
   *
   */
  public void initFields() {
    super.initFields();
    event = null;
    category = null;
//    oldCategory = null;
    sponsor = null;
    location = null;
    updGroupMember = null;
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

