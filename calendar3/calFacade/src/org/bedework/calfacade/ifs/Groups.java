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
package org.bedework.calfacade.ifs;

import org.bedework.calfacade.BwGroup;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;

import java.io.Serializable;
import java.util.Collection;

/** An interface to handle calendar groups.
 *
 * <p>Groups may be stored in a site specific manner so the actual
 * implementation used is a build-time configuration option. They may be
 * ldap directory based or implemented by storing in the calendar database.
 *
 * <p>Methods may throw an unimplemented exception if functions are not
 * available.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 2.2
 */
public interface Groups extends Serializable {

  /** Class to be implemented by caller and passed during init.
   */
  public static abstract class CallBack implements Serializable {
    /**
     * @param account
     * @return BwUser represented by account
     * @throws CalFacadeException
     */
    public abstract BwUser getUser(String account) throws CalFacadeException;

    /**
     * @param id
     * @return BwUser with the given id
     * @throws CalFacadeException
     */
    public abstract BwUser getUser(int id) throws CalFacadeException;

    /** An implementation specific method allowing access to the underlying
     * persistance engine. This may return, for example, a Hibernate session,
     *
     * @return Object    db session
     * @throws CalFacadeException
     */
    public abstract Object getDbSession() throws CalFacadeException;
  }

  /** Provide the callback object
   *
   * @param cb
   * @throws CalFacadeException
   */
  public void init(CallBack cb) throws CalFacadeException;

  /** Return all groups of which the given principal is a member. Never returns null.
   *
   * <p>Does not check the returned groups for membership of other groups.
   *
   * @param val            a principal
   * @return Collection    of BwGroup
   * @throws CalFacadeException
   */
  public Collection getGroups(BwPrincipal val) throws CalFacadeException;

  /** Return all groups of which the given principal is a member. Never returns null.
   *
   * <p>This does check the groups for membership of other groups so the
   * returned collection gives the groups of which the principal is
   * directly or indirectly a member.
   *
   * @param val            a principal
   * @return Collection    of BwGroup
   * @throws CalFacadeException
   */
  public Collection getAllGroups(BwPrincipal val) throws CalFacadeException;

  /** Show whether entries can be modified with this
   * class. Some sites may use other mechanisms.
   *
   * @return boolean    true if group maintenance is implemented.
   */
  public boolean getGroupMaintOK();

  /** Return all groups to which this user has some access. Never returns null.
   *
   * @param  populate      boolean populate with members
   * @return Collection    of BwGroup
   * @throws CalFacadeException
   */
  public Collection getAll(boolean populate) throws CalFacadeException;

  /** Populate the group with a (possibly empty) Collection of members. Does not
   * populate groups which are members.
   *
   * @param  group           BwGroup group object to add
   * @throws CalFacadeException
   */
  public void getMembers(BwGroup group) throws CalFacadeException;

  /* ====================================================================
   *  The following are available if group maintenance is on.
   * ==================================================================== */

  /** Add a group
   *
   * @param  group           BwGroup group object to add
   * @exception CalFacadeException If there's a problem
   */
  public void addGroup(BwGroup group) throws CalFacadeException;

  /** Find a group given its name
   *
   * @param  name           String group name
   * @return BwGroup        group object
   * @exception CalFacadeException If there's a problem
   */
  public BwGroup findGroup(String name) throws CalFacadeException;

  /** Add a principal to a group
   *
   * @param group          a group principal
   * @param val            BwPrincipal new member
   * @exception CalFacadeException   For invalid usertype values.
   */
  public void addMember(BwGroup group, BwPrincipal val) throws CalFacadeException;

  /** Remove a member from a group
   *
   * @param group          a group principal
   * @param val            BwPrincipal new member
   * @exception CalFacadeException   For invalid usertype values.
   */
  public void removeMember(BwGroup group, BwPrincipal val) throws CalFacadeException;

  /** Delete a group
   *
   * @param  group           BwGroup group object to delete
   * @exception CalFacadeException If there's a problem
   */
  public void removeGroup(BwGroup group) throws CalFacadeException;

  /** update a group. This may have no meaning in some directories.
   *
   * @param  group           BwGroup group object to update
   * @exception CalFacadeException If there's a problem
   */
  public void updateGroup(BwGroup group) throws CalFacadeException;
}
