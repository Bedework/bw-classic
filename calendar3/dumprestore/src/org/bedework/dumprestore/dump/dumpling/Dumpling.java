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
package org.bedework.dumprestore.dump.dumpling;

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.base.BwDbentity;
import org.bedework.calfacade.base.BwOwnedDbentity;
import org.bedework.calfacade.base.BwShareableContainedDbentity;
import org.bedework.calfacade.base.BwShareableDbentity;
import org.bedework.dumprestore.Defs;
import org.bedework.dumprestore.dump.DumpGlobals;

import java.io.Writer;
import java.util.Iterator;

import org.apache.log4j.Logger;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public abstract class Dumpling implements Defs {
  protected DumpGlobals globals;

  private transient Logger log;

  protected Dumpling(DumpGlobals globals) {
    this.globals = globals;
  }

  /** Dump the whole section e.g. locations or events.
   * The order this takes place in is important for a couple of reasons.
   * <ul><li>Database constraints may require we restore in a certain order</li>
   * <li>The restore process also assumes the availability of some objects
   * either in internal tables or in the db.</li></ul>
   *
   * @param it
   * @throws Throwable
   */
  public abstract void dumpSection(Iterator it) throws Throwable;

  protected void indentIn() {
    globals.indentIn();
  }

  protected void indentOut() {
    globals.indentOut();
  }

  protected String indent() {
    return globals.getIndent();
  }

  protected Writer out() {
    return globals.getOut();
  }

  protected void tagStart(String name) throws Throwable {
    out().write(indent() + "<" + name + ">");
    out().write('\n');
    indentIn();
  }

  protected void tagEnd(String name) throws Throwable {
    indentOut();
    out().write(indent() + "</" + name + ">");
    out().write('\n');
  }

  protected void taggedVal(String name, boolean val) throws Throwable {
    out().write(indent() + "<" + name + ">" +
                val +
                "</" + name + ">");
    out().write('\n');
  }

  protected void taggedVal(String name, char val) throws Throwable {
    out().write(indent() + "<" + name + ">" +
                val +
                "</" + name + ">");
    out().write('\n');
  }

  protected void taggedVal(String name, int val) throws Throwable {
    out().write(indent() + "<" + name + ">" +
                val +
                "</" + name + ">");
    out().write('\n');
  }

  protected void taggedVal(String name, long val) throws Throwable {
    out().write(indent() + "<" + name + ">" +
                val +
                "</" + name + ">");
    out().write('\n');
  }

  protected void principalTags(BwPrincipal val) throws Throwable {
    taggedEntityId(val);
    taggedVal("account", val.getAccount());
    taggedVal("created", val.getCreated());
    taggedVal("logon", val.getLogon());
    taggedVal("lastAccess", val.getLastAccess());
    taggedVal("lastModify", val.getLastModify());
    taggedVal("category-access", val.getCategoryAccess());
    taggedVal("location-access", val.getLocationAccess());
    taggedVal("sponsor-access", val.getSponsorAccess());
  }

  protected void shareableEntityTags(BwShareableDbentity entity) throws Throwable {
    ownedEntityTags(entity);

    taggedEntityId("creator", entity.getCreator());
    taggedVal("access", entity.getAccess());
  }

  protected void shareableContainedEntityTags(BwShareableContainedDbentity entity)
          throws Throwable {
    shareableEntityTags(entity);

    taggedEntityId("calendar", entity.getCalendar());
    taggedVal("access", entity.getAccess());
  }

  protected void ownedEntityTags(BwOwnedDbentity entity) throws Throwable {
    taggedEntityId(entity);

    taggedEntityId("owner", entity.getOwner());
    taggedVal("public", entity.getPublick());
  }

  protected void taggedEntityId(BwDbentity entity) throws Throwable {
    taggedVal("id", entity.getId());
    taggedVal("seq", entity.getSeq());
  }

  protected void taggedEntityId(String name, BwDbentity entity) throws Throwable {
    if (entity == null) {
      return;
    }

    taggedVal(name, entity.getId());
  }

  protected void taggedDateTime(String prefix, BwDateTime dt) throws Throwable {
    taggedVal(prefix + "-date-type", dt.getDateType());
    taggedVal(prefix + "-tzid", dt.getTzid());
    taggedVal(prefix + "-dtval", dt.getDtval());
    taggedVal(prefix + "-date", dt.getDate());
  }

  /** Anything for which toString() works OK
   */
  protected void taggedVal(String name, Object val) throws Throwable {
    if (val == null) {
      return;
    }

    String sval = String.valueOf(val);

    if (sval.length() == 0) {
      return;
    }

    if ((sval.indexOf('&') < 0) && (sval.indexOf('<') < 0)) {
      out().write(indent() + "<" + name + ">" +
                  sval +
                  "</" + name + ">");
    } else {
      out().write(indent() + "<" + name + ">" +
                  "<![CDATA[" + sval + "]]>" +
                  "</" + name + ">");
    }

    out().write('\n');
  }

  protected Logger getLog() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void info(String msg) {
    getLog().info(msg);
  }

  protected void error(String msg) {
    getLog().error(msg);
  }

  protected void trace(String msg) {
    getLog().debug(msg);
  }
}

