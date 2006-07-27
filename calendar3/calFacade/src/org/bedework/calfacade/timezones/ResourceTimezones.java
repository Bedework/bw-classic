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
package org.bedework.calfacade.timezones;

import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.TimeZoneInfo;

import java.io.InputStream;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

import org.apache.log4j.Logger;

/** Standalone implementation which initialises from a resource.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class ResourceTimezones extends SATimezonesImpl {
  private static String timezonesFile = "/properties/calendar/timezones.xml";

  private Set timezoneIds = new TreeSet();

  /** Constructor
   * @param debug
   * @param user
   * @throws CalFacadeException
   */
  public ResourceTimezones(boolean debug, BwUser user) throws CalFacadeException {
    super(debug, user);
  }

  /** Get Set of timezone info containing ids.
   *
   * @return Set of TimeZoneInfo
   */
  public Set getTimezoneIds() {
    return timezoneIds;
  }

  /* ====================================================================
   *                   Protected methods
   * ==================================================================== */

  /** Called when the lookup method finds that system timezones need to
   * be initialised.
   *
   * @throws CalFacadeException
   */
  protected void initSystemTimeZones() throws CalFacadeException {
    synchronized (this) {
      if (systemTimezonesInitialised) {
        return;
      }

      loadTimezones();
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

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private void loadTimezones() throws CalFacadeException {
    if (userTimezonesInitialised) {
      return;
    }

    InputStream is = null;

    try {
      try {
        // The jboss?? way - should work for others as well.
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        is = cl.getResourceAsStream(timezonesFile);
      } catch (Throwable clt) {}

      if (is == null) {
        // Try another way
        is = ResourceTimezones.class.getResourceAsStream(timezonesFile);
      }

      if (is == null) {
        throw new CalFacadeException("Unable to load properties file" +
                                  timezonesFile);
      }

      TimeZonesParser tzp = new TimeZonesParser(is, debug);

      Collection tzis = tzp.getTimeZones();

      Iterator it = tzis.iterator();
      while (it.hasNext()) {
        TimeZonesParser.TimeZoneInfo tzi = (TimeZonesParser.TimeZoneInfo)it.next();

        timezoneIds.add(new TimeZoneInfo(tzi.tzid, true));
        saveTimeZone(tzi.tzid, tzi.timezone);
      }
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      Logger.getLogger(ResourceTimezones.class).error("loadTimezones error", t);
      throw new CalFacadeException(t.getMessage());
    } finally {
      if (is != null) {
        try {
          is.close();
        } catch (Throwable t1) {}
      }
    }
  }
}
