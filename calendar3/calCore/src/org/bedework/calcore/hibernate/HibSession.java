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

import org.bedework.calfacade.CalFacadeException;

import org.hibernate.Criteria;
import org.hibernate.FlushMode;
import org.hibernate.LockMode;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SQLQuery;
import org.hibernate.ReplicationMode;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import java.io.Serializable;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import org.apache.log4j.Logger;

/** Convenience class to do the actual hibernate interaction. Intended for
 * one use only.
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class HibSession {
  transient Logger log;

  Session sess;
  Transaction tx;

  Query q;
  Criteria crit;

  /** Exception from this session. */
  Throwable exc;

  /** Set up for a hibernate interaction. Throw the object away on exception.
   *
   * @param sessFactory
   * @param log
   * @throws CalFacadeException
   */
  public HibSession(SessionFactory sessFactory,
                    Logger log) throws CalFacadeException {
    try {
      this.log = log;
      sess = sessFactory.openSession();
      sess.setFlushMode(FlushMode.COMMIT);
//      tx = sess.beginTransaction();
    } catch (Throwable t) {
      exc = t;
      tx = null;  // not even started. Should be null anyway
      close();
    }
  }

  /**
   * @return boolean true if open
   * @throws CalFacadeException
   */
  public boolean isOpen() throws CalFacadeException {
    try {
      return sess.isOpen();
    } catch (Throwable t) {
      handleException(t);
      return false;
    }
  }

  /** Clear a session
   *
   * @throws CalFacadeException
   */
  public void clear() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.clear();
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Reconnect a session
   *
   * @throws CalFacadeException
   */
  public void reconnect() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.reconnect();
