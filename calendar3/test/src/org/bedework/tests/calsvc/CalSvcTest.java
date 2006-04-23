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

import org.bedework.calfacade.svc.UserAuth;

import junit.framework.TestCase;

/** Test the CalSvcI class
 *
 * <p>We require that the UserAuth classes function enough for
 * this test framework. I'm not sure we can test the roles based version for
 * example, as this requires a servlet.
 *
 * <p>The assumption we're making here is that we don't need to pass any
 * object to the class. It's probably a db based version.
 *
 * @author Mike Douglass       douglm@rpi.edu
   @version 1.1
 */
public class CalSvcTest extends TestCase {
  private CalSvcTestUtil svciUtil;

  private boolean debug = true;

  private static final String adminUser = "caladmin";
  private static final String privateUser1 = "calowner";

  /**
   *
   */
  public void testCalSvc() {
    try {
      svciUtil = new CalSvcTestUtil(debug);

      svciUtil.getSvci(adminUser, UserAuth.superUser, true);
      svciUtil.getSvci(privateUser1, UserAuth.noPrivileges, false);
      svciUtil.open(adminUser);  // open public

      /* Quick check of userauth */
      UserAuth ua = getUserAuth(adminUser);

      assertTrue("Access should be " + UserAuth.superUser, ua.isSuperUser());

      /* Add a bunch of public locations */
      int numLocs = 10;
      int firstLoc = addLocations(numLocs, adminUser);

      /* Add a bunch of public sponsors */
      int numSps = 10;
      int firstSp = addSponsors(numSps, adminUser);

      /* Insure these changes go through before adding events */
      svciUtil.close(adminUser);
      svciUtil.open(adminUser);

      /* Add a bunch of public events */
      int numEvs = 10;
      addEvents(numEvs, firstLoc, firstSp, adminUser,
                "Public events for svc test");

      svciUtil.close(adminUser);
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting service interface: " + t.getMessage());
    }

//    assertTrue("calsvc test 1", true);
  }

  /**
   * @param user
   * @return UserAuth object
   */
  public UserAuth getUserAuth(String user) {
    try {
      return svciUtil.getSvci(user).getUserAuth();
    } catch (Throwable t) {
      t.printStackTrace();
      fail(t.getMessage());
    }

    return null;
  }

  /* ====================================================================
   *                       Private location methods.
   * ==================================================================== */

  /** Add a bunch of locations for later use
   *
   * @param n     int number of locations
   * @param user
   * @return int  key of first added (remainder should follow)
   * @throws Throwable
   */
  private int addLocations(int n,
                           String user) throws Throwable {
    int first = -1;
    for (int i = 1; i <= n; i++) {
      int key = svciUtil.addLocation(svciUtil.getSvci(user),
                                     "Dummy location address " + i,
                                     "Dummy location subaddress " + i,
                                     "http://dummy.link" + i + ".edu",
                                     svciUtil.getSvci(user).findUser(user));

      if (key < 0) {
        // failure
        return key;
      }

      if (first < 0) {
        first = key;
      }
    }

    return first;
  }

  /* ====================================================================
   *                       Private sponsor methods.
   * ==================================================================== */

  /** Add a bunch of sponsors for later use
   *
   * @param n     int number of sponsors
   * @param user
   * @return int  key of first added (remainder should follow)
   * @throws Throwable
   */
  private int addSponsors(int n,
                          String user) throws Throwable {
    int first = -1;
    for (int i = 1; i <= n; i++) {
      int key = svciUtil.addSponsor(svciUtil.getSvci(user),
                                    "Dummy sponsor name " + i,
                                    "Dummy sponsor phone " + i,
                                    "Dummy sponsor email " + i,
                                    "http://dummy.link" + i + ".edu",
                                    svciUtil.getSvci(user).findUser(user));

      if (key < 0) {
        // failure
        return key;
      }

      if (first < 0) {
        first = key;
      }
    }

    return first;
  }

  /* ====================================================================
   *                       Private category methods.
   * ==================================================================== */

  /* Add a bunch of categories for later use
   *
   * @param n     int number of sponsors
   * @return int  key of first added (remainder should follow)
   * /
  private int addCategories(int n, String user) {
    int first = -1;
    for (int i = 1; i <= n; i++) {
      int key = svciUtil.addCategory(svciUtil.getSvci(user),
                                     "Dummy category " + i,
                                     "Dummy category description " + i,
                                     user);

      if (key < 0) {
        // failure
        return key;
      }

      if (first < 0) {
        first = key;
      }
    }

    return first;
  } */

  /* ====================================================================
   *                       Private event methods.
   * ==================================================================== */

  /** Add a bunch of events for later use
   *
   * @param n         int number of events
   * @param locn      int first location id
   * @param spn       int first sponsor id
   * @param user
   * @param desc      some identifying text
   * @return int      key of first added (remainder should follow)
   * @throws Throwable
   */
  private int addEvents(int n, int locn, int spn,
                        String user,
                        String desc) throws Throwable {
    int first = -1;
    for (int i = 1; i <= n; i++) {
      int key = svciUtil.addEvent(svciUtil.getSvci(user),
                                  i, locn - 1 + i, spn - 1 + i,
                                  desc);

      if (key < 0) {
        // failure
        return key;
      }

      if (first < 0) {
        first = key;
      }
    }

    return first;
  }

  /* ====================================================================
   *                       Protected methods.
   * ==================================================================== */

  protected void log(String msg) {
    System.out.println(this.getClass().getName() + ": " + msg);
  }
}

