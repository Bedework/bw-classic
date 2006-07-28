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
import org.bedework.calfacade.timezones.SATimezonesImpl;
import org.bedework.calfacade.timezones.TimeZonesParser;

import net.fortuna.ical4j.model.component.VTimeZone;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Collection;
import java.util.Iterator;

/** Handle timezones for bedework restore program.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
class TimezonesImpl extends SATimezonesImpl {
  private RestoreGlobals globals;

//  private static volatile HashMap systemTimezones = new HashMap();
  //private static volatile boolean systemTimezonesInitialised = false;

  TimezonesImpl(boolean debug, BwUser user, RestoreGlobals globals)
          throws CalFacadeException {
    super(debug, user);
    this.globals = globals;

    initSystemTimeZones();
  }

  public void saveTimeZone(String tzid, VTimeZone vtz, boolean publick)
          throws CalFacadeException {
    super.saveTimeZone(tzid, vtz, publick);

    saveTZ(tzid, vtz, publick, getUser());
  }

  /** Called when the lookup method finds that system timezones need to
   * be initialised.
   *
   * @throws CalFacadeException
   */
  protected void initSystemTimeZones() throws CalFacadeException {
    try {
      if (globals.config.getFrom2p3px() &&
          (globals.config.getTimezonesFilename() != null)) {
        // Populate from a file
        TimeZonesParser tzp = new TimeZonesParser(
                    new FileInputStream(globals.config.getTimezonesFilename()),
                    globals.config.getDebug());

        Collection tzis = tzp.getTimeZones();

        Iterator it = tzis.iterator();
        while (it.hasNext()) {
          TimeZonesParser.TimeZoneInfo tzi = (TimeZonesParser.TimeZoneInfo)it.next();

          savePublicTimeZone(tzi.tzid, tzi.timezone);
        }
      }
    } catch (FileNotFoundException fnfe) {
      throw new CalFacadeException(fnfe);
    }
  }

  /** Called when the lookup method finds that user timezones need to
   * be initialised.
   *
   * @throws CalFacadeException
   */
  protected void initUserTimeZones() throws CalFacadeException {
    userTimezonesInitialised = true;
  }

  private void saveTZ(String tzid, VTimeZone vtz,
                      boolean publick, BwUser user) throws CalFacadeException {
    BwTimeZone btz = new BwTimeZone();

    btz.setTzid(tzid);
    btz.setPublick(true);
    btz.setOwner(getUser());

    StringBuffer sb = new StringBuffer();

    sb.append("BEGIN:VCALENDAR\n");
    sb.append("PRODID:-//RPI//BEDEWORK//US\n");
    sb.append("VERSION:2.0\n");
    sb.append(vtz.toString());
    sb.append("END:VCALENDAR\n");

    btz.setVtimezone(sb.toString());

    try {
      globals.rintf.restoreTimezone(btz);
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }
}
