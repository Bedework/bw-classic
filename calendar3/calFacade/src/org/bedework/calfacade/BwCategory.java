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
package org.bedework.calfacade;

/** A category in Bedework. This value object does no consistency or validity
 * checking
 *.
 *  @version 1.0
 */
public class BwCategory extends BwEventProperty implements Comparable{
  private String word;
  private String description;

  /** Constructor
   */
  public BwCategory() {
    super();
  }

  /** Create a category by specifying all its fields
   *
   * @param owner          BwUser user who owns the entity
   * @param publick        boolean true if the entity is public
   * @param creator        BwUser user who created the entity
   * @param access
   * @param word        String word
   * @param description String long description for help
   */
  public BwCategory(BwUser owner,
                    boolean publick,
                    BwUser creator,
                    String access,
                    String word,
                    String description) {
    super(owner, publick, creator, access);
    this.word = word;
    this.description = description;
  }

  /** Set the word
   *
   * @param val    String word
   */
  public void setWord(String val) {
    word = val;
  }

  /** Get the word
   *
   * @return String   word
   */
  public String getWord() {
    return word;
  }

  /** Set the category's description
   *
   * @param val    String category's description
   */
  public void setDescription(String val) {
    description = val;
  }

  /** Get the category's description
   *
   *  @return String   category's description
   */
  public String getDescription() {
    return description;
  }

  /* ====================================================================
   *                        Object methods
   * ==================================================================== */

  public int compareTo(Object o) {
    if (o == null) {
      return -1;
    }

    if (!(o instanceof BwCategory)) {
      return -1;
    }

    BwCategory that = (BwCategory)o;

    int res = CalFacadeUtil.cmpObjval(getWord(), that.getWord());

    if (res != 0) {
      return res;
    }

    return CalFacadeUtil.cmpObjval(getOwner(), that.getOwner());
  }

  public int hashCode() {
    int hc = 1;

    if (getWord() != null) {
      hc *= getWord().hashCode();
    }

    if (getOwner() != null) {
      hc *= getOwner().hashCode();
    }

    return hc;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwCategory{");

    toStringSegment(sb);
    sb.append(", word=");
    sb.append(word);
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    return new BwCategory((BwUser)getOwner().clone(),
                          getPublick(),
                          (BwUser)getCreator().clone(),
                          getAccess(),
                          getWord(),
                          getDescription());
  }
}
