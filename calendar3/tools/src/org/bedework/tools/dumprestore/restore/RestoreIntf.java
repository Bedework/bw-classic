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

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwOrganizer;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwSystem;
import org.bedework.calfacade.BwTimeZone;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.BwUserInfo;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.BwPreferences;
import org.bedework.tools.dumprestore.BwDbLastmod;

/** Interface which defines the database functions needed to restore the
 * calendar database. The methods need to be called in the order defined
 * below.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public interface RestoreIntf {
  /**
   * @param url
   * @param className
   * @param id
   * @param pw
   * @param dbType
   * @param globals
   * @throws Throwable
   */
  public void init(String url,
                   String className,
                   String id,
                   String pw,
                   int dbType,
                   RestoreGlobals globals) throws Throwable;

  /**
   * @param globals
   * @throws Throwable
   */
  public void init(RestoreGlobals globals) throws Throwable;

  /** Call after any init phase
   *
   * @throws Throwable
   */
  public void open() throws Throwable;

  /** Call at end of restoring to finish up. Will restore any cached values.
   *
   * @throws Throwable
   */
  public void close() throws Throwable;

  /** Restore system pars
   *
   * @param o
   * @throws Throwable
   */
  public void restoreSyspars(BwSystem o) throws Throwable;

  /** Restore user
   *
   * @param o
   * @throws Throwable
   */
  public void restoreUser(BwUser o) throws Throwable;

  /** Restore user info
   *
   * @param o
   * @throws Throwable
   */
  public void restoreUserInfo(BwUserInfo o) throws Throwable;

  /** Restore timezone
   *
   * @param o
   * @throws Throwable
   */
  public void restoreTimezone(BwTimeZone o) throws Throwable;

  /** Restore an admin group - though not the user entries nor
   * the authuser entries.
   *
   * @param o   Object to restore with id set
   * @throws Throwable
   */
  public void restoreAdminGroup(BwAdminGroup o) throws Throwable;

  /** Restore an auth user and preferences
   *
   * @param o   Object to restore with id set
   * @throws Throwable
   */
  public void restoreAuthUser(BwAuthUser o) throws Throwable;

  /** Restore an event and associated entries
   *
   * @param o   Object to restore with id set
   * @throws Throwable
   */
  public void restoreEvent(BwEvent o) throws Throwable;

  /** Update an event
   *
   * @param o   Object to restore with id set
   * @throws Throwable
   */
  public void update(BwEvent o) throws Throwable;

  /** Restore category
   *
   * @param o   Object to restore with id set
   * @throws Throwable
   */
  public void restoreCategory(BwCategory o) throws Throwable;

  /** Restore location
   *
   * @param o   Object to restore with id set
   * @return Integer index of already saved entry with same key fields or null
   *              for saved ok.
   * @throws Throwable
   */
  public Integer restoreLocation(BwLocation o) throws Throwable;

  /** Restore organizer
   *
   * @param o   Object to restore with id set
   * @throws Throwable
   */
  public void restoreOrganizer(BwOrganizer o) throws Throwable;

  /** Restore sponsor
   *
   * @param o   Object to restore with id set
   * @return Integer index of already saved entry with same key fields or null
   *              for saved ok.
   * @throws Throwable
   */
  public Integer restoreSponsor(BwSponsor o) throws Throwable;

  /** Restore filter
   *
   * @param o   Object to restore with id set
   * @throws Throwable
   */
  public void restoreFilter(BwFilter o) throws Throwable;

  /** Restore user prefs
   *
   * @param o   Object to restore with id set
   * @throws Throwable
   */
  public void restoreUserPrefs(BwPreferences o) throws Throwable;

  /** Update user.
   *
   * @param user  Object to restore with id set
   * @throws Throwable
   */
  public void update(BwUser user) throws Throwable;

  /**
   * @param o
   * @throws Throwable
   */
  public void restoreDbLastmod(BwDbLastmod o) throws Throwable;

  /** Update all events for given user and set cal as the default calendar.
   *
   * @param u
   * @param cal
   * @return  int num updated
   * @throws Throwable
   */
  public int fixUserEventsCal(BwUser u, BwCalendar cal) throws Throwable;

  /**
   * @param val
   * @throws Throwable
   */
  public void restoreCalendars(BwCalendar val) throws Throwable;
}

