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
package org.bedework.calfacade.base;

import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeDefs;

import java.io.Serializable;

/** Base type for a database entity. We require an id and the subclasses must
 * implement hashcode and compareTo.
 *
 * @author Mike Douglass
 * @version 1.0
 */
public class BwDbentity implements Comparable, Serializable {
  private int id = CalFacadeDefs.unsavedItemKey;

  /* db version number */
  private int seq;

  /** No-arg constructor
   *
   */
  public BwDbentity() {
  }

  /** Create an entity specifying the fields
   *
   * @param id            int unique ID for the sponsor
   */
  public BwDbentity(int id) {
    this.id = id;
  }

  /**
   * @param val
   */
  public void setId(int val) {
    id = val;
  }

  /**
   * @return int id
   */
  public int getId() {
    return id;
  }

  /** Set the seq for this entity
   *
   * @param val    int seq
   */
  public void setSeq(int val) {
    seq = val;
  }

  /** Get the entity seq
   *
   * @return int    the entity seq
   */
  public int getSeq() {
    return seq;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /** Add our stuff to the StringBuffer
   *
   * @param sb    StringBuffer for result
   */
  protected void toStringSegment(StringBuffer sb) {
    sb.append("id=");
    sb.append(getId());
  }

  /* ====================================================================
   *                   Object methods
   * The following are required for a db object.
   * ==================================================================== */

  public int compareTo(Object o) {
    throw new RuntimeException("compareTo must be implemented for a db object");
  }

  public int hashCode() {
    throw new RuntimeException("hashcode must be implemented for a db object");
  }

  /* We always use the compareTo method
   */
  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    return compareTo(obj) == 0;
  }

  /* ====================================================================
   *                   Protected methods
   * ==================================================================== */

  protected String userid(BwUser u) {
    if (u == null) {
      return "null";
    }

    return String.valueOf(u.getId());
  }
}
