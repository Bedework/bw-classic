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
import org.bedework.calfacade.filter.BwAndFilter;
import org.bedework.calfacade.filter.BwCategoryFilter;
import org.bedework.calfacade.filter.BwCreatorFilter;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.filter.BwLocationFilter;
import org.bedework.calfacade.filter.BwNotFilter;
import org.bedework.calfacade.filter.BwOrFilter;
import org.bedework.calfacade.filter.BwSponsorFilter;
import org.bedework.dumprestore.restore.RestoreGlobals;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class FilterRule extends EntityRule {
  /** Constructor
   *
   * @param globals
   */
  public FilterRule(RestoreGlobals globals) {
    super(globals);
  }

  public void end(String ns, String name) throws Exception {
    BwFilter entity = (BwFilter)pop();
    globals.filters++;

    globals.filtersTbl.put(entity);

    try {
      if (globals.from2p3px) {
        /* We are converting filter definitions into calendar definitions.
         */
        BwCalendar cal = new BwCalendar();
        cal.setName(fixName(entity.getName()));

        BwUser calOwner = globals.getPublicUser();

        cal.setCreator(calOwner);
        cal.setOwner(calOwner);
        cal.setPublick(true);

        if (entity instanceof BwAndFilter) {
          error("Unable to map filter " + entity);
          cal = null;
          globals.calMapErrors++;
        } else if (entity instanceof BwCategoryFilter) {
          BwCategoryFilter catf = (BwCategoryFilter)entity;

          cal.setCalendarCollection(true);
          globals.calLeaves.add(entity);
          globals.catCalTbl.put(catf.getCategory().getId(), cal);
          if (globals.debug) {
            trace("Save calendar with id " + cal.getId());
          }
        } else if (entity instanceof BwCreatorFilter) {
          cal.setCalendarCollection(true);
          globals.calLeaves.add(entity);
        } else if (entity instanceof BwLocationFilter) {
          cal.setCalendarCollection(true);
          globals.calLeaves.add(entity);
        } else if (entity instanceof BwOrFilter) {
          if (entity.getId() == 2) {
            if (globals.publicCalRoot != null) {
              error("Seen two roots " + entity);
              cal = null;
              globals.calMapErrors++;
            }

            // This is the root
            globals.publicCalRoot = cal;
            globals.publicCalRoot.setName(globals.syspars.getPublicCalendarRoot());
            globals.publicCalRoot.setPath("/" + globals.syspars.getPublicCalendarRoot());

            globals.publicCalRoot.setAccess(globals.getDefaultPublicCalendarsAccess());
          }
        } else if (entity instanceof BwSponsorFilter) {
          cal.setCalendarCollection(true);
          globals.calLeaves.add(entity);
        } else if (entity instanceof BwNotFilter) {
          error("Unable to map filter " + entity);
          cal = null;
          globals.calMapErrors++;
        } else if (entity instanceof RestoreGlobals.AliasFilter) {
          error("Unable to map filter " + entity);
          cal = null;
          globals.calMapErrors++;
        } else {
          error("Unable to map filter " + entity);
          cal = null;
          globals.calMapErrors++;
        }

        if (cal != null) {
          cal.setId(globals.nextCalKey);
          globals.nextCalKey++;

          globals.calendarsTbl.put(new Integer(cal.getId()), cal);

          if (entity.getParent() != null) {
            BwCalendar parent = (BwCalendar)globals.filterToCal.get(
                new Integer(entity.getParent().getId()));

            if (parent == null) {
              error("Missing parent in mapping tbl " + entity);
              globals.calMapErrors++;
            } else {
              cal.setCalendar(parent);
              cal.setPath(parent.getPath() + "/" + cal.getName());
              if (cal.getPath().equals(globals.defaultPublicCalPath)) {
                globals.defaultPublicCal = cal;
              }
              parent.addChild(cal);
            }
          }

          globals.filterToCal.put(new Integer(entity.getId()), cal);
        }

        entity.setOwner(globals.getPublicUser());
        entity.setPublick(true);
      }

      if (globals.rintf != null) {
        trace("About to restore filter " + entity);
        globals.rintf.restoreFilter(entity);
      }
    } catch (Throwable t) {
      throw new Exception(t);
    }
  }

  /* There are restrictions on what is valid in calendar names.
   */
  private String fixName(String val) {
    boolean changed = false;
    StringBuffer sb = new StringBuffer(val);

    do {
      changed = false;

      /* First character - letter or digit  */

      if (!Character.isLetterOrDigit(sb.charAt(0))) {
        char ch = sb.charAt(0);

        if ((ch == ' ') || (ch == '_') || (ch == '/')) {
          sb.deleteCharAt(0);
        } else {
          sb.insert(0, 'X');
        }
        changed = true;
      } else {
        for (int i = 1; i < sb.length(); i++) {
          char ch = sb.charAt(i);

          if (!Character.isLetterOrDigit(ch) &&
              (ch != '_') && (ch != ' ')) {
            sb.setCharAt(i, '_');
            changed = true;
          }
        }
      }
    } while (changed && (sb.length() > 0));

    String newVal = sb.toString();
    if (!BwCalendar.checkName(newVal)) {
      // Unable to fix it?
      newVal = "UnableToFixName";
    }

    if (!newVal.equals(val)) {
      globals.fixedCalendarNames.add(val);
      globals.fixedCalendarNames.add(newVal);
    }

    return newVal;
  }
}

