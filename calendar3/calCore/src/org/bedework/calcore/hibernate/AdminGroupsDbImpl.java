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
package org.bedework.calcore.hibernate;

import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.svc.AdminGroups;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwAdminGroupEntry;

import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

import org.apache.log4j.Logger;

/** An implementation of AdminGroups which stores the groups in the calendar
 * database.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public class AdminGroupsDbImpl implements AdminGroups {
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
    HibSession sess = getSess();

    sess.namedQuery("getAdminGroups");
    sess.setInt("entId", val.getId());

    /* This is what I want to do but it inserts 'true' or 'false'
    sess.setBool("isgroup", (val instanceof BwGroup));
    */
    if (val instanceof BwGroup) {
      sess.setString("isgroup", "T");
    } else {
      sess.setString("isgroup", "F");
    }

    return sess.getList();
  }

  public Collection getAllGroups(BwPrincipal val) throws CalFacadeException {
    Collection groups = getGroups(val);
    Collection allGroups = new TreeSet(groups);

    Iterator it = groups.iterator();
    while (it.hasNext()) {
      BwAdminGroup adgrp = (BwAdminGroup)it.next();
//      BwGroup grp = new BwGroup(adgrp.getAccount());

      Collection gg = getAllGroups(adgrp);
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
    return true;
  }

  public Collection getAll(boolean populate) throws CalFacadeException {
    HibSession sess = getSess();

    sess.namedQuery("getAllAdminGroups");

    Collection gs = sess.getList();

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
    HibSession sess = getSess();

    sess.namedQuery("getGroupUserMembers");
    sess.setEntity("gr", group);

    Collection ms = sess.getList();

    sess.namedQuery("getGroupGroupMembers");
    sess.setEntity("gr", group);

    ms.addAll(sess.getList());

    group.setGroupMembers(ms);
  }

  /* ====================================================================
   *  The following are available if group maintenance is on.
   * ==================================================================== */

  public void addGroup(BwGroup group) throws CalFacadeException {
    if (findGroup(group.getAccount()) != null) {
      throw new CalFacadeException(CalFacadeException.duplicateAdminGroup);
    }
    getSess().save(group);
  }

  /** Find a group given its name
   *
   * @param  name             String group name
   * @return AdminGroupVO   group object
   * @exception CalFacadeException If there's a problem
   */
  public BwGroup findGroup(String name) throws CalFacadeException {
    HibSession sess = getSess();

    sess.createQuery("from " + BwAdminGroup.class.getName() + " ag " +
                     "where ag.account = :account");
    sess.setString("account", name);

    return (BwAdminGroup)sess.getUnique();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#addMember(org.bedework.calfacade.BwGroup, org.bedework.calfacade.BwPrincipal)
   */
  public void addMember(BwGroup group, BwPrincipal val) throws CalFacadeException {
    BwGroup ag = findGroup(group.getAccount());

    if (ag == null) {
      throw new CalFacadeException("Group " + group + " does not exist");
    }

    /*
    if (val instanceof BwUser) {
      ensureAuthUserExists((BwUser)val);
    } else {
      val = findGroup(val.getAccount());
    }
    */

    ag.addGroupMember(val);

    BwAdminGroupEntry ent = new BwAdminGroupEntry();

    ent.setGrp(ag);
    ent.setMember(val);

    getSess().save(ent);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#removeMember(org.bedework.calfacade.BwGroup, org.bedework.calfacade.BwPrincipal)
   */
  public void removeMember(BwGroup group, BwPrincipal val) throws CalFacadeException {
    BwGroup ag = findGroup(group.getAccount());
    HibSession sess = getSess();

    if (ag == null) {
      throw new CalFacadeException("Group " + group + " does not exist");
    }

    ag.removeGroupMember(val);

    //BwAdminGroupEntry ent = new BwAdminGroupEntry();

    //ent.setGrp(ag);
    //ent.setMember(val);

    sess.namedQuery("findAdminGroupEntry");
    sess.setEntity("grp", group);
    sess.setInt("mbrId", val.getId());

    /* This is what I want to do but it inserts 'true' or 'false'
    sess.setBool("isgroup", (val instanceof BwGroup));
    */
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
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#removeGroup(org.bedework.calfacade.BwGroup)
   */
  public void removeGroup(BwGroup group) throws CalFacadeException {
    // Remove all group members
    HibSession sess = getSess();

    sess.namedQuery("removeAllGroupMembers");
    sess.setEntity("gr", group);
    sess.executeUpdate();

    // Remove from any groups

    sess.namedQuery("removeFromAllGroups");
    sess.setInt("mbrId", group.getId());

    /* This is what I want to do but it inserts 'true' or 'false'
    sess.setBool("isgroup", (val instanceof BwGroup));
    */
    sess.setString("isgroup", "T");
    sess.executeUpdate();

    sess.delete(group);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#findGroupByEventOwner(org.bedework.calfacade.BwUser)
   */
  public BwAdminGroup findGroupByEventOwner(BwUser owner)
      throws CalFacadeException {
    HibSession sess = getSess();

    sess.createQuery("from " + BwAdminGroup.class.getName() + " ag " +
                     "where ag.owner = :owner");
    sess.setEntity("owner", owner);

    return (BwAdminGroup)sess.getUnique();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.svc.AdminGroups#updateGroup(org.bedework.calfacade.svc.BwAdminGroup)
   */
  public void updateGroup(BwGroup group) throws CalFacadeException {
    getSess().saveOrUpdate(group);
  }

  /* Ensure the authorised user exists - create an entry if not
   *
   * @param val      BwUser account
   * /
  private void ensureAuthUserExists(BwUser u) throws CalFacadeException {
    UserAuth uauth = cb.getUserAuth();

    BwAuthUser au = uauth.getUser(u.getAccount());

    if ((au != null) && (au.getUsertype() != UserAuth.noPrivileges)) {
      return;
    }

    au = new BwAuthUser(u,
                        UserAuth.publicEventUser,
                        "",
                        "",
                        "",
                        "",
                        "");
    uauth.updateUser(au);
  }

  / * Ensure the user exists - create an entry if not
   *
   * @param val      account name
   * @return UserVO  retrieved userVO entry
   * /
  private BwUser ensureUserExists(String val) throws CalFacadeException {
    BwUser user = cb.getUser(val);

    if (user != null) {
      return user;
    }

    user = new BwUser(val);
    cb.addUser(user);

    return user;
  }*/

  private HibSession getSess() throws CalFacadeException {
    return (HibSession)cb.getDbSession();
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
