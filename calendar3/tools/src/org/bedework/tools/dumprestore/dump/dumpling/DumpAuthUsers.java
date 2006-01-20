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
package org.bedework.tools.dumprestore.dump.dumpling;

import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.BwAuthUserPrefs;
import org.bedework.tools.dumprestore.dump.DumpGlobals;



import java.util.Iterator;
import java.util.Set;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpAuthUsers extends Dumpling {
  /** Constructor
   *
   * @param globals
   */
  public DumpAuthUsers(DumpGlobals globals) {
    super(globals);
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    tagStart(sectionAuthUsers);

    while (it.hasNext()) {
      BwAuthUser au = (BwAuthUser)it.next();

      dumpAuthUser(au);
    }

    tagEnd(sectionAuthUsers);
  }

  private void dumpAuthUser(BwAuthUser au) throws Throwable {
    tagStart(objectAuthUser);

    taggedVal("id", au.getUser().getId());
    taggedVal("userType", au.getUsertype());

    tagStart("preferences");

    BwAuthUserPrefs aup = au.getPrefs();

    if (aup != null) {
      taggedVal("autoAddCategories", aup.getAutoAddCategories());
      taggedVal("autoAddLocations", aup.getAutoAddLocations());
      taggedVal("autoAddSponsors", aup.getAutoAddSponsors());

      Set s = aup.getPreferredCategories();
      if ((s != null) && (s.size() > 0)) {
        tagStart("preferredCategories");

        Iterator si = s.iterator();

        while (si.hasNext()) {
          BwCategory p = (BwCategory)si.next();

          taggedVal("preferredCategory", p.getId());
        }

        tagEnd("preferredCategories");
      }

      s = aup.getPreferredLocations();
      if ((s != null) && (s.size() > 0)) {
        tagStart("preferredLocations");

        Iterator si = s.iterator();

        while (si.hasNext()) {
          BwLocation p = (BwLocation)si.next();

          taggedVal("preferredLocation", p.getId());
        }

        tagEnd("preferredLocations");
      }

      s = aup.getPreferredSponsors();
      if ((s != null) && (s.size() > 0)) {
        tagStart("preferredSponsors");

        Iterator si = s.iterator();

        while (si.hasNext()) {
          BwSponsor p = (BwSponsor)si.next();

          taggedVal("preferredSponsor", p.getId());
        }

        tagEnd("preferredSponsors");
      }
    }

    tagEnd("preferences");
    tagEnd(objectAuthUser);

    globals.authusers++;
  }
}

