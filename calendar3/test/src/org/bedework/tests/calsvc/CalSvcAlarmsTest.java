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

package org.bedework.tests.calsvc;

import org.bedework.calfacade.BwAttendee;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAlarm;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.svc.UserAuth;

import java.util.Collection;
import java.util.Iterator;

import junit.framework.TestCase;

/** Test alarm manipulation.
 *
 * We'll create a public event and then during the test try to add an
 * alarm to it as personal user # 1.
 *
 * <p>We then try adding an alarm as user # 2 - we should see no alarms
 * prior tothe add.
 *
 * <p>Back as user #1 we should only see the one alarm that user created.
 *
 * @author Mike Douglass       douglm@rpi.edu
   @version 1.1
 */
public class CalSvcAlarmsTest extends TestCase {
  private CalSvcTestUtil svciUtil;

  private boolean debug = true;

  private static final String adminUser = "caladmin";
  private static final String privateUser1 = "calowner";
  private static final String privateUser2 = "calowner2";

  /** The event we work on. */
  BwEvent ev;
  int key;

  protected void setUp() throws Exception {
    svciUtil = new CalSvcTestUtil(debug);

    svciUtil.getSvci(adminUser, UserAuth.superUser, true);
    svciUtil.getSvci(privateUser1, UserAuth.noPrivileges, false);
    svciUtil.getSvci(privateUser2, UserAuth.noPrivileges, false);

  }

  protected void tearDown() throws Exception {
  }

  /**
   *
   */
  public void testCalSvcPublicEventAlarms() {
    try {
      /* Add our public event */
      svciUtil.open(adminUser);
      key = svciUtil.addEvent(svciUtil.getSvci(adminUser), 1, 0, 0,
                              "Alarms test public event");
      svciUtil.closeFlushAll(adminUser);

      /* Add an alarm for a public event as private user 1 */
      svciUtil.openFlushed(privateUser1);
      ev = getEvent(key, privateUser1);
      BwEventAlarm alarm = makeAlarm(privateUser1, 3);
      svciUtil.getSvci(privateUser1).setAlarm(ev, alarm);
      svciUtil.close(privateUser1);

      /* Open as private user 2 and do the same */
      svciUtil.open(privateUser2);
      ev = getEvent(key, privateUser2);
      expectAlarms(0, privateUser2);
      alarm = makeAlarm(privateUser2, 3);
      svciUtil.getSvci(privateUser2).setAlarm(ev, alarm);
      svciUtil.close(privateUser2);

      /* Refetch and check we have the one alarm then add another alarm. */
      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      expectAlarms(1, privateUser1);
      alarm = makeAlarm(privateUser1, 5);
      svciUtil.getSvci(privateUser1).setAlarm(ev, alarm);
      svciUtil.close(privateUser1);

      /* Refetch and check we have the two alarms. */

      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      expectAlarms(2, privateUser1);

      /* Add another attendee to the first alarm */

      Iterator it = iterateAlarms(privateUser1);
      alarm = (BwEventAlarm)it.next();

      int twoAttendeeAlarm = alarm.getId();

      alarm.addAttendee(new BwAttendee(null, null, null, null,
                                       null, null, null, true,
                                       null, null, "someone@rpi.edu",
                                       "anotherperson@rpi.edu"));
      svciUtil.getSvci(privateUser1).updateAlarm(alarm);
      svciUtil.close(privateUser1);

      /* See if a refetch shows 2 attendees */

      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      expectAlarms(2, privateUser1);

      it = iterateAlarms(privateUser1);
      while (it.hasNext()) {
        alarm = (BwEventAlarm)it.next();
        if (alarm.getId() == twoAttendeeAlarm) {
          twoAttendeeAlarm = -1; // We saw it

          Collection c = alarm.getAttendees();
          assertEquals(2, c.size());
        }
      }
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting service interface: " + t.getMessage());
    }
  }

