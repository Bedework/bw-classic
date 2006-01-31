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

package org.bedework.icalendar;

import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.CalTimezones;

import edu.rpi.cct.uwcal.common.URIgen;

import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.TimeZone;

import java.io.Serializable;
import java.util.Collection;

/** Allow the translation process to retrieve objects and information it might
 * need from the system.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public interface IcalCallback extends Serializable {
  /** Get the current user
   *
   * @return User object
   * @throws CalFacadeException
   */
  public BwUser getUser() throws CalFacadeException;

  /** Look for the given category. Return null for not found.
   *
   * @param val
   * @return Category object
   * @throws CalFacadeException
   */
  public BwCategory findCategory(BwCategory val) throws CalFacadeException;

  /** Add the given category.
   *
   * @param val
   * @throws CalFacadeException
   */
  public void addCategory(BwCategory val) throws CalFacadeException;

  /** Ensure the location exists and return it.
   *
   * @param address
   * @return Location object
   * @throws CalFacadeException
   */
  public BwLocation ensureLocationExists(String address) throws CalFacadeException;

  /** Return a Collection of EventInfo objects. More than one for a recurring
   * event with overrides.
   *
   * @param guid
   * @param rid
   * @param seqnum
   * @param recurRetrieval Takes value defined in CalFacadeDefs.
   * @return Collection of EventInfo
   * @throws CalFacadeException
   */
  public Collection getEvent(String guid, String rid,
                             Integer seqnum,
                             int recurRetrieval) throws CalFacadeException;

  /** URIgen object used to provide ALTREP values - or null for no altrep
   *
   * @return object or null
   * @throws CalFacadeException
   */
  public URIgen getURIgen() throws CalFacadeException;

  /** Get the tzproc cache object
   *
   * @return CalTimezones object
   * @throws CalFacadeException if not admin
   */
  public CalTimezones getTimezones() throws CalFacadeException;

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
  public void saveTimeZone(String tzid, VTimeZone vtz
                           ) throws CalFacadeException;

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

  /** Find a timezone object in the database given the id.
   *
   * @param id
   * @param owner     event owner or null for current user
   * @return VTimeZone with id or null
   * @throws CalFacadeException
   */
  public VTimeZone findTimeZone(final String id, BwUser owner) throws CalFacadeException;
}

