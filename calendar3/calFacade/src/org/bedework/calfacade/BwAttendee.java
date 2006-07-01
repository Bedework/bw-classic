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

/** Represent an attendee
 *
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class BwAttendee extends BwOwnedDbentity implements Comparable {
  /* Params fields */

  private String cn;
  private String cuType;
  private String delegatedFrom;
  private String delegatedTo;
  private String dir;
  private String language;
  private String member;
  private String sentBy;
  private boolean rsvp;
  private String role;
  private String partstat;

  /** The uri */
  private String attendeeUri;

  /** Constructor
   *
   */
  public BwAttendee() {
  }

  /** Constructor
   *
   * @param owner
   * @param publick
   * @param cn
   * @param cuType
   * @param delegatedFrom
   * @param delegatedTo
   * @param dir
   * @param language
   * @param member
   * @param rsvp
   * @param role
   * @param partstat
   * @param sentBy
   * @param attendeeUri
   */
  public BwAttendee(BwUser owner,
                    boolean publick,
                    String cn,
                    String cuType,
                    String delegatedFrom,
                    String delegatedTo,
                    String dir,
                    String language,
                    String member,
                    boolean rsvp,
                    String role,
                    String partstat,
                    String sentBy,
                    String attendeeUri) {
    super(owner, publick);
    this.cn = cn;
    this.cuType = cuType;
    this.delegatedFrom = delegatedFrom;
    this.delegatedTo = delegatedTo;
    this.dir = dir;
    this.language = language;
    this.member = member;
    this.rsvp = rsvp;
    this.role = role;
    this.sentBy = sentBy;
    this.attendeeUri = attendeeUri;
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

  /** Set the cuType
   *
   *  @param  val   String cuType
   */
  public void setCuType(String val) {
    cuType = val;
  }

  /** Get the cuType
   *
   *  @return String     cuType
   */
  public String getCuType() {
    return cuType;
  }

  /** Set the delegatedFrom
   *
   *  @param  val   String delegatedFrom
   */
  public void setDelegatedFrom(String val) {
    delegatedFrom = val;
  }

  /** Get the delegatedFrom
   *
   *  @return String     delegatedFrom
   */
  public String getDelegatedFrom() {
    return delegatedFrom;
  }

  /** Set the delegatedTo
   *
   *  @param  val   String delegatedTo
   */
  public void setDelegatedTo(String val) {
    delegatedTo = val;
  }

  /** Get the delegatedTo
   *
   *  @return String     delegatedTo
   */
  public String getDelegatedTo() {
    return delegatedTo;
  }

  /** Set the dir
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

  /** Set the member
   *
   *  @param  val   String member
   */
  public void setMember(String val) {
    member = val;
  }

  /** Get the member
   *
   *  @return String     member
   */
  public String getMember() {
    return member;
  }

  /** Set the rsvp
   *
   *  @param  val   boolean rsvp
   */
  public void setRsvp(boolean val) {
    rsvp = val;
  }

  /** Get the rsvp
   *
   *  @return boolean     rsvp
   */
  public boolean getRsvp() {
    return rsvp;
  }

  /** Set the role
   *
   *  @param  val   String role
   */
  public void setRole(String val) {
    role = val;
  }

  /** Get the role
   *
   *  @return String     role
   */
  public String getRole() {
    return role;
  }

  /** Set the partstat
   *
   *  @param  val   String partstat
   */
  public void setPartstat(String val) {
    partstat = val;
  }

  /** Get the partstat
   *
   *  @return String     partstat
   */
  public String getPartstat() {
    return partstat;
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

  /** Set the attendeeUri
   *
   *  @param  val   String attendeeUri
   */
  public void setAttendeeUri(String val) {
    attendeeUri = val;
  }

  /** Get the attendeeUri
   *
   *  @return String     attendeeUri
   */
  public String getAttendeeUri() {
    return attendeeUri;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int hashCode() {
    return getAttendeeUri().hashCode();
  }

  public int compareTo(Object o)  {
    if (!(o instanceof BwAttendee)) {
      throw new ClassCastException();
    }

    if (this == o) {
      return 0;
    }

    BwAttendee that = (BwAttendee)o;

    return getAttendeeUri().compareTo(that.getAttendeeUri());
  }

  /* For equality checks, we cannot use the id - we are possibly attempting
   * to determine if an object is the same as a persisted object.
   *
   * <p>We need to decide what determines equality and what is simply an
   * attribute of that object.
   *
   * <p>For example, a phone number should probably not be part of that check.
   * If we are trying to modify the phone number they will obviously be
   * different.
   *
   * <p>For an attendee we assume equals if attendeeUri match
   */
  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (!(obj instanceof BwAttendee)) {
      return false;
    }

    BwAttendee that = (BwAttendee)obj;

    return CalFacadeUtil.eqObjval(getAttendeeUri(), that.getAttendeeUri());
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("AttendeeVO{");

    toStringSegment(sb);
    sb.append(", cn=");
    sb.append(cn);
    sb.append(", cuType=");
    sb.append(getCuType());
    sb.append(", delegatedFrom=");
    sb.append(getDelegatedFrom());
    sb.append(", delegatedTo=");
    sb.append(getDelegatedTo());
    sb.append(", dir=");
    sb.append(getDir());
    sb.append(", language=");
    sb.append(getLanguage());
    sb.append(", member=");
    sb.append(getMember());
    sb.append(", rsvp=");
    sb.append(getRsvp());
    sb.append(", role=");
    sb.append(getRole());
    sb.append(", partstat=");
    sb.append(getPartstat());
    sb.append(", sentBy=");
    sb.append(getSentBy());
    sb.append(", attendeeUri=");
    sb.append(getAttendeeUri());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    BwAttendee nobj = new BwAttendee((BwUser)getOwner().clone(),
                                     getPublick(),
                                     getCn(),
                                     getCuType(),
                                     getDelegatedFrom(),
                                     getDelegatedTo(),
                                     getDir(),
                                     getLanguage(),
                                     getMember(),
                                     getRsvp(),
                                     getRole(),
                                     getPartstat(),
                                     getSentBy(),
                                     getAttendeeUri());
    nobj.setId(getId());

    return nobj;
  }
}

