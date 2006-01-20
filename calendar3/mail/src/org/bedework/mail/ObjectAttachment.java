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
package org.bedework.mail;

/** An attachment represented by an object in memory.
 */
public class ObjectAttachment implements Attachment {
  private String mimeType;

  /** file name for object */
  private String originalName;

  private Object val;

  /**
   *
   */
  public ObjectAttachment() {
  }

  /**
   * @param val
   * @param originalName
   * @param mimeType
   */
  public ObjectAttachment(Object val,
                          String originalName,
                          String mimeType) {
    this.val = val;
    this.originalName = originalName;
    this.mimeType = mimeType;
  }

  /**
   * @param val
   */
  public void setVal(Object val) {
    this.val = val;
  }

  /**
   * @return value
   */
  public Object getVal() {
    return val;
  }

  /**
   * @param val
   */
  public void setOriginalName(String val) {
    originalName = val;
  }

  /**
   * @return value
   */
  public String getOriginalName() {
    return originalName;
  }

  /**
   * @param val
   */
  public void setMimeType(String val) {
    mimeType = val;
  }

  /**
   * @return value
   */
  public String getMimeType() {
    return mimeType;
  }

  /** Return a value of the form:
   *   ObjectAttachment[mimeType originalName String.valueOf(val)]
   *
   * @return String    representation of object.
   */
  public String toString() {
    StringBuffer sb = new StringBuffer("ObjectAttachment[");

    try {
      sb.append(mimeType);
      sb.append(" ");
      sb.append(originalName);
      sb.append(" ");
      sb.append(val);
      sb.append("]");
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }

    return sb.toString();
  }
}