  /**
   *
   */
  public void testCalSvcPrivateEventAlarms() {
    try {
      /* Add our personal event */
      svciUtil.open(privateUser1);
      key = svciUtil.addEvent(svciUtil.getSvci(privateUser1), 1, 0, 0,
                              "Alarms test private event");
      svciUtil.close(privateUser1);

      /* Add an alarm to our event as private user 1 */
      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      BwEventAlarm alarm = makeAlarm(privateUser1, 3);
      svciUtil.getSvci(privateUser1).setAlarm(ev, alarm);

      /* Get the trigger time here - just in case it fails
       */
      System.out.println("Trigger time " + new java.util.Date(
           alarm.getTriggerTime()));
      svciUtil.close(privateUser1);

      /* Open as private user 2 and ensure we cannot see the event */

      svciUtil.open(privateUser2);
      checkMissingEvent(key, privateUser2);
      svciUtil.close(privateUser2);

      /* Refetch, check we have the one alarm and add another alarm. */
      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      expectAlarms(1, privateUser1);
      alarm= makeAlarm(privateUser1, 5);
      svciUtil.getSvci(privateUser1).setAlarm(ev, alarm);
      svciUtil.close(privateUser1);

      /* Refetch, check we have the two alarms.and add another attendee to
         the first alarm */
      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      expectAlarms(2, privateUser1);

      Iterator it = iterateAlarms(privateUser1);
      alarm = (BwEventAlarm)it.next();

      int twoAttendeeAlarm = alarm.getId();

      alarm.addAttendee(new BwAttendee(null, null, null, null,
                                       null, null, null, true,
                                       null, null, "someone@rpi.edu",
                                       "anotherperson@rpi.edu"));
      svciUtil.getSvci(privateUser1).updateAlarm(alarm);
      svciUtil.close(privateUser1);

      /* See if a refetch shows 2 attendees */
      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      expectAlarms(2, privateUser1);

      it = iterateAlarms(privateUser1);
      while (it.hasNext()) {
        alarm = (BwEventAlarm)it.next();
        if (alarm.getId() == twoAttendeeAlarm) {
          twoAttendeeAlarm = -1; // We saw it

          Collection c = alarm.getAttendees();
          assertEquals(2, c.size());
        }
      }
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting service interface: " + t.getMessage());
    }
  }

  /* ====================================================================
   *                       Private methods.
   * ==================================================================== */

  private BwEventAlarm makeAlarm(String user, int mins) {
    BwEventAlarm alarm = BwEventAlarm.emailAlarm(ev, new BwUser(user),
                                                 "-PT" + mins + "M", true, true,
                                                 "PT5M", 1,
                                                 null, // attach
                                                 "Description of alarm",
                                                 "Summary for alarm",
                                                 null);  //attendees
    BwAttendee att = new BwAttendee(null, null, null, null,
                                    null, null, null, true,
                                    null, null, "someone@rpi.edu",
                                    "someoneelse@rpi.edu");

    alarm.addAttendee(att);

    return alarm;
  }

  private BwEvent getEvent(int id, String user) {
    return svciUtil.getEvent(svciUtil.getSvci(user), id, true);
  }

  private void checkMissingEvent(int id, String user) {
    assertNull(svciUtil.getEvent(svciUtil.getSvci(user), id, false));
  }

  private Iterator iterateAlarms(String user) throws Throwable {
    Collection alarms = svciUtil.getSvci(user).getAlarms(ev,
                                    svciUtil.getSvci(user).findUser(user));
    return alarms.iterator();
  }

  private void expectAlarms(int num, String user) throws Throwable {
    Collection alarms = svciUtil.getSvci(user).getAlarms(ev,
                                    svciUtil.getSvci(user).findUser(user));
    assertNotNull("Expecting non-null alarms for user " + user, alarms);
    assertEquals("Expecting " + num + " alarms for user " + user,
                 num, alarms.size());

    Iterator it = alarms.iterator();
    while (it.hasNext()) {
      BwEventAlarm alarm = (BwEventAlarm)it.next();

      BwUser auser = alarm.getOwner();
      assertNotNull("Expecting non-null alarm for user " + user, auser);

      assertEquals("Expecting alarm owned by user " + user,
                 user, auser.getAccount());
    }
  }
}

