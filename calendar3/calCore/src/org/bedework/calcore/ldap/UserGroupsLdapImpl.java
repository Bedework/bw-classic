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

import org.bedework.calenv.CalOptions;
import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUnimplementedException;
import org.bedework.calfacade.ifs.Groups;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Properties;
import java.util.TreeSet;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;

import org.apache.log4j.Logger;

/** An implementation of Groups which stores the groups in an external ldap
 * directory.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public class UserGroupsLdapImpl implements Groups {
  private LdapConfigProperties props;

  private CallBack cb;

  private transient Logger log;

  public void init(CallBack cb) {
    this.cb = cb;
  }

  /* ===================================================================
   *  The following should not change the state of the current users
   *  group.
   *  =================================================================== */

  public Collection getGroups(BwPrincipal val) throws CalFacadeException {
    return getGroups(getProps(), val);
  }

  public Collection getAllGroups(BwPrincipal val) throws CalFacadeException {
    Collection groups = getGroups(getProps(), val);
    Collection allGroups = new TreeSet(groups);

    Iterator it = groups.iterator();
    while (it.hasNext()) {
      BwGroup grp = (BwGroup)it.next();

      Collection gg = getAllGroups(grp);
      if (!gg.isEmpty()) {
        allGroups.addAll(gg);
      }
    }

    return allGroups;
  }

  /** Show whether user entries can be modified with this
   * class. Some sites may use other mechanisms.
   *
   * @return boolean    true if group maintenance is implemented.
   */
  public boolean getGroupMaintOK() {
    return false;
  }

  public Collection getAll(boolean populate) throws CalFacadeException {
    Collection gs = getGroups(getProps(), null);

    if (!populate) {
      return gs;
    }

    Iterator it = gs.iterator();
    while (it.hasNext()) {
      getMembers((BwGroup)it.next());
    }

    return gs;
  }

  public void getMembers(BwGroup group) throws CalFacadeException {
    getGroupMembers(getProps(), group);
  }

  /* ====================================================================
   *  The following are available if group maintenance is on.
   * ==================================================================== */

  public void addGroup(BwGroup group) throws CalFacadeException {
    if (findGroup(group.getAccount()) != null) {
      throw new CalFacadeException(CalFacadeException.duplicateAdminGroup);
    }
    throw new CalFacadeUnimplementedException();
  }

  /** Find a group given its name
   *
   * @param  name             String group name
   * @return AdminGroupVO   group object
   * @exception CalFacadeException If there's a problem
   */
  public BwGroup findGroup(String name) throws CalFacadeException {
    return findGroup(getProps(), name);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#addMember(org.bedework.calfacade.BwGroup, org.bedework.calfacade.BwPrincipal)
   */
  public void addMember(BwGroup group, BwPrincipal val) throws CalFacadeException {
    BwGroup ag = findGroup(group.getAccount());

    if (ag == null) {
      throw new CalFacadeException("Group " + group + " does not exist");
    }

    /* val must not already be present on any paths to the root.
     * We'll assume the possibility of more than one parent.
     */

    if (!checkPathForSelf(group, val)) {
      throw new CalFacadeException(CalFacadeException.alreadyOnAdminGroupPath);
    }

    /*
    ag.addGroupMember(val);

    BwAdminGroupEntry ent = new BwAdminGroupEntry();

    ent.setGrp(ag);
    ent.setMember(val);

    getSess().save(ent);
    */
    throw new CalFacadeUnimplementedException();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#removeMember(org.bedework.calfacade.BwGroup, org.bedework.calfacade.BwPrincipal)
   */
  public void removeMember(BwGroup group, BwPrincipal val) throws CalFacadeException {
    BwGroup ag = findGroup(group.getAccount());

    if (ag == null) {
      throw new CalFacadeException("Group " + group + " does not exist");
    }

    /*
    ag.removeGroupMember(val);

    sess.namedQuery("findAdminGroupEntry");
    sess.setEntity("grp", group);
    sess.setInt("mbrId", val.getId());

    /* This is what I want to do but it inserts 'true' or 'false'
    sess.setBool("isgroup", (val instanceof BwGroup));
    * /
    if (val instanceof BwGroup) {
      sess.setString("isgroup", "T");
    } else {
      sess.setString("isgroup", "F");
    }

    BwAdminGroupEntry ent = (BwAdminGroupEntry)sess.getUnique();

    if (ent == null) {
      return;
    }

    getSess().delete(ent);
    */
    throw new CalFacadeUnimplementedException();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#removeGroup(org.bedework.calfacade.BwGroup)
   */
  public void removeGroup(BwGroup group) throws CalFacadeException {
    // Remove all group members
    /*
    HibSession sess = getSess();

    sess.namedQuery("removeAllGroupMembers");
    sess.setEntity("gr", group);
    sess.executeUpdate();

    // Remove from any groups

    sess.namedQuery("removeFromAllGroups");
    sess.setInt("mbrId", group.getId());

    /* This is what I want to do but it inserts 'true' or 'false'
    sess.setBool("isgroup", (val instanceof BwGroup));
    * /
    sess.setString("isgroup", "T");
    sess.executeUpdate();

    sess.delete(group);
    */
    throw new CalFacadeUnimplementedException();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#updateGroup(org.bedework.calfacade.svc.BwAdminGroup)
   */
  public void updateGroup(BwGroup group) throws CalFacadeException {
    //getSess().saveOrUpdate(group);
    throw new CalFacadeUnimplementedException();
  }

  private boolean checkPathForSelf(BwGroup group,
                                   BwPrincipal val) throws CalFacadeException {
    if (group.equals(val)) {
      return false;
    }

    /* get all parents of group and try again * /

    HibSession sess = getSess();

    /* Want this
    sess.createQuery("from " + BwAdminGroup.class.getName() + " ag " +
                     "where mbr in elements(ag.groupMembers)");
    sess.setEntity("mbr", val);
    * /

    sess.namedQuery("getGroupParents");
    sess.setInt("grpid", group.getId());

    Collection parents = sess.getList();

    Iterator it = parents.iterator();

    while (it.hasNext()) {
      BwAdminGroup g = (BwAdminGroup)it.next();

      if (!checkPathForSelf(g, val)) {
        return false;
      }
    }

    return true;
    */
    throw new CalFacadeUnimplementedException();
  }

  private InitialLdapContext createLdapInitContext(LdapConfigProperties props)
          throws CalFacadeException {
    Properties env = new Properties();

    // Map all options into the JNDI InitialLdapContext env

    env.setProperty(Context.INITIAL_CONTEXT_FACTORY,
                    props.getInitialContextFactory());

    env.setProperty(Context.SECURITY_AUTHENTICATION,
                    props.getSecurityAuthentication());

    env.setProperty(Context.SECURITY_PROTOCOL,
                    props.getSecurityProtocol());

    env.setProperty(Context.PROVIDER_URL, props.getProviderUrl());

    String protocol = env.getProperty(Context.SECURITY_PROTOCOL);
    String providerURL = env.getProperty(Context.PROVIDER_URL);

    if (providerURL == null) {
      providerURL = "ldap://localhost:" +
      ((protocol != null && protocol.equals("ssl")) ? "389" : "636");
      env.setProperty(Context.PROVIDER_URL, providerURL);
    }

    if (props.getAuthDn() != null) {
      env.setProperty(Context.SECURITY_PRINCIPAL, props.getAuthDn());
      env.put(Context.SECURITY_CREDENTIALS, props.getAuthPw());
    }

    InitialLdapContext ctx = null;

    try {
      ctx = new InitialLdapContext(env, null);
      if (props.getDebug()) {
        trace("Logged into LDAP server, " + ctx);
      }

      return ctx;
    } catch(Throwable t) {
      if (props.getDebug()) {
        error(t);
      }
      throw new CalFacadeException(t);
    }
  }

  /* Search for a group to ensure it exists
   *
   */
  private BwGroup findGroup(LdapConfigProperties props, String groupName)
          throws CalFacadeException {
    InitialLdapContext ctx = null;

    try {
      ctx = createLdapInitContext(props);

      BasicAttributes matchAttrs = new BasicAttributes(true);

      matchAttrs.put(props.getGroupIdAttr(), groupName);

      String[] idAttr = {props.getGroupIdAttr()};

      BwGroup group = null;
      NamingEnumeration response = ctx.search(props.getGroupContextDn(),
                                              matchAttrs, idAttr);
      while (response.hasMore()) {
        SearchResult sr = (SearchResult)response.next();
        Attributes attrs = sr.getAttributes();

        if (group != null) {
          throw new CalFacadeException("org.bedework.ldap.groups.multiple.result");
        }

        group = new BwGroup();
        group.setAccount(groupName);
      }

      return group;
    } catch(Throwable t) {
      if (props.getDebug()) {
        error(t);
      }
      throw new CalFacadeException(t);
    } finally {
      // Close the context to release the connection
      if (ctx != null) {
        closeContext(ctx);
      }
    }
  }

  /* Return all groups for principal == null or all groups for which principal
   * is a member
   *
   */
  private Collection getGroups(LdapConfigProperties props, BwPrincipal principal)
          throws CalFacadeException {
    InitialLdapContext ctx = null;
    String member = null;

    if (principal != null) {
      if (principal instanceof BwUser) {
        member = getUserEntryValue(props, (BwUser)principal);
      } else if (principal instanceof BwGroup) {
        member = getGroupEntryValue(props, (BwGroup)principal);
      }
    }

    try {
      ctx = createLdapInitContext(props);

      BasicAttributes matchAttrs = new BasicAttributes(true);

      if (member != null) {
        matchAttrs.put(props.getGroupMemberAttr(), member);
      }

      String[] idAttr = {props.getGroupIdAttr()};

      ArrayList groups = new ArrayList();
      NamingEnumeration response = ctx.search(props.getGroupContextDn(),
                                              matchAttrs, idAttr);
      while (response.hasMore()) {
        SearchResult sr = (SearchResult)response.next();
        Attributes attrs = sr.getAttributes();

        Attribute nmAttr = attrs.get(props.getGroupIdAttr());
        if (nmAttr.size() != 1) {
          throw new CalFacadeException("org.bedework.ldap.groups.multiple.result");
        }

        BwGroup group = new BwGroup();
        group.setAccount(nmAttr.get(0).toString());

        groups.add(group);
      }

      return groups;
    } catch(Throwable t) {
      if (props.getDebug()) {
        error(t);
      }
      throw new CalFacadeException(t);
    } finally {
      // Close the context to release the connection
      if (ctx != null) {
        closeContext(ctx);
      }
    }
  }

  /* Find members for given group
   *
   */
  private void getGroupMembers(LdapConfigProperties props, BwGroup group)
          throws CalFacadeException {
    InitialLdapContext ctx = null;

    try {
      ctx = createLdapInitContext(props);

      BasicAttributes matchAttrs = new BasicAttributes(true);

      matchAttrs.put(props.getGroupIdAttr(), group.getAccount());

      String[] memberAttr = {props.getGroupMemberAttr()};

      ArrayList mbrs = null;

      boolean beenHere = false;

      NamingEnumeration response = ctx.search(props.getGroupContextDn(),
                                              matchAttrs, memberAttr);
      while (response.hasMore()) {
        SearchResult sr = (SearchResult)response.next();
        Attributes attrs = sr.getAttributes();

        if (beenHere) {
          throw new CalFacadeException("org.bedework.ldap.groups.multiple.result");
        }

        beenHere = true;

        Attribute membersAttr = attrs.get(props.getGroupMemberAttr());
        mbrs = new ArrayList();

        for (int m = 0; m < membersAttr.size(); m ++) {
          mbrs.add(membersAttr.get(m).toString());
        }
      }
      // XXX We need a way to search recursively for groups.

      /* Search for each user in the group */
      String memberContext = props.getGroupMemberContextDn();
      String memberSearchAttr = props.getGroupMemberSearchAttr();
      String[] idAttr = {props.getGroupMemberUserIdAttr(),
                         props.getGroupMemberGroupIdAttr(),
                         "objectclass"};

      Iterator it = mbrs.iterator();
      while (it.hasNext()) {
        String mbr = (String)it.next();
        if (memberContext != null) {
          matchAttrs = new BasicAttributes(true);

          matchAttrs.put(memberSearchAttr, mbr);

          response = ctx.search(memberContext, matchAttrs, idAttr);
        } else {
          response = ctx.search(memberContext, null, idAttr);
        }

        if (response.hasMore()) {
          SearchResult sr = (SearchResult)response.next();
          Attributes attrs = sr.getAttributes();

          Attribute ocsAttr = attrs.get("objectclass");
          String userOc = props.getUserObjectClass();
          String groupOc = props.getGroupObjectClass();
          boolean isGroup = false;

          for (int oci = 0; oci < ocsAttr.size(); oci++) {
            String oc = ocsAttr.get(oci).toString();
            if (userOc.equals(oc)) {
              break;
            }

            if (groupOc.equals(oc)) {
              isGroup = true;
              break;
            }
          }

          if (isGroup) {
            BwGroup groupMbr = new BwGroup();

            Attribute groupAttr = attrs.get(props.getGroupMemberGroupIdAttr());
            if (groupAttr.size() != 1) {
              throw new CalFacadeException("org.bedework.ldap.groups.multiple.result");
            }

            groupMbr.setAccount(groupAttr.get(0).toString());
            group.addGroupMember(groupMbr);
          } else {
            BwUser user = new BwUser();

            Attribute userAttr = attrs.get(props.getGroupMemberUserIdAttr());
            if (userAttr.size() != 1) {
              throw new CalFacadeException("org.bedework.ldap.groups.multiple.result");
            }

            user.setAccount(userAttr.get(0).toString());
            group.addGroupMember(user);
          }
        }
      }
    } catch(Throwable t) {
      if (props.getDebug()) {
        error(t);
      }
      throw new CalFacadeException(t);
    } finally {
      // Close the context to release the connection
      if (ctx != null) {
        closeContext(ctx);
      }
    }

    /* Recursively fetch members of groups that are members. */

    Iterator git = group.iterateGroups();
    while (git.hasNext()) {
      Object o = git.next();
      if (o instanceof BwGroup) {
        getGroupMembers(props, (BwGroup)o);
      }
    }
  }

  /* Return the entry we will find in a group identifying this user
   */
  private String getUserEntryValue(LdapConfigProperties props, BwUser user) {
    return makeUserDn(props, user);
  }

  /* Return the entry we will find in a group identifying this group
   */
  private String getGroupEntryValue(LdapConfigProperties props, BwGroup group) {
    return makeGroupDn(props, group);
  }

  private String makeUserDn(LdapConfigProperties props, BwUser user) {
    return props.getUserDnPrefix() + user.getAccount() +
           props.getUserDnSuffix();
  }

  private String makeGroupDn(LdapConfigProperties props, BwGroup group) {
    return props.getGroupDnPrefix() + group.getAccount() +
           props.getGroupDnSuffix();
  }

  private void closeContext(InitialLdapContext ctx) {
    if (ctx != null) {
      try {
        ctx.close();
      } catch (Throwable t) {}
    }
  }

  private LdapConfigProperties getProps() throws CalFacadeException {
    if (props == null) {
      try {
        props = (LdapConfigProperties)CalOptions.getGlobalProperty("module.user-ldap-group");
      } catch (Throwable t) {
        throw new CalFacadeException(t);
      }
    }
    return props;
  }

  /* Get a logger for messages
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void error(Throwable t) {
    getLogger().error(this, t);
  }

  protected void trace(String msg) {
    getLogger().debug(msg);
  }
}