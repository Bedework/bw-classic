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
package org.bedework.calcore.ldap;

/** This class defines the various properties we need to make a connection
 * and retrieve a group and user information via ldap.
 *
 * @author Mike Douglass
 */
public class LdapConfigProperties {
  private String initialContextFactory = "com.sun.jndi.ldap.LdapCtxFactory";
  private String securityAuthentication = "simple";

  private String securityProtocol = "NONE";

  private String providerUrl;

  private String groupContextDn;

  private String groupIdAttr = "cn";

  private String groupMemberAttr;

  private String groupMemberContextDn;

  private String groupMemberSearchAttr;

  private String groupMemberUserIdAttr = "uid";

  private String groupMemberGroupIdAttr = "cn";

  private String userDnPrefix;

  private String userDnSuffix;

  private String groupDnPrefix;

  private String groupDnSuffix;

  private String userObjectClass = "posixAccount";

  private String groupObjectClass = "groupOfUniqueNames";

  private String authDn;

  private String authPw;

  private boolean debug;

  public void setInitialContextFactory(String val)  {
    initialContextFactory  = val;
  }

  public String getInitialContextFactory()  {
    return initialContextFactory;
  }

  public void setSecurityAuthentication(String val)  {
    securityAuthentication  = val;
  }

  public String getSecurityAuthentication()  {
    return securityAuthentication;
  }

  /** e.g. "ssl"
  *
  * @param val
  */
  public void setSecurityProtocol(String val)  {
    securityProtocol = val;
  }

  /** e.g "ssl"
  *
  * @return String val
  */
  public String getSecurityProtocol()  {
    return securityProtocol;
  }

  /** URL of ldap server
   *
   * @param val
   */
  public void setProviderUrl(String val)  {
    providerUrl = val;
  }

  /** URL of ldap server
   *
   * @return String val
   */
  public String getProviderUrl()  {
    return providerUrl;
  }

  /** Dn we search under for groups e.g. "ou=groups, dc=bedework, dc=org"
   *
   * @param val
   */
  public void setGroupContextDn(String val)  {
    groupContextDn = val;
  }

  /** Dn we search under for groups e.g. "ou=groups, dc=bedework, dc=org"
   *
   * @return String val
   */
  public String getGroupContextDn()  {
    return groupContextDn;
  }

  /** Attribute we search for to get a group
   *
   * @param val
   */
  public void setGroupIdAttr(String val)  {
    groupIdAttr = val;
  }

  /** Attribute we search for to get a group
   *
   * @return String val
   */
  public String getGroupIdAttr()  {
    return groupIdAttr;
  }

  /** Attribute we want back identifying a member
   *
   * @param val
   */
  public void setGroupMemberAttr(String val)  {
    groupMemberAttr = val;
  }

  /** Attribute we want back identifying a member
   *
   * @return String val
   */
  public String getGroupMemberAttr()  {
    return groupMemberAttr;
  }

  /** If non-null we treat the group member entry as a value to search for
   * under this context dn. Otherwise we treat the group member entry as the
   * actual dn.
   *
   * @param val
   */
  public void setGroupMemberContextDn(String val)  {
    groupMemberContextDn = val;
  }

  /** If non-null we treat the group member entry as a value to search for
   * under this context dn. Otherwise we treat the group member entry as the
   * actual dn.
   *
   * @return String val
   */
  public String getGroupMemberContextDn()  {
    return groupMemberContextDn;
  }

  /** If groupMemberContextDn is not null this is the attribute we search
   * for under that dn, otherwise we don't use this value.
   *
   * @param val
   */
  public void setGroupMemberSearchAttr(String val)  {
    groupMemberSearchAttr = val;
  }

  /** If groupMemberContextDn is not null this is the attribute we search
   * for under that dn, otherwise we don't use this value.
   *
   * @return String val
   */
  public String getGroupMemberSearchAttr()  {
    return groupMemberSearchAttr;
  }

  /** Attribute we want back for a member search giving the user account
   *
   * @param val
   */
  public void setGroupMemberUserIdAttr(String val)  {
    groupMemberUserIdAttr = val;
  }

  /** Attribute we want back for a member search giving the user account
   *
   * @return String val
   */
  public String getGroupMemberUserIdAttr()  {
    return groupMemberUserIdAttr;
  }

  /** Attribute we want back for a member search giving the group account
   *
   * @param val
   */
  public void setGroupMemberGroupIdAttr(String val)  {
    groupMemberGroupIdAttr = val;
  }

  /** Attribute we want back for a member search giving the group account
   *
   * @return String val
   */
  public String getGroupMemberGroupIdAttr()  {
    return groupMemberGroupIdAttr;
  }

  /** Prefix for user principal dn
   *
   * @param val
   */
  public void setUserDnPrefix(String val)  {
    userDnPrefix = val;
  }

  /** Prefix for user principal dn
   *
   * @return String val
   */
  public String getUserDnPrefix()  {
    return userDnPrefix;
  }

  /** Suffix for user principal dn
   *
   * @param val
   */
  public void setUserDnSuffix(String val)  {
    userDnSuffix = val;
  }

  /** Prefix for user principal dn
   *
   * @return String val
   */
  public String getUserDnSuffix()  {
    return userDnSuffix;
  }

  /** Prefix for group principal dn
   *
   * @param val
   */
  public void setGroupDnPrefix(String val)  {
    groupDnPrefix = val;
  }

  /** Prefix for group principal dn
   *
   * @return String val
   */
  public String getGroupDnPrefix()  {
    return groupDnPrefix;
  }

  /** Suffix for group principal dn
   *
   * @param val
   */
  public void setGroupDnSuffix(String val)  {
    groupDnSuffix = val;
  }

  /** Prefix for group principal dn
   *
   * @return String val
   */
  public String getGroupDnSuffix()  {
    return groupDnSuffix;
  }

  /** An object class which identifies an entry as a user
   *
   * @param val
   */
  public void setUserObjectClass(String val)  {
    userObjectClass = val;
  }

  /** An object class which identifies an entry as a user
   *
   * @return String val
   */
  public String getUserObjectClass()  {
    return userObjectClass;
  }

  /** An object class which identifies an entry as a group
   *
   * @param val
   */
  public void setGroupObjectClass(String val)  {
    groupObjectClass = val;
  }

  /** An object class which identifies an entry as a user
   *
   * @return String val
   */
  public String getGroupObjectClass()  {
    return groupObjectClass;
  }

  /** If we need an id to authenticate this is it.
   *
   * @param val
   */
  public void setAuthDn(String val)  {
    authDn = val;
  }

  /** If we need an id to authenticate this is it.
   *
   * @return String val
   */
  public String getAuthDn()  {
    return authDn;
  }

  /** If we need an id to authenticate this is the pw.
   *
   * @param val
   */
  public void setAuthPw(String val)  {
    authPw = val;
  }

  /** If we need an id to authenticate this is it.
   *
   * @return String val
   */
  public String getAuthPw()  {
    return authPw;
  }

  /**
   * @param val
   */
  public void setDebug(boolean val)  {
    debug = val;
  }

  /** If we need an id to authenticate this is it.
   *
   * @return String val
   */
  public boolean getDebug()  {
    return debug;
  }
}
