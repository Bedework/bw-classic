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

import org.bedework.calfacade.base.BwDbentity;

import java.util.Comparator;

/** System settings for an instance of bedework as represented by a single
 * database. These settings may be changed by the super user but most should
 * not be changed after system initialisation..
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class BwSystem extends BwDbentity implements Comparator {
  /* A name for the system */
  private String name;

  /* Default time zone */
  private String tzid;

  /* The system id */
  private String systemid;

  /* Default calendara names */
  private String publicCalendarRoot;
  private String userCalendarRoot;
  private String userDefaultCalendar;
  private String defaultTrashCalendar;
  private String userInbox;
  private String userOutbox;

  private String publicUser;

  private boolean directoryBrowsingDisallowed;

  private int httpConnectionsPerUser;
  private int httpConnectionsPerHost;
  private int httpConnections;

  private String userauthClass;
  private String mailerClass;
  private String admingroupsClass;
  private String usergroupsClass;

  /** Set the system's name
   *
   * @param val    String system name
   */
  public void setName(String val) {
    name = val;
  }

  /** Get the system's name.
   *
   * @return String   system's name
   */
  public String getName() {
    return name;
  }

  /** Set the default tzid
   *
   * @param val    String
   */
  public void setTzid(String val) {
    tzid = val;
  }

  /** Get the default tzid.
   *
   * @return String   tzid
   */
  public String getTzid() {
    return tzid;
  }

  /** Set the default systemid
   *
   * @param val    String
   */
  public void setSystemid(String val) {
    systemid = val;
  }

  /** Get the default systemid.
   *
   * @return String   systemid
   */
  public String getSystemid() {
    return systemid;
  }

  /** Set the public Calendar Root
   *
   * @param val    String
   */
  public void setPublicCalendarRoot(String val) {
    publicCalendarRoot = val;
  }

  /** Get the publicCalendarRoot
   *
   * @return String   publicCalendarRoot
   */
  public String getPublicCalendarRoot() {
    return publicCalendarRoot;
  }

  /** Set the user Calendar Root
   *
   * @param val    String
   */
  public void setUserCalendarRoot(String val) {
    userCalendarRoot = val;
  }

  /** Get the userCalendarRoot
   *
   * @return String   userCalendarRoot
   */
  public String getUserCalendarRoot() {
    return userCalendarRoot;
  }

  /** Set the user default calendar
   *
   * @param val    String
   */
  public void setUserDefaultCalendar(String val) {
    userDefaultCalendar = val;
  }

  /** Get the userDefaultCalendar
   *
   * @return String   userDefaultCalendar
   */
  public String getUserDefaultCalendar() {
    return userDefaultCalendar;
  }

  /** Set the user trash calendar
   *
   * @param val    String
   */
  public void setDefaultTrashCalendar(String val) {
    defaultTrashCalendar = val;
  }

  /** Get the userTrashCalendar
   *
   * @return String   userTrashCalendar
   */
  public String getDefaultTrashCalendar() {
    return defaultTrashCalendar;
  }

  /** Set the user inbox
   *
   * @param val    String
   */
  public void setUserInbox(String val) {
    userInbox = val;
  }

  /** Get the userCalendar
   *
   * @return String   userTrashCalendar
   */
  public String getUserInbox() {
    return userInbox;
  }

  /** Set the user outbox
   *
   * @param val    String
   */
  public void setUserOutbox(String val) {
    userOutbox = val;
  }

  /** Get the userCalendar
   *
   * @return String   userTrashCalendar
   */
  public String getUserOutbox() {
    return userOutbox;
  }

  /** Set the public user
   *
   * @param val    String
   */
  public void setPublicUser(String val) {
    publicUser = val;
  }

  /**
   *
   * @return String
   */
  public String getPublicUser() {
    return publicUser;
  }

  /** Set the directory browsing disallowed
   *
   * @param val    boolean directory browsing disallowed
   */
  public void setDirectoryBrowsingDisallowed(boolean val) {
    directoryBrowsingDisallowed = val;
  }

  /**
   *
   * @return boolean
   */
  public boolean getDirectoryBrowsingDisallowed() {
    return directoryBrowsingDisallowed;
  }

  /** Set the max http connections per user
   *
   * @param val    int max http connections per user
   */
  public void setHttpConnectionsPerUser(int val) {
    httpConnectionsPerUser = val;
  }

  /**
   *
   * @return int
   */
  public int getHttpConnectionsPerUser() {
    return httpConnectionsPerUser;
  }

  /** Set the max http connections per host
   *
   * @param val    int max http connections per host
   */
  public void setHttpConnectionsPerHost(int val) {
    httpConnectionsPerHost = val;
  }

  /**
   *
   * @return int
   */
  public int getHttpConnectionsPerHost() {
    return httpConnectionsPerHost;
  }

  /** Set the max http connections
   *
   * @param val    int max http connections
   */
  public void setHttpConnections(int val) {
    httpConnections = val;
  }

  /**
   *
   * @return int
   */
  public int getHttpConnections() {
    return httpConnections;
  }

  /** Set the userauth class
   *
   * @param val    String userauth class
   */
  public void setUserauthClass(String val) {
    userauthClass = val;
  }

  /**
   *
   * @return String
   */
  public String getUserauthClass() {
    return userauthClass;
  }

  /** Set the mailer class
   *
   * @param val    String mailer class
   */
  public void setMailerClass(String val) {
    mailerClass = val;
  }

  /**
   *
   * @return String
   */
  public String getMailerClass() {
    return mailerClass;
  }

  /** Set the admingroups class
   *
   * @param val    String admingroups class
   */
  public void setAdmingroupsClass(String val) {
    admingroupsClass = val;
  }

  /**
   *
   * @return String
   */
  public String getAdmingroupsClass() {
    return admingroupsClass;
  }

  /** Set the usergroups class
   *
   * @param val    String usergroups class
   */
  public void setUsergroupsClass(String val) {
    usergroupsClass = val;
  }

  /**
   *
   * @return String
   */
  public String getUsergroupsClass() {
    return usergroupsClass;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compare(Object o1, Object o2) {
    if (!(o1 instanceof BwSystem)) {
      return -1;
    }

    if (!(o2 instanceof BwSystem)) {
      return 1;
    }

    if (o1 == o2) {
      return 0;
    }

    BwSystem s1 = (BwSystem)o1;
    BwSystem s2 = (BwSystem)o2;

    return s1.getName().compareTo(s2.getName());
  }

  public int compareTo(Object o2) {
    return compare(this, o2);
  }

  public int hashCode() {
    return getName().hashCode();
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwSystem{");

    toStringSegment(sb);
    sb.append("name=");
    sb.append(getName());
    sb.append("tzid=");
    sb.append(getTzid());
    sb.append("systemid=");
    sb.append(getSystemid());
    sb.append("publicCalendarRoot=");
    sb.append(getPublicCalendarRoot());
    sb.append("userCalendarRoot=");
    sb.append(getUserCalendarRoot());
    sb.append("userDefaultCalendar=");
    sb.append(getUserDefaultCalendar());
    sb.append("defaultTrashCalendar=");
    sb.append(getDefaultTrashCalendar());
    sb.append("userInbox=");
    sb.append(getUserInbox());
    sb.append("userOutbox=");
    sb.append(getUserOutbox());

    sb.append("publicUser=");
    sb.append(getPublicUser());
    sb.append("directoryBrowsingDisallowed=");
    sb.append(getDirectoryBrowsingDisallowed());

    sb.append("httpConnectionsPerUser=");
    sb.append(getHttpConnectionsPerUser());
    sb.append("httpConnectionsPerHost=");
    sb.append(getHttpConnectionsPerHost());
    sb.append("httpConnections=");
    sb.append(getHttpConnections());

    sb.append("userauthClass=");
    sb.append(getUserauthClass());
    sb.append("mailerClass=");
    sb.append(getMailerClass());
    sb.append("admingroupsClass=");
    sb.append(getAdmingroupsClass());
    sb.append("usergroupsClass=");
    sb.append(getUsergroupsClass());

    sb.append("}");

    return sb.toString();
  }
}
