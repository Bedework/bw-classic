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

import org.bedework.calfacade.BwEventProperty;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.Calintf;

import java.util.Collection;

/** Class which handles manipulation of BwEventProperty subclasses which are
 * treated in the same manner, these being Category, Location and Sponsor.
 *
 * <p>Each has a single field which together with the owner makes a unique
 * key and all operations on those classes are the same.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
/**
 * @author douglm
 *
 */
public class EventProperties extends CalintfHelper {
  private String keyFieldName;

  private String className;

  /* Named query to get refs */
  private String refQuery;

  /* if >= 0 we limit retrievals to ids gretaer than this. */
  private int minId;

  /** Constructor
   *
   * @param cal           Calintf object
   * @param access
   * @param user
   * @param keyFieldName  Name of entity keyfield
   * @param className     Class of entity
   * @param refQuery      Name of query which returns referring event ids
   * @param minId         if >= 0 we limit retrievals to ids gretaer than this
   * @param debug
   */
  public EventProperties(Calintf cal, AccessUtil access, BwUser user,
                         String keyFieldName,
                         String className,
                         String refQuery,
                         int minId,
                         boolean debug) {
    super(cal, access, user, debug);

    this.keyFieldName = keyFieldName;
    this.className = className;
    this.refQuery = refQuery;
    this.minId = minId;
  }

  /** Return all entities satisfying the conditions.
   *
   * <p>Returns an empty collection for none.
   *
   * <p>The returned objects may not be persistant objects but the result of a
   * report query.
   *
   * @param  owner          non-null means limit to this
   * @param  creator        non-null means limit to this
   * @return Collection     of objects
   * @throws CalFacadeException
   */
  public Collection get(BwUser owner, BwUser creator) throws CalFacadeException {
    /* Use a report query to try to prevent the appearance of a lot of
       persistent objects we don't need.

       This isn't too good. If we change fields we'll need to change this.
       We could use reflection - we could use persistent objects if it
       doesn't mean the reappearance of the non-unique object problem.
    * /
    StringBuffer qstr = new StringBuffer("select new ");
    qstr.append(className);
    qstr.append("(ent.id, ent.creator, ent.owner, ent.access, ent.publick, " +
                 "ent.address, ent.subaddress, ent.link) ");

    qstr.append("from ");
    */

    HibSession sess = getSess();

    StringBuffer qstr = new StringBuffer("from ");
    qstr.append(className);
    qstr.append(" ent where ");
    if (owner != null) {
      qstr.append(" ent.owner=:owner");
    }

    if (creator != null) {
      if (owner != null) {
        qstr.append(" and ");
      }
      qstr.append(" ent.creator=:creator");
    }

    if (minId >= 0) {
      qstr.append(" and ent.id>=");
      qstr.append(minId);
    }

    qstr.append(" order by ent.");
    qstr.append(keyFieldName);

    sess.createQuery(qstr.toString());

    if (owner != null) {
      sess.setEntity("owner", owner);
    }

    if (creator != null) {
      sess.setEntity("creator", creator);
    }

    return sess.getList();
  }

  /** Return an entity with the given id
   *
   * @param id            int id of the entity
   * @param currentMode   mode we are in (guest etc)
   * @param ignoreCreator true if we ignore creator
   * @return BwEventProperty object representing the entity in question
   *                     null if it doesn't exist.
   * @throws CalFacadeException
   */
  public BwEventProperty get(int id,
                             int currentMode,
                             boolean ignoreCreator) throws CalFacadeException {
    HibSession sess = getSess();

    StringBuffer qstr = new StringBuffer("from ");
    qstr.append(className);
    qstr.append(" ent where ");
    boolean setUser = CalintfUtil.appendPublicOrCreatorTerm(qstr, "ent",
                                      currentMode, ignoreCreator);
    qstr.append(" and ent.id=:id");

    sess.createQuery(qstr.toString());

    sess.setInt("id", id);

    if (setUser) {
      sess.setEntity("user", cal.getUser());
    }

    return (BwEventProperty)sess.getUnique();
  }

  /** Return an entity matching the given keyfelds or null.
   *
   * @param keyVal       String key field value
   * @param owner        BwUser owner
   * @return BwEventProperty object representing the entity in question
   *                     null if it doesn't exist.
   * @throws CalFacadeException
   */
  public BwEventProperty find(String keyVal, BwUser owner)
          throws CalFacadeException {
    if (keyVal == null) {
      throw new CalFacadeException("Missing key value");
    }

    if (owner == null) {
      throw new CalFacadeException("Missing owner value");
    }

    HibSession sess = getSess();

    StringBuffer qstr = new StringBuffer("from ");
    qstr.append(className);
    qstr.append(" ent where ent.");
    qstr.append(keyFieldName);
    qstr.append("=:keyval and ent.owner=:owner");

    sess.createQuery(qstr.toString());

    sess.setString("keyval", keyVal);
    sess.setEntity("owner", owner);

    return (BwEventProperty)sess.getUnique();
  }

  /** Add an entity to the database. The id will be set in the parameter
   * object.
   *
   * @param val   BwEventProperty object to be added
   * @throws CalFacadeException
   */
  public void add(BwEventProperty val) throws CalFacadeException {
    if ((val.getCreator() == null) ||
        (val.getOwner() == null)) {
      throw new CalFacadeException("Owner and creator must be set");
    }

    getSess().save(val);
  }

  /** Update an entity in the database.
   *
   * @param val   BwEventProperty object to be updated
   * @throws CalFacadeException
   */
  public void update(BwEventProperty val) throws CalFacadeException {
    if ((val.getCreator() == null) ||
        (val.getOwner() == null)) {
      throw new CalFacadeException("Owner and creator must be set");
    }

    getSess().saveOrUpdate(val);
  }

  /** Delete an entity
   *
   * @param val      BwEventProperty object to be deleted
   * @throws CalFacadeException
   */
  public void delete(BwEventProperty val) throws CalFacadeException {
    getSess().delete(val);
  }

  /** Return ids of events referencing the given entity
   *
   * @param val      BwEventProperty object to be checked
   * @return Collection of Integer
   * @throws CalFacadeException
   */
  public Collection getRefs(BwEventProperty val) throws CalFacadeException {
    HibSession sess = getSess();

    sess.namedQuery(refQuery);
    sess.setEntity("ent", val);

    Collection refs = sess.getList();

    if (debug) {
      trace(" ----------- count = " + refs.size());
      if (refs.size() > 0) {
        trace(" ---------- first el class is " + refs.iterator().next().getClass().getName());
      }
    }

    return refs;
  }
}

