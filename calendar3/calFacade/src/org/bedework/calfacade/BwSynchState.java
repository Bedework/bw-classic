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

/** Represents the synchronization state of an event.
 *
 *  @author Mike Douglass douglm@rpi.edu
 *  @version 1.0
 */
public class BwSynchState implements Serializable {
  /** Define the states an event might be in wrt the calendar/user
   * Userid + deviceid + eventid form the unique key.
   */

  /** This state will be used to mark all items that have never been synched.
   * This is the state of all events before their first synchronization.
   */
  public static final int UNKNOWN = 0;

  /** A synchronized event is an event that has not changed since the time of
   * the last synchronization
   */
  public static final int SYNCHRONIZED = 1;

  /** An event will be in that state if it has been created/added by the user
   * and not yet synchronized. This will typically happen if the user
   * creates/adds an event from the WEB view of their calendar.
   */
  public static final int NEW = 2;

  /** An event will be in that state if it has been modified by the user and
   * not yet synchronized. This will typically happen if the user modifies an
   * event from the WEB view of their calendar.
   */
  public static final int MODIFIED = 3;

  /** An event will be in that state if it has been deleted by the user and
   * not yet synchronized. This will typically happen if the user deletes an
   * event from the WEB view of their calendar.
   */
  public static final int DELETED = 4;

  /** An event will be in this state if it has been deleted by the client but
   * cannot be deleted by the server - probably because the user does not own
   * the entity. It will remain in that state until either the event is really
   * deleted or the state is explicitly reset by the web user.
   */
  public static final int CLIENT_DELETED = 5;

  /** An event will be in this state if it has been deleted by this user from
   * another device. For that device it will be CLIENT_DELETED. This state
   * signifies the deleted state has not been delivered to the device. Once
   * the state is delivered this state will be set to CLIENT_DELETED.
   */
  public static final int CLIENT_DELETED_UNDELIVERED = 6;

  /** An event will be in this state if it has been modified by the client but
   * cannot be modified by the server - probably because the user does not own
   * the entity. It will remain in that state until explicitly reset by the web user.
   */
  public static final int CLIENT_MODIFIED = 7;

  /** Flag an event whih will take the state CLIENT_MODFIED but must still
   * be delivered as a modified event.
   */
  public static final int CLIENT_MODIFIED_UNDELIVERED = 8;

  private static final String[] stateNames = {
    "UNKNOWN",
    "SYNCHRONIZED",
    "NEW",
    "MODIFIED",
    "DELETED",
    "CLIENT_DELETED",
    "CLIENT_DELETED_UNDELIVERED",
    "CLIENT_MODIFIED",
    "CLIENT_MODIFIED_UNDELIVERED",
  };

  private int userid;

  /** The user */
  private BwUser user;

  /** The deviceId identifies the other end of the conversation. This is
   * something of an Syncml term
   */
  private String deviceId;

  /** The event this refers to. If the event has been deleted this will be
   * null, however the guid will be set and can be used by the synch engine.
   */
  private BwEvent event;

  private int eventId;

  /** Event guid. Mostly used for deleted events.
   */
  private String guid;

  /** Synchronization state of this event - see above
   */
  private int synchState;

  /** If the event was modifed by the client device but is a read-only event
   * (e.g. a public event) then we store the modified event here as an icalendar
   * string and replay it on later synch events.
   */
  private BwSynchData synchData;

  /** Constructor
   *
   */
  public BwSynchState() {
  }

  /** Constructor
   *
   * @param user
   * @param deviceId
   * @param event
   * @param guid
   * @param synchState
   */
  public BwSynchState(BwUser user,
                      String deviceId,
                      BwEvent event,
                      String guid,
                      int synchState) {
    setUser(user);
    this.deviceId = deviceId;
    setEvent(event);
    this.guid = guid;
    this.synchState = synchState;
  }

  /**    Set the userid
   *
   * @param val   userid
   */
  public void setUserid(int val) {
    userid = val;
  }

  /** Get the user id
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

  /** set the event
   *
   * @param val  EventVO event
   */
  public void setEvent(BwEvent val) {
    event = val;
    if (val != null) {
      eventId = val.getId();
    }
  }

  /** Get the event
   *
   * @return EventVO     event
   */
  public BwEvent getEvent() {
    return event;
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

  /** Set the event's guid
   *
   * @param val    String event's guid
   */
  public void setGuid(String val) {
    guid = val;
  }

  /** Get the event's guid
   *
   * @return String   event's guid
   */
  public String getGuid() {
    return guid;
  }

  /** set the synchState
   *
   * @param val  int synchState
   */
  public void setSynchState(int val) {
    synchState = val;
  }

  /** Get the synchState
   *
   * @return int     synchState
   */
  public int getSynchState() {
    return synchState;
  }

  /** set the modifed event data
   *
   * @param val  SynchDataVO synchData
   */
  public void setSynchData(BwSynchData val) {
    synchData = val;
  }

  /** Get the modifed event data
   *
   * @return SynchDataVO     synchData
   */
  public BwSynchData getSynchData() {
    return synchData;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("SynchStateVO{user=");

    if (user == null) {
      sb.append("**********null************");
    } else {
      sb.append(user.getAccount());
    }
    sb.append(", deviceId=");
    sb.append(deviceId);
    sb.append(", event=");

    if (synchState != DELETED) {
      if (event == null) {
        sb.append("**********null************");
      } else {
        sb.append(event.getId());
      }
    } else {
      sb.append("null");
    }

    sb.append(", guid=");
    sb.append(guid);
    sb.append(", synchState=");
    sb.append(stateNames[synchState]);
    sb.append(", synchData=");

    if (synchData == null) {
      sb.append("absent");
    } else {
      sb.append("present");
    }
    sb.append("}");

    return sb.toString();
  }

  public int hashCode() {
    return 31 * (userid + 1) * deviceId.hashCode();
  }

  public boolean equals(Object obj) {
    if (!(obj instanceof BwSynchState)) {
      return false;
    }

    BwSynchState that = (BwSynchState)obj;

    return (userid == that.userid) && (deviceId.equals(that.deviceId));
  }
}
