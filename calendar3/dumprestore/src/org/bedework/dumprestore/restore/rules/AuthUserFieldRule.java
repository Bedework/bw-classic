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
package org.bedework.dumprestore.restore.rules;

import org.bedework.calfacade.BwUserInfo;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.BwAuthUserPrefs;
import org.bedework.dumprestore.restore.RestoreGlobals;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class AuthUserFieldRule extends EntityFieldRule {
  AuthUserFieldRule(RestoreGlobals globals) {
    super(globals);
  }

  public void field(String name) throws Exception {
    BwAuthUser au = (BwAuthUser)top();

    if (name.equals("id")) {
      au.setId(intFld());
      au.setUser(userFld());
    } else if (name.equals("userType")) {
      au.setUsertype(intFld());

      /* Prefs stuff next */
    } else if (name.equals("autoAddCategories")) {
      getPrefs(au).setAutoAddCategories(booleanFld());
    } else if (name.equals("autoAddLocations")) {
      getPrefs(au).setAutoAddLocations(booleanFld());
    } else if (name.equals("autoAddSponsors")) {
      getPrefs(au).setAutoAddSponsors(booleanFld());
    } else if (name.equals("preferredCategory")) {
      getPrefs(au).addCategory(categoryFld());
    } else if (name.equals("preferredLocation")) {
      getPrefs(au).addLocation(locationFld());
    } else if (name.equals("preferredSponsor")) {
      getPrefs(au).addSponsor(sponsorFld());

      /* 2.3.2 stuff follows */
    } else if (name.equals("lastname")) {
      getUserInfo().setLastname(stringFld());
    } else if (name.equals("firstname")) {
      getUserInfo().setFirstname(stringFld());
    } else if (name.equals("phone")) {
      getUserInfo().setPhone(stringFld());
    } else if (name.equals("email")) {
      getUserInfo().setEmail(stringFld());
    } else if (name.equals("department")) {
      getUserInfo().setDept(stringFld());
    }
  }

  /**
   * @param au
   * @return prefs
   */
  public BwAuthUserPrefs getPrefs(BwAuthUser au) {
    BwAuthUserPrefs aup = au.getPrefs();

    if (aup == null) {
      aup = new BwAuthUserPrefs();
      aup.setAuthUser(au);
      au.setPrefs(aup);
    }

    return aup;
  }

  private BwUserInfo getUserInfo() {
    if (globals.userInfo == null) {
      globals.userInfo = new BwUserInfo();
    }

    return globals.userInfo;
  }
}

