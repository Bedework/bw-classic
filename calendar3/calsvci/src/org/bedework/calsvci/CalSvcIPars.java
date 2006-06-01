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

package org.bedework.calsvci;

import java.io.Serializable;

/** These are global parameters used by the CalSvc interface.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class CalSvcIPars implements Serializable {
  /** The authenticated user - null for guest
   */
  private String authUser;

  /** The current user we run as. null to use calSuite
   */
  private String user;

  /** The calendar suite name. user and calSuite null for guest.
   */
  private String calSuite;

  /** Environment properties prefix - e.g. "org.bedework.webpersonal."
   */
  private String envPrefix;

  /** True if this is for public admin
   */
  private boolean publicAdmin;

  /** True if this is via caldav
   */
  private boolean caldav;

  /** Non-null if this is for synchronization. Identifies the client end.
   */
  private String synchId;

  /** True if we want debugging output
   */
  private boolean debug;

  /** Constructor for this object.
   *
   * @param authUser    String authenticated user of the application
   * @param user        String user to act as
   * @param calSuite    String calSuite name
   * @param envPrefix   String Environment properties prefix
   * @param publicAdmin true for admin
   * @param caldav      true if via caldav
   * @param synchId     non-null if this is for synchronization. Identifies the
   *                    client end.
   * @param debug       boolean true to turn on debugging trace
   */
  public CalSvcIPars(String authUser,
                     String user,
                     String calSuite,
                     String envPrefix,
                     boolean publicAdmin,
                     boolean caldav,
                     String synchId,
                     boolean debug) {
    this.authUser = authUser;
    this.user = user;
    this.calSuite = calSuite;
    this.envPrefix = envPrefix;
    this.publicAdmin = publicAdmin;
    this.caldav = caldav;
    this.synchId = synchId;
    this.debug = debug;
  }

  /**
   * @return String auth user
   */
  public String getAuthUser() {
    return authUser;
  }

  /**
   * @param val String user to run as
   */
  public void setUser(String  val) {
    user = val;
  }

  /**
   * @return String current user
   */
  public String getUser() {
    return user;
  }

  /**
   * @param val String calSuite
   */
  public void setCalSuite(String  val) {
    calSuite = val;
  }

  /**
   * @return String
   */
  public String getCalSuite() {
    return calSuite;
  }

  /**
   * @param val String envPrefix
   */
  public void setEnvPrefix(String  val) {
    envPrefix = val;
  }

  /**
   * @return String current envPrefix
   */
  public String getEnvPrefix() {
    return envPrefix;
  }

  /**
   * @return boolean true if this is a public admin object.
   */
  public boolean getPublicAdmin() {
    return publicAdmin;
  }

  /**
   * @return boolean true if this is a caldav client..
   */
  public boolean getCaldav() {
    return caldav;
  }

  /**
   * @return String Non-null if this is for synchronization. Identifies the client end.
   */
  public String getSynchId() {
    return synchId;
  }

  /**
   * @return boolean true for debugging on
   */
  public boolean getDebug() {
    return debug;
  }

  /**
   * @return boolean true for guest
   */
  public boolean isGuest() {
    return authUser == null;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("CalSvcIPars{");

    sb.append("authUser=");
    sb.append(getAuthUser());
    sb.append(", user=");
    sb.append(getUser());
    sb.append(", calSuite=");
    sb.append(getCalSuite());
    sb.append(", publicAdmin=");
    sb.append(getPublicAdmin());
    sb.append(", caldav=");
    sb.append(getCaldav());
    sb.append(", synchid=");
    sb.append(getSynchId());
    sb.append(", debug=");
    sb.append(getDebug());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    CalSvcIPars pars = new CalSvcIPars(getAuthUser(),
                                       getUser(),
                                       getCalSuite(),
                                       getEnvPrefix(),
                                       getPublicAdmin(),
                                       getCaldav(),
                                       getSynchId(),
                                       getDebug());
    return pars;
  }
}
