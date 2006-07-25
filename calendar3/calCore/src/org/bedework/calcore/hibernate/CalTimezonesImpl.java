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

import org.bedework.calfacade.BwRWStats;
import org.bedework.calfacade.BwStats;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.BwTimeZone;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.Calintf;
import org.bedework.calfacade.timezones.CalTimezones;
import org.bedework.icalendar.IcalTranslator;

import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.TimeZone;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

/** Handle timezones for bedework.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
class CalTimezonesImpl extends CalTimezones {
  private Calintf cal;
  private BwRWStats stats;

  private boolean publicAdmin;

  private static volatile HashMap systemTimezones = new HashMap();
  private static volatile boolean systemTimezonesInitialised = false;

  CalTimezonesImpl(Calintf cal, BwStats stats, boolean publicAdmin, boolean debug)
          throws CalFacadeException {
    super(debug);
    this.cal = cal;
    this.stats = (BwRWStats)stats;
    this.publicAdmin = publicAdmin;

    // Force fetch of timezones
    //lookup("not-a-timezone");
  }

  public void saveTimeZone(String tzid, VTimeZone vtz)
          throws CalFacadeException {
    cal.saveTimeZone(tzid, vtz);
    stats.incTzStores();

    /* For a user update the map to avoid a refetch. For system timezones we will
       force a refresh when we're done.
    */
    if (publicAdmin) {
      return;
    }

    TimezoneInfo tzinfo = (TimezoneInfo)timezones.get(tzid);
    TimeZone tz = new TimeZone(vtz);

    if (tzinfo == null) {
      tzinfo = new TimezoneInfo(tz);
      timezones.put(tzid, tzinfo);
    } else {
      tzinfo.init(tz);
    }
  }

  public TimeZone getTimeZone(final String id) throws CalFacadeException {
    if ((defaultTimeZone != null) && id.equals(defaultTimeZoneId)) {
      return defaultTimeZone;
    }

    stats.incTzFetches();
    TimezoneInfo tzinfo = lookup(id);

    if (tzinfo == null) {
      VTimeZone vTimeZone = cal.getTimeZone(id, null);
      if (vTimeZone == null) {
        return null;
      }

      tzinfo = new TimezoneInfo(new TimeZone(vTimeZone));
      timezones.put(id, tzinfo);
    }

    if (tzinfo.getPublick()) {
      stats.incSystemTzFetches();
    }

    if ((defaultTimeZone == null) && id.equals(defaultTimeZoneId)) {
      defaultTimeZone = tzinfo.getTz();
    }

    return tzinfo.getTz();
  }

  public VTimeZone findTimeZone(final String id, BwUser owner) throws CalFacadeException {
    if (debug) {
      trace("find timezone with id " + id + " for owner " + owner);
    }

    TimezoneInfo tzinfo = lookup(id);

    if ((tzinfo != null) && (tzinfo.getTz().getVTimeZone() != null)) {
      return tzinfo.getTz().getVTimeZone();
    }

    VTimeZone vTimeZone = cal.getTimeZone(id, owner);
    if (vTimeZone == null) {
      return null;
    }

    if (tzinfo != null) {
      tzinfo.init(new TimeZone(vTimeZone));
    } else {
      tzinfo = new TimezoneInfo(new TimeZone(vTimeZone));
      timezones.put(id, tzinfo);
    }

    return vTimeZone;
  }

  public void storeTimeZone(final String id, BwUser owner) throws CalFacadeException {
    TimezoneInfo tzinfo = lookup(id);

    if (tzinfo == null) {
      throw new CalFacadeException("org.bedework.calcore.unknown.tzid", id);
    }

    if (!tzinfo.getNewDef() && !tzinfo.getChanged()) {
      return;
    }

    if (tzinfo.getPublick()) {
      warn("Attempt to update public timezone");
      return;
    }

    if (tzinfo.getNewDef()) {
      saveTimeZone(id, tzinfo.getTz().getVTimeZone());
      tzinfo.setNewDef(false);
    } else {
      // XXX Ignore change for the moment.
      tzinfo.setChanged(false);
    }
  }

  public void clearPublicTimezones() throws CalFacadeException {
    cal.clearPublicTimezones();
    super.clearPublicTimezones();
  }

  public void refreshTimezones() throws CalFacadeException {
    synchronized (this) {
      systemTimezonesInitialised = false;
      systemTimezones = new HashMap();
    }

    // force refresh now
    lookup("not-a-timezone");
  }

  /* ====================================================================
   *                   Protected methods
   * ==================================================================== */

  protected TimezoneInfo lookup(String id) throws CalFacadeException {
    TimezoneInfo tzinfo;

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

            /* Don't save the vtimezone, there are a lot and it's a significant
             * amount of space. We probably only look at 2-3 of them after this.
             * The find timezone method will look it up again if requested and
             * cache it at that point.
             */
            tzinfo = new TimezoneInfo(new TimeZone(vtz), true);
            systemTimezones.put(btz.getTzid(), tzinfo);
          }

          systemTimezonesInitialised = true;
        }
      }
    }

    if (!userTimezonesInitialised) {
      // First call after object creation.
      synchronized (this) {
        if (!userTimezonesInitialised) {
          Collection tzs = cal.getUserTimeZones();
          Iterator it = tzs.iterator();

          while (it.hasNext()) {
            BwTimeZone btz = (BwTimeZone)it.next();

            Calendar cal = IcalTranslator.getCalendar(btz.getVtimezone());

            VTimeZone vtz = (VTimeZone)cal.getComponents().getComponent(Component.VTIMEZONE);
            if (vtz == null) {
              throw new CalFacadeException("Incorrectly stored timezone");
            }

            tzinfo = new TimezoneInfo(new TimeZone(vtz), true);
            timezones.put(btz.getTzid(), tzinfo);
          }

          userTimezonesInitialised = true;
        }
      }
    }

    tzinfo = (TimezoneInfo)systemTimezones.get(id);

    if (tzinfo == null) {
      tzinfo = (TimezoneInfo)timezones.get(id);
    }

    return tzinfo;
  }
}

