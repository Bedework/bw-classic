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

import org.bedework.calfacade.svc.BwPreferences;
import org.bedework.calfacade.svc.BwSubscription;
import org.bedework.calfacade.svc.BwView;
import org.bedework.dumprestore.dump.DumpGlobals;

import java.util.Collection;
import java.util.Iterator;

/** Helper classes for the calendar data dump utility.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class DumpUserPrefs extends Dumpling {
  /** Constructor
   *
   * @param globals
   */
  public DumpUserPrefs(DumpGlobals globals) {
    super(globals);
  }

  /* (non-Javadoc)
   * @see org.bedework.dumprestore.dump.dumpling.Dumpling#dumpSection(java.util.Iterator)
   */
  public void dumpSection(Iterator it) throws Throwable {
    tagStart(sectionUserPrefs);

    while (it.hasNext()) {
      BwPreferences p = (BwPreferences)it.next();

      dumpUserPrefs(p);
    }

    tagEnd(sectionUserPrefs);
  }

  private void dumpUserPrefs(BwPreferences p) throws Throwable {
    tagStart(objectUserPrefs);

    ownedEntityTags(p);

    Collection s = p.getSubscriptions();

    if (s.size() > 0) {
      tagStart("subscriptions");

      Iterator si = s.iterator();

      while (si.hasNext()) {
        BwSubscription sub = (BwSubscription)si.next();

        tagStart("subscription");

        taggedVal("sub-id", sub.getId());
        taggedVal("sub-seq", sub.getSeq());
        taggedVal("sub-name", sub.getName());
        taggedVal("sub-owner", sub.getOwner().getId());
        taggedVal("sub-uri", sub.getUri());
        taggedVal("sub-affectsFreeBusy", sub.getAffectsFreeBusy());
        taggedVal("sub-display", sub.getDisplay());
        taggedVal("sub-style", sub.getStyle());
        taggedVal("sub-internalSubscription", sub.getInternalSubscription());
        taggedVal("sub-emailNotifications", sub.getEmailNotifications());
        taggedVal("sub-calendarDeleted", sub.getCalendarDeleted());
        taggedVal("sub-unremoveable", sub.getUnremoveable());

        tagEnd("subscription");
        globals.subscriptions++;
      }

      globals.subscribedUsers++;

      tagEnd("subscriptions");
    }

    Collection v = p.getViews();

    if (v.size() > 0) {
      tagStart("views");

      Iterator vi = v.iterator();

      while (vi.hasNext()) {
        BwView view = (BwView)vi.next();

        tagStart("view");

        taggedVal("view-id", view.getId());
        taggedVal("view-seq", view.getSeq());
        taggedVal("view-name", view.getName());
        taggedVal("view-owner", view.getOwner().getId());

        Collection vs = view.getSubscriptions();

        if (vs.size() > 0) {
          tagStart("view-subscriptions");

          Iterator vsi = vs.iterator();

          while (vsi.hasNext()) {
            BwSubscription sub = (BwSubscription)vsi.next();

            taggedVal("view-sub-id", sub.getId());
          }

          tagEnd("view-subscriptions");
        }

        tagEnd("view");
      }

      tagEnd("views");
    }

    taggedVal("email", p.getEmail());
    if (p.getDefaultCalendar() != null) {
      taggedVal("default-calendar", p.getDefaultCalendar().getId());
    }
    taggedVal("skinName", p.getSkinName());
    taggedVal("skinStyle", p.getSkinStyle());
    taggedVal("preferredView", p.getPreferredView());
    taggedVal("preferredViewPeriod", p.getPreferredViewPeriod());
    taggedVal("workDays", p.getWorkDays());
    taggedVal("workdayStart", p.getWorkdayStart());
    taggedVal("workdayEnd", p.getWorkdayEnd());

    tagEnd(objectUserPrefs);
  }
}

