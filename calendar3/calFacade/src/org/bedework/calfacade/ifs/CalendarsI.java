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

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;

import java.io.Serializable;
import java.util.Collection;

/** This is the calendars section of the low level interface to the calendar
 * database.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public interface CalendarsI extends Serializable {

  /* ====================================================================
   *                   Calendars
   * ==================================================================== */

  /** Returns the tree of public calendars. The returned objects are those to
   * which the current user has access and are copies of the actual db objects,
   * that is, the actual db objecst will need to be fetched for updates.
   *
   * @return BwCalendar   root with all children attached
   * @throws CalFacadeException
   */
  public BwCalendar getPublicCalendars() throws CalFacadeException;

  /** Return a list of public calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of CalendarVO
   * @throws CalFacadeException
   */
  public Collection getPublicCalendarCollections() throws CalFacadeException;

  /** Returns calendars owned by the current user.
   *
   * <p>For authenticated, personal access this always returns the user
   * entry in the /user calendar tree, e.g. for user smithj it would return
   * an entry /user/smithj
   *
   * @return BwCalendar   root with all children attached
   * @throws CalFacadeException
   */
  public BwCalendar getCalendars() throws CalFacadeException;

  /** Returns calendars owned by the given user.
   *
   * <p>For authenticated, personal access this always returns the user
   * entry in the /user calendar tree, e.g. for user smithj it would return
   * an entry smithj
   *
   * @param  user         BwUser entry
   * @param  desiredAccess access we need
   * @return BwCalendar   root with all children attached
   * @throws CalFacadeException
   */
  public BwCalendar getCalendars(BwUser user,
                                 int desiredAccess) throws CalFacadeException;

  /** Return a list of user calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of CalendarVO
   * @throws CalFacadeException
   */
  public Collection getCalendarCollections() throws CalFacadeException;

  /** Return a list of calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of BwCalendar
   * @throws CalFacadeException
   */
  public Collection getAddContentPublicCalendarCollections()
          throws CalFacadeException;

  /** Return a list of calendars in which calendar objects can be
   * placed by the current user.
   *
   * <p>Caldav currently does not allow collections inside collections so that
   * calendar collections are the leaf nodes only.
   *
   * @return Collection   of BwCalendar
   * @throws CalFacadeException
   */
  public Collection getAddContentCalendarCollections()
          throws CalFacadeException;

  /** Get a calendar we are interested in. This is represented by the id
   * of a calendar.
   *
   * @param  val     int id of calendar
   * @return CalendarVO null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getCalendar(int val) throws CalFacadeException;

  /** Get a calendar given the path
   *
   * @param  path     String path of calendar
   * @param  desiredAccess int access we need
   * @return BwCalendar null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getCalendar(String path,
                                int desiredAccess) throws CalFacadeException;

  /** Get the default calendar for the given user. This is determined by the
   * name for the default calendar assigned to the system, not by any user
   * preferences. This is normally used at initialisation of a new user.
   *
   * @param  user
   * @return BwCalendar null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getDefaultCalendar(BwUser user) throws CalFacadeException;

  /** Get the trash calendar for the given user.
   *
   * @param  user
   * @return BwCalendar null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getTrashCalendar(BwUser user) throws CalFacadeException;

  /** Get the deleted calendar for the given user. This holds annotations
   * marking other events as deleted
   *
   * @param  user
   * @return BwCalendar null for unknown calendar
   * @throws CalFacadeException
   */
  public BwCalendar getDeletedCalendar(BwUser user) throws CalFacadeException;

  /** Add a calendar object
   *
   * <p>The new calendar object will be added to the db. If the indicated parent
   * is null it will be added as a root level calendar.
   *
   * <p>Certain restrictions apply, mostly because of interoperability issues.
   * A calendar cannot be added to another calendar which already contains
   * entities, e.g. events etc.
   *
   * <p>Names cannot contain certain characters - (complete this)
   *
   * <p>Name must be unique at this level, i.e. all paths must be unique
   *
   * @param  val     CalendarVO new object
   * @param  parent  CalendarVO object or null for root level
   * @throws CalFacadeException
   */
  public void addCalendar(BwCalendar val, BwCalendar parent) throws CalFacadeException;

  /** Update a calendar object
   *
   * @param  val     CalendarVO object
   * @throws CalFacadeException
   */
  public void updateCalendar(BwCalendar val) throws CalFacadeException;

  /** Delete the given calendar
   *
   * <p>XXX Do we want a recursive flag or do we implement that higher up?
   *
   * @param val      CalendarVO object to be deleted
   * @return boolean false if it didn't exist, true if it was deleted.
   * @throws CalFacadeException
   */
  public boolean deleteCalendar(BwCalendar val) throws CalFacadeException;

  /** Check to see if a calendar is referenced.
   *
   * @param val      CalendarVO object to check
   * @return boolean true if the calendar is referenced somewhere
   * @throws CalFacadeException
   */
  public boolean checkCalendarRefs(BwCalendar val) throws CalFacadeException;
}
