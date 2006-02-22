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

package org.bedework.appcommon;

import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.component.VTimeZone;

import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.CalTimezones;

import java.util.HashMap;

/** This class caches the utc times calculated when we display events in day
 * chunks. There are a limited number of such utc times and calculating them is 
 * expensive.
 *
 * @author  Mike Douglass douglm@rpi.edu
 */
public class TimezoneCache extends CalTimezones {
  /* We have one cache per timezone
   */
  private HashMap caches = new HashMap();

  private HashMap defaultCache = new HashMap();

  private CalTimezones sysTimezones;
  
  public TimezoneCache(boolean debug) {
    super(debug);
  }
  
  public void setSysTimezones(CalTimezones val) {
    sysTimezones = val;
  }
  
  public void saveTimeZone(String tzid, VTimeZone vtz)
          throws CalFacadeException {
    sysTimezones.saveTimeZone(tzid, vtz);
  }

  public void registerTimeZone(String id, TimeZone timezone)
          throws CalFacadeException {
    sysTimezones.registerTimeZone(id, timezone);
  }
  
  public TimeZone getTimeZone(final String id) throws CalFacadeException {
    return sysTimezones.getTimeZone(id);
  }

  public TimeZone getDefaultTimeZone() throws CalFacadeException {
    return sysTimezones.getDefaultTimeZone();
  }

  public void setDefaultTimeZoneId(String id) throws CalFacadeException {
    sysTimezones.setDefaultTimeZoneId(id);
  }

  public String getDefaultTimeZoneId() throws CalFacadeException {
    return sysTimezones.getDefaultTimeZoneId();
  }

  public VTimeZone findTimeZone(final String id, BwUser owner) throws CalFacadeException {
    return sysTimezones.findTimeZone(id, owner);
  }

  public void clearPublicTimezones() throws CalFacadeException {
    sysTimezones.clearPublicTimezones();
    caches.clear();
    defaultCache.clear();
  }

  public void refreshTimezones() throws CalFacadeException {
    sysTimezones.refreshTimezones();
    caches.clear();
    defaultCache.clear();
  }

  public synchronized String getUtc(String time, String tzid, TimeZone tz) 
          throws CalFacadeException {
    if (time.length() != 8) {
      return sysTimezones.getUtc(time, tzid, tz);
    }

    HashMap cache;
    
    if (tz == null) {
      cache = defaultCache;
    } else if (tz.equals(getDefaultTimeZoneId())) {
      cache = defaultCache;
    } else {
      cache = (HashMap)caches.get(tzid);
      if (cache == null) {
        cache = new HashMap();
        caches.put(tzid, cache);
      }
    }
    
    String utc = (String)cache.get(time);
    
    if (utc != null) {
      return utc;
    }
    
    utc = sysTimezones.getUtc(time, tzid, tz);
    cache.put(time, utc);
    return utc;
  }
}
