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
package org.bedework.dumprestore.restore.rules;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwUser;
import org.bedework.dumprestore.restore.RestoreGlobals;

import java.util.Iterator;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class FiltersRule extends RestoreRule {
  /** Constructor
   *
   * @param globals
   */
  public FiltersRule(RestoreGlobals globals) {
    super(globals);
  }

  /* Finished doing filters - if we're converting from 2.3.2 to version 3
   * fix up the new calendar definitions.
   *
   * (non-Javadoc)
   * @see org.apache.commons.digester.Rule#end(java.lang.String, java.lang.String)
   */
  public void end(String ns, String name) throws Exception {
    if (!globals.from2p3px) {
      // Not converting
      return;
    }

    try {
      /* We are converting filter definitions into calendar definitions.
       */
      if (globals.rintf != null) {
        globals.rintf.restoreCalendars(globals.publicCalRoot);
      }

      // Ensure public user in user table.
      globals.getPublicUser();

      /* Create a root level user calendar collection.
       */
      BwCalendar userRootCal = new BwCalendar();
      userRootCal.setId(globals.nextCalKey);
      globals.nextCalKey++;
      userRootCal.setName(globals.syspars.getUserCalendarRoot());
      userRootCal.setPath("/" + globals.syspars.getUserCalendarRoot());
      userRootCal.setCreator(globals.getPublicUser());
      userRootCal.setOwner(globals.getPublicUser());
      if (globals.rintf != null) {
        globals.rintf.restoreCalendars(userRootCal);
      }

      Iterator it = globals.usersTbl.values().iterator();
      while (it.hasNext()) {
        BwUser u = (BwUser)it.next();

        makeUserCals(u, userRootCal);
      }
    } catch (Throwable t) {
      throw new Exception(t);
    }
  }

  private void makeUserCals(BwUser u, BwCalendar userRootCal) throws Throwable {
    /* Create a user collection */

    /* Create a folder for the user */
    BwCalendar ucal = new BwCalendar();
    ucal.setId(globals.nextCalKey);
    globals.nextCalKey++;
    ucal.setName(u.getAccount());
    ucal.setPath(userRootCal.getPath() + "/" + u.getAccount());
    ucal.setCreator(u);
    ucal.setOwner(u);
    ucal.setCalendar(userRootCal);
    userRootCal.addChild(ucal);

    /* Create a default calendar */
    BwCalendar cal = new BwCalendar();
    cal.setId(globals.nextCalKey);
    globals.nextCalKey++;
    cal.setName(globals.syspars.getUserDefaultCalendar());
    cal.setPath(ucal.getPath() + "/" + cal.getName());
    cal.setCreator(u);
    cal.setOwner(u);
    cal.setCalendar(ucal);
    cal.setCalendarCollection(true);
    ucal.addChild(cal);

    globals.calendars.put(new Integer(cal.getId()), cal);

    globals.defaultCalendars.put(new Integer(u.getId()), cal);

    /* Add the trash calendar */
    cal = new BwCalendar();
    cal.setId(globals.nextCalKey);
    globals.nextCalKey++;
    cal.setName(globals.syspars.getDefaultTrashCalendar());
    cal.setPath(ucal.getPath() + "/" + cal.getName());
    cal.setCreator(u);
    cal.setOwner(u);
    cal.setCalendar(ucal);
    cal.setCalendarCollection(true);
    ucal.addChild(cal);

    /* Add the inbox */
    cal = new BwCalendar();
    cal.setId(globals.nextCalKey);
    globals.nextCalKey++;
    cal.setName(globals.syspars.getUserInbox());
    cal.setPath(ucal.getPath() + "/" + cal.getName());
    cal.setCreator(u);
    cal.setOwner(u);
    cal.setCalendar(ucal);
    cal.setCalendarCollection(true);
    ucal.addChild(cal);

    /* Add the outbox */
    cal = new BwCalendar();
    cal.setId(globals.nextCalKey);
    globals.nextCalKey++;
    cal.setName(globals.syspars.getUserOutbox());
    cal.setPath(ucal.getPath() + "/" + cal.getName());
    cal.setCreator(u);
    cal.setOwner(u);
    cal.setCalendar(ucal);
    cal.setCalendarCollection(true);
    ucal.addChild(cal);

    if (globals.rintf != null) {
      globals.rintf.restoreCalendars(ucal);
      globals.rintf.fixUserEventsCal(u, cal);
      globals.rintf.update(u);
    }
  }
}

