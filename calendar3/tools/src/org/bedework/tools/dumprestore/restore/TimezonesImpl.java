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

import org.bedework.calfacade.BwUser;
//import org.bedework.calfacade.BwTimeZone;
import org.bedework.calfacade.CalFacadeBadDateException;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calfacade.ifs.CalTimezones;
//import org.bedework.icalendar.IcalTranslator;

//import net.fortuna.ical4j.model.Calendar;
//import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.parameter.TzId;
import net.fortuna.ical4j.model.property.DtEnd;
import net.fortuna.ical4j.model.TimeZone;

//import java.util.Collection;
import java.util.HashMap;
//import java.util.Iterator;

import org.apache.log4j.Logger;

/** Handle timezones for bedework restore program.
 *
 * <p>At the moment this does nothing as we have no timezones in the 2.3
 * version. This needs to act as a repository for all timezones as we restore
 * them.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
class TimezonesImpl implements CalTimezones {
  private transient Logger log;

  private boolean publicAdmin;
  private boolean debug;

  private static class TimezoneInfo {
    TimeZone tz;

    boolean publick;

    /* If tz was derived from a db object, this is the data */
    VTimeZone vtz;
  }

  /* Map of user TimezoneInfo */
  private HashMap timezones = new HashMap();

  private static volatile HashMap systemTimezones = new HashMap();
  //private static volatile boolean systemTimezonesInitialised = false;

  //private transient Logger log;

  TimezonesImpl(boolean publicAdmin, boolean debug)
          throws CalFacadeException {
    this.publicAdmin = publicAdmin;
    this.debug = debug;

    // Force fetch of timezones
    //lookup("not-a-timezone");
  }

  public void saveTimeZone(String tzid, VTimeZone vtz)
          throws CalFacadeException {
    /* For a user update the map to avoid a refetch. For system timezones we will
       force a refresh when we're done.
    */
    if (publicAdmin) {
      return;
    }

    TimezoneInfo tzinfo = (TimezoneInfo)timezones.get(tzid);

    if (tzinfo == null) {
      tzinfo = new TimezoneInfo();
    }

    tzinfo.vtz = vtz;
    tzinfo.tz = new TimeZone(vtz);
    timezones.put(tzid, tzinfo);
  }

  public void registerTimeZone(String id, TimeZone timezone)
      throws CalFacadeException {
    if (debug) {
      trace("register timezone with id " + id);
    }

    TimezoneInfo tzinfo = (TimezoneInfo)timezones.get(id);

    if (tzinfo == null) {
      tzinfo = new TimezoneInfo();
      tzinfo.tz = timezone;
      timezones.put(id, tzinfo);
    } else {
      tzinfo.tz = timezone;
    }
  }

  public TimeZone getTimeZone(final String id) throws CalFacadeException {
    TimezoneInfo tzinfo = lookup(id);

    /* Do we need to look up anything?
    if (tzinfo == null) {
      VTimeZone vTimeZone = cal.getTimeZone(id, null);
      if (vTimeZone == null) {
        return null;
      }

      tzinfo = new TimezoneInfo();

      tzinfo.vtz = vTimeZone;
      tzinfo.tz = new TimeZone(vTimeZone);
      timezones.put(id, tzinfo);
    }
    */

    return tzinfo.tz;
  }

  public VTimeZone findTimeZone(final String id, BwUser owner) throws CalFacadeException {
    if (debug) {
      trace("find timezone with id " + id + " for owner " + owner);
    }

    TimezoneInfo tzinfo = lookup(id);

    if ((tzinfo != null) && (tzinfo.vtz != null)) {
      return tzinfo.vtz;
    }

    /* Do we need to look up anything?
    VTimeZone vTimeZone = cal.getTimeZone(id, owner);
    if (vTimeZone == null) {
      return null;
    }

    tzinfo = new TimezoneInfo();

    tzinfo.vtz = vTimeZone;
    tzinfo.tz = new TimeZone(vTimeZone);
    timezones.put(id, tzinfo);

    return vTimeZone;
    */
    return null;
  }

  public void clearPublicTimezones() throws CalFacadeException {
  }

  public void refreshTimezones() throws CalFacadeException {
    synchronized (this) {
      //systemTimezonesInitialised = false;
      systemTimezones = new HashMap();
    }

    // force refresh now
    lookup("not-a-timezone");
  }

  public String getUtc(String time, String tzid, TimeZone tz) throws CalFacadeException {
    //if (debug) {
    //  trace("Get utc for " + time + " tzid=" + tzid + " tz =" + tz);
    //}
    if (CalFacadeUtil.isISODateTimeUTC(time)) {
      // Already UTC
      return time;
    }

    if (CalFacadeUtil.isISODateTime(time)) {
      try {
        DtEnd dte = new DtEnd();

        if ((tz == null) && (tzid != null)) {
          tz = getTimeZone(tzid);

          //if (debug) {
          //  trace("--------Got timezone " + tz);
          //}

          if (tz == null) {
            throw new CalFacadeBadDateException();
          }

          dte.getParameters().add(new TzId(tzid));
          dte.setTimeZone(tz);
        }

        dte.setValue(time);
        dte.setUtc(true);

        return dte.getValue();
      } catch (Throwable t) {
        t.printStackTrace();
        throw new CalFacadeBadDateException();
      }
    }

    if (CalFacadeUtil.isISODate(time)) {
      return time + "T000000Z";
    }

    throw new CalFacadeBadDateException();
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private TimezoneInfo lookup(String id) throws CalFacadeException {
    TimezoneInfo tzinfo;

    /*
    if (!systemTimezonesInitialised) {
      // First call (after reinit)
      synchronized (this) {
        if (!systemTimezonesInitialised) {
          Collection tzs = cal.getPublicTimeZones();
          Iterator it = tzs.iterator();

          while (it.hasNext()) {
            BwTimeZone btz = (BwTimeZone)it.next();

            Calendar cal = IcalTranslator.getCalendar(btz.getVtimezone());

            VTimeZone vtz = (VTimeZone)cal.getComponents().getComponent(Component.VTIMEZONE);
            if (vtz == null) {
              throw new CalFacadeException("Incorrectly stored timezone");
            }

            tzinfo = new TimezoneInfo();

            tzinfo.vtz = vtz;
            tzinfo.tz = new TimeZone(vtz);
            systemTimezones.put(btz.getTzid(), tzinfo);
          }

          systemTimezonesInitialised = true;
        }
      }
    }
    */

    tzinfo = (TimezoneInfo)systemTimezones.get(id);

    if (tzinfo != null) {
      tzinfo.publick = true;
    } else {
      tzinfo = (TimezoneInfo)timezones.get(id);
    }

    return tzinfo;
  }

  /* Get a logger for messages
   */
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void trace(String msg) {
    getLogger().debug("trace: " + msg);
  }
}
