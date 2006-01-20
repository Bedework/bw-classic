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

/** Information about synchronization with a given device
 *
 *  @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwSynchInfo implements Serializable {
  private int userid;

  /** The user */
  private BwUser user;

  /** The deviceId identifies the other end of the conversation. This is
   * something of an Syncml term
   */
  private String deviceId;

  /** The calendarId determines what view of the users data we are synching
   * with. For example, for device "MyPalm" we might only be synching movies.
   *
   * <p>For the time being at least we are only synching the entire visible
   * set of user events - defined by a calendarId of < 0
   */
  private int calendarId = -1;

  /** Last synch date/time in iso format.
   */
  private String lastsynch;

  /** Constructor
   *
   */
  public BwSynchInfo() {
  }

  /** Constructor
   *
   * @param user
   * @param deviceId
   * @param calendarId
   * @param lastsynch
   */
  public BwSynchInfo(BwUser user,
                     String deviceId,
                     int calendarId,
                     String lastsynch) {
    this.user = user;
    if (user != null) {
      this.userid = user.getId();
    }
    this.deviceId = deviceId;
    this.calendarId = calendarId;
    this.lastsynch = lastsynch;
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

  /** set the deviceId
   *
   * @param val  String deviceId
   */
  public void setDeviceId(String val) {
    deviceId = val;
  }

  /** Get the deviceId
   *
   * @return String     deviceId
   */
  public String getDeviceId() {
    return deviceId;
  }

  /** set the calendarId
   *
   * @param val  int calendarId
   */
  public void setCalendarId(int val) {
    calendarId = val;
  }

  /** Get the calendarId
   *
   * @return int     calendarId
   */
  public int getCalendarId() {
    return calendarId;
  }

  /** Set last synch
   *
   * @param val
   */
  public void setLastsynch(String val) {
    lastsynch = val;
  }

  /** Get last synch
   *
   * @return String last synch value
   */
  public String getLastsynch() {
    return lastsynch;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int hashCode() {
    int hc = 31 * (userid + 1);

    if (deviceId != null) {
      hc = hc * deviceId.hashCode();
    }

    return hc;
  }

  public boolean equals(Object obj) {
    if (!(obj instanceof BwSynchInfo)) {
      return false;
    }

    BwSynchInfo that = (BwSynchInfo)obj;

    return (userid == that.userid) &&
           (CalFacadeUtil.compareStrings(deviceId, that.deviceId) == 0);
  }
}