//      tx = sess.beginTransaction();
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Disconnect a session
   *
   * @throws CalFacadeException
   */
  public void disconnect() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      if (exc instanceof CalFacadeException) {
        throw (CalFacadeException)exc;
      }
      throw new CalFacadeException(exc);
    }

    try {
      sess.disconnect();
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Get the connection
   *
   * @return Connection
   * @throws CalFacadeException
   */
  public Connection connection() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      return sess.connection();
    } catch (Throwable t) {
      exc = t;
      throw new CalFacadeException(t);
    }
  }

  /** set the flushmode
   *
   * @param val
   * @throws CalFacadeException
   */
  public void setFlushMode(FlushMode val) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      if (tx != null) {
        throw new CalFacadeException("Transaction already started");
      }

      sess.setFlushMode(val);
    } catch (Throwable t) {
      exc = t;
      throw new CalFacadeException(t);
    }
  }

  /** Begin a transaction
   *
   * @throws CalFacadeException
   */
  public void beginTransaction() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      if (tx != null) {
        throw new CalFacadeException("Transaction already started");
      }

      tx = sess.beginTransaction();
    } catch (Throwable t) {
      exc = t;
      throw new CalFacadeException(t);
    }
  }

  /** Commit a transaction
   *
   * @throws CalFacadeException
   */
  public void commit() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      if (tx != null &&
          !tx.wasCommitted() &&
          !tx.wasRolledBack()) {
        tx.commit();
      }

      tx = null;
    } catch (Throwable t) {
      exc = t;
      throw new CalFacadeException(t);
    }
  }

  /** Rollback a transaction
   *
   * @throws CalFacadeException
   */
  public void rollback() throws CalFacadeException {
/*    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }
*/
    Logger log = getLogger();

    if (log.isDebugEnabled()) {
      log.debug("Enter rollback");
    }
    try {
      if (tx != null &&
          !tx.wasCommitted() &&
          !tx.wasRolledBack()) {
        if (log.isDebugEnabled()) {
          log.debug("About to rollback");
        }
        tx.rollback();
      }

      tx = null;
    } catch (Throwable t) {
      exc = t;
      throw new CalFacadeException(t);
    }
  }

  /** Create a Criteria ready for the additon of Criterion.
   *
   * @param cl           Class for criteria
   * @return Criteria    created Criteria
   * @throws CalFacadeException
   */
  public Criteria createCriteria(Class cl) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      crit = sess.createCriteria(cl);
      q = null;

      return crit;
    } catch (Throwable t) {
      handleException(t);
      return null;  // Don't get here
    }
  }

  /** Evict an object from the session.
   *
   * @param val          Object to evict
   * @throws CalFacadeException
   */
  public void evict(Object val) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.evict(val);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Create a query ready for parameter replacement or execution.
   *
   * @param s             String hibernate query
   * @throws CalFacadeException
   */
  public void createQuery(String s) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q = sess.createQuery(s);
      crit = null;
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Create a sql query ready for parameter replacement or execution.
   *
   * @param s             String hibernate query
   * @param returnAlias
   * @param returnClass
   * @throws CalFacadeException
   */
  public void createSQLQuery(String s, String returnAlias, Class returnClass)
        throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      SQLQuery sq = sess.createSQLQuery(s);
      sq.addEntity(returnAlias, returnClass);

      q = sq;
      crit = null;
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Create a named query ready for parameter replacement or execution.
   *
   * @param name         String named query name
   * @throws CalFacadeException
   */
  public void namedQuery(String name) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q = sess.getNamedQuery(name);
      crit = null;
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Mark the query as cacheable
   *
   * @throws CalFacadeException
   */
  public void cacheableQuery() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q.setCacheable(true);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      String parameter value
   * @throws CalFacadeException
   */
  public void setString(String parName, String parVal) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q.setString(parName, parVal);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      Date parameter value
   * @throws CalFacadeException
   */
  public void setDate(String parName, Date parVal) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      // Remove any time component
      java.sql.Date dt = java.sql.Date.valueOf(
          new SimpleDateFormat("yyyy-MM-dd").format(parVal));
      q.setDate(parName, dt);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      boolean parameter value
   * @throws CalFacadeException
   */
  public void setBool(String parName, boolean parVal) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q.setBoolean(parName, parVal);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      int parameter value
   * @throws CalFacadeException
   */
  public void setInt(String parName, int parVal) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q.setInteger(parName, parVal);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      long parameter value
   * @throws CalFacadeException
   */
  public void setLong(String parName, long parVal) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q.setLong(parName, parVal);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      Object parameter value
   * @throws CalFacadeException
   */
  public void setEntity(String parName, Object parVal) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q.setEntity(parName, parVal);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      Object parameter value
   * @throws CalFacadeException
   */
  public void setParameter(String parName, Object parVal) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      q.setParameter(parName, parVal);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Return the single object resulting from the query.
   *
   * @return Object          retrieved object or null
   * @throws CalFacadeException
   */
  public Object getUnique() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      if (q != null) {
        return q.uniqueResult();
      }

      return crit.uniqueResult();
    } catch (Throwable t) {
      handleException(t);
      return null;  // Don't get here
    }
  }

  /** Return a list resulting from the query.
   *
   * @return List          list from query
   * @throws CalFacadeException
   */
  public List getList() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      List l;
      if (q != null) {
        l = q.list();
      } else {
        l = crit.list();
      }

      if (l == null) {
        return new Vector();
      }

      return l;
    } catch (Throwable t) {
      handleException(t);
      return null;  // Don't get here
    }
  }

  /**
   * @return int number updated
   * @throws CalFacadeException
   */
  public int executeUpdate() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      if (q == null) {
        throw new CalFacadeException("No query for execute update");
      }

      return q.executeUpdate();
    } catch (Throwable t) {
      handleException(t);
      return 0;  // Don't get here
    }
  }


  /** Update an object which may have been loaded in a previous hibernate
   * session
   *
   * @param obj
   * @throws CalFacadeException
   */
  public void update(Object obj) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.update(obj);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Save a new object or update an object which may have been loaded in a
   * previous hibernate session
   *
   * @param obj
   * @throws CalFacadeException
   */
  public void saveOrUpdate(Object obj) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.saveOrUpdate(obj);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Copy the state of the given object onto the persistent object with the
   * same identifier. If there is no persistent instance currently associated
   * with the session, it will be loaded. Return the persistent instance.
   * If the given instance is unsaved or does not exist in the database,
   * save it and return it as a newly persistent instance. Otherwise, the
   * given instance does not become associated with the session.
   *
   * @param obj
   * @return Object
   * @throws CalFacadeException
   */
  public Object saveOrUpdateCopy(Object obj) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      return sess.merge(obj);
    } catch (Throwable t) {
      handleException(t);
      return null;  // Don't get here
    }
  }

  /** Return an object of the given class with the given id if it is
   * already associated with this session. This must be called for specific
   * key queries or we can get a NonUniqueObjectException later.
   *
   * @param  cl    Class of the instance
   * @param  id    A serializable key
   * @return Object
   * @throws CalFacadeException
   */
  public Object get(Class cl, Serializable id) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      return sess.get(cl, id);
    } catch (Throwable t) {
      handleException(t);
      return null;  // Don't get here
    }
  }

  /** Return an object of the given class with the given id if it is
   * already associated with this session. This must be called for specific
   * key queries or we can get a NonUniqueObjectException later.
   *
   * @param  cl    Class of the instance
   * @param  id    int key
   * @return Object
   * @throws CalFacadeException
   */
  public Object get(Class cl, int id) throws CalFacadeException {
    return get(cl, new Integer(id));
  }

  /** Save a new object.
   *
   * @param obj
   * @throws CalFacadeException
   */
  public void save(Object obj) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.save(obj);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Save a new object with the given id. This should only be used for
   * restoring the db from a save or for assigned keys.
   *
   * @param obj
   * @param id
   * @throws CalFacadeException
   */
  public void save(Object obj, Serializable id) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.save(obj, id);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Delete an object
   *
   * @param obj
   * @throws CalFacadeException
   */
  public void delete(Object obj) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.delete(obj);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /** Save a new object with the given id. This should only be used for
   * restoring the db from a save.
   *
   * @param obj
   * @throws CalFacadeException
   */
  public void restore(Object obj) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.replicate(obj, ReplicationMode.IGNORE);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /**
   * @param o
   * @throws CalFacadeException
   */
  public void reAttach(Object o) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.lock(o, LockMode.NONE);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /**
   * @param o
   * @throws CalFacadeException
   */
  public void lockRead(Object o) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.lock(o, LockMode.READ);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /**
   * @param o
   * @throws CalFacadeException
   */
  public void lockUpdate(Object o) throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.lock(o, LockMode.UPGRADE);
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /**
   * @throws CalFacadeException
   */
  public void flush() throws CalFacadeException {
    if (exc != null) {
      // Didn't hear me last time?
      throw new CalFacadeException(exc);
    }

    try {
      sess.flush();
    } catch (Throwable t) {
      handleException(t);
    }
  }

  /**
   * @throws CalFacadeException
   */
  public void close() throws CalFacadeException {
    if (sess == null) {
      return;
    }

//    throw new CalFacadeException("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX");/*
    try {
      if (sess.isDirty()) {
        sess.flush();
      }
      if (tx != null) {
        tx.commit();
      }
    } catch (Throwable t) {
      if (exc == null) {
        exc = t;
      }
    } finally {
      tx = null;
      if (sess != null) {
        try {
          sess.close();
        } catch (Throwable t) {}
      }
    }

    sess = null;
    if (exc != null) {
      throw new CalFacadeException(exc);
    }
//    */
  }

  private void handleException(Throwable t) throws CalFacadeException {
    try {
      Logger log = getLogger();

      if (log.isDebugEnabled()) {
        log.debug("handleException called");
        log.error(this, t);
      }
    } catch (Throwable dummy) {}

    try {
      if (tx != null) {
        try {
          tx.rollback();
        } catch (Throwable t1) {
          rollbackException(t1);
        }
        tx = null;
      }
    } finally {
      try {
        sess.close();
      } catch (Throwable t2) {}
      sess = null;
    }

    exc = t;
    throw new CalFacadeException(t);
  }

  /** This is just in case we want to report rollback exceptions. Seems we're
   * likely to get one.
   *
   * @param t   Throwable from the rollback
   */
  private void rollbackException(Throwable t) {
    Logger log = getLogger();

    if (log.isDebugEnabled()) {
      log.debug("HibSession: ", t);
    }
    log.error(this, t);
  }

  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}
