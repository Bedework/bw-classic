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
package org.bedework.dumprestore.restore;

import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.base.BwOwnedDbentity;
import org.bedework.calfacade.base.BwShareableDbentity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/** Handle the onlyusers processing.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class OnlyUsersMap {
  /** If true we should discard all but users in onlyUsers
   * This helps when building demo data
   */
  private boolean onlyUsers;

  /* Users we preserve */
  private HashMap map = new HashMap();

  /** Users we skipped */
  private HashMap skipped = new HashMap();

  /** User patterns we preserve */
  private ArrayList patterns = new ArrayList();

  /**
   *
   * @param val
   */
  public void setOnlyUsers(boolean val) {
    onlyUsers = val;
  }

  /**
   *
   * @return boolean
   */
  public boolean getOnlyUsers() {
    return onlyUsers;
  }

  /**
   * @param val
   */
  public void add(String val) {
    if (val.endsWith("*")) {
      patterns.add(val.substring(0, val.length() - 1));
    } else {
      map.put(val, val);
    }
  }

  /** See if we skip this one
   *
   * @param ent Principal to check
   * @return boolean true if user if OK
   */
  public boolean check(BwPrincipal ent) {
    if (!onlyUsers) {
      return true;
    }

    String account = ent.getAccount();
    if (map.get(account) == null) {
      if (skipped.get(account) != null) {
        return false;
      }

      Iterator it = patterns.iterator();
      while (it.hasNext()) {
        String prefix = (String)it.next();
        if (account.startsWith(prefix)) {
          map.put(account, account);
          return true;
        }
      }

      // Bypass the above next time
      skipped.put(account, account);
      return false;
    }

    return true;
  }

  /** See if we skip this one
   *
   * @param ent Owned entity to check
   * @return boolean true if user if OK
   */
  public boolean check(BwOwnedDbentity ent) {
    if (!onlyUsers) {
      return true;
    }

    return check(ent.getOwner());
  }

  /** Check and modify a shareable entity with creator different from owner.
   *
   * @param ent Sahreable entity
   * @return boolean true if owner if OK
   */
  public boolean checkOnlyUser(BwShareableDbentity ent) {
    if (!onlyUsers) {
      return true;
    }

    if (!check(ent.getOwner())) {
      return false;
    }

    if (!check(ent.getCreator())) {
      ent.setCreator(ent.getOwner());
    }

    return true;
  }
}
