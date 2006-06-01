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

package org.bedework.webcommon;

import org.bedework.appcommon.BedeworkDefs;
import org.bedework.appcommon.CalendarInfo;
import org.bedework.appcommon.DayView;
import org.bedework.appcommon.MonthView;
import org.bedework.appcommon.MyCalendarVO;
import org.bedework.appcommon.TimeView;
import org.bedework.appcommon.WeekView;
import org.bedework.appcommon.YearView;
import org.bedework.calenv.CalEnv;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwSystem;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwAuthUserPrefs;
import org.bedework.calfacade.svc.BwPreferences;
import org.bedework.calfacade.svc.BwSubscription;
import org.bedework.calfacade.svc.BwView;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.calfacade.svc.wrappers.BwCalSuiteWrapper;
import org.bedework.calsvci.CalSvcI;
import org.bedework.mail.MailerIntf;

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.jsp.UtilActionForm;

import net.fortuna.ical4j.model.Calendar;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.TreeMap;
import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

/** Base for action form used by bedework web applications
 *
 * @author  Mike Douglass     douglm@rpi.edu
 */
public class BwActionFormBase extends UtilActionForm implements BedeworkDefs {
  /** This object will be set up appropriately for the kind of client,
   * e.g. admin, guest etc.
   */
  private CalEnv env;

  private ConfigBase config;

  // XXX locale - needs to be changed when locale changes
  private transient Collator listCollator;

  /* This should be a cloned copy only */
  private BwSystem syspars;

  private Collection sysStats;

  private transient MailerIntf mailer;

  /* Kind of entity we are referring to */

  private static int publicEntity = 0;
  private static int ownersEntity = 1;
  private static int editableEntity = 2;

  private boolean newSession;

  private BwSession sess;

  private BwUser userVO;

  /** Requests waiting */
  private int waiters;

  private MyCalendarVO today;

  /** true if this is a guest (unauthenticated) user
   */
  private boolean guest;

  /**
   * The current administrative user.
   */
  protected String currentAdminUser;

  /** True if this user has more than the default rights
   */
  private boolean authorisedUser;

  /** true if we are showing the public face
   */
  private boolean publicView;

  private CalSvcI calsvci;

  private String[] yearVals;
  private static final int numYearVals = 10;
  //private String curYear;

  /** Whether we show year data
   */
  private boolean showYearData;

  /** Id doing administration, May be a group id */
  private String adminUserId;

  /** Auth prefs for the currently logged in user
   */
  private BwAuthUserPrefs authUserPrefs;

  private boolean authUserAlerts;
  private boolean authUserPublicEvents;
  private boolean authUserSuperUser;

  /* ....................................................................
   *                       Calendar suites
   * .................................................................... */

  private BwCalSuiteWrapper calSuite;

  private boolean addingCalSuite;

  /* ....................................................................
   *                       Admin Groups
   * .................................................................... */

  /** True if we have set the user's group.
   */
  private boolean groupSet;

  /** True if we are choosing the user's group.
   */
  private boolean choosingGroup;

  /** User's current group or null. */
  private BwAdminGroup adminGroup;

  /** The groups of which our user is a member
   */
  private Collection userAdminGroups;

  /* ....................................................................
   *           Event date and time fields
   * .................................................................... */

  private EventDates eventDates;

  private boolean hour24;

  private int minIncrement;

  /* ....................................................................
   *           Ids for fetching objects
   * .................................................................... */

  private int categoryId;

  private int locationId;

  private int sponsorId;

  private int eventId;

  //private EventKey ekey = new EventKey();

  /* ....................................................................
   *           Fields for creating or editing objects
   * .................................................................... */

  /** newCategory is where we build a new category object
   */
  private BwCategory newCategory;

  /** editCategory is where we hold a category object for editing
   */
  private BwCategory editCategory;

  /** newLocation is where we build a new location object
   */
  private BwLocation newLocation;

  /** editLocation is where we hold a location object for editing
   */
  private BwLocation editLocation;

  /** newSponsor is where we build a new Sponsor object
   */
  private BwSponsor newSponsor;

  /** editSponsor is where we hold a Sponsor object for editing
   */
  private BwSponsor editSponsor;

  /** newEvent is where we build a new Event object
   */
  private BwEvent newEvent;

  /** editEvent is where we hold a Event object for editing
   */
  private BwEvent editEvent;

  private EventInfo eventInfo;

  /** For passing between actions
   */
  private BwEvent currentEvent;

  /* ....................................................................
   *                       Uploads and exports
   * .................................................................... */

  private FormFile uploadFile;

  private Calendar vcal;

  /* ....................................................................
   *                       Selection type and selection
   * .................................................................... */

  // ENUM
  private String selectionType = selectionTypeView;

  private Collection currentSubscriptions;

  /* ....................................................................
   *                       View period
   * .................................................................... */

  private static HashMap viewTypeMap = new HashMap();

  static {
    for (int i = 0; i < BedeworkDefs.viewPeriodNames.length; i++) {
      viewTypeMap.put(BedeworkDefs.viewPeriodNames[i], new Integer(i));
    }
  }

