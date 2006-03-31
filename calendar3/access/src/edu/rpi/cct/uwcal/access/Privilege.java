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
package edu.rpi.cct.uwcal.access;

import java.util.ArrayList;
import java.util.Iterator;

/** Define the properties of a privilege for the calendar.
 *
 *  @author Mike Douglass   douglm @ rpi.edu
 */
/**
 * @author douglm
 *
 */
public class Privilege implements PrivilegeDefs {
  private String name;

  /** This will probably go - the description needs to come from a resource
   * and be in the appropriate language.
   */
  private String description;

  private boolean abstractPriv;

  /** Is this a denial rather than granting
   */
  private boolean denial;

  private int index;

  private char encoding;

  private ArrayList containedPrivileges = new ArrayList();

  /** Constructor
   *
   * @param name
   * @param description
   * @param abstractPriv
   * @param denial
   * @param index
   */
  public Privilege(String name,
                   String description,
                   boolean abstractPriv,
                   boolean denial,
                   int index) {
    this.name = name;
    this.description = description;
    this.abstractPriv = abstractPriv;
    this.denial = denial;
    setIndex(index);
  }

  /**
   * @param val
   */
  public void setName(String val) {
    name = val;
  }

  /**
   * @return String
   */
  public String getName() {
    return name;
  }

  /**
   * @param val
   */
  public void setDescription(String val) {
    description = val;
  }

  /**
   * @return String
   */
  public String getDescription() {
    return description;
  }

  /**
   * @param val
   */
  public void setAbstractPriv(boolean val) {
    abstractPriv = val;
  }

  /**
   * @return String
   */
  public boolean getAbstractPriv() {
    return abstractPriv;
  }

  /**
   * @param val
   */
  public void setDenial(boolean val) {
    denial = val;
  }

  /**
   * @return String
   */
  public boolean getDenial() {
    return denial;
  }

  /**
   * @param val
   */
  public void setIndex(int val) {
    index = val;
    encoding = privEncoding[index];
  }

  /**
   * @return String
   */
  public int getIndex() {
    return index;
  }

  /**
   * @param val
   */
  public void addContainedPrivilege(Privilege val) {
    containedPrivileges.add(val);
  }

  /**
   * @return String
   */
  public Iterator iterateContainedPrivileges() {
    return containedPrivileges.iterator();
  }

  /* ====================================================================
   *                 Decoding methods
   * ==================================================================== */

  /** If the characters at the current position match the encoding for this
   * privilege, returns true else false.
   */
  /**
   * @param acl
   * @return String
   * @throws AccessException
   */
  public boolean match(EncodedAcl acl) throws AccessException {
    if (acl.remaining() < 2) {
      return false;
    }

    char c = acl.getChar();

    /* Expect the privilege allowed/denied flag
     */
    if (c == denied) {
      denial = true;
    } else if (c == allowed) {
      denial = false;
    } else {
      throw AccessException.badACE("privilege flag=" + c +
                                   " " + acl.getErrorInfo());
    }

    if (encoding != acl.getChar()) {
      acl.back(2);
      return false;
    }

    return true;
  }

  /* ====================================================================
   *                 Encoding methods
   * ==================================================================== */

  /** Encode this object as a sequence of char.
   *
   * @param acl   EncodedAcl for result.
   */
  /**
   * @param acl
   * @throws AccessException
   */
  public void encode(EncodedAcl acl) throws AccessException {
    if (denial) {
      acl.addChar(denied);
    } else {
      acl.addChar(allowed);
    }

    acl.addChar(encoding);
  }

  /* ====================================================================
   *                    Object methods
   * ==================================================================== */
/*
  public int hashCode() {
    return 31 * entityId * entityType;
  }

  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (obj == null) {
      return false;
    }

    if (!(obj instanceof AttendeeVO)) {
      return false;
    }

    AttendeePK that = (AttendeePK)obj;

    return (entityId == that.entityId) &&
           (entityType == that.entityType);
  }
  */

  /** Provide a string representation for user display - this should probably
   * use a localized resource
   */
  /**
   * @return String
   */
  public String toUserString() {
    StringBuffer sb = new StringBuffer();

    if (getDenial()) {
      sb.append("NOT ");
    }

    sb.append(getName());

    return sb.toString();
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("Privilege{name=");
    sb.append(name);
    sb.append(", description=");
    sb.append(description);
    sb.append(", abstractPriv=");
    sb.append(abstractPriv);
    sb.append(", denial=");
    sb.append(denial);
    sb.append(", index=");
    sb.append(index);
    sb.append("}");

    return sb.toString();
  }

  /** We do not clone the contained privileges - if any.
   *
   * @return Object cloned value
   */
  public Object clone() {
    return new Privilege(getName(),
                         getDescription(),
                         getAbstractPriv(),
                         getDenial(),
                         getIndex());
  }
}

