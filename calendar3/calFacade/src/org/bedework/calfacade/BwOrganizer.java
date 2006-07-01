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

import org.bedework.calfacade.base.BwOwnedDbentity;
import org.bedework.calfacade.util.CalFacadeUtil;

import java.util.Set;

/** Represent an organizer
 *
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class BwOrganizer extends BwOwnedDbentity {
  /* Params fields */

  private String cn;
  private String dir;
  private String language;
  private String sentBy;

  /** The uri */
  private String organizerUri;

  /** Events referencing this organizer
   */
  protected Set events;

  /** Constructor
   *
   */
  public BwOrganizer() {
    super();
  }

  /** Constructor
   *
   * @param owner
   * @param publick
   * @param cn
   * @param dir
   * @param language
   * @param sentBy
   * @param organizerUri
   */
  public BwOrganizer(BwUser owner,
                     boolean publick,
                     String cn,
                     String dir,
                     String language,
                     String sentBy,
                     String organizerUri) {
    super(owner, publick);
    this.cn = cn;
    this.dir = dir;
    this.language = language;
    this.sentBy = sentBy;
    this.organizerUri = organizerUri;
  }

  /* ====================================================================
   *                      Bean methods
   * ==================================================================== */

  /** Set the cn
   *
   *  @param  val   String cn
   */
  public void setCn(String val) {
    cn = val;
  }

  /** Get the cn
   *
   *  @return String     cn
   */
  public String getCn() {
    return cn;
  }

  /** Set the dir (directory url for lookup)
   *
   *  @param  val   String dir
   */
  public void setDir(String val) {
    dir = val;
  }

  /** Get the dir
   *
   *  @return String     dir
   */
  public String getDir() {
    return dir;
  }

  /** Set the language
   *
   *  @param  val   String language
   */
  public void setLanguage(String val) {
    language = val;
  }

  /** Get the language
   *
   *  @return String     language
   */
  public String getLanguage() {
    return language;
  }

  /** Set the sentBy
   *
   *  @param  val   String sentBy
   */
  public void setSentBy(String val) {
    sentBy = val;
  }

  /** Get the sentBy
   *
   *  @return String     sentBy
   */
  public String getSentBy() {
    return sentBy;
  }

  /** Set the organizerUri
   *
   *  @param  val   String organizerUri
   */
  public void setOrganizerUri(String val) {
    organizerUri = val;
  }

  /** Get the organizerUri
   *
   *  @return String     organizerUri
   */
  public String getOrganizerUri() {
    return organizerUri;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compareTo(Object o) {
    if (this == o) {
      return 0;
    }

    if (o == null) {
      return -1;
    }

    if (!(o instanceof BwLocation)) {
      return -1;
    }

    BwOrganizer that = (BwOrganizer)o;

    return CalFacadeUtil.cmpObjval(getOrganizerUri(), that.getOrganizerUri());
  }

  public int hashCode() {
    int hc = 1;

    if (getOrganizerUri() != null) {
      hc *= getOrganizerUri().hashCode();
    }

    return hc;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwOrganizer");

    toStringSegment(sb);
    sb.append(", cn=");
    sb.append(cn);
    sb.append(", dir=");
    sb.append(dir);
    sb.append(", language=");
    sb.append(language);
    sb.append(", sentBy=");
    sb.append(sentBy);
    sb.append(", organizerUri=");
    sb.append(organizerUri);
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    BwOrganizer nobj = new BwOrganizer((BwUser)getOwner().clone(),
                                       getPublick(),
                                       getCn(),
                                       getDir(),
                                       getLanguage(),
                                       getSentBy(),
                                       getOrganizerUri());
    nobj.setId(getId());

    return nobj;
  }
}

