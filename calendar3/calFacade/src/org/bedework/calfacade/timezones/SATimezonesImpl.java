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

import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.TimeZone;

/** Standalone implementation.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class SATimezonesImpl extends CalTimezones {
  private boolean publick = true; // current mode
  private BwUser user;

  /** Constructor
   * @param debug
   * @param user
   * @throws CalFacadeException
   */
  public SATimezonesImpl(boolean debug, BwUser user) throws CalFacadeException {
    super(debug);
  }

  public TimeZone getTimeZone(final String id) throws CalFacadeException {
    TimezoneInfo tzinfo = lookup(id);

    if (tzinfo == null) {
      return null;
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

    return null;
  }

  /** Set current publick mode
   *
   * @param val
   */
  public void setPublick(boolean val) {
    publick = val;
  }

  /**
   * @return boolean
   */
  public boolean getPublick() {
    return publick;
  }

  /** Set current user
   *
   * @param val
   */
  public void setUser(BwUser val) {
    user = val;
  }

  /**
   * @return BwUser
   */
  public BwUser getUser() {
    return user;
  }

  public void storeTimeZone(final String id, BwUser owner) throws CalFacadeException {
  }

  public void refreshTimezones() throws CalFacadeException {
    // force refresh now
    lookup("not-a-timezone");
  }

  public void saveTimeZone(String tzid, VTimeZone vtz)
          throws CalFacadeException {
    /* For a user update the map to avoid a refetch. For system timezones we will
       force a refresh when we're done.
    */

    /* Don't use lookup - we might be called from lookup on init */
    TimezoneInfo tzinfo = (TimezoneInfo)timezones.get(tzid);
    TimeZone tz = new TimeZone(vtz);

    if (tzinfo == null) {
      tzinfo = new TimezoneInfo(tz);
      timezones.put(tzid, tzinfo);
    } else {
      tzinfo.init(tz);
    }
  }
}
