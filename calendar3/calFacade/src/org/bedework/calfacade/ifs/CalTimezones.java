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

package org.bedework.calfacade.ifs;

import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;

import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.component.VTimeZone;

import java.io.Serializable;

/** Handle caching, retrieval and registration of timezones.
 *
 * @author Mike Douglass
 *
 */
public interface CalTimezones extends Serializable {
  /** Save a timezone definition in the database. The timezone is in the
   * form of a complete calendar definition containing a single VTimeZone
   * object.
   *
   * <p>The calendar must be on a path from a timezone root
   *
   * @param tzid
   * @param vtz
   * @throws CalFacadeException
   */
  public void saveTimeZone(String tzid, VTimeZone vtz)
          throws CalFacadeException;

  /** Register a timezone object in the current session.
  *
  * @param id
  * @param timezone
  * @throws CalFacadeException
  */
 public void registerTimeZone(String id, TimeZone timezone)
     throws CalFacadeException;

 /** Get a timezone object given the id. This will return transient objects
  * registered in the timezone directory
  *
  * @param id
  * @return TimeZone with id or null
  * @throws CalFacadeException
  */
 public TimeZone getTimeZone(final String id) throws CalFacadeException;

 /** Get the default timezone for this system.
  *
  * @return default TimeZone or null for none set.
  * @throws CalFacadeException
  */
 public TimeZone getDefaultTimeZone() throws CalFacadeException;

 /** Set the default timezone id for this system.
  *
  * @param id
  * @throws CalFacadeException
  */
 public void setDefaultTimeZoneId(String id) throws CalFacadeException;

 /** Get the default timezone id for this system.
 *
 * @return String id
 * @throws CalFacadeException
 */
 public String getDefaultTimeZoneId() throws CalFacadeException;

 /** Find a timezone object in the database given the id.
  *
  * @param id
  * @param owner     event owner or null for current user
  * @return VTimeZone with id or null
  * @throws CalFacadeException
  */
 public VTimeZone findTimeZone(final String id, BwUser owner) throws CalFacadeException;

 /** Clear all public timezone objects
  *
  * <p>Will remove all public timezones in preparation for a replacement
  * (presumably)
  *
  * @throws CalFacadeException
  */
 public void clearPublicTimezones() throws CalFacadeException;

 /** Refresh the public timezone table - presumably after a call to clearPublicTimezones.
  * and many calls to saveTimeZone.
  *
  * @throws CalFacadeException
  */
 public void refreshTimezones() throws CalFacadeException;

 /** Given a String time value and a possibly null tzid and/or timezone
  *  will return a UTC formatted value. The supplied time should be of the
  *  form yyyyMMdd or yyyyMMddThhmmss or yyyyMMddThhmmssZ
  *
  *  <p>The last form will be returned untouched, the first will have T000000Z
  *  appended and the second will be converted to the equivalent UTC time.
  *
  *  <p>The returned value is used internally as a value for indexes and
  *  recurrence ids.
  *
  *  <p>Both tzid and tz null mean this is local or floating time
  *
  * @param time  String time to convert.
  * @param tzid  String tzid.
  * @param tz    If set used in preference to tzid.
  * @return String always of form yyyyMMddThhmmssZ
  * @throws CalFacadeException for bad parameters or timezone
  */
 public String getUtc(String time, String tzid, TimeZone tz) throws CalFacadeException;
}
