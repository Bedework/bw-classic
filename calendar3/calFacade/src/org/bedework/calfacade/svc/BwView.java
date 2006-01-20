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
package org.bedework.calfacade.svc;

import org.bedework.calfacade.base.BwOwnedDbentity;

import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

/** A view in Bedework. This is a named collection of subscriptions used to
 * provide different vies of the events..
 *
 *   @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwView extends BwOwnedDbentity {
  /** A printable name for the view
   */
  private String name;

  /** The subscriptions
   */
  private Collection subscriptions;

  /** Constructor
   *
   */
  public BwView() {
    super();
  }

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

  /** Set the name
   *
   * @param val    String name
   */
  public void setName(String val) {
    name = val;
  }

  /** Get the name
   *
   * @return String   name
   */
  public String getName() {
    return name;
  }

  /** Set of subscriptions for this view
   *
   * @param val        Collection of BwSubscription
   */
  public void setSubscriptions(Collection val) {
    subscriptions = val;
  }

  /** Get the subscriptions for this view
   *
   * @return Collection    of BwSubscription
   */
  public Collection getSubscriptions() {
    if (subscriptions == null) {
      subscriptions = new TreeSet();
    }
    return subscriptions;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /** Add a subscription
   *
   * @param val
   */
  public void addSubscription(BwSubscription val) {
    getSubscriptions().add(val);
  }

  /** Remove a subscription
   *
   * @param val
   */
  public void removeSubscription(BwSubscription val) {
    getSubscriptions().remove(val);
  }

  /**
   * @return Iterator over subscriptions
   */
  public Iterator iterateSubscriptions() {
    return getSubscriptions().iterator();
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  /** Comapre this view and an object
   *
   * @param  o    object to compare.
   * @return int -1, 0, 1
   */
  public int compareTo(Object o) {
    if (o == this) {
      return 0;
    }

    if (o == null) {
      return -1;
    }

    if (!(o instanceof BwView)) {
      return -1;
    }

    BwView that = (BwView)o;

    int res = getOwner().compareTo(that.getOwner());
    if(res != 0) {
      return res;
    }

    return getName().compareTo(that.getName());
  }

  public int hashCode() {
    return getName().hashCode();
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwView(");
    super.toStringSegment(sb);
    sb.append(", name=");
    sb.append(String.valueOf(getName()));
    sb.append(", subscriptions=[");
    Iterator it = iterateSubscriptions();
    boolean first = true;

    while (it.hasNext()) {
      BwSubscription sub = (BwSubscription)it.next();
      if (first) {
        first = false;
      } else {
        sb.append(", ");
      }
      sb.append(sub.getName());
    }
    sb.append("]");

    sb.append(")");

    return sb.toString();
  }
}
