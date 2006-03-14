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

import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.BwTimeZone;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.CalTimezones;

import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.TimeZone;

/** Handle timezones for bedework restore program.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
class TimezonesImpl extends CalTimezones {
  private boolean publick = true; // current mode
  private BwUser user;

  private RestoreIntf ri;

//  private static volatile HashMap systemTimezones = new HashMap();
  //private static volatile boolean systemTimezonesInitialised = false;

  TimezonesImpl(boolean debug, BwUser user, RestoreIntf ri)
          throws CalFacadeException {
    super(debug);
    this.user = user;
    this.ri = ri;

    // Force fetch of timezones
    //lookup("not-a-timezone");
  }

  /** Set current publick mode
   *
   * @param val
   */
  public void setPublick(boolean val) {
    publick = val;
  }

  /** Set current user
   *
   * @param val
   */
  public void setUser(BwUser val) {
    user = val;
  }

  public void saveTimeZone(String tzid, VTimeZone vtz)
          throws CalFacadeException {
    /* For a user update the map to avoid a refetch. For system timezones we will
       force a refresh when we're done.
    */

    BwTimeZone btz = new BwTimeZone();

    btz.setTzid(tzid);
    btz.setPublick(publick);
    btz.setOwner(user);

    StringBuffer sb = new StringBuffer();

    sb.append("BEGIN:VCALENDAR\n");
    sb.append("PRODID:-//RPI//BEDEWORK//US\n");
    sb.append("VERSION:2.0\n");
    sb.append(vtz.toString());
    sb.append("END:VCALENDAR\n");

    btz.setVtimezone(sb.toString());

    try {
      ri.restoreTimezone(btz);
    } catch (Throwable t) {
      throw new CalFacadeException(t);
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

  public void refreshTimezones() throws CalFacadeException {
    synchronized (this) {
      //systemTimezonesInitialised = false;
      // systemTimezones = new HashMap();
    }

    // force refresh now
    lookup("not-a-timezone");
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

//    tzinfo = (TimezoneInfo)systemTimezones.get(id);

  //  if (tzinfo != null) {
  //    tzinfo.publick = true;
  //  } else {
      tzinfo = (TimezoneInfo)timezones.get(id);
  //  }

    return tzinfo;
  }
}
