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

import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwOrganizer;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.svc.UserAuth;

import junit.framework.TestCase;

/** Test some basic event stuff.
 *
 * <p>We'll create a private event, save it.
 *
 * <p>Add an organizer, save it.
 *
 * <p>Add an attendee, save it.
 *
 * <p>Add another attendee, save it.
 *.
 *
 * @author Mike Douglass       douglm@rpi.edu
   @version 1.1
 */
public class CalSvcEventsTest extends TestCase {
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

    try {
      svciUtil.getSvci(adminUser, UserAuth.superUser, true);
      svciUtil.getSvci(privateUser1, UserAuth.noPrivileges, false);
      svciUtil.getSvci(privateUser2, UserAuth.noPrivileges, false);

      svciUtil.open(privateUser1);

      /* Add our personal event */
      key = svciUtil.addEvent(svciUtil.getSvci(privateUser1), 1, 0, 0,
                              "Events test private event");
    } finally {
      svciUtil.close(privateUser1);
    }
  }

  protected void tearDown() throws Exception {
  }

  private static String orguri1 = "organizer1@rpi.edu";
  private static String orguri2 = "organizer2@rpi.edu";

  /**
   *
   */
  public void testCalSvcEvents() {
    try {
      svciUtil.open(privateUser1);

      /* Add an organizer to our event as private user 1 */

      ev = getEvent(key, privateUser1);

      // clone it to see what happens
      if (ev instanceof BwEventObj) {
        ((BwEventObj)ev).clone();
      }

      ev.setOrganizer(makeOrganizer(orguri1));
      svciUtil.getSvci(privateUser1).updateEvent(ev);
      svciUtil.close(privateUser1);

      /* Open as private user 2 and ensure we cannot see the event */
      svciUtil.open(privateUser2);
      checkMissingEvent(key, privateUser2);
      svciUtil.close(privateUser2);

      /* Refetch, check out organizer and then update it. */
      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);

      BwOrganizer org = ev.getOrganizer();
      assertNotNull("Expecting an organizer object", org);
      assertEquals("Checking uri is correct", orguri1, org.getOrganizerUri());

      org.setOrganizerUri(orguri2);
      svciUtil.getSvci(privateUser1).updateEvent(ev);
      svciUtil.close(privateUser1);

      /* Refetch, and see if update stuck. */
      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      org = ev.getOrganizer();
      assertNotNull("Expecting an updated organizer object", org);
      assertEquals("Expecting organizer object update to have stuck",
                   orguri2, org.getOrganizerUri());

      // clone it to see what happens
      if (ev instanceof BwEventObj) {
        ((BwEventObj)ev).clone();
      }

      svciUtil.close(privateUser1);

      /* Refetch - check we have the organizer, set it to null and update.
         close, refetch and ensure it's gone.
       */
      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      org = ev.getOrganizer();
      assertNotNull(org);
      ev.setOrganizer(null);
      svciUtil.getSvci(privateUser1).updateEvent(ev);
      svciUtil.close(privateUser1);

      svciUtil.open(privateUser1);
      ev = getEvent(key, privateUser1);
      org = ev.getOrganizer();
      assertNull(org);
      svciUtil.close(privateUser1);
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting service interface: " + t.getMessage());
    }
  }

  /* ====================================================================
   *                       Private methods.
   * ==================================================================== */

  private BwOrganizer makeOrganizer(String uri) {
    BwOrganizer org = new BwOrganizer(CalFacadeDefs.unsavedItemKey,
                                      null, // cn
                                      null, // dir
                                      null, // language
                                      "me@rpi.edu",
                                      uri);

    return org;
  }

  private BwEvent getEvent(int id, String user) {
    return svciUtil.getEvent(svciUtil.getSvci(user), id, true);
  }

  private void checkMissingEvent(int id, String user) {
    assertNull(svciUtil.getEvent(svciUtil.getSvci(user), id, false));
  }
}

