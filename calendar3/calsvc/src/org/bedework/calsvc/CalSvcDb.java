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

package org.bedework.calsvc;


import org.bedework.calcore.hibernate.HibSession;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.svc.BwPreferences;
import org.bedework.calfacade.svc.BwSubscription;
//import org.bedework.calfacade.svc.BwSubscription;
import org.bedework.calfacade.CalFacadeException;

import java.io.Serializable;

//import org.apache.log4j.Logger;

/** This acts as an interface to the database for more client oriented
 * bedework objects. CalIntf is a more general calendar specific interface.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
class CalSvcDb implements Serializable {
  private CalSvc svci;

  private BwPreferences prefs;

  /** Current user of the system
   */
  private BwUser user;

  //private transient Logger log;

  CalSvcDb(CalSvc svci, BwUser user) {
    this.svci = svci;
    this.user = user;
  }

  /** Call at svci open
   *
   */
  public void open() {
    prefs = null;
  }

  /** Call at svci close
   *
   */
  public void close() {
    prefs = null;
  }

  /* ====================================================================
   *                    User preferences methods
   * ==================================================================== */

  /** Get the preferences for the current user
   *
   * @return the preferences for the current user
   * @throws CalFacadeException
   */
  public BwPreferences getPreferences() throws CalFacadeException {
    if (prefs != null) {
      return prefs;
    }

    prefs = fetchPreferences();

    return prefs;
  }

  /** Fetch the preferences for the current user from the db
   *
   * @return the preferences for the current user
   * @throws CalFacadeException
   */
  public BwPreferences fetchPreferences() throws CalFacadeException {
    return fetchPreferences(user);
  }

  /** Fetch the preferences for the given user from the db
   *
   * @param owner
   * @return the preferences for the current user
   * @throws CalFacadeException
   */
  public BwPreferences fetchPreferences(BwUser owner) throws CalFacadeException {
    HibSession sess = getSess();

    sess.namedQuery("getOwnerPreferences");
    sess.setEntity("owner", owner);
    sess.cacheableQuery();

    return (BwPreferences)sess.getUnique();
  }

  /** Update a preferences object
   *
   * @param val
   * @throws CalFacadeException
   */
  public void updatePreferences(BwPreferences val) throws CalFacadeException {
    getSess().saveOrUpdate(val);
  }

  /** delete a preferences object
   *
   * @param val
   * @throws CalFacadeException
   */
  public void deletePreferences(BwPreferences val) throws CalFacadeException {
    getSess().delete(val);
  }

  /* ====================================================================
   *                  Auth user preferences methods
   * ==================================================================== */

  /* ====================================================================
   *                    Subscription method
   * ==================================================================== */

  /** Fetch the subscription from the db given an id
   *
   * @param id
   * @return the subscription
   * @throws CalFacadeException
   */
  public BwSubscription getSubscription(int id) throws CalFacadeException {
    HibSession sess = getSess();

    StringBuffer sb = new StringBuffer();

    sb.append("from ");
    sb.append(BwSubscription.class.getName());
    sb.append(" sub ");
    sb.append(" where sub.id=:id");

    sess.createQuery(sb.toString());

    sess.setInt("id", id);
    sess.cacheableQuery();

    return (BwSubscription)sess.getUnique();
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  /* Get the current db session
   *
   * @return Object
   */
  private HibSession getSess() throws CalFacadeException {
    return (HibSession)svci.getDbSession();
  }

  /* Get a logger for messages
   * /
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void trace(String msg) {
    getLogger().debug("trace: " + msg);
  }*/
}

