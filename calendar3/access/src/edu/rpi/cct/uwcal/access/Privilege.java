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

  /** Constructor for non-abstract non-denial
   *
   * @param name
   * @param description
   * @param index
   */
  public Privilege(String name,
                   String description,
                   int index) {
    this(name, description, false, false, index);
  }

  /**
   * @return String
   */
  public String getName() {
    return name;
  }

  /**
   * @return String
   */
  public String getDescription() {
    return description;
  }

  /**
   * @return String
   */
  public boolean getAbstractPriv() {
    return abstractPriv;
  }

  /**
   * @return String
   */
  public boolean getDenial() {
    return denial;
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
  void addContainedPrivilege(Privilege val) {
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

  /** Works its way down the tree of privileges finding the highest entry
   * that matches the privilege in the acl.
   *
   * @param allowedRoot
   * @param deniedRoot
   * @param acl
   * @return Privilege
   * @throws AccessException
   */
  public static Privilege findPriv(Privilege allowedRoot,
                                   Privilege deniedRoot,
                                   EncodedAcl acl)
          throws AccessException {
    if (acl.remaining() < 2) {
      return null;
    }

    Privilege p;

    if (matchDenied(acl)) {
      p = matchEncoding(deniedRoot, acl);
    } else {
      p = matchEncoding(allowedRoot, acl);
    }

    if (p == null) {
      acl.back();  // back up over denied flag
    }

    return p;
  }

  private static boolean matchDenied(EncodedAcl acl) throws AccessException {
    char c = acl.getChar();

    /* Expect the privilege allowed/denied flag
     * (or the oldDenied or oldAllowed flag)
     */
    if ((c == denied) || (c == oldDenied)) {
      return true;
    }

    if ((c == allowed) || (c == oldAllowed)) {
      return false;
    }

    throw AccessException.badACE("privilege flag=" + c +
                                 " " + acl.getErrorInfo());
  }

  /** We matched denied at the start. Here only the encoding is compared.
   *
   * @param subRoot Privilege
   * @param acl
   * @return Privilege or null
   * @throws AccessException
   */
  private static Privilege matchEncoding(Privilege subRoot,
                                         EncodedAcl acl) throws AccessException {
    if (acl.remaining() < 1) {
      return null;
    }

    char c = acl.getChar();

    //System.out.println("subRoot.encoding='" + subRoot.encoding + " c='" + c + "'");
    if (subRoot.encoding == c) {
      return subRoot;
    }

    /* Try the children */

    acl.back();

    Iterator it = subRoot.iterateContainedPrivileges();
    while (it.hasNext()) {
      Privilege p = matchEncoding((Privilege)it.next(), acl);
      if (p != null) {
        return p;
      }
    }

    return null;
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

  /** Make a copy including children with the denied flag set true
   *
   * @param val Privilege to clone
   * @return Privilege cloned value
   */
  public static Privilege cloneDenied(Privilege val) {
    Privilege newval = new Privilege(val.getName(),
                                     val.getDescription(),
                                     val.getAbstractPriv(),
                                     true,
                                     val.getIndex());

    Iterator it = val.iterateContainedPrivileges();
    while (it.hasNext()) {
      newval.addContainedPrivilege(cloneDenied((Privilege)it.next()));
    }

    return newval;
  }

  /* ====================================================================
   *                    private methods
   * ==================================================================== */

  /**
   * @param val
   */
  private void setIndex(int val) {
    index = val;
    encoding = privEncoding[index];
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

