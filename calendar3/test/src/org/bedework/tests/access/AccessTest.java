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

package org.bedework.tests.access;

import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.BwUser;

import edu.rpi.cct.uwcal.access.Ace;
import edu.rpi.cct.uwcal.access.Acl;
import edu.rpi.cct.uwcal.access.Privilege;
import edu.rpi.cct.uwcal.access.Privileges;

import junit.framework.TestCase;

/** Test the access classes
 *
 * @author Mike Douglass       douglm@rpi.edu
   @version 1.0
 */
public class AccessTest extends TestCase {
  boolean debug = true;

  Acl acl = new Acl(debug);

  /**
   *
   */
  public void testBasics() {
    try {
      // Make sonme test objects
      BwUser unauth = new BwUser();
      BwUser owner = new BwUser("anowner");
      BwUser auser = new BwUser("auser");
      BwUser auserInGroup = new BwUser("auseringroup");

      BwGroup agroup = new BwGroup("agroup");
      BwGroup bgroup = new BwGroup("bgroup");

      auserInGroup.addGroup(agroup);
      auserInGroup.addGroup(bgroup);

      Privilege read = acl.makePriv(Privileges.privRead);
      Privilege write = acl.makePriv(Privileges.privWrite);

      Privilege[] privSetRead = {read};
      Privilege[] privSetReadWrite = {read, write};

      /* See what we get when we encode a null - that's default - acl. */

      char[] encoded = logEncoded(acl, "default encoded");
      tryDecode(encoded, "default");
      tryEvaluateAccess(owner, owner, privSetRead, encoded, true,
                        "Owner access for default");
      tryEvaluateAccess(auser, owner, privSetRead, encoded, false,
                        "User access for default");

      log("---------------------------------------------------------");

      /* read others - i.e. not owner */
      acl.clear();
      acl.addAce(new Ace(null, false, Ace.whoTypeOther,
                         acl.makePriv(Privileges.privRead)));
      encoded = logEncoded(acl, "read others");
      tryDecode(encoded, "read others");
      tryEvaluateAccess(owner, owner, privSetReadWrite, encoded, true,
                        "Owner access for read others");
      tryEvaluateAccess(auser, owner, privSetRead, encoded, true,
                        "User access for read others");
      tryEvaluateAccess(unauth, owner, privSetRead, encoded, false,
                        "Unauthenticated access for read others");

      log("---------------------------------------------------------");

      /* read for group "agroup", rw for user "auser" */
      acl.clear();
      Ace ace = new Ace("agroup", false, Ace.whoTypeGroup,
                        acl.makePriv(Privileges.privRead));
      acl.addAce(ace);

      ace = new Ace("auser", false, Ace.whoTypeUser);
      ace.addPriv(acl.makePriv(Privileges.privRead));
      ace.addPriv(acl.makePriv(Privileges.privWrite));
      acl.addAce(ace);
      encoded = logEncoded(acl, "read g=agroup,rw auser");
      tryDecode(encoded, "read g=agroup,rw auser");
      tryEvaluateAccess(owner, owner, privSetReadWrite, encoded, true,
                        "Owner access for read g=agroup,rw auser");
      tryEvaluateAccess(auserInGroup, owner, privSetRead, encoded, true,
                        "User access for read g=agroup,rw auser");
    } catch (Throwable t) {
      t.printStackTrace();
      fail("Exception testing access: " + t.getMessage());
    }
  }

  /* ====================================================================
   *                       Private methods.
   * ==================================================================== */

  private void tryEvaluateAccess(BwPrincipal who, BwPrincipal owner,
                                 Privilege[] how,char[] encoded,
                                 boolean expected, String title) throws Throwable {
    boolean allowed = acl.evaluateAccess(who, owner.getAccount(), how, encoded);

    if (debug) {
      log(title + " got " + allowed + " and expected " + expected);
    }
    assertEquals(title, expected, allowed);
  }

  private void tryDecode(char[] encoded, String title) throws Throwable {
    Acl acl = new Acl();

    acl.decode(encoded);
    log("Result of decoding " + title);
    log(acl.toString());
    log(acl.toUserString());
  }

  private char[] logEncoded(Acl acl, String title) throws Throwable {
    char [] encoded = acl.encode();

    String s = new String(encoded);

    log(title + "='" + s + "'");

    return encoded;
  }

  private void log(String msg) {
    System.out.println(this.getClass().getName() + ": " + msg);
  }
}

