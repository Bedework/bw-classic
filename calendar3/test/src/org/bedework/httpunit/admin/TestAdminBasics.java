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

package org.bedework.httpunit.admin;

import java.util.ArrayList;

/** Class to test the basic admin client functions. More complex tests
 * take place after these.
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class TestAdminBasics {
  private TestAdminUtils util;

  private String adminid = "caladmin";
  private String adminpw = "uwcal";

  /* Links to edit location page.
   */
  private ArrayList locations = new ArrayList();

  /* Links to edit sponsor page.
   */
  private ArrayList sponsors = new ArrayList();

  /**
   * @param util
   */
  public TestAdminBasics(TestAdminUtils util) {
    this.util = util;
  }

  /** Basic tests are:<ul>
   * <li>Authenticate as admin client - verify we are at main menu</li>
   * <li>Use create location link to add some locations</li>
   * <li>logout</li>
   * <li>Authenticate as admin client</li>
   * <li>Verify all locations exist</li>
   * </ul>
   *
   * @return boolean ok if test passed
   */
  public boolean doTest() {
    try {
      util.doServletFormsAuth(adminid, adminpw);

      /** We should now have the main menu */
      if (!util.verifyMainPage()) {
        return false;
      }

      locations.add(util.addLocation("loc1", null, null));
      locations.add(util.addLocation("loc2", null, null));
      locations.add(util.addLocation("loc3", null, null));
      locations.add(util.addLocation("loc4", null, null));
      locations.add(util.addLocation("loc5", null, null));

      /* log out */
      util.logout();

      util.doServletFormsAuth(adminid, adminpw);

      ArrayList editLocLinks = util.getLocationEditLinks();
      if (editLocLinks == null) {
        return false;
      }

      if (editLocLinks.size() != locations.size()) {
        util.fail("Number of locations doesn't match");
        return false;
      }

      sponsors.add(util.addSponsor("sponsor1", "123", "456", "7890", null, null, null));
      sponsors.add(util.addSponsor("sponsor2", "223", "456", "7890", null, null, null));
      sponsors.add(util.addSponsor("sponsor3", "323", "456", "7890", null, null, null));
      sponsors.add(util.addSponsor("sponsor4", "423", "456", "7890", null, null, null));
      sponsors.add(util.addSponsor("sponsor5", "523", "456", "7890", null, null, null));
      sponsors.add(util.addSponsor("sponsor6", "623", "456", "7890", null, null, null));

      util.succeed("Ran basic tests");
      return true;
    } catch (Throwable t) {
      util.fail(t);
      return false;
    }
  }
}


