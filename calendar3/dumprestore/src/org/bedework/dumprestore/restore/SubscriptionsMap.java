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

import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.svc.BwSubscription;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

/** Map for subscriptions
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class SubscriptionsMap extends HashMap {
  /** For 2.3.2 conversion
   *
   * @param key   OwnerInfo
   * @param calid
   */
  public void put(OwnerInfo key, int calid) {
    ArrayList al = (ArrayList)get(key);
    if (al == null) {
      al = new ArrayList();
      put(key, al);
    }

    al.add(new Integer(calid));
  }

  /**
   * @param key   BwUser
   * @param sub
   */
  public void put(BwUser key, BwSubscription sub) {
    put(OwnerInfo.makeOwnerInfo(key), sub);
  }

  /**
   * @param key   OwnerInfo
   * @param sub
   */
  public void put(OwnerInfo key, BwSubscription sub) {
    ArrayList al = (ArrayList)get(key);
    if (al == null) {
      al = new ArrayList();
      put(key, al);
    }

    al.add(sub);
  }

  /** 2.3.2
   *
   * @param key   BwUser
   * @return Collection
   */
  public Collection getCalendarids(BwUser key) {
    return (Collection)get(OwnerInfo.makeOwnerInfo(key));
  }

  /**
   * @param key   OwnerInfo
   * @return Collection
   */
  public Collection getSubs(OwnerInfo key) {
    return (Collection)get(key);
  }

  /**
   * @param key   OwnerInfo
   * @param subid
   * @return BwSubscription
   */
  public BwSubscription getSub(OwnerInfo key, int subid) {
    Collection subs = getSubs(key);

    if (subs == null) {
      return null;
    }

    Iterator it = subs.iterator();
    while (it.hasNext()) {
      BwSubscription sub = (BwSubscription)it.next();
      if (sub.getId() == subid) {
        return sub;
      }
    }

    return null;
  }

  /**
   * @param key   OwnerInfo
   * @param name
   * @return BwSubscription
   */
  public BwSubscription getSub(OwnerInfo key, String name) {
    Collection subs = getSubs(key);

    if (subs == null) {
      return null;
    }

    Iterator it = subs.iterator();
    while (it.hasNext()) {
      BwSubscription sub = (BwSubscription)it.next();
      if (sub.getName().equals(name)) {
        return sub;
      }
    }

    return null;
  }
}
