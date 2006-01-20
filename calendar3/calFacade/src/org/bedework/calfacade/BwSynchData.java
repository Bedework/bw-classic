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

import java.io.Serializable;

/** Save a modified copy of an event for a synchronising user.
 *
 *  @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwSynchData implements Serializable {
  private int userid;

  /** The user */
  private BwUser user;

  private int eventId;

  private String eventData;

  /** Constructor
   *
   */
  public BwSynchData() {
  }

  /** Constructor
   *
   * @param user
   * @param eventId
   * @param eventData
   */
  public BwSynchData(BwUser user,
                     int eventId,
                     String eventData) {
    this.user = user;
    if (user != null) {
      this.userid = user.getId();
    }
    this.eventId = eventId;
    this.eventData = eventData;
  }

  /**    Set the userid
   * @param val   userid
   */
  public void setUserid(int val) {
    userid = val;
  }

  /** Get the unique id
   *
   * @return int    the userid
   */
  public int getUserid() {
    return userid;
  }

  /** set the user
   *
   * @param val  UserVO user
   */
  public void setUser(BwUser val) {
    user = val;
    if (user != null) {
      userid = user.getId();
    }
  }

  /** Get the user
   *
   * @return UserVO     user, userVO
   */
  public BwUser getUser() {
    return user;
  }

  /** set the eventId
   *
   * @param val  int eventId
   */
  public void setEventId(int val) {
    eventId = val;
  }

  /** Get the eventId
   *
   * @return int     eventId
   */
  public int getEventId() {
    return eventId;
  }

  /** set the eventData
   *
   * @param val  String eventData
   */
  public void setEventData(String val) {
    eventData = val;
  }

  /** Get the eventData
   *
   * @return String     eventData
   */
  public String getEventData() {
    return eventData;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int hashCode() {
    return 31 * (userid + 1) * (eventId + 1);
  }

  public boolean equals(Object obj) {
    if (!(obj instanceof BwSynchData)) {
      return false;
    }

    BwSynchData that = (BwSynchData)obj;

    return (userid == that.userid) && (eventId == that.eventId);
  }
}
