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

package org.bedework.tests.ical;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.icalendar.IcalTranslator;
import org.bedework.tests.calsvc.CalSvcTestUtil;

import edu.rpi.sss.util.log.Log4jOutputStream;


import java.util.Collection;
import java.util.Iterator;

import junit.framework.TestCase;

import net.fortuna.ical4j.data.CalendarOutputter;
import net.fortuna.ical4j.model.Calendar;

/** Test the IcalTranslator class
 *
 * <p>We'll manufacture an EventVO object, feed it through the translator
 * then send it back again. The end result should be equal.
 *
 * @author Mike Douglass       douglm@rpi.edu
   @version 1.1
 */
public class IcalTranslatorTest extends TestCase {
  private CalSvcTestUtil svciUtil;

  private boolean debug = true;

  private static final String adminUser = "caladmin";
  private static final String privateUser1 = "calowner";

  private static final String[] icalText = {
    "BEGIN:VCALENDAR",
    "PRODID:UW calendar V2.0",
    "VERSION:2.0",
    "BEGIN:VEVENT",
    "CATEGORIES:",
    "CLASS:PRIVATE",
    "CREATED;VALUE=DATE-TIME:20041210T160137Z",
    "DESCRIPTION:Dummy ical event description",
    "DTEND;VALUE=DATE-TIME:20041118T170000",
    "DTSTART;VALUE=DATE-TIME:20041118T160000",
    "LAST-MODIFIED;VALUE=DATE-TIME:20041210T160137Z",
    "LOCATION:Test user synch location address",
    "ORGANIZER:caladmin",
    "SEQUENCE:1",
    "SUMMARY:Dummy ical event  summary",
    "UID:12-calendar@mysite.edu",
    "URL:http://www.rpi.edu",
    "END:VEVENT",
    "END:VCALENDAR",
  };

  /**
   *
   */
  public void testIcalTranslator() {
    try {
      svciUtil = new CalSvcTestUtil(debug);

      /* Init public svci */
      svciUtil.getSvci(adminUser, UserAuth.superUser, true);

      /* Init personal svci */
      svciUtil.getSvci(privateUser1, UserAuth.noPrivileges, false);

      svciUtil.open(privateUser1);  // open private

      /* Add a private location */
      int locKey = svciUtil.addLocation(svciUtil.getSvci(privateUser1),
                                        "Test user synch location address",
                                        "Test user synch location subaddress",
                                        "http://dummy.synch.link.edu",
                                        svciUtil.getSvci(privateUser1).findUser(privateUser1));

      if (locKey < 0) {
        fail("previous step failed");
      }

      /* Add a private sponsor
      int spKey = svciUtil.addSponsor("Test user synch sponsor name",
                                      "Test user synch sponsor phone",
                                      "Test user synch sponsor email",
                                      "http://dummy.synch.link.edu",
                                      user,
                                      false);

      if (spKey < 0) {
        fail("previous step failed");
      }*/

      /* flush private cache */
      svciUtil.close(privateUser1);

      /*
      svciUtil.open(true);  // open public
      / * Add a public category (category) * /
      int kKey = svciUtil.addCategory("Test user synch category",
                                      "Test user synch category description",
                                      user,
                                      true);

      if (kKey < 0) {
        fail("previous step failed");
      }

      BwCategory key = svciUtil.getCategory(kKey, true);

      / * close public * /
      svciUtil.close(true);*/

      svciUtil.open(privateUser1);  // open private

      BwLocation loc = svciUtil.getLocation(svciUtil.getSvci(privateUser1), locKey, false);

      int eventId = svciUtil.addEvent(svciUtil.getSvci(privateUser1),
                                      "Dummy ical event  summary",
                                     "Dummy ical event description",
                                     "20041118T160000",
                                     "20041118T170000",
                                     loc,
                                     null,
                                     null,    // key,
                                     "http://www.rpi.edu",
                                     privateUser1);

      /* flush private */
      svciUtil.close(privateUser1);
      svciUtil.open(privateUser1);

      BwEvent ev = svciUtil.getEvent(svciUtil.getSvci(privateUser1), eventId, true);

      //URIgen urigen = new BwWebURIgen("http://cal.rpi.edu");

      IcalTranslator icalTrans = new IcalTranslator(
                   svciUtil.getSvci(privateUser1).getIcalCallback(),
                   debug);

      Calendar ical = icalTrans.toIcal(ev);
      svciUtil.close(privateUser1);

      CalendarOutputter calOut = new CalendarOutputter(true);

      Log4jOutputStream out = new Log4jOutputStream();

      System.out.println("===========================================");
      calOut.output(ical, out);
      System.out.println("===========================================");

      BwCalendar cal = svciUtil.getSvci(privateUser1).getCalendar();
      Collection c = makeEvents(icalTrans, cal, icalText);
      Iterator it = c.iterator();

      while (it.hasNext()) {
        EventInfo einf = (EventInfo)it.next();

        log(einf.getEvent().toString());
      }
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting service interface: " + t.getMessage());
    }
  }

  /* ====================================================================
   *                       Private methods.
   * ==================================================================== */

  /* Get a Collection of EventInfo
   *
   * @param icalTrans
   * @param cal
   * @param calText
   * @return Collection
   * @throws Throwable
   */
  private Collection makeEvents(IcalTranslator icalTrans,
                                BwCalendar cal,
                                String[] calText) throws Throwable {
    StringBuffer sb = new StringBuffer();

    for (int i = 0; i < calText.length; i++) {
      sb.append(calText[i]);
      sb.append("\r\n");
    }

    svciUtil.open(privateUser1);
    try {
      return icalTrans.fromIcal(cal, sb.toString());
    } finally {
      svciUtil.close(privateUser1);
    }
  }

  private void log(String msg) {
    System.out.println(this.getClass().getName() + ": " + msg);
  }
}