  /** Index of the view type set when the page was last generated
   */
  private int curViewPeriod;

  /** This will be set if a refresh is needed - we do it on the way out.
   */
  private boolean refreshNeeded;

  /** Index of the view type requested this time round. We set curViewPeriod to
   * viewTypeI. This allows us to see if the view changed as a result of the
   * request.
   */
  private int viewTypeI;

  /** one of the viewTypeNames values
   */
  private String viewType;

  /** The current view with user selected date (day, week, month etc)
   */
  private TimeView curTimeView;

  /** MyCalendarVO version of the start date
   */
  private MyCalendarVO viewMcDate;

  /* ....................................................................
   *                       Subscriptions
   * .................................................................... */

  private Collection subscriptions;

  private BwSubscription subscription;

  private boolean addingSubscription;

  /* ....................................................................
   *                       Views
   * .................................................................... */

  private BwView view;

  private boolean addingView;

  /* ....................................................................
   *                       Calendars
   * .................................................................... */

  private BwCalendar calendar;

  private String parentCalendarPath;

  /** True if we are adding a new calendar
   */
  private boolean addingCalendar;

  /* ....................................................................
   *                   Preferences
   * .................................................................... */

  /** Last email address used to mail message. By default set to
   * preferences value.
   */
  private String lastEmail;

  private String lastSubject;

  private BwPreferences preferences;

  private BwPreferences userPreferences;

  /* ====================================================================
   *                   Property methods
   * ==================================================================== */

  /** Set a (cloned) copy of the system parameters
   * @param val
   */
  public void setSyspars(BwSystem val) {
    syspars = (BwSystem)val.clone();
  }

  /**
   * @return BwSystem object
   */
  public BwSystem getSyspars() {
    return syspars;
  }

  /** Set a copy of the config parameters
   *
   * @param val
   */
  public void setConfig(ConfigBase val) {
    config = val;

    /* Set defaults */
    setHour24(config.getHour24());
    setMinIncrement(config.getMinIncrement());
    assignShowYearData(config.getShowYearData());
  }

  /** Return a cloned copy of the config parameters
   *
   * @return Config object
   */
  public ConfigBase getConfig() {
    if (config == null) {
      return null;
    }

    return (ConfigBase)config.clone();
  }

  /** True if we have a config object set.
   *
   * @return boolean
   */
  public boolean configSet() {
    return config != null;
  }

  /** Return the uncloned config parameters
   *
   * @return Config object
   */
  public ConfigBase retrieveConfig() {
    return config;
  }

  /** Set system statistics
  *
  * @param val      Collection of BwStats.StatsEntry objects
  */
  public void assignSysStats(Collection val) {
    sysStats = val;
  }

  /** Get system statistics
  *
  * @return Collection of BwStats.StatsEntry objects
  */
  public Collection getSysStats() {
    if (sysStats == null) {
      sysStats = new ArrayList();
    }

    return sysStats;
  }

  /** Get system statistics enabled state
  *
   * @return boolean true if statistics collection enabled
  */
  public boolean getSysStatsEnabled() {
    try {
      return fetchSvci().getDbStatsEnabled();
    } catch (Throwable t) {
      return false;
    }
  }

  /** This will default to the current user. Superusers will be able to
   * specify a creator.
   *
   * @param val    String creator used to limit searches
   */
  public void setAdminUserId(String val) {
    adminUserId = val;
  }

  /**
   * @return admin userid
   */
  public String getAdminUserId() {
    return adminUserId;
  }

  /**
   * @return Collection of calendar instance owners
   */
  public Collection getInstanceOwners() {
    try {
      return fetchSvci().getInstanceOwners();
    } catch (Throwable t) {
      err.emit(t);
      return new ArrayList();
    }
  }

  /* ====================================================================
   *                   UserAuth Methods
   * DO NOT return userAuth. We don't want the user auth object
   * accessible to the request. Use the RO object instead.
   * ==================================================================== */

  /**
   * @param val
   */
  public void setAuthUserPrefs(BwAuthUserPrefs val) {
    authUserPrefs = val;
  }

  /**
   * @return auth user prefs
   */
  public BwAuthUserPrefs getAuthUserPrefs() {
    return authUserPrefs;
  }

  /** Current auth user rights
   *
   * @param val
   */
  public void assignAuthUserAlerts(boolean val) {
    authUserAlerts = val;
  }

  /** Current auth user rights
  *
   * @return alerts
   */
  public boolean getAuthUserAlerts() {
    return authUserAlerts;
  }

  /** Current auth user rights
   *
   * @param val
   */
  public void assignAuthUserPublicEvents(boolean val) {
    authUserPublicEvents = val;
  }

  /** Current auth user rights
  *
   * @return true for user who can edit public events
   */
  public boolean getAuthUserPublicEvents() {
    return authUserPublicEvents;
  }

  /** Current auth user rights
   *
   * @param val true for superuser
   */
  public void assignAuthUserSuperUser(boolean val) {
    authUserSuperUser = val;
  }

