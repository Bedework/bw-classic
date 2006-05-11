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

/** Class to represent an owner. Key into various tables.
 *
 * @author Mike Douglass   douglm at rpi.edu
 */
public class OwnerInfo  implements Comparable {
  /** */
  public String account;
  /** */
  public int kind;

  /** No-arg Constructor
   */
  public OwnerInfo() {
  }

  /** Constructor
   *
   * @param account
   * @param kind
   */
  public OwnerInfo(String account, int kind) {
    this.account = account;
    this.kind = kind;
  }

  /**
   * @param val
   */
  public void setAccount(String val) {
    account = val;
  }

  /**
   * @return  String account name
   */
  public String getAccount() {
    return account;
  }

  /**
   * @param val int
   */
  public void setKind(int val) {
    kind = val;
  }

  /**
   * @return int kind
   */
  public int getKind() {
    return kind;
  }

  /** Make a key to the principal.
   *
   * @param p
   * @return OwnerInfo
   */
  public static OwnerInfo makeOwnerInfo(BwPrincipal p) {
    return new OwnerInfo(p.getAccount(), p.getKind());
  }

  /**
   * @param o
   * @return int
   */
  public int compareTo(Object o) {
    if (o == null) {
      return -1;
    }

    if (!(o instanceof OwnerInfo)) {
      return -1;
    }

    OwnerInfo that = (OwnerInfo)o;

    if (kind < that.kind) {
      return -1;
    }

    if (kind > that.kind) {
      return -1;
    }

    return account.compareTo(that.account);
  }

  public int hashCode() {
    return account.hashCode() * (kind + 1);
  }

  /* We always use the compareTo method
   */
  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    return compareTo(obj) == 0;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("OwnerInfo[");

    sb.append(account);
    sb.append(", ");
    sb.append(kind);
    sb.append("]");

    return sb.toString();
  }
}
