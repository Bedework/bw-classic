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
package org.bedework.tools.dumprestore.restore;


import org.bedework.calcore.hibernate.HibSession;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwOrganizer;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwSystem;
import org.bedework.calfacade.BwTimeZone;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.BwUserInfo;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.svc.BwAdminGroup;
import org.bedework.calfacade.svc.BwAdminGroupEntry;
import org.bedework.calfacade.svc.BwAuthUser;
import org.bedework.calfacade.svc.BwPreferences;
import org.bedework.tools.dumprestore.BwDbLastmod;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import java.util.Collection;
import java.util.Iterator;

import org.apache.log4j.Logger;
import org.hibernate.FlushMode;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

/** Class which restores via jdbc.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class HibRestore implements RestoreIntf {
//  private boolean debug;

  private RestoreGlobals globals;

  private HibSession sess;
  private SessionFactory sessFactory;

  private transient Logger log;

  /**
   * @param debug
   */
  public HibRestore(boolean debug) {
    //this.debug = debug;
    log = Logger.getLogger(getClass());
    try {
      sessFactory = new Configuration().configure().buildSessionFactory();
    } catch (Throwable t) {
      log.error("Failed to get session factory", t);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#init(java.lang.String, java.lang.String, java.lang.String, java.lang.String, int, org.bedework.tools.dumprestore.restore.RestoreGlobals)
   */
  public void init(String url,
                   String className,
                   String id,
                   String pw,
                   int dbType,
                   RestoreGlobals globals) throws Throwable {
    this.globals = globals;
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#init(org.bedework.tools.dumprestore.restore.RestoreGlobals)
   */
  public void init(RestoreGlobals globals) throws Throwable {
    this.globals = globals;
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#open()
   */
  public void open() throws Throwable {
    openSess();

    Connection conn = sess.connection();

    PreparedStatement ps = null;

    ps = conn.prepareStatement("SET REFERENTIAL_INTEGRITY FALSE");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from bedework_settings");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from adminGroupMembers");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from adminGroups");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from alarms");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from alarm_attendees");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from attendees");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from auth");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from authprefcalendars");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from authprefCategories");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from authprefLocations");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from authprefs");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from authprefSponsors");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from calendars");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from categories");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from eventrrules");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from events");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from event_attendees");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from event_categories");
    ps.executeUpdate();

    if (globals.from2p3px) {
      ps = conn.prepareStatement("delete from filters");
      ps.executeUpdate();
      ps.close();

      ps = conn.prepareStatement("delete from filter_categories");
      ps.executeUpdate();
      ps.close();

      ps = conn.prepareStatement("delete from filter_creators");
      ps.executeUpdate();
      ps.close();

      ps = conn.prepareStatement("delete from filter_locations");
      ps.executeUpdate();
      ps.close();

      ps = conn.prepareStatement("delete from filter_sponsors");
      ps.executeUpdate();
      ps.close();
    }

    ps = conn.prepareStatement("delete from locations");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from organizers");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from preferences");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from sponsors");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from subscriptions");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from synchdata");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from synchinfo");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from synchstate");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from timezones");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from todos");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from users");
    ps.executeUpdate();
    ps.close();

    ps = conn.prepareStatement("delete from user_subscriptions");
    ps.executeUpdate();
    ps.close();

    if (!globals.from2p3px) {
      ps = conn.prepareStatement("delete from lastmods");
      ps.executeUpdate();
      ps.close();
    }

    ps = conn.prepareStatement("SET REFERENTIAL_INTEGRITY TRUE");
    ps.executeUpdate();
    ps.close();

    closeSess();
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#close()
   */
  public void close() throws Throwable {
    if (sess == null) {
      return;
    }

    try {
      sess.close();
    } catch (Throwable t) {
    }
  }

  public void restoreSyspars(BwSystem o) throws Throwable {
    openSess();

    sess.save(o);

    closeSess();
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#restoreUser(org.bedework.calfacade.BwUser)
   */
  public void restoreUser(BwUser o) throws Throwable {
    openSess();

    sess.save(o, new Integer(o.getId()));

    closeSess();
  }

  /** Restore user info
   *
   * @param o
   * @throws Throwable
   */
  public void restoreUserInfo(BwUserInfo o) throws Throwable {
    openSess();

    sess.save(o);

    closeSess();
  }

  public void restoreTimezone(BwTimeZone o) throws Throwable {
    openSess();

    sess.save(o);

    closeSess();
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#restoreAdminGroup(org.bedework.calfacade.svc.BwAdminGroup)
   */
  public void restoreAdminGroup(BwAdminGroup o) throws Throwable {
    openSess();

    if (globals.from2p3px) {
      // No id assigned
      sess.save(o);
    } else {
      sess.save(o, new Integer(o.getId()));
    }

    log.debug("Saved admin group " + o);

    closeSess();

    /* Save members. */

    Collection c = o.getGroupMembers();
    Iterator it = c.iterator();
    while (it.hasNext()) {
      openSess();

      BwAdminGroupEntry entry = new BwAdminGroupEntry();

      entry.setGrp(o);
      entry.setMember((BwPrincipal)it.next());

      log.debug("About to save " + entry);

      sess.save(entry);

      closeSess();
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#restoreAuthUser(org.bedework.calfacade.svc.BwAuthUser)
   */
  public void restoreAuthUser(BwAuthUser o) throws Throwable {
    openSess();

    sess.save(o);

    closeSess();
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#restoreEvent(org.bedework.calfacade.BwEvent)
   */
  public void restoreEvent(BwEvent o) throws Throwable {
    openSess();

    sess.save(o, new Integer(o.getId()));

    closeSess();
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#update(org.bedework.calfacade.BwEvent)
   */
  public void update(BwEvent o) throws Throwable {
    openSess();

    sess.saveOrUpdate(o);

    closeSess();
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#restoreCategory(org.bedework.calfacade.BwCategory)
   */
  public void restoreCategory(BwCategory o) throws Throwable {
    openSess();

    sess.save(o, new Integer(o.getId()));

    closeSess();
  }

  /* (non-Javadoc)
   * @see org.bedework.tools.dumprestore.restore.RestoreIntf#restoreLocation(org.bedework.calfacade.BwLocation)
   */
  public Integer restoreLocation(BwLocation o) throws Throwable {
    openSess();

    StringBuffer sb = new StringBuffer();
    sb.append("select ent.id from ");
    sb.append(BwLocation.class.getName());
    sb.append(" ent where ent.address=:address and ent.owner=:owner");

    sess.createQuery(sb.toString());
    sess.setString("address", o.getAddress());
    sess.setEntity("owner", o.getOwner());

    Integer i = (Integer)sess.getUnique();

    if (i == null) {
      // no entry with that key

      sess.save(o, new Integer(o.getId()));
    }

    closeSess();

    return i;
  }

  public Integer restoreSponsor(BwSponsor o) throws Throwable {
    openSess();

    StringBuffer sb = new StringBuffer();
    sb.append("select ent.id from ");
    sb.append(BwSponsor.class.getName());
    sb.append(" ent where ent.name=:name and ent.owner=:owner");

    sess.createQuery(sb.toString());
    sess.setString("name", o.getName());
    sess.setEntity("owner", o.getOwner());

    Integer i = (Integer)sess.getUnique();

    if (i == null) {
      // no entry with that key

      sess.save(o, new Integer(o.getId()));
    }

    closeSess();

    return i;
  }

  public void restoreOrganizer(BwOrganizer o) throws Throwable {
    openSess();

    sess.save(o, new Integer(o.getId()));

    closeSess();
  }

  public void restoreFilter(BwFilter o) throws Throwable {
    openSess();

    sess.save(o, new Integer(o.getId()));

    closeSess();
  }

  public void restoreUserPrefs(BwPreferences o) throws Throwable {
    openSess();

    sess.save(o, new Integer(o.getId()));

    closeSess();
  }

  public void update(BwUser user) throws Throwable {
    openSess();

    sess.saveOrUpdate(user);

    closeSess();
  }

  public void restoreDbLastmod(BwDbLastmod o) throws Throwable {
    openSess();

    sess.save(o);

    closeSess();
  }

  public int fixUserEventsCal(BwUser u, BwCalendar cal) throws Throwable {
    /*
    PreparedStatement ps = null;

    try {
      ps = conn.prepareStatement(
            "UPDATE events SET calendarid=? where publicf='F' and creatorid=?");
      ps.setInt(1, cal.getId());
      ps.setInt(2, u.getId());

      int numUpdated = ps.executeUpdate();

      ps = conn.prepareStatement(
            "UPDATE users SET default_calendarid=? where userid=?");
      ps.setInt(1, cal.getId());
      ps.setInt(2, u.getId());

      if (ps.executeUpdate() != 1) {
        throw new Exception("Failed update of user default calendar " + u);
      }

      return numUpdated;
    } finally {
      if (ps != null) {
        ps.close();
      }
    }*/
    return 1;
  }

  /* We cannot use hibernate to set the db id here as the save will cascade
   * down all the children.
   *
   * <p>We save a skeleton copy of the calendar structure using direct jdbc
   * calls then update the structure with hibernate.
   */
  public void restoreCalendars(BwCalendar o) throws Throwable {
    openSess();

    restoreCalendars(o, sess.connection());

    sess.update(o);

    closeSess();
  }

  /* ====================================================================
   *                       Private methods
   * ==================================================================== */

  private void restoreCalendars(BwCalendar val, Connection conn) throws Throwable {
    PreparedStatement ps = null;

    try {
      ps = conn.prepareStatement(
            "INSERT INTO calendars " +
                "(id, seq, creatorid, ownerid, access, " +
                 "publick, name, path, summary, description," +
                 " mail_list_id, calendar_collection, parent) " +
               "VALUES (?,?,?,?,?," +
                       "?,?,?,?,?," +
                       "?,?,?)");

      ps.setInt(1, val.getId());
      ps.setInt(2, val.getSeq());
      ps.setInt(3, val.getCreator().getId());
      ps.setInt(4, val.getOwner().getId());
      ps.setString(5, val.getAccess());

      ps.setString(6, boolVal(val.getPublick()));
      ps.setString(7, val.getName());
      ps.setString(8, val.getPath());
      ps.setString(9, val.getSummary());
      ps.setString(10, val.getDescription());

      ps.setString(11, val.getMailListId());
      ps.setString(12, boolVal(val.getCalendarCollection()));

      if (val.getCalendar() == null) {
        ps.setNull(13, Types.INTEGER);
      } else {
        ps.setInt(13, val.getCalendar().getId());
      }

      ps.executeUpdate();
    } catch (Throwable t) {
      log.error("Exception restoring " + val);
      throw t;
    } finally {
      if (ps != null) {
        ps.close();
      }
    }

    Collection cals = val.getChildren();
    if (cals == null) {
      return;
    }

    Iterator it = cals.iterator();

    while (it.hasNext()) {
      BwCalendar cal = (BwCalendar)it.next();

      restoreCalendars(cal, conn);
    }
  }

  private synchronized void openSess() throws Throwable {
    if (sess == null) {
      sess = new HibSession(sessFactory, log);
      sess.setFlushMode(FlushMode.COMMIT);
    } else {
      sess.reconnect();
    }
    sess.beginTransaction();
  }

  private synchronized void closeSess() throws Throwable {
    sess.commit();
    try {
      if (sess != null) {
        sess.close();
  //      sess.disconnect();
      }
   // } catch (Throwable t) {
      // Discard session if we get errors on close.
//      sess = null;
    } finally {
      sess = null;
    }
  }

  /* Start a (possibly long-running) transaction. In the web environment
   * this might do nothing. The endTransaction method should in some way
   * check version numbers to detect concurrent updates and fail with an
   * exception.
   * /
  private void beginTransaction() throws Throwable {
    sess.beginTransaction();
  }

  / * End a (possibly long-running) transaction. In the web environment
   * this should in some way check version numbers to detect concurrent updates
   * and fail with an exception.
   * /
  public void endTransaction() throws Throwable {
    /* Just commit * /
    sess.commit();
  }*/

  private String boolVal(boolean val) {
    if (val) {
      return "T";
    }

    return "F";
  }
}