  /** Current auth user rights
  *
   * @return true for superuser
   */
  public boolean getAuthUserSuperUser() {
    return authUserSuperUser;
  }

  /* ====================================================================
   *                   Calendar suites
   * ==================================================================== */

  /**
   * @param val
   */
  public void setCalSuite(BwCalSuiteWrapper val) {
    calSuite = val;
  }

  /**
   * @return BwCalSuiteWrapper
   */
  public BwCalSuiteWrapper getCalSuite() {
    return calSuite;
  }

  /** Not set - invisible to jsp
   *
   * @param val
   */
  public void assignCalSuite(boolean val) {
    addingCalSuite = val;
  }

  /**
   * @return bool
   */
  public boolean getAddingCalSuite() {
    return addingCalSuite;
  }

  /* ====================================================================
   *                   Admin groups
   * ==================================================================== */

  /**
   * @param val
   */
  public void assignGroupSet(boolean val) {
    groupSet = val;
  }

  /**
   * @return true for group set
   */
  public boolean getGroupSet() {
    return groupSet;
  }

  /**
   * @param val
   */
  public void assignChoosingGroup(boolean val) {
    choosingGroup = val;
  }

  /**
   * @return true for choosing group
   */
  public boolean retrieveChoosingGroup() {
    return choosingGroup;
  }

  /** Implant the current user group (or null for none) in the form.
   * Do NOT call the setAdminGroup - it should not be visible to the request
   * stream.
   *
   * @param val      AdminGroupROVO representing users group or null
   */
  public void assignAdminGroup(BwAdminGroup val) {
    adminGroup = val;
    assignGroupSet(true);
  }

  /**
   * @return admin group
   */
  public BwAdminGroup getAdminGroup() {
    return adminGroup;
  }

  /** The groups of which our user is a member
   *
   * @param val
   */
  public void setUserAdminGroups(Collection val) {
    userAdminGroups = val;
  }

  /**
   * @return user admin groups
   */
  public Collection getUserAdminGroups() {
    return userAdminGroups;
  }

  /**
   * @param val
   */
  public void assignEnv(CalEnv val) {
    env = val;
  }

  /**
   * @return env object
   */
  public CalEnv getEnv() {
    return env;
  }

  /**
   * @return mailer object
   */
  public MailerIntf getMailer() {
    if (mailer != null) {
      return mailer;
    }

    try {
      mailer = (MailerIntf)CalEnv.getGlobalObject("mailerclass",
                                                  MailerIntf.class);
      mailer.init(fetchSvci(), debug);
    } catch (Throwable t) {
      err.emit(t);
    }

    return mailer;
  }

  /**
   * @param val
   */
  public void assignUserVO(BwUser val) {
    userVO = val;
  }

  /**
   * @return BwUser
   */
  public BwUser getUserVO() {
    return userVO;
  }

  /* (non-Javadoc)
   * @see edu.rpi.sss.util.jsp.UtilActionForm#incWaiters()
   */
  public void incWaiters() {
    waiters++;
  }

  /* (non-Javadoc)
   * @see edu.rpi.sss.util.jsp.UtilActionForm#decWaiters()
   */
  public void decWaiters() {
    waiters--;
  }

  /* (non-Javadoc)
   * @see edu.rpi.sss.util.jsp.UtilActionForm#getWaiters()
   */
  public int getWaiters() {
    return waiters;
  }

  /**
   * @param val true for new session
   */
  public void assignNewSession(boolean val) {
    newSession = val;
  }

  /**
   * @return boolean  true for new session
   */
  public boolean getNewSession() {
    return newSession;
  }

  /** This should not be setCurrentAdminUser as that exposes it to the incoming
   * request.
   *
   * @param val      String user id
   */
  public void assignCurrentAdminUser(String val) {
    currentAdminUser = val;
  }

  /**
   * @return admin user id
   */
  public String getCurrentAdminUser() {
    return currentAdminUser;
  }

  /**
   * @param val svci
   */
  public void setCalSvcI(CalSvcI val) {
    calsvci = val;
  }

  /**
   * @return svci
   */
  public CalSvcI fetchSvci() {
    return calsvci;
  }

