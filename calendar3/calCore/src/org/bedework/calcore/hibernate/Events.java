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

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventAnnotation;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwEventProxy;
import org.bedework.calfacade.BwRecurrenceInstance;
import org.bedework.calfacade.BwSynchState;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calfacade.CoreEventInfo;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.calfacade.ifs.CalTimezones;
import org.bedework.calfacade.ifs.Calintf;
import org.bedework.calfacade.ifs.EventsI;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.icalendar.VEventUtil;

import edu.rpi.cct.uwcal.access.Acl.CurrentAccess;

import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.Date;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.PeriodList;
import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.property.DtStart;

import org.hibernate.Criteria;
import org.hibernate.criterion.Expression;
import org.hibernate.Hibernate;
import org.hibernate.id.Configurable;
import org.hibernate.id.UUIDHexGenerator;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Properties;
import java.util.TreeSet;

/** Class to encapsulate most of what we do with events
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class Events extends CalintfHelper implements EventsI {
  private transient UUIDHexGenerator uuidGen;

  /** Constructor
   *
   * @param cal
   * @param access
   * @param user
   * @param debug
   */
  public Events(Calintf cal, AccessUtil access, 
                int currentMode, boolean debug) {
    super(cal, access, currentMode, debug);
  }

  public Collection getEvent(BwCalendar calendar, String guid, String rid,
                             int recurRetrieval) throws CalFacadeException {
    CoreEventInfo cei = null;
    BwEvent master = null;
    TreeSet ts = new TreeSet();
    HibSession sess = getSess();
    
    /* This (seems) to work as follows:
     * 
     * First try to retrieve the event from the events table.
     * 
     * If not there try the annotations table. If it's there, it's a reference
     * to an event owned by somebody else. Otherwise we drew a blank.
     * 
     * If we want the recurrences and the event is recurring we go on to try to
     * retrieve the rest.
     */

    if (rid == null) {
      // First look in the events table for the master.
      eventQuery(BwEventObj.class, calendar, guid, rid, true);

      /* There should be one only */

      cei = postGetEvent((BwEvent)sess.getUnique(), privRead, noAccessReturnsNull);

      if (cei == null) {
        /* Look for an annotation to that event by the current user.
         */
        eventQuery(BwEventAnnotation.class, calendar, guid, rid, true);
        cei = postGetEvent((BwEvent)sess.getUnique(),
                           privRead, noAccessReturnsNull);

        if (cei != null) {
          cei.setEvent(new BwEventProxy((BwEventAnnotation)cei.getEvent()));
        }
      }
      
      if (cei == null) {
        return ts;
      }
      
      master = cei.getEvent();

      ts.add(cei);
      if ((recurRetrieval == CalFacadeDefs.retrieveRecurMaster) ||
          (!master.getRecurring())) {
        return ts;
      }

      // Fetch all overrrides for this master event.
      /* FIXME Note that master.getOwner() cripples looking for user overrides of
       * the instances.
       *
       * We probably need to be able to fetch overrides by a user of instances
       * owned by another user. For the moment we just use the original
       * overrides - if any
       */
      /*
      eventQuery(BwEventAnnotation.class, guid, rid, seqnum, false);

      Collection ovs = sess.getList();
      Collection overrides = new TreeSet();

      Iterator it = ovs.iterator();
      while (it.hasNext()) {
        BwEventAnnotation override = (BwEventAnnotation)it.next();
        BwEventProxy proxy = (BwEventProxy)postGetEvent(
                             makeProxy(null, override, null,
                                       CalFacadeDefs.retrieveRecurExpanded),
                         privRead, noAccessReturnsNull);
        if (proxy != null) {
          overrides.add(proxy);
        }
      }

      if (recurRetrieval == CalFacadeDefs.retrieveRecurOverrides) {
        // Overrides only - we're done
        ts.addAll(overrides);
        return ts;
      }
      */
      if (recurRetrieval == CalFacadeDefs.retrieveRecurOverrides) {
        eventQuery(BwEventAnnotation.class, calendar, guid, rid, false);

        Collection ovs = sess.getList();
        Collection overrides = new TreeSet();

        Iterator it = ovs.iterator();
        while (it.hasNext()) {
          BwEventAnnotation override = (BwEventAnnotation)it.next();
          cei = makeProxy(null, override, null,
                          CalFacadeDefs.retrieveRecurExpanded);
          if (cei != null) {
            overrides.add(cei);
          }
        }

        ts.addAll(overrides);
        return ts;
      }

      /* We want all instances. Get them and return.
       * Note that the overrides come with the instances.
       */
      StringBuffer sb = new StringBuffer();

      sb.append("from ");
      sb.append(BwRecurrenceInstance.class.getName());
      sb.append(" rec ");
      sb.append(" where rec.master=:master ");

      sess.createQuery(sb.toString());

      sess.setEntity("master", master);

      Collection instances = sess.getList();

      Iterator it = instances.iterator();
      while (it.hasNext()) {
        BwRecurrenceInstance instance = (BwRecurrenceInstance)it.next();
        ts.add(makeProxy(instance, null, null,
                         CalFacadeDefs.retrieveRecurExpanded));
      }

      return ts;
    }

    /* Rid is non-null - look first for an override then for the instance.
     */
    eventQuery(BwEventAnnotation.class, calendar, guid, rid, false);
    BwEventAnnotation override = (BwEventAnnotation)sess.getUnique();

    if (override != null) {
      cei = makeProxy(null, override, null, CalFacadeDefs.retrieveRecurExpanded);
    } else {
      // Look in the recurrences table
      StringBuffer sb = new StringBuffer();

      sb.append("from ");
      sb.append(BwRecurrenceInstance.class.getName());
      sb.append(" rec ");
      sb.append(" where rec.master.guid=:guid ");

      sb.append(" and rec.recurrenceId=:rid ");

      sess.createQuery(sb.toString());

      sess.setString("guid", guid);

      sess.setString("rid", rid);

      BwRecurrenceInstance inst = (BwRecurrenceInstance)sess.getUnique();
      if (inst == null) {
        return ts;
      }

      cei = makeProxy(inst, null, null, CalFacadeDefs.retrieveRecurExpanded);
    }

    if (cei != null) {
      ts.add(cei);
    }

    return ts;
  }

  public CoreEventInfo getEvent(int id) throws CalFacadeException {
    HibSession sess = getSess();
    Criteria cr = sess.createCriteria(BwEventObj.class);

    cr.add(Expression.eq("id", new Integer(id)));

    BwEvent ev = (BwEvent)sess.getUnique();

    return postGetEvent(ev, privRead, noAccessReturnsNull);
  }

  public void addEvent(BwEvent val, 
                       Collection overrides) throws CalFacadeException {
    RecuridTable recurids = null;
    HibSession sess = getSess();

    if ((overrides != null) && (overrides.size() != 0)) {
      if (!val.getRecurring()) {
        throw new CalFacadeException("Master event not recurring");
      }

      recurids = new RecuridTable(overrides);
    }

    assignGuid(val);

    /* The guid must not exist in the same calendar. The above call assigns a guid if
     * one wasn't assigned already. However, the event may have come with a guid
     * (caldav, import, etc) so we need to check here.
     *
     * It also ensures our guid allocation is working OK
     */
    sess.namedQuery("getGuidCountCalendar");
    sess.setEntity("cal", val.getCalendar());
    sess.setString("guid", val.getGuid());

    Collection refs = sess.getList();

    Integer ct = (Integer)refs.iterator().next();
    if (ct.intValue() > 0) {
      throw new CalFacadeException(CalFacadeException.duplicateGuid);
    }
    
    if (val.getOrganizer() != null) {
      sess.saveOrUpdate(val.getOrganizer());
    }

    sess.save(val);

    /** If it's a recurring event see what we can do to optimise searching
     * and retrieval
     */
    if (!val.getRecurring()) {
      return;
    }

    /* Try to create a set of occurrences for the event
       We'll turn it into a VEvent to use the ical4j code.
    */

    VEvent vev = VEventUtil.toIcalEvent(val, null);

    /* Determine the absolute latest date. */
    Date latest = VEventUtil.getLatestRecurrenceDate(vev, debug);

    if (latest == null) {
      /* Unlimited recurrences. No more to do here
       * We could optionally choose to limit these to say 3 years
       */
      return;
    }

    CalTimezones tzs = cal.getTimezones();
    DtStart vstart = vev.getStartDate();

    String stzid = CalFacadeUtil.getTzid(vstart);
    TimeZone stz = null;
    if (stzid != null) {
      stz = tzs.getTimeZone(stzid);
    }

    val.getRecurrence().setLatestDate(tzs.getUtc(latest.toString(), stzid, stz));

    /* Get all the times for this event. - this could be a problem. Need to
       limit the number. Should we do this in chunks, stepping through the
       whole period?
     */

    Date start = vev.getStartDate().getDate();
    PeriodList pl = vev.getConsumedTime(start, latest);
    Iterator it = pl.iterator();
    boolean dateOnly = val.getDtstart().getDateType();

    while (it.hasNext()) {
      Period p = (Period)it.next();

      BwDateTime rstart = new BwDateTime();
      rstart.init(dateOnly, p.getStart().toString(), stzid, tzs);
      BwDateTime rend = new BwDateTime();
      rend.init(dateOnly, p.getEnd().toString(), stzid, tzs);

      BwRecurrenceInstance ri = new BwRecurrenceInstance();


      ri.setDtstart(rstart);
      ri.setDtend(rend);
      ri.setRecurrenceId(ri.getDtstart().getDate());
      ri.setMaster(val);

      if (recurids != null) {
        /* See if we have a recurrence */
        String rid = ri.getRecurrenceId();
        BwEventProxy ov = (BwEventProxy)recurids.get(rid);

        if (ov != null) {
          if (debug) {
            debugMsg("Add override with recurid " + rid);
          }

          addOverride(ov, ri);
          recurids.remove(rid);
        }
      }

      sess.save(ri);
    }

    if (recurids != null) {
      if (recurids.size() != 0) {
        throw new CalFacadeException("Invalid override");
      }
    }

    val.getRecurrence().setExpanded(true);
    sess.saveOrUpdate(val);
  }

  public void updateEvent(BwEvent val) throws CalFacadeException {
    HibSession sess = getSess();
    if (!(val instanceof BwEventProxy)) {
      sess.saveOrUpdate(val);

      if (val.getRecurring()) {
        /* Check the instances and see if any changes need to be made.
         */
        updateRecurrences(val);
      }
      return;
    }

    /* Save the annotation.
     */
    BwEventProxy proxy = (BwEventProxy)val;

    if (!proxy.getRefChanged()) {
      return;
    }

    /* if this is a proxy for a recurrence instance of our own event
       then the recurrence instance should point at this override.
       Otherwise we just update the event annotation.
     */
    BwEventAnnotation override = proxy.getRef();
    if (debug) {
      debugMsg("Update override event " + override);
    }

    BwEvent mstr = override.getTarget();

    while (mstr instanceof BwEventAnnotation) {
      /* XXX The master may itself be an annotated event. We should really
         stop when we get to that point
       */
      /*
      BwEventProxy tempProxy = new BwEventProxy(mstr);
      if (some-condition-holds) {
        break;
      }
      */
      mstr = ((BwEventAnnotation)mstr).getTarget();
    }

    if (mstr.getOwner().equals(getUser()) && mstr.getRecurring()) {
      // Our own and a recurring event - retrieve the instance
      // from the recurrences table
      StringBuffer sb = new StringBuffer();

      sb.append("from ");
      sb.append(BwRecurrenceInstance.class.getName());
      sb.append(" rec ");
      sb.append(" where rec.master=:mstr ");
      sb.append(" and rec.recurrenceId=:rid ");

      sess.createQuery(sb.toString());

      sess.setEntity("mstr", mstr);
      sess.setString("rid", override.getRecurrence().getRecurrenceId());

      BwRecurrenceInstance inst = (BwRecurrenceInstance)sess.getUnique();
      if (inst == null) {
        throw new CalFacadeException("Cannot locate instance for " + mstr +
                                     "with recurrence id " + override.getRecurrence().getRecurrenceId());
      }

      sess.saveOrUpdate(override);
//      sess.flush();
      if (inst.getOverride() == null) {
        inst.setOverride(override);
        sess.saveOrUpdate(inst);
      }
    } else {
      sess.saveOrUpdate(override);
    }

    proxy.setRefChanged(false);
  }

  public DelEventResult deleteEvent(BwEvent val) throws CalFacadeException {
    HibSession sess = getSess();
    DelEventResult der = new DelEventResult(false, 0);

    der.alarmsDeleted = deleteAlarms(val);

    StringBuffer sb = new StringBuffer();

    /* SEG:   delete from recurrences recur where */
    sb.append("delete from ");
    sb.append(BwRecurrenceInstance.class.getName());
    sb.append(" where master=:master");

    sess.createQuery(sb.toString());
    sess.setEntity("master", val);
    sess.executeUpdate();

    /* XXX Cascades don't seem to do the job here - we have to explicitly delete the
       annotations.

       In any case, this won't work if we have a shared event and there are
       annotations to the annotation. We need a field which identifies all
       annotations related to the master i.e. not just a target field but a
       master field.
     */
    sb = new StringBuffer();

    sb.append("from ");
    sb.append(BwEventAnnotation.class.getName());
    sb.append(" where target=:target");

    sess.createQuery(sb.toString());
    sess.setEntity("target", val);

    Collection anns = sess.getList();
    Iterator it = anns.iterator();

    while (it.hasNext()) {
      BwEventAnnotation ann = (BwEventAnnotation)it.next();

      ann.getAttendees().clear();

      sess.delete(ann);
    }

    sess.delete(val);

    /* This event was really deleted so we need to set any synch states to
     * indicate this is the case.
     */
    cal.setSynchState(val, BwSynchState.DELETED);

    der.eventDeleted = true;

    return der;
  }

  public Collection getEvents(BwCalendar calendar, BwFilter filter,
                              BwDateTime startDate, BwDateTime endDate,
                              int recurRetrieval)
          throws CalFacadeException {
    HibSession sess = getSess();
    StringBuffer sb = new StringBuffer();

    if (debug) {
      trace("getEvents for start=" + startDate + " end=" + endDate);
    }

    /* Name of the event in the query */
    final String qevName = "ev";

    Filters flt = new Filters(filter, sb, qevName, debug);

    /* SEG:   from Events ev where */
    sb.append("from ");
    sb.append(BwEvent.class.getName());
    sb.append(" ");
    sb.append(qevName);
    sb.append(" where ");

    /* SEG:   (<date-ranges>) and  */
    if (appendDateTerms(sb, qevName + ".dtstart.date",
                        qevName + ".dtend.date",
                        startDate, endDate)) {
      sb.append(" and ");
    }

    /* Don't retrieve any master records - I guess we might have a choice
       to retrieve any with the dates in the given range
     */
    sb.append(qevName);
    sb.append(".recurring = false and ");

    /* SEG   (    */
    sb.append(" (");

    boolean setUser = doCalendarClause(sb, qevName, calendar,
                                       currentMode, cal.getSuperUser());

    sb.append(") ");

    flt.addWhereFilters();

    sb.append(" order by ");
    sb.append(qevName);
    sb.append(".dtstart.dtval");

    //if (debug) {
    //  trace(sb.toString());
    //}

    sess.createQuery(sb.toString());

    /* XXX Limit result set size - pagination allows something like:
       query.setFirstResult(0);
       query.setMaxResults(10);
       */

    if (startDate != null) {
      sess.setString("fromDate", startDate.getDate());
    }

    if (endDate != null) {
      sess.setString("toDate", endDate.getDate());
    }

    doCalendarEntities(setUser, calendar);

    flt.parPass(sess);

    if (debug) {
      trace(sess.getQueryString());
    }

    Collection ceis = sess.getList();

    if (debug) {
      trace("Found " + ceis.size() + " events");
    }

    ceis = postGetEvents(ceis, privRead, noAccessReturnsNull);

    /** Run the events we got through the filters
     */
    ceis = flt.postExec(ceis);

    Collection rceis = getLimitedRecurrences(calendar, filter, startDate, endDate,
                                             currentMode, cal.getSuperUser(),
                                             recurRetrieval);
    if (rceis != null) {
      ceis.addAll(rceis);
    }

    return ceis;
  }

  public boolean editable(BwEvent val) throws CalFacadeException {
    if (currentMode == CalintfUtil.guestMode) {
      return false;
    }

    if (val.getPublick() != (currentMode == CalintfUtil.publicAdminMode)) {
      return false;
    }

    return getUser().equals(val.getCreator());
  }

  public Collection getEventsByName(BwCalendar cal, String val)
          throws CalFacadeException {
    HibSession sess = getSess();
    sess.namedQuery("eventsByName");
    sess.setString("name", val);
    sess.setEntity("cal", cal);

    Collection evs = sess.getList();

    return postGetEvents(evs, privRead, noAccessReturnsNull);
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  /** Assign a guid to an event. A noop if this event already has a guid.
   *
   * @param val      BwEvent object
   * @throws CalFacadeException
   */
  private void assignGuid(BwEvent val) throws CalFacadeException {
    if (val == null) {
      return;
    }

    String guidPrefix = "CAL-" + (String)getUuidGen().generate(null, null);

    if (val.getName() == null) {
      val.setName(guidPrefix + ".ics");
    }

    if (val.getGuid() != null) {
      return;
    }

    String guid = guidPrefix + cal.getSysid();

    val.setGuid(guid);
  }

  /* Called when adding an event with overrides
   */
  private void addOverride(BwEventProxy proxy,
                           BwRecurrenceInstance inst) throws CalFacadeException {
    BwEventAnnotation override = proxy.getRef();
    override.setOwner(getUser());

    getSess().saveOrUpdate(override);
    inst.setOverride(override);
  }

  /* XXX This is a bit brute force but it will do for the moment. We have to turn a
   * set of rules into a set of changes. If we'd preserved the rules prior to this I
   * guess we could figure out the differences without querying the db.
   *
   * For the moment create a whole set of instances and then query the db to see if
   * they match.
   */
  private void updateRecurrences(BwEvent val) throws CalFacadeException {
    HibSession sess = getSess();
    VEvent vev = VEventUtil.toIcalEvent(val, null);

    /* Determine the absolute latest date. */
    Date latest = VEventUtil.getLatestRecurrenceDate(vev, debug);

    if (latest == null) {
      /* Unlimited recurrences. No more to do here
       * We could optionally choose to limit these to say 3 years
       */
      return;
    }

    CalTimezones tzs = cal.getTimezones();
    DtStart vstart = vev.getStartDate();

    String stzid = CalFacadeUtil.getTzid(vstart);
    TimeZone stz = null;
    if (stzid != null) {
      stz = tzs.getTimeZone(stzid);
    }

    val.getRecurrence().setLatestDate(tzs.getUtc(latest.toString(), stzid, stz));

    /* Get all the times for this event. - this could be a problem. Need to
       limit the number. Should we do this in chunks, stepping through the
       whole period?
     */

    Date start = vev.getStartDate().getDate();
    PeriodList pl = vev.getConsumedTime(start, latest);
    Iterator it = pl.iterator();
    boolean dateOnly = val.getDtstart().getDateType();

    Collection updated = new TreeSet();

    while (it.hasNext()) {
      Period p = (Period)it.next();

      BwDateTime rstart = new BwDateTime();
      rstart.init(dateOnly, p.getStart().toString(), stzid, tzs);
      BwDateTime rend = new BwDateTime();
      rend.init(dateOnly, p.getEnd().toString(), stzid, tzs);

      BwRecurrenceInstance ri = new BwRecurrenceInstance();


      ri.setDtstart(rstart);
      ri.setDtend(rend);
      ri.setRecurrenceId(ri.getDtstart().getDate());
      ri.setMaster(val);

      updated.add(ri);
    }

    StringBuffer sb = new StringBuffer();

    sb.append("from ");
    sb.append(BwRecurrenceInstance.class.getName());
    sb.append(" where master=:master");

    sess.createQuery(sb.toString());
    sess.setEntity("master", val);
    Collection current = sess.getList();

    it = updated.iterator();
    while (it.hasNext()) {
      BwRecurrenceInstance ri = (BwRecurrenceInstance)it.next();

      if (!current.contains(ri)) {
        sess.save(ri);
      }
    }

    it = current.iterator();
    while (it.hasNext()) {
      BwRecurrenceInstance ri = (BwRecurrenceInstance)it.next();

      if (!updated.contains(ri)) {
        sess.delete(ri);
      }
    }
  }

  private void eventQuery(Class cl, BwCalendar calendar, String guid, String rid, 
                          boolean masterOnly) throws CalFacadeException {
    HibSession sess = getSess();
    StringBuffer sb = new StringBuffer();

    /* SEG:   from Events ev where */
    sb.append("from ");
    sb.append(cl.getName());
    sb.append(" ev ");
    sb.append(" where ev.calendar=:cal ");
    sb.append(" and ev.guid=:guid ");

    if (masterOnly) {
      sb.append(" and ev.recurrence.recurrenceId is null ");
    } else if (rid != null) {
      sb.append(" and ev.recurrence.recurrenceId=:rid ");
    }

    sess.createQuery(sb.toString());

    sess.setEntity("cal", calendar);
    sess.setString("guid", guid);

    if (! masterOnly && (rid != null)) {
      sess.setString("rid", rid);
    }

    //debugMsg("Try query " + sb.toString());
  }

  /* Return event recurrences within the given date range and calendar for
   * recurrent events which have been expanded.
   *
   * <p>All parameters may be null implying all events for this object.
   * Start or end or both may be null.<ul>
   * <li>startDate=null,endDate=null means all</li>
   * <li>startDate=null means all less than endDate</li>
   * <li>endDate=null means all including and after startDate</li>
   *
   * @param calendar     BwCalendar object restricting search or null.
   * @param filter       BwFilter object restricting search or null.
   * @param startDate    DateTimeVO start - may be null
   * @param endDate      DateTimeVO end - may be null.
   * @param currentMode
   * @param ignoreCreator
   * @return Collection  of CoreEventInfo objects
   * @throws CalFacadeException
   */
  private Collection getLimitedRecurrences(BwCalendar calendar, BwFilter filter,
                                           BwDateTime startDate, BwDateTime endDate,
                                           int currentMode, boolean ignoreCreator,
                                           int recurRetrieval)
          throws CalFacadeException {
    HibSession sess = getSess();
    StringBuffer sb = new StringBuffer();

    /* Name of the event in the query */
    final String qevName = "evr";

    Filters flt = new Filters(filter, sb, qevName + ".master", debug);

    /* SEG:   from recurrences evr where */
    sb.append("from ");
    sb.append(BwRecurrenceInstance.class.getName());
    sb.append(" ");
    sb.append(qevName);
    sb.append(" where ");

    /* SEG:   (<date-ranges>) and
       Note that we store the string version of the date only so this looks different than for
       regular events.

    */
    if (appendDateTerms(sb, qevName + ".dtstart.date",
                        qevName + ".dtend.date",
                        startDate, endDate)) {
      sb.append(" and ");
    }

    /* SEG   (    */
    sb.append(" (");

    boolean setUser = doCalendarClause(sb, qevName + ".master", calendar,
                                       currentMode, ignoreCreator);

    sb.append(") ");

    flt.addWhereFilters();

    sb.append(" order by ");
    sb.append(qevName);
    sb.append(".dtstart.dtval");

    //if (debug) {
    //  debugMsg("recurrences query is " + sb);
    //}

    sess.createQuery(sb.toString());

    if (startDate != null) {
      sess.setString("fromDate", startDate.getDate());
    }

    if (endDate != null) {
      sess.setString("toDate", endDate.getDate());
    }

    doCalendarEntities(setUser, calendar);

    flt.parPass(sess);

    Collection rs = sess.getList();

    //if (debug) {
    //  debugMsg("recurrences query found " + rs.size());
    //}

    /* We have a collection of recurrence instances, each of which has a
     * master event attached. For each unique master we should check it's
     * validity. We will maintain a table of ids we have checked and the result
     * so we only check once.
     *
     * We also handle the processing of the recurRetrieval parameter here.
     */

    CheckMap checked = new CheckMap();
    TreeSet ceis = new TreeSet();

    Iterator it = rs.iterator();
    while (it.hasNext()) {
      BwRecurrenceInstance inst = (BwRecurrenceInstance)it.next();

      /* XXX should have a list of overrides that cover
       */
      CoreEventInfo cei = makeProxy(inst, null, checked, recurRetrieval);
      if (cei != null) {
        //if (debug) {
        //  debugMsg("Ev: " + proxy);
        //}
        ceis.add(cei);
      }
    }

    //if (debug) {
    //  debugMsg("recurrences after postexec " + evs.size());
    //}

    /** Run the events we got through the filters
     */
    return flt.postExec(ceis);
  }

  private class CalTerm {
    int i = 1;
  }

  /* Append the calendar clauses. Return true if we have to set the user entity
   */
  private boolean doCalendarClause(StringBuffer sb, String qevName, BwCalendar calendar,
                                   int currentMode, boolean ignoreCreator) throws CalFacadeException {
    /* if no calendar set
          if public
            SEG: publicf=true
          else
            SEG: user=?
     */
    if (calendar == null) {
      return CalintfUtil.appendPublicOrCreatorTerm(sb, qevName,
                          currentMode, ignoreCreator);
    }

    if (calendar.getCalendarCollection()) {
      // Single leaf calendar
      sb.append("(");
      sb.append(qevName);
      sb.append(".calendar=:calendar");
      sb.append(") ");
      return false;
    }

    // Non leaf - build a query
    sb.append("(");
    appendCalendarClause(sb, qevName, calendar, new CalTerm());
    sb.append(") ");

    return false;
  }

  private void appendCalendarClause(StringBuffer sb, String qevName, BwCalendar calendar,
                                    CalTerm calTerm) throws CalFacadeException {
    if (calendar.getCalendarCollection()) {
      // leaf calendar
      if (calTerm.i > 1) {
        sb.append(" or ");
      }
      sb.append(qevName);
      sb.append(".calendar=:calendar" + calTerm.i);
      calTerm.i++;
    } else {
      Iterator it = calendar.getChildren().iterator();
      while (it.hasNext()) {
        appendCalendarClause(sb, qevName, (BwCalendar)it.next(), calTerm);
      }
    }
  }

  private void doCalendarEntities(boolean setUser, BwCalendar calendar)
          throws CalFacadeException {
    HibSession sess = getSess();
    if (setUser) {
      sess.setEntity("user", getUser());
    }

    if (calendar != null) {
      if (calendar.getCalendarCollection()) {
        // Single leaf calendar
        sess.setEntity("calendar", calendar);
      } else {
        // Non leaf - add entities
        setCalendarEntities(calendar, new CalTerm());
      }
    }
  }

  private void setCalendarEntities(BwCalendar calendar, CalTerm calTerm)
          throws CalFacadeException {
    if (calendar.getCalendarCollection()) {
      // leaf calendar
      getSess().setEntity("calendar" + calTerm.i, calendar);
      calTerm.i++;
    } else {
      Iterator it = calendar.getChildren().iterator();
      while (it.hasNext()) {
        setCalendarEntities((BwCalendar)it.next(), calTerm);
      }
    }
  }

  /** Check the master for access and if ok build and return an event
   * proxy.
   *
   * <p>If checked is non-null willuse and update the checked map.
   *
   * @param inst        May be null if we retrieved the override
   * @param override    May be null if we retrieved the instance
   * @param checked
   * @return CoreEventInfo
   * @throws CalFacadeException
   */
  private CoreEventInfo makeProxy(BwRecurrenceInstance inst,
                                  BwEventAnnotation override,
                                  CheckMap checked,
                                  int recurRetrieval) throws CalFacadeException {
    BwEvent mstr;
    if (inst != null) {
      mstr = inst.getMaster();
    } else {
      mstr = override.getTarget();
    }

    //int res = 0;
    CurrentAccess ca = null;

    if (checked != null) {
      ca = checked.getca(mstr);
      if ((ca != null) && !ca.accessAllowed) {
        // failed
        return null;
      }
    }

    if ((recurRetrieval == CalFacadeDefs.retrieveRecurMaster) &&
        (checked != null) && (ca != null)) {
      // Master only and we've already seen it - we don't want it again
      return null;
    }

    if ((checked == null) || (ca == null)) {
      // untested
      ca = access.checkAccess(mstr, privRead, noAccessReturnsNull);
      if (checked != null) {
        checked.setChecked(mstr, ca);
      }
      
      if (!ca.accessAllowed) {
        return null;
      }
    }

    if (recurRetrieval == CalFacadeDefs.retrieveRecurMaster) {
      // Master only and we've just seen it for the first time

      /* XXX I think this was wrong. Why make an override?
       */
      // make a fake one pointing at the owners override
      override = new BwEventAnnotation();
      override.setTarget(mstr);
      override.setMaster(mstr);

      BwDateTime start = mstr.getDtstart();
      BwDateTime end = mstr.getDtend();

      override.setDtstart(start);
      override.setDtend(end);
      override.setDuration(BwDateTime.makeDuration(start, end).toString());
      override.setCreator(mstr.getCreator());
      override.setOwner(getUser());

      return new CoreEventInfo(new BwEventProxy(override), ca);
    }

    /* success so now we build a proxy with the event and any override.
     */

    if (override == null) {
      if (recurRetrieval == CalFacadeDefs.retrieveRecurOverrides) {
        // Master and overrides only
        return null;
      }

      /* XXX The instance could point to an overrride if the owner of the event
             changed an instance.
       */
      BwEventAnnotation instOverride = inst.getOverride();
      boolean newOverride = true;

      if (instOverride != null) {
        if (instOverride.getOwner().equals(getUser())) {
          // It's our own override.
          override = instOverride;
          newOverride = false;
        } else {
          // make a fake one pointing at the owners override
          override = new BwEventAnnotation();
          override.setTarget(instOverride);
          override.setMaster(instOverride);
        }
      } else {
        // make a fake one pointing at the master event
        override = new BwEventAnnotation();

        override.setTarget(mstr);
        override.setMaster(mstr);
      }

      if (newOverride) {
        BwDateTime start = inst.getDtstart();
        BwDateTime end = inst.getDtend();

        override.setDtstart(start);
        override.setDtend(end);
        override.setDuration(BwDateTime.makeDuration(start, end).toString());
        override.setCreator(mstr.getCreator());
        override.setOwner(getUser());

        override.getRecurrence().setRecurrenceId(inst.getRecurrenceId());
        override.setRecurrenceChanged(true);
      }
    }

    return new CoreEventInfo(new BwEventProxy(override), ca);
  }

  private static class CheckMap extends HashMap {
    void setChecked(BwEvent ev, CurrentAccess ca) {
      put(new Integer(ev.getId()), ca);
    }

    /* Return null for not found.
     */
    CurrentAccess getca(BwEvent ev) {
      return (CurrentAccess)get(new Integer(ev.getId()));
    }
  }

  /* Just encapsulate the date restrictions.
   * If both dates are null just return. Otherwise return the appropriate
   * terms with the ids: <br/>
   * fromDate    -- first day
   * toDate      -- last day
   *
   * <p>XXX Does this work correctly for datetime types?
   *
   * @return boolean true if we appended something
   */
  private boolean appendDateTerms(StringBuffer sb,
                                  String startField,
                                  String endField,
                                  BwDateTime from, BwDateTime to) {
    if ((from == null) && (to == null)) {
      return false;
    }

    /** Note that the comparisons below are required to ensure that the
     *  start date is inclusive and the end date is exclusive.
     * From CALDAV:
     * A VEVENT component overlaps a given time-range if:
     *
     * (DTSTART <= start AND DTEND > start) OR
     * (DTSTART <= start AND DTSTART+DURATION > start) OR
     * (DTSTART >= start AND DTSTART < end) OR
     * (DTEND   > start AND DTEND <= end)
     * 
     * XXX This is wrong??? Last should be
     * XXX (DTEND   > start AND DTEND < end)
     *
     *  case 1 has the event starting between the dates.
     *  case 2 has the event ending between the dates.
     *  case 3 has the event starting before and ending after the dates.
     */

    if (from == null) {
      sb.append("(");
      sb.append(startField);
      sb.append(" < :toDate)");
      return true;
    }

    if (to == null) {
      sb.append("(");
      sb.append(endField);
      sb.append(" >= :fromDate)");
      return true;
    }

    sb.append("(((");

    sb.append(startField);
    sb.append(" <= :fromDate) and (");
    sb.append(endField);
    sb.append(" > :fromDate)) or ((");

    sb.append(startField);
    sb.append(" >= :fromDate) and (");
    sb.append(startField);
    sb.append(" < :toDate)) or ((");

    // case 3
    /*
    sb.append(endField);
    sb.append(" > :fromDate) and (");
    sb.append(endField);
    sb.append(" <= :toDate)))");
    */
    sb.append(endField);
    sb.append(" > :fromDate) and (");
    sb.append(endField);
    sb.append(" < :toDate)))");

    /*
    (((ev.dtstart.datePart <= :fromDate) and (ev.dtend.datePart > :fromDate)) or
     ((ev.dtstart.datePart >= :fromDate) and (ev.dtstart.datePart < :toDate)) or
     XXX ((ev.dtend.datePart > :fromDate) and (ev.dtend.datePart <= :toDate)))
     ((ev.dtend.datePart >= :fromDate) and (ev.dtend.datePart < :toDate)))
    */
    return true;
  }

  private int deleteAlarms(BwEvent ev) throws CalFacadeException {
    HibSession sess = getSess();
    sess.namedQuery("deleteEventAlarms");
    sess.setEntity("ev", ev);

    return sess.executeUpdate();
  }

  private Collection postGetEvents(Collection evs, int desiredAccess,
                                   boolean nullForNoAccess)
          throws CalFacadeException {
    TreeSet outevs = new TreeSet();

    Iterator it = evs.iterator();

    while (it.hasNext()) {
      CoreEventInfo cei = postGetEvent((BwEvent)it.next(), 
                                       desiredAccess, nullForNoAccess);
      
      if (cei != null) {
        outevs.add(cei);
      }
    }

    return outevs;
  }

  /* Post processing of event. Return null or throw exception for no access
   */
  private CoreEventInfo postGetEvent(BwEvent ev, int desiredAccess,
                                     boolean nullForNoAccess) throws CalFacadeException {
    if (ev == null) {
      return null;
    }

    CurrentAccess ca = access.checkAccess(ev, desiredAccess, nullForNoAccess);
    
    if (!ca.accessAllowed) {
      return null;
    }

    /* XXX-ALARM
    if (currentMode == userMode) {
      ev.setAlarms(getAlarms(ev, user));
    }
    */

    CoreEventInfo cei = new CoreEventInfo(ev, ca);
    
    return cei;
  }

  private class RecuridTable extends HashMap {
    RecuridTable(Collection events) {
      Iterator it = events.iterator();
      while (it.hasNext()) {
        BwEvent ev = (BwEvent)it.next();

        String rid = ev.getRecurrence().getRecurrenceId();
        if (debug) {
          debugMsg("Add override to table with recurid " + rid);
        }

        put(rid, ev);
      }
    }

    BwEvent getEvent(String rid) {
      return (BwEvent)get(rid);
    }
  }

  private UUIDHexGenerator getUuidGen() {
    if (uuidGen != null) {
      return uuidGen;
    }

    Properties uidprops = new Properties();
    uidprops.setProperty("separator", "-");
    uuidGen = new UUIDHexGenerator();
    ((Configurable)uuidGen).configure(Hibernate.STRING, uidprops, null);
    return uuidGen;
  }
}
