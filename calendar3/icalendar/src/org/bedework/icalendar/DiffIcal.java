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

package org.bedework.icalendar;

import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.data.CalendarParserImpl;
import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.property.TzId;

import java.io.StringReader;
import java.util.Iterator;
import java.util.Vector;

/** Attempt to determine the differences between calendar objects.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public class DiffIcal {
  /** Two have byte-for-byte equality */
  public static final int byteEquality = 0;
  /** cal1 null or unparseable */
  public static final int cal1Unparseable = 1;
  /** cal2 null or unparseable */
  public static final int cal2Unparseable = 2;
  /** both null or unparseable */
  public static final int cal12Unparseable = 3;

  /** Result from diff
   */
  public static class DiffResult {
    /** Set as above
     */
    public int status;

    /** Found some unsupported icalendar features
     */
    public boolean unsupported;
  }

  /** Compare two calendars represented as Strings
   *
   * @param cal1Str
   * @param cal2Str
   * @return DiffResult
   */
  public static DiffResult diff(String cal1Str, String cal2Str) {
    DiffResult dr = new DiffResult();

    if (cal1Str == null) {
      dr.status = cal1Unparseable;
    }

    if (cal2Str == null) {
      dr.status =+ cal2Unparseable;
    }

    if (dr.status != byteEquality) {
      return dr;
    }

    Calendar cal1 = getCalendar(cal1Str);
    Calendar cal2 = getCalendar(cal2Str);

    if (cal1 == null) {
      dr.status = cal1Unparseable;
    }

    if (cal2 == null) {
      dr.status =+ cal2Unparseable;
    }

    if (dr.status != byteEquality) {
      return dr;
    }

    return diff(cal1, cal2);
  }

  private static class UnsupportedException extends Exception {
    UnsupportedException() {
      super();
    }
  }

  /** Compare two calendars represented as Calendar objects
   *
   * @param cal1
   * @param cal2
   * @return DiffResult
   */
  public static DiffResult diff(Calendar cal1, Calendar cal2) {
    DiffResult dr = new DiffResult();

    /* Try to match up the components then we'll see if they're in the same order
     */

    ComponentList compl1 = cal1.getComponents();
    ComponentList compl2 = cal1.getComponents();
    boolean[] cmap2 = new boolean[compl2.size()];

    Vector cinfos = new Vector();
    int index = 0;

    Iterator it = compl1.iterator();
    while (it.hasNext()) {
      CompInfo cinfo = new CompInfo();
      cinfos.add(cinfo);

      cinfo.index1 = index;
      cinfo.comp1 = (Component)it.next();

      try {
        if (findComponent(cinfo, compl2)) {
          cmap2[cinfo.index2] = true;
        } else {
          out("Component " + index + " not in 'to'");
        }
      } catch (UnsupportedException ue) {
        dr.unsupported = true;
      }

      index++;
    }

    return dr;
  }

  /* Try to find a component in cl which matches the first component
   */
  private static boolean findComponent(CompInfo cinfo, ComponentList cl)
          throws UnsupportedException {
    int index = 0;
    Component comp1 = cinfo.comp1;
    String cname = comp1.getName();

    Iterator it = cl.iterator();
    while (it.hasNext()) {
      Component comp2 = (Component)it.next();
      if (!cname.equals(comp2.getName())) {
        index++;
        continue;
      }

      if (cname.equals(Component.VTIMEZONE)) {
        TzId tzid1 = (TzId)IcalUtil.getProperty(comp1, "TZID");
        TzId tzid2 = (TzId)IcalUtil.getProperty(comp2, "TZID");
        if (tzid1.getValue().equals(tzid2.getValue())) {
          cinfo.index2 = index;
          cinfo.comp2 = comp2;

          return true;
        }
      } else if (cname.equals(Component.VEVENT)) {
        Property guid1 = IcalUtil.getProperty(comp1, "UID");
        Property guid2 = IcalUtil.getProperty(comp2, "UID");
        if (guid1.getValue().equals(guid2.getValue())) {
          /* If we have recurrence ids they should match
           */
          cinfo.index2 = index;
          cinfo.comp2 = comp2;

          return true;
        }
      } else {
        throw new UnsupportedException();
      }

      index++;
    }

    return false;
  }

  private static class CompInfo {
    int index1;
    Component comp1;

    int index2;
    Component comp2;

    boolean completeMatch;
    boolean semanticMatch;
  }

  private static Calendar getCalendar(String val) {
    try {
      CalendarBuilder bldr = new CalendarBuilder(new CalendarParserImpl());

      return bldr.build(new StringReader(val));
    } catch (Throwable t) {
      return null;
    }
  }

  private static void out(String msg) {
    System.out.println(msg);
  }
}

