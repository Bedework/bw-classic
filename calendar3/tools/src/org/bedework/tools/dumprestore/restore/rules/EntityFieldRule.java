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
package org.bedework.tools.dumprestore.restore.rules;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwOrganizer;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.tools.dumprestore.restore.RestoreGlobals;

import java.sql.Timestamp;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public abstract class EntityFieldRule extends RestoreRule {
  EntityFieldRule(RestoreGlobals globals) {
    super(globals);
  }

  protected transient String tagName;
  protected transient String fldval;

  /**
   * @param name
   * @throws Exception
   */
  public abstract void field(String name) throws Exception;

  public void body(String namespace, String name, String text)
      throws java.lang.Exception{
    /*
    if (globals.debug) {
      trace("Save field " + name);
    }
    */

    tagName = name;
    fldval = text;
  }

  public void end(String ns, String name) throws Exception {
    field(name);
  }

  /** prehib to hib */
  protected BwDateTime dateFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    /** Date should be of form yyyy-MM-dd, convert to yyyyMMdd
     */

    if ((fldval.length() != 10) ||
        (fldval.charAt(4) != '-') ||
        (fldval.charAt(7) != '-')) {
      throw new Exception("Bad value " + fldval + " for " + tagName);
    }

    String dtval = fldval.substring(0, 4) + fldval.substring(5, 7) +
                   fldval.substring(8, 10);

    BwDateTime dtim = new BwDateTime();
    dtim.init(true, dtval, null, globals.timezones);

    return dtim;
  }

  /** prehib to hib */
  protected void makeDateTimeFld(BwDateTime val) throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    if (val == null) {
      throw new Exception("No date for " + tagName);
    }

    /** Time should be of form hh:mm:ss, convert to Thhmmss
     */

    if ((fldval.length() != 8) ||
        (fldval.charAt(2) != ':') ||
        (fldval.charAt(5) != ':')) {
      throw new Exception("Bad value " + fldval + " for " + tagName);
    }

    String tmval = "T" + fldval.substring(0, 2) + fldval.substring(3, 5) +
                   fldval.substring(6, 8);

    /* XXX We need to handle timezones here as well */
    val.init(false, val.getDtval() + tmval, null, globals.timezones);
  }

  /** Make an iso date time -- prehib to hib */
  protected String isoDateTimeFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    /** Value should be of form yyyy-MM-dd hh:mm:ss.0 or yyyy-MM-dd hh:mm:ss,
        convert to yyyyMMddThhmmss
     */

    if ((fldval.length() < 21) ||
        (fldval.charAt(4) != '-') ||
        (fldval.charAt(7) != '-') ||
        (fldval.charAt(10) != ' ') ||
        (fldval.charAt(13) != ':') ||
        (fldval.charAt(16) != ':')) {
      throw new Exception("Bad value " + fldval + " for " + tagName);
    }

    String dtval = fldval.substring(0, 4) + fldval.substring(5, 7) +
                   fldval.substring(8, 10) +
                   "T" + fldval.substring(11, 13) + fldval.substring(14, 16) +
                   fldval.substring(17, 19);

    return dtval;
  }

  protected BwDateTime dateTimeFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    BwDateTime dtim = new BwDateTime();
    dtim.init(false, fldval, null, globals.timezones);

    return dtim;
  }

  protected BwCategory categoryFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    int id = Integer.parseInt(fldval);

    BwCategory category = globals.categoriesTbl.get(id);

    if (category == null) {
      if (globals.failOnError) {
        throw new Exception("Missing category with id " + id + " for " + top());
      }
      error("Missing category with id " + id + " for " + top());
    }

    return category;
  }

  protected BwCalendar calendarFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    int id = Integer.parseInt(fldval);

    return (BwCalendar)globals.calendars.get(new Integer(id));
  }

  protected BwFilter filterFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    int id = Integer.parseInt(fldval);

    BwFilter f = new BwFilter();

    f.setId(id);

    return f;
  }

  protected BwUser userFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    int id = Integer.parseInt(fldval);

    BwUser user = globals.usersTbl.get(id);

    if (user == null) {
      if (globals.failOnError) {
        throw new Exception("Missing user with id " + id + " for " + top());
      }
      error("Missing user with id " + id + " for " + top());
    }

    return user;
  }

  protected BwGroup groupFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    int id = Integer.parseInt(fldval);

    BwGroup g = new BwGroup();

    g.setId(id);

    return g;
  }

  protected BwLocation locationFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    int id = Integer.parseInt(fldval);

    BwLocation val = globals.locationsTbl.get(id);

    if (val == null) {
      throw new Exception("Missing location with id " + id + " for " + top());
    }

    return val;
  }

  protected BwSponsor sponsorFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    int id = Integer.parseInt(fldval);

    BwSponsor val = globals.sponsorsTbl.get(id);

    if (val == null) {
      throw new Exception("Missing sponsor with id " + id + " for " + top());
    }

    return val;
  }

  protected BwOrganizer organizerFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    int id = Integer.parseInt(fldval);

    BwOrganizer val = globals.organizersTbl.get(id);

    if (val == null) {
      throw new Exception("Missing organizer with id " + id + " for " + top());
    }

    return val;
  }

  protected int intFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    return Integer.parseInt(fldval);
  }

  protected long longFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    return Long.parseLong(fldval);
  }

  protected Timestamp timestampFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    return  Timestamp.valueOf(fldval);
  }

  protected String stringFld() throws Exception {
    return  fldval;
  }

  protected boolean booleanFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    return  "true".equals(fldval);
  }

  protected char charFld() throws Exception {
    if (fldval == null) {
      throw new Exception("No value for " + tagName);
    }

    if (fldval.length() != 1) {
      throw new Exception("Bad value for fld" + fldval + " for tag " + tagName);
    }

    return fldval.charAt(0);
  }
}

