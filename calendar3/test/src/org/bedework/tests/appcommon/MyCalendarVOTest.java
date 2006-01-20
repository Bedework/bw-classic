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

package org.bedework.tests.appcommon;

import org.bedework.appcommon.CalendarInfo;
import org.bedework.appcommon.MyCalendarVO;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import junit.framework.TestCase;

/** Test the MyCalendarVO class
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class MyCalendarVOTest extends TestCase {
  //private MyCalendarVO mc;

  //private boolean debug = true;

  /**
   * @throws Throwable
   */
  public void testMyCalendarVO() throws Throwable {
    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
                                                Locale.US);
    Date dt = fmt.parse("2004-10-10 10:11:12");

    showStuff(dt, Locale.US);
    showStuff(dt, Locale.CHINA);
    showStuff(dt, Locale.GERMAN);
    showStuff(dt, new Locale("es", "ES"));
  }

  /**
   * @param dt
   * @param loc
   */
  public void showStuff(Date dt, Locale loc) {
    try {
      MyCalendarVO mc = new MyCalendarVO(dt, loc);

      CalendarInfo cinf = mc.getCalInfo();

      System.out.println("getFirstDayOfWeek()=" + cinf.getFirstDayOfWeek());

      String[] days = cinf.getDayNames();
      String[] sdays = cinf.getShortDayNames();

      StringBuffer sb = new StringBuffer(loc.toString());

      sb.append(": ");
      for (int i = 0; i < days.length; i++) {
        sb.append(days[i]);
        sb.append(" ");
      }

      System.out.println(sb);

      sb = new StringBuffer(loc.toString());

      sb.append(": ");
      for (int i = 0; i < sdays.length; i++) {
        sb.append(sdays[i]);
        sb.append(" ");
      }

      System.out.println(sb);

      sb = new StringBuffer(loc.toString());
      sb.append(": ");

      sb.append(mc.getMonthName());
      sb.append(" ");
      sb.append(mc.getShortMonthName());

      System.out.println(sb);

      System.out.println(sb);
    } catch (Throwable t) {
      t.printStackTrace();
      fail(t.getMessage());
    }
  }
}