  /** Returns a read only form for the jsp.
   *
   * @return UserAuth
   */
  public UserAuth getUserAuth() {
    try {
      return fetchSvci().getUserAuth().getUserAuthRO();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Don't call this getUserAuth so it's hidden from the
   * request stream
   *
   * @return UserAuth
   */
  public UserAuth retrieveUserAuth() {
    try {
      return fetchSvci().getUserAuth();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Set flag to show if this user has any admin rights.
   *
   * @param val   boolean true if admin user
   */
  public void assignAuthorisedUser(boolean val) {
    authorisedUser = val;
  }

  /** See if user has some form of access
   *
   * @return true for auth user
   */
  public boolean getAuthorisedUser() {
    return authorisedUser;
  }

  /**
   * @param val
   */
  public void setToday(MyCalendarVO val) {
    today = val;
  }

  /**
   * @return calendar today
   */
  public MyCalendarVO getToday() {
    if (today == null) {
      Locale loc = Locale.getDefault();  // XXX Locale
      today = new MyCalendarVO(new Date(System.currentTimeMillis()), loc);
    }
    return today;
  }

  /**
   * @return calendar info
   */
  public CalendarInfo getCalInfo() {
    return getToday().getCalInfo();
  }

  /**
   * @param val true for guest
   */
  public void setGuest(boolean val) {
    guest = val;
  }

  /**
   * @return true for guest
   */
  public boolean getGuest() {
    return guest;
  }

  /**
   * @param val
   */
  public void setPublicView(boolean val) {
    publicView = val;
  }

  /**
   * @return bool
   */
  public boolean getPublicView() {
    return publicView;
  }

  /**
   * @param val
   */
  public void assignShowYearData(boolean val) {
    showYearData = val;
  }

  /**
   * @return bool
   */
  public boolean getShowYearData() {
    return showYearData;
  }

  /**
   * @param val
   */
  public void setUploadFile(FormFile val) {
    uploadFile = val;
  }

  /**
   * @return FormFile
   */
  public FormFile getUploadFile() {
    return uploadFile;
  }

  /**
   * @param val
   */
  public void setVcal(Calendar val) {
    vcal = val;
  }

  /**
   * @return Calendar
   */
  public Calendar getVcal() {
    return vcal;
  }

  /* ====================================================================
   *                   View Period methods
   * ==================================================================== */

  /**
   * @return names
   */
  public String[] getViewTypeNames() {
    return BedeworkDefs.viewPeriodNames;
  }

  /**
   * @param i
   * @return view name
   */
  public String getViewTypeName(int i) {
    return BedeworkDefs.viewPeriodNames[i];
  }

  /** Index of the view type set when the page was last generated
   *
   * @param val  int valid view index
   */
  public void setCurViewPeriod(int val) {
    curViewPeriod = val;
  }

  /**
   * @return view index
   */
  public int getCurViewPeriod() {
    return curViewPeriod;
  }

  /** Index of the view type requested this time round. We set curViewPeriod to
   * viewTypeI. This allows us to see if the view changed as a result of the
   * request.
   *
   * @param val index
   */
  public void setViewTypeI(int val) {
    viewTypeI = val;
  }

  /**
   * @return index
   */
  public int getViewTypeI() {
    return viewTypeI;
  }

  /** This often appears as the request parameter specifying the view.
   * It should be one of the viewTypeNames
   *
   * @param  val   String viewType
   */
  public void setViewType(String val) {
    viewType = Util.checkNull(val);

    if (viewType == null) {
      viewTypeI = -1;
      return;
    }

    Integer i = (Integer)viewTypeMap.get(viewType);

    if (i == null) {
      viewTypeI = BedeworkDefs.defaultView;
    } else {
      viewTypeI = i.intValue();
    }
  }

  /** Return the value or a default if it's invalid
   *
   * @param val
   * @return String valid view period
   */
  public String validViewPeriod(String val) {
    int vt = BedeworkDefs.defaultView;

    val = Util.checkNull(val);
    if (val != null) {
      Integer i = (Integer)viewTypeMap.get(val);

      if (i != null) {
        vt = i.intValue();
      }
    }

    return BedeworkDefs.viewPeriodNames[vt];
  }

  /**
   * @return String
   */
  public String getViewType() {
    return viewType;
  }

  /** Date of the view as a MyCalendar object
   *
   * @param val
   */
  public void setViewMcDate(MyCalendarVO val) {
    viewMcDate = val;
  }

  /* * return true if the parameter is the index of the current view.
   * UW considers 0 to be today. We return selected if the current view is
   * day and it is for today.
   *
   * @param  i       int view index
   * @return boolean true if i is the current view index
   * /
  public boolean getViewSelected(int i) {
    if (i == BedeworkDefs.todayView) {
      if (curViewPeriod != BedeworkDefs.dayView) {
        return false;
      }

      return getCurTimeView().getFirstDay().isSameDate(new MyCalendarVO());
    }
    return (i == curViewPeriod) / *|| ((curViewPeriod == 1 && (i == 0))) * /;
  }*/

  /** The current view (day, week, month etc)
   */
  /**
   * @param val
   */
  public void setCurTimeView(TimeView val) {
    curTimeView = val;
  }

  /**
   *
   * @return current view (day, week, month etc)
   */
  public TimeView getCurTimeView() {
    /* We might be called before any time is set. Set a week view by
       default
       */

    try {
      if (curTimeView == null) {
        /** Figure out the default from the properties
         */
        String vn;

        try {
          vn = fetchSvci().getUserPrefs().getPreferredViewPeriod();
          if (vn == null) {
            vn = "week";
          }
        } catch (Throwable t) {
          System.out.println("Exception setting current view");
          vn = "week";
        }

        curViewPeriod = -1;

        for (int i = 1; i < BedeworkDefs.viewPeriodNames.length; i++) {
          if (BedeworkDefs.viewPeriodNames[i].startsWith(vn)) {
            curViewPeriod = i;
            break;
          }
        }

        if (curViewPeriod < 0) {
          curViewPeriod = BedeworkDefs.weekView;
        }

        Locale loc = Locale.getDefault();  // XXX Locale
        setViewMcDate(new MyCalendarVO(new Date(System.currentTimeMillis()), loc));
        refreshView();
      }
    } catch (Throwable t) {
      getLog().error("Exception in getCurTimeView", t);
    }

    if (curTimeView == null) {
      getLog().warn("Null time view!!!!!!!!!!!");
//    } else if (debug) {
//      getLog().debug("Return a time view");
    }

    return curTimeView;
  }

  /** XXX This looks wrong we might be refreshing twice.
   *
   */
  public void refreshIsNeeded() {
    refreshView();
    refreshNeeded = true;
  }

  /** set refreh needed flag
   *
   * @param val   boolean
   */
  public void setRefreshNeeded(boolean val) {
    refreshNeeded = val;
  }

  /**
   * @return true if we need to refresh
   */
  public boolean isRefreshNeeded() {
    return refreshNeeded;
  }

  /** Reset the view according to the current setting of curViewPeriod.
   * May be called when we change the view or if we need a refresh
   */
  public void refreshView() {
    if (debug) {
      getLog().debug(" set new view to ViewTypeI=" + curViewPeriod);
    }

    try {
      fetchSvci().refreshEvents();

      switch (curViewPeriod) {
      case BedeworkDefs.dayView:
        setCurTimeView(new DayView(getCalInfo(), viewMcDate, fetchSvci(), debug));
        break;
      case BedeworkDefs.weekView:
        setCurTimeView(new WeekView(getCalInfo(), viewMcDate, fetchSvci(), debug));
        break;
      case BedeworkDefs.monthView:
        setCurTimeView(new MonthView(getCalInfo(), viewMcDate, fetchSvci(), debug));
        break;
      case BedeworkDefs.yearView:
        setCurTimeView(new YearView(getCalInfo(), viewMcDate, fetchSvci(),
                       getShowYearData(), debug));
        break;
      }
    } catch (Throwable t) {
      // Not much we can do here
      setException(t);
    }
  }

  /* ====================================================================
   *                   Subscriptions
   * ==================================================================== */

  /**
   * @param val
   */
  public void setSubscriptions(Collection val) {
    subscriptions = val;
  }

  /**
   * @return Collection of subscriptions - never null
   */
  public Collection getSubscriptions() {
    if (subscriptions == null) {
      subscriptions = new ArrayList();
    }
    return subscriptions;
  }

  /**
   * @param val
   */
  public void setSubscription(BwSubscription val) {
    subscription = val;
  }

  /**
   * @return BwSubscription subscription object
   */
  public BwSubscription getSubscription() {
    return subscription;
  }

  /** Not set - invisible to jsp
   *
   * @param val
   */
  public void assignAddingSubscription(boolean val) {
    addingSubscription = val;
  }

  /**
   * @return bool
   */
  public boolean getAddingSubscription() {
    return addingSubscription;
  }

  /* ....................................................................
   *                       Selection type
   * .................................................................... */

  /**
   * @param val
   */
  public void setSelectionType(String val) {
    selectionType = val;
  }

  /**
   * @return String
   */
  public String getSelectionType() {
    return selectionType;
  }

  /** Set the current collections of subscriptions defining the display
   *
   * @param val Collection of subscriptions
   */
  public void assignCurrentSubscriptions(Collection val) {
    currentSubscriptions = val;
  }

  /** Return the current collections of subscriptions defining the display
   *
   * @return Collection of subscriptions
   */
  public Collection getCurrentSubscriptions() {
    if (currentSubscriptions == null) {
      currentSubscriptions = new ArrayList();
    }
    return currentSubscriptions;
  }

  /* ====================================================================
   *                   Views
   * ==================================================================== */

  /** Return the collection of views - named collections of subscriptions
   *
   * @return views
   */
  public Collection getViews() {
    try {
      return fetchSvci().getViews();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Get the current view we are displaying - or null for all events
   *
   * @return BwView  object or null for all events
   */
  public BwView getCurrentView() {
    try {
      return fetchSvci().getCurrentView();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Set the view we are editing
   *
   * @param val    BwView  object or null
   */
  public void setView(BwView val) {
    view = val;
  }

  /** Get the view we are editing
   *
   * @return BwView  object
   */
  public BwView getView() {
    if (view == null) {
      view = new BwView();
    }

    return view;
  }

  /** Not set - invisible to jsp
   *
   * @param val
   */
  public void assignAddingView(boolean val) {
    addingView = val;
  }

  /**
   * @return bool
   */
  public boolean getAddingView() {
    return addingView;
  }

  /* ====================================================================
   *                   Calendars
   * ==================================================================== */

  /** Return the public calendars
   *
   * @return BwCalendar   root calendar
   */
  public BwCalendar getPublicCalendars() {
    try {
      return fetchSvci().getPublicCalendars();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Return a list of public calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of CalendarVO
   */
  public Collection getPublicCalendarCollections() {
    try {
      return fetchSvci().getPublicCalendarCollections();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Return the current users calendars. For admin or guest mode this is the
   * same as calling getPublicCalendars.
   *
   * @return BwCalendar   root of calendar tree
   */
  public BwCalendar getCalendars() {
    try {
      return fetchSvci().getCalendars();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Return a list of user calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of CalendarVO
   */
  public Collection getCalendarCollections() {
    try {
      return fetchSvci().getCalendarCollections();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Return a list of calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of BwCalendar
   */
  public Collection getAddContentCalendarCollections() {
    try {
      TreeMap tm = new TreeMap(getListCollator());

      Iterator it = fetchSvci().getAddContentCalendarCollections().iterator();

      while (it.hasNext()) {
        BwCalendar cal = (BwCalendar)it.next();
        tm.put(cal.getName(), cal);
      }

      return tm.values();
//      return fetchSvci().getAddContentCalendarCollections();
    } catch (Throwable t) {
      err.emit(t);
      return null;
    }
  }

  /** Save the Path of the soon-to-be parent
   *
   * @param val
   */
  public void setParentCalendarPath(String val) {
    parentCalendarPath = val;
  }

  /**
   * @return cal Path
   */
  public String getParentCalendarPath() {
    return parentCalendarPath;
  }

  /** Not set - invisible to jsp
   */
  /**
   * @param val
   */
  public void assignAddingCalendar(boolean val) {
    addingCalendar = val;
  }

  /**
   * @return boolean
   */
  public boolean getAddingCalendar() {
    return addingCalendar;
  }

  /**
   * @param val
   */
  public void setCalendar(BwCalendar val) {
    calendar = val;
  }

  /** If a calendar object exists, return that otherwise create an empty one.
   *
   * @return CalendarVO  populated calendar value object
   */
  public BwCalendar getCalendar() {
    if (calendar == null) {
      calendar = new BwCalendar();
    }

    return calendar;
  }

  /* ====================================================================
   *                   preferences
   * ==================================================================== */

  /** Last email address used
   *
   * @param  val   email address
   */
  public void setLastEmail(String val) {
    lastEmail = val;
  }

  /**
   * @return last email
   */
  public String getLastEmail() {
    if (lastEmail == null) {
      if (getUserVO() != null) {
        lastEmail = getPreferences().getEmail();
      }
    }

    return lastEmail;
  }

  /** Last subject used
   *
   * @param  val   subject
   */
  public void setLastSubject(String val) {
    lastSubject = val;
  }

  /**
   * @return last subject
   */
  public String getLastSubject() {
    return lastSubject;
  }

  /** Get the preferences for the current user
   *
   * @return prefs
   */
  public BwPreferences getPreferences() {
    if (preferences == null) {
      try {
        preferences = fetchSvci().getUserPrefs();
      } catch (Throwable t) {
        err.emit(t);
      }
    }

    return preferences;
  }

  /** Set preferences for a given user
   *
   * @param  val   prefernces
   */
  public void setUserPreferences(BwPreferences val) {
    userPreferences = val;
  }

  /** Set preferences for a given user
   *
   * @return  val   prefernces
   */
  public BwPreferences getUserPreferences() {
    return userPreferences;
  }

  /* ====================================================================
   *                   Categories
   * ==================================================================== */

  /** Category id for next action
   *
   * @param val
   */
  public void setCategoryId(int val) {
    categoryId = val;
  }

  /**
   * @return int
   */
  public int getCategoryId() {
    return categoryId;
  }

  /** Get the list of categories for this owner. Return a null list for
   * exceptions or no categories.
   *
   * @return Collection    of BwCategory
   */
  public Collection getCategories() {
    return getCategoryCollection(ownersEntity);
  }

  /** Get the list of editable categories for this user. Return a null list for
   * exceptions or no categories.
   *
   * @return Collection    of BwCategory
   */
  public Collection getEditableCategories() {
    return getCategoryCollection(editableEntity);
  }

  /** Get the list of public categories. Return a null list for exceptions or no
   * categories.
   *
   * @return Collection    of BwCategory
   */
  public Collection getPublicCategories() {
    return getCategoryCollection(publicEntity);
  }

  /**
   * @return category
   */
  public BwCategory getNewCategory() {
    if (newCategory == null) {
      newCategory = new BwCategory();
    }

    return newCategory;
  }

  /** The only difference with newCategory is this doesn't get reset
   *
   * @param val
   */
  public void setEditCategory(BwCategory val) {
    editCategory = val;
  }

  /**
   * @return category
   */
  public BwCategory getEditCategory() {
    if (editCategory == null) {
      editCategory = new BwCategory();
    }

    return editCategory;
  }

  /* ====================================================================
   *                   Locations
   * ==================================================================== */

  /** Location id for next action
   *
   * @param val id
   */
  public void setLocationId(int val) {
    locationId = val;
  }

  /**
   * @return id
   */
  public int getLocationId() {
    return locationId;
  }

  /**
   * @return locations
   */
  public Collection getLocations() {
    return getLocations(ownersEntity);
  }

  /**
   * @return editable locations
   */
  public Collection getEditableLocations() {
    return getLocations(editableEntity);
  }

  /**
   * @return public locations
   */
  public Collection getPublicLocations() {
    return getLocations(publicEntity);
  }

  /**
   * @return location
   */
  public BwLocation getNewLocation() {
    if (newLocation == null) {
      newLocation = new BwLocation();
    }

    return tidyLocation(newLocation);
  }

  /**
   *
   */
  public void resetNewLocation() {
    newLocation = null;
  }

  /** The only difference with newLocation is this doesn't get reset
   *
   * @param val
   */
  public void setEditLocation(BwLocation val) {
    editLocation = val;
  }

  /**
   * @return location
   */
  public BwLocation getEditLocation() {
    if (editLocation == null) {
      editLocation = new BwLocation();
    }

    return tidyLocation(editLocation);
  }

  /* ====================================================================
   *                   Sponsors
   * ==================================================================== */

  /** Sponsor id for next action
   *
   * @param val
   */
  public void setSponsorId(int val) {
    sponsorId = val;
  }

  /**
   * @return id
   */
  public int getSponsorId() {
    return sponsorId;
  }

  /** Get the list of sponsors for this owner. Return a null list for
   * exceptions or no sponsors.
   *
   * @return Collection    of SponsorVO
   */
  public Collection getSponsors() {
    return getSponsorCollection(ownersEntity);
  }

  /** Get the list of editable sponsors for this user. Return a null list for
   * exceptions or no sponsors.
   *
   * @return Collection    of SponsorVO
   */
  public Collection getEditableSponsors() {
    return getSponsorCollection(editableEntity);
  }

  /** Get the list of public sponsors. Return a null list for exceptions or no
   * sponsors.
   *
   * @return Collection    of SponsorVO
   */
  public Collection getPublicSponsors() {
    return getSponsorCollection(publicEntity);
  }

  /**
   * @return sponsor
   */
  public BwSponsor getNewSponsor() {
    if (newSponsor == null) {
      newSponsor = new BwSponsor();
    }

    return newSponsor;
  }

  /** The only difference with newSponsor is this doesn't get reset
   *
   * @param val
   */
  public void setEditSponsor(BwSponsor val) {
    editSponsor = val;
  }

  /**
   * @return sponsor
   */
  public BwSponsor getEditSponsor() {
    if (editSponsor == null) {
      editSponsor = new BwSponsor();
    }

    return editSponsor;
  }

  /* ====================================================================
   *                   Events
   * ==================================================================== */

  /** Event id for next action
   *
   * @param val
   */
  public void setEventId(int val) {
    eventId = val;
  }

  /**
   * @return int
   */
  public int getEventId() {
    return eventId;
  }

  /**
   * @return int
   */
  public BwEvent getNewEvent() {
    if (newEvent == null) {
      newEvent = new BwEventObj();
    }

    return newEvent;
  }

  /**
   *
   */
  public void resetNewEvent() {
    newEvent = null;
  }

  /** The only difference from newEvent is this doesn't get reset
   *
   * @param val
   */
  public void setEditEvent(BwEvent val) {
    try {
      if (val == null) {
        val = new BwEventObj();
        getEventDates().setNewEvent(val, fetchSvci().getTimezones());
      } else {
        getEventDates().setFromEvent(val, fetchSvci().getTimezones());
      }
      editEvent = val;
    } catch (Throwable t) {
      err.emit(t);
    }
  }

  /**
   * @return event
   */
  public BwEvent getEditEvent() {
    if (editEvent == null) {
      editEvent = new BwEventObj();
      eventInfo = new EventInfo(editEvent);
    }

    return editEvent;
  }

  /**
   * @param val
   */
  public void setEventInfo(EventInfo val) {
    eventInfo = val;
    if (val == null) {
      setEditEvent(null);
    } else {
      setEditEvent(val.getEvent());
    }
  }

  /**
   * @return EventInfo
   */
  public EventInfo getEventInfo() {
    return eventInfo;
  }

  /** Event passed between actions
   */
  /**
   * @param val
   */
  public void assignCurrentEvent(BwEvent val) {
    currentEvent = val;
  }

  /**
   * @return event
   */
  public BwEvent retrieveCurrentEvent() {
    return currentEvent;
  }

  /** Return an initialised TimeDateComponents representing now
   *
   * @return TimeDateComponents  initialised object
   */
  public TimeDateComponents getNowTimeComponents() {
    return getEventDates().getNowTimeComponents();
  }

  /* ====================================================================
   *             Start and end Date and time and duration
   *
   * Methods related to selecting a particular date. These values may be
   * used when setting the current date or when setting the date of an event.
   * They will be distinguished by the action called.
   * ==================================================================== */

  /** Assign event dates based on parameter
   *
   * @param dt     Date object representing date
   */
  public void assignEventDates(Date dt) {
    getEventDates().setFromDate(dt);
  }

  /** Return an object containing the dates.
   *
   * @return EventDates  object representing date/times and duration
   */
  public EventDates getEventDates() {
    if (eventDates == null) {
      eventDates = new EventDates(fetchSvci(), getCalInfo(),
                                  config.getHour24(), config.getMinIncrement(),
                                  err, debug);
    }

    return eventDates;
  }

  /**
   * @param val
   */
  public void setHour24(boolean val) {
    hour24 = val;
    eventDates = null;   // reset it
  }

  /**
   * @return bool
   */
  public boolean getHour24() {
    return hour24;
  }


  /**
   * @param val
   */
  public void setMinIncrement(int val) {
    minIncrement = val;
    eventDates = null;   // reset it
  }

  /**
   * @return int
   */
  public int getMinIncrement() {
    return minIncrement;
  }

  /** Return an object representing an events start date.
   *
   * @return TimeDateComponents  object representing date and time
   */
  public TimeDateComponents getEventStartDate() {
    return getEventDates().getStartDate();
  }

  /** Return an object representing an events end date.
   *
   * @return TimeDateComponents  object representing date and time
   */
  public TimeDateComponents getEventEndDate() {
    return getEventDates().getEndDate();
  }

  /** Return an object representing an events duration.
   *
   * @return Duration  object representing date and time
   */
  public DurationBean getEventDuration() {
//    return getEventDates().getDuration();
    DurationBean db = getEventDates().getDuration();
    if (debug) {
      debugMsg("Event duration=" + db);
    }

    return db;
  }
/*
  public void resetEventStartDate() {
    eventStartDate = null;
  }

  public void resetEventEndDate() {
    eventEndDate = null;
  }*/

  /**
   * @param val
   */
  public void setEventEndType(String val) {
    getEventDates().setEndType(val);
  }

  /**
   * @return event end type
   */
  public String getEventEndType() {
    return getEventDates().getEndType();
  }

  /* ====================================================================
   *                Date and time labels for select boxes
   * ==================================================================== */

  /**
   * @return year values
   */
  public String[] getYearVals() {
    if (yearVals == null) {
      yearVals = new String[numYearVals];
      int year = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
      //curYear = String.valueOf(year);

      for (int i = 0; i < numYearVals; i++) {
        yearVals[i] = String.valueOf(year + i);
      }
    }

    return yearVals;
  }

  /**
   * @return TimeDateComponents used for labels
   */
  public TimeDateComponents getForLabels() {
    return getEventDates().getForLabels();
  }

  /**
   * @param val
   */
  public void setSession(BwSession val) {
    sess = val;
  }

  /**
   * @return session
   */
  public BwSession getSession() {
    return  sess;
  }

  /** Make sure string fields are null - no zero length
   *
   * @param loc
   * @return tidied location
   */
  public BwLocation tidyLocation(BwLocation loc) {
    loc.setAddress(Util.checkNull(loc.getAddress()));
    loc.setSubaddress(Util.checkNull(loc.getSubaddress()));
    loc.setLink(Util.checkNull(loc.getLink()));

    return loc;
  }

  /**
   * Reset properties to their default values.
   *
   * @param mapping The mapping used to select this instance
   * @param request The servlet request we are processing
   */
  public void reset(ActionMapping mapping, HttpServletRequest request) {
    eventId = CalFacadeDefs.unsavedItemKey;
    locationId = CalFacadeDefs.defaultLocationId;
    newCategory = null;
    newSponsor = null;
    viewTypeI = -1;
    //key.reset();
  }

  /* ====================================================================
   *                Private methods
   * ==================================================================== */

  private Collection getCategoryCollection(int kind) {
    try {
      if (kind == publicEntity) {
        return calsvci.getPublicCategories();
      }

      if (kind == ownersEntity) {
        return calsvci.getCategories();
      }

      if (kind == editableEntity) {
        return calsvci.getEditableCategories();
      }

      // Won't need this with 1.5
      throw new Exception("Software error - bad kind " + kind);
    } catch (Throwable t) {
      if (debug) {
        t.printStackTrace();
      }
      err.emit(t);
      return new ArrayList();
    }
  }

  private Collection getLocations(int kind) {
    try {
      if (kind == publicEntity) {
        return calsvci.getPublicLocations();
      }

      if (kind == ownersEntity) {
        return calsvci.getLocations();
      }

      if (kind == editableEntity) {
        return calsvci.getEditableLocations();
      }

      // Won't need this with 1.5
      throw new Exception("Software error - bad kind " + kind);
    } catch (Throwable t) {
      if (debug) {
        t.printStackTrace();
      }
      err.emit(t);
      return new ArrayList();
    }
  }

  private Collection getSponsorCollection(int kind) {
    try {
      if (kind == publicEntity) {
        return calsvci.getPublicSponsors();
      }

      if (kind == ownersEntity) {
        return calsvci.getSponsors();
      }

      if (kind == editableEntity) {
        return calsvci.getEditableSponsors();
      }

      // Won't need this with 1.5
      throw new Exception("Software error - bad kind " + kind);
    } catch (Throwable t) {
      if (debug) {
        t.printStackTrace();
      }
      err.emit(t);
      return new ArrayList();
    }
  }

  // XXX locale - needs to be changed when locale changes
  private Collator getListCollator() {
    if (listCollator == null) {
      listCollator = Collator.getInstance();
    }

    return listCollator;
  }
}
