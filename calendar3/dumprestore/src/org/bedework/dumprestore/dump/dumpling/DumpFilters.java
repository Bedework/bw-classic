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



import java.util.Iterator;

import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.filter.BwAndFilter;
import org.bedework.calfacade.filter.BwCategoryFilter;
import org.bedework.calfacade.filter.BwCreatorFilter;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.filter.BwLocationFilter;
import org.bedework.calfacade.filter.BwNotFilter;
import org.bedework.calfacade.filter.BwOrFilter;
import org.bedework.calfacade.filter.BwSponsorFilter;
import org.bedework.dumprestore.dump.DumpGlobals;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpFilters extends Dumpling {
  /** Constructor
   *
   * @param globals
   */
  public DumpFilters(DumpGlobals globals) {
    super(globals);
  }

  /* (non-Javadoc)
   * @see org.bedework.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    tagStart(sectionFilters);

    while (it.hasNext()) {
      BwFilter f = (BwFilter)it.next();

      dumpFilter(f);
    }

    tagEnd(sectionFilters);
  }

  private void dumpFilter(BwFilter f) throws Throwable {
    String tagName;

    int ref = -1;

    if (f instanceof BwAndFilter) {
      tagName = objectAndFilter;
    } else if (f instanceof BwCategoryFilter) {
      tagName = objectCategoryFilter;

      BwCategory key = ((BwCategoryFilter)f).getCategory();

      if (key != null) {
        ref = key.getId();
      }
    } else if (f instanceof BwCreatorFilter) {
      tagName = objectCreatorFilter;

      BwUser creator = ((BwCreatorFilter)f).getCreator();

      if (creator != null) {
        ref = creator.getId();
      }
    } else if (f instanceof BwLocationFilter) {
      tagName = objectLocationFilter;

      BwLocation l = ((BwLocationFilter)f).getLocation();

      if (l != null) {
        ref = l.getId();
      }
    } else if (f instanceof BwNotFilter) {
      tagName = objectNotFilter;
    } else if (f instanceof BwOrFilter) {
      tagName = objectOrFilter;
    } else if (f instanceof BwSponsorFilter) {
      tagName = objectSponsorFilter;

      BwSponsor s = ((BwSponsorFilter)f).getSponsor();

      if (s != null) {
        ref = s.getId();
      }
    } else {
      throw new Exception("Unimplemented filter " + f.getClass().getName());
    }

    tagStart(tagName);

    taggedVal("id", f.getId());
    taggedVal("name", f.getName());
    taggedVal("description", f.getDescription());
    taggedVal("not", f.getNot());
    taggedVal("owner", f.getOwner());
    taggedVal("publick", f.getPublick());

    if (f.getParent() != null) {
      taggedVal("parent", f.getParent().getId());
    }

    if (ref > 0) {
      taggedVal("ref", ref);
    }

    tagEnd(tagName);
    globals.filters++;
  }
}
