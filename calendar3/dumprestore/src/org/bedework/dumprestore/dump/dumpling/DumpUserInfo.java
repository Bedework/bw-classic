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
package org.bedework.dumprestore.dump.dumpling;

import org.bedework.calfacade.BwUserInfo;
import org.bedework.dumprestore.dump.DumpGlobals;

import java.util.Collection;
import java.util.Iterator;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpUserInfo extends Dumpling {
  /** Constructor
   *
   * @param globals
   */
  public DumpUserInfo(DumpGlobals globals) {
    super(globals);
  }

  /* (non-Javadoc)
   * @see org.bedework.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    tagStart(sectionUserInfo);

    while (it.hasNext()) {
      BwUserInfo ui = (BwUserInfo)it.next();

      dumpUserInfo(ui);
    }

    tagEnd(sectionUserInfo);
  }

  private void dumpUserInfo(BwUserInfo ui) throws Throwable {
    tagStart(objectUserInfo);

    taggedVal("id", ui.getUser().getId());
    taggedVal("lastname", ui.getLastname());
    taggedVal("firstname", ui.getFirstname());
    taggedVal("phone", ui.getPhone());
    taggedVal("email", ui.getEmail());
    taggedVal("department", ui.getDept());

    tagStart("properties");

    Collection props = ui.getProperties();

    Iterator pi = props.iterator();

    while (pi.hasNext()) {
      BwUserInfo.UserProperty p = (BwUserInfo.UserProperty)pi.next();

      tagStart("property");
      taggedVal("name", p.getName());
      taggedVal("name", p.getVal());
      tagEnd("property");
    }

    tagEnd("properties");
    tagEnd(objectUserInfo);

    globals.authusers++;
  }
}

