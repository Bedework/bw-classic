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

package org.bedework.tests.webcommon;

import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.icalendar.URIgen;
import org.bedework.webcommon.BwWebURIgen;



import java.net.URI;

import junit.framework.TestCase;

/** Test the UWCalWebURIgen class
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class UWCalWebURIgenTest extends TestCase {
  /**
   *
   */
  public void testUWCalWebURIgen() {
    try {
      BwLocation loc = new BwLocation();
      loc.setId(12345);

      BwSponsor sp = new BwSponsor();
      sp.setId(67890);

      URIgen urigen = new BwWebURIgen("http://cal.rpi.edu");

      URI locUri = urigen.getLocationURI(loc);

      System.out.println("locuri=" + locUri);

      URI spUri = urigen.getSponsorURI(sp);

      System.out.println("spUri=" + spUri);

      BwLocation loc2 = urigen.getLocation(locUri);
      BwSponsor sp2 = urigen.getSponsor(spUri);

      assertNotNull("Location", loc2);
      assertTrue("Location matches", loc2.getId() == loc.getId());

      assertNotNull("Sponsor", sp2);
      assertTrue("Sponsor matches", sp2.getId() == sp.getId());
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception testing URIgen: " + t.getMessage());
    }
  }

  /* ====================================================================
   *                       protected methods.
   * ==================================================================== */

  protected void log(String msg) {
    System.out.println(this.getClass().getName() + ": " + msg);
  }
}

