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
package org.bedework.freebusyServer;

import java.io.Serializable;

/** Information about the user (or group) whose free/busy we are querying.
 *
 * <p>For a given target user we need an identifying account, possibly an email
 * address, the host, port and url for the calendar information, and an
 * id and password for an account authorised to read that free/busy.
 *
 * <p>In general the authorised id/pw will not be that of the user whose
 * free/busy we are querying.
 *
 * @author Mike Douglass
 */
public class FBUserInfo implements Comparable, Serializable {
  /* user id for server authentication. May be null if anon ok */
  private String authUser;
  private String authPw;

  /* Whose free busy? */
  private String account;

  private String host;
  private int port;

  private boolean secure;

  private String url;

  /** Constructor
   *
   * @param account -- the key
   * @param authUser
   * @param authPw
   * @param host
   * @param port
   * @param secure
   * @param url
   */
  public FBUserInfo(String account,
                    String authUser,
                    String authPw,
                    String host,
                    int port,
                    boolean secure,
                    String url) {
    this.account = account;
    this.authUser = authUser;
    this.authPw = authPw;
    this.host = host;
    this.port = port;
    this.secure = secure;
    this.url = url;
  }

  /** Constructor
   *
   * @param account -- the key
   */
  public FBUserInfo(String account) {
    this.account = account;
  }

  /**
   * @param val
   */
  public void setAccount(String val) {
    account = val;
  }

  /**
   * @return String
   */
  public String getAccount() {
    return account;
  }

  /**
   * @param val
   */
  public void setAuthUser(String val) {
    authUser = val;
  }

  /**
   * @return String
   */
  public String getAuthUser() {
    return authUser;
  }

  /**
   * @param val
   */
  public void setAuthPw(String val) {
    authPw = val;
  }

  /**
   * @return String
   */
  public String getAuthPw() {
    return authPw;
  }

  /**
   * @param val
   */
  public void setHost(String val) {
    host = val;
  }

  /**
   * @return String
   */
  public String getHost() {
    return host;
  }

  /**
   * @param val
   */
  public void setPort(int val) {
    port = val;
  }

  /**
   * @return int
   */
  public int getPort() {
    return port;
  }

  /**
   * @param val
   */
  public void setSecure(boolean val) {
    secure = val;
  }

  /**
   * @return String
   */
  public boolean getSecure() {
    return secure;
  }

  /**
   * @param val
   */
  public void setUrl(String val) {
    url = val;
  }

  /**
   * @return String
   */
  public String getUrl() {
    return url;
  }

  /* ====================================================================
   *                   Object methods
   * The following are required for a db object.
   * ==================================================================== */

  public int compareTo(Object o) {
    if (o == null) {
      return -1;
    }

    if (!(o instanceof FBUserInfo)) {
      return -1;
    }

    FBUserInfo that = (FBUserInfo)o;

    return getAccount().compareTo(that.getAccount());
  }

  public int hashCode() {
    return getAccount().hashCode();
  }

  /* We always use the compareTo method
   */
  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    return compareTo(obj) == 0;
  }
}
