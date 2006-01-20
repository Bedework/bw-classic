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

package edu.rpi.sss.util.xml;

/** Class to represent an XML qualified name.
 * NOTE: This is defined in the j2ee world somewhere as javax.xml.namespace.QName
 * and we should use that when it appears in the appropriate libraries.
 *
 * <p>An xml name is represented by an optional namespace uri folllowed by a
 * localPart.
 * @author Mike Douglass  douglm@rpi.edu
 */
public class QName {
  private String namespaceURI;
  private String localPart;

  /** Constructor
   * @param namespaceURI
   * @param localPart
   */
  public QName(String namespaceURI, String localPart) {
    this.namespaceURI = namespaceURI;
    this.localPart = localPart;
  }

  /**
   * @return namespace uri
   */
  public String getNamespaceURI() {
    return namespaceURI;
  }

  /**
   * @return local part of name
   */
  public String getLocalPart() {
    return localPart;
  }

  public int hashCode() {
    int hc = 1;

    String ns = getNamespaceURI();
    if (ns != null) {
      hc *= ns.hashCode();
    }

    String lp = getLocalPart();
    if (lp != null) {
      hc *= lp.hashCode();
    }

    return hc;
  }

  public boolean equals(Object o) {
    if (o == this) {
      return true;
    }

    if (!(o instanceof QName)) {
      return false;
    }

    QName that = (QName)o;

    String ns = getNamespaceURI();
    if (ns == null) {
      if (that.getNamespaceURI() != null) {
        return false;
      }
    } else if (!ns.equals(that.getNamespaceURI())) {
      return false;
    }

    String lp = getLocalPart();
    if (lp == null) {
      if (that.getLocalPart() != null) {
        return false;
      }
    } else if (!lp.equals(that.getLocalPart())) {
      return false;
    }

    return true;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    String ns = getNamespaceURI();
    if (ns != null) {
      sb.append(ns);
      sb.append(":");
    }

    sb.append(getLocalPart());

    return sb.toString();
  }
}

