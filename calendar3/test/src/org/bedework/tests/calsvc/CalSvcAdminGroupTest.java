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

import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.ifs.Groups;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.UserAuth;
import org.bedework.calsvci.CalSvcI;

import junit.framework.TestCase;

import java.util.Collection;
import java.util.Iterator;

/** Test the Admin groups classes
 *
 * @author Mike Douglass       douglm@rpi.edu
   @version 1.1
 */
public class CalSvcAdminGroupTest extends TestCase {
  private CalSvcTestUtil svciUtil;

  private boolean debug = true;

  private static final String adminUser = "caladmin";

  CalSvcI svci;

  /**
   *
   */
  public void testCalSvc() {
    try {
      svciUtil = new CalSvcTestUtil(debug);

      svci = svciUtil.getSvci(adminUser, UserAuth.superUser, true);

      Groups ag = svci.getGroups();

      // create a group.
      BwGroup g1 = addGroup(ag, "test1");

      // create 3 auth users
      svciUtil.open(adminUser);  // open public
      svci.addUser(new BwUser("test1member1"));
      svci.addUser(new BwUser("test1member2"));
      svci.addUser(new BwUser("test1member3"));
      svciUtil.close(adminUser);

      svciUtil.open(adminUser);  // open public
      BwUser usr1 = svci.findUser("test1member1");
      BwUser usr2 = svci.findUser("test1member2");
      BwUser usr3 = svci.findUser("test1member3");
      svciUtil.close(adminUser);

      svciUtil.open(adminUser);  // open public
      ag.addMember(g1, usr1);
      svciUtil.close(adminUser);

      svciUtil.open(adminUser);  // open public
      ag.addMember(g1, usr2);
      svciUtil.close(adminUser);

      svciUtil.open(adminUser);  // open public
      ag.addMember(g1, usr3);
      svciUtil.close(adminUser);

      // See which groups member 1 is in
      checkNumGroups(ag, usr1, 1);

      // Add another group

      BwGroup g2 = addGroup(ag, "test2");

      svciUtil.open(adminUser);  // open public
      ag.addMember(g2, usr2);
      svciUtil.close(adminUser);

      // Add a super group
      BwGroup g3 = addGroup(ag, "test3");

      svciUtil.open(adminUser);  // open public
      ag.addMember(g3, g1);
      ag.addMember(g3, g2);
      svciUtil.close(adminUser);

      // See which groups member 1 is in
      checkNumGroups(ag, usr1, 2);

      // Check user 2
      checkNumGroups(ag, usr2, 3);

      svciUtil.open(adminUser);  // open public
      ag.removeMember(g2, usr2);
      svciUtil.close(adminUser);

      // Check user 2
      checkNumGroups(ag, usr2, 2);

      svciUtil.open(adminUser);  // open public
      ag.removeGroup(g1);
      svciUtil.close(adminUser);
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception getting service interface: " + t.getMessage());
    }
  }

  private void checkNumGroups(Groups ag, BwUser u, int expected) throws Throwable {
    svciUtil.open(adminUser);  // open public
    Collection c = ag.getAllGroups(u);

    Iterator it = c.iterator();
    while (it.hasNext()) {
      BwGroup g = (BwGroup)it.next();
      if (debug) {
        log("User " + u.getAccount() + " in group " + g.getAccount());
      }
    }

    assertTrue("Should be in " + expected + " groups", c.size() == expected);
    svciUtil.close(adminUser);
  }

  private BwGroup addGroup(Groups ag, String name) throws Throwable {
    svciUtil.open(adminUser);  // open public
    BwAdminGroup g = new BwAdminGroup(name);

    String gownerName = name + "groupowner";
    BwUser gowner = new BwUser(gownerName);
    svci.addUser(gowner);

    String ownerName = name + "powner";
    BwUser owner = new BwUser(ownerName);
    svci.addUser(owner);

    g.setGroupOwner(gowner);
    g.setOwner(owner);

    ag.addGroup(g);

    svciUtil.close(adminUser);

    svciUtil.open(adminUser);  // open public

    g = (BwAdminGroup)ag.findGroup(name);

    assertTrue("Find group " + name + " we just created", g != null);

    svciUtil.close(adminUser);

    return g;
  }

  /* ====================================================================
   *                       Protected methods.
   * ==================================================================== */

  protected void log(String msg) {
    System.out.println(this.getClass().getName() + ": " + msg);
  }
}

