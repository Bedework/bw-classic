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

package edu.rpi.cct.uwcal.synchml.common;

import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwSynchData;
import org.bedework.calfacade.BwSynchInfo;
import org.bedework.calfacade.BwSynchState;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calfacade.svc.EventInfo;
import org.bedework.calsvc.CalSvc;
import org.bedework.calsvci.CalSvcI;
import org.bedework.calsvci.CalSvcIPars;
import org.bedework.icalendar.BwEventUtil;
import org.bedework.icalendar.IcalTranslator;
import org.bedework.icalendar.URIgen;


import net.fortuna.ical4j.model.component.VEvent;

import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.Vector;
import org.apache.log4j.Logger;

/** Class to encapsulate the interactions between a synchronization client
 * and the uwcal suite. There are two sets of methods here, those that work
 * with Ical4j objects and those that work with UWCal objects.
 *
 * <p>There should be one call on init immediately after obtaining the
 * object.
 *
 * <p>Any further interactions must take place between an open and a close
 *
 * @author Mike Douglass    douglm@rpi.edu
 * @author Xavier Lawrence  jahia.org
 */
public class Synchml {
  private boolean debug;

  private CalSvcI svci;

  /** The deviceId identifies the other end of the conversation. This is
   * something of an Syncml term
   */
  private String deviceId;

  private IcalTranslator trans;

  private BwSynchInfo synchInfo;

  private transient Logger log;

  /** Constructor
   *
   * @param account    String authenticated account name
   * @param deviceId   Identifies the client end.
   * @param uriGen     URIgen object used to provide ALTREP values.
   * @param debug      boolean true for some amount of debugging output.
   * @throws CalFacadeException
   */
  public Synchml(String account,
                 String deviceId,
                 URIgen uriGen, boolean debug) throws CalFacadeException {
    svci = new CalSvc();
    this.deviceId = deviceId;
    this.debug = debug;
    CalSvcIPars pars = new CalSvcIPars(account, 
                                       account,
                                       null,     // XXX Requires an env prefix
                                       false,    // public
                                       false,    // caldav
                                       deviceId, // synchId
                                       debug);
    svci.init(pars);

    /** If we were limiting our view to a particular filter we would set that
        now. */

    svci.open();

    try {
      trans = new IcalTranslator(svci.getIcalCallback(), debug);

      synchInfo = svci.getSynchInfo();
      if (synchInfo == null) {
        svci.beginTransaction();
        synchInfo = new BwSynchInfo();
        synchInfo.setUser(svci.getUser());
        synchInfo.setDeviceId(deviceId);
        svci.addSynchInfo(synchInfo);
        svci.endTransaction();
      }
    } finally {
      svci.close();
    }
  }

  /** Signal the start of a sequence of operations. These overlap transactions
   * in that there may be 0 to many transactions started and ended within an
   * open/close call and many open/close calls within a transaction.
   *
   * <p>The open close methods are mainly associated with web style requests
   * and open will usually be called early in the incoming request handling
   * and close will always be called on the way out allowing the interface an
   * opportunity to reacquire (on open) and release (on close) any resources
   * such as connections.
   *
   * @throws CalFacadeException
   */
  public void open() throws CalFacadeException {
    svci.open();
  }

  /** Call on the way out after handling a request..
   *
   * @throws CalFacadeException
   */
  public void close() throws CalFacadeException {
    svci.close();
  }

  /**
   * Starts a transaction on the backend persistent store of the calendar
   * server. This will make sure that all or none of the synchronization
   * updates succeed. If no transaction is required, simply avoid calling
   * this method.
   *
   * @throws CalFacadeException
   */
  public void beginTransaction() throws CalFacadeException {
    svci.beginTransaction();
  }

  /**
   * Commits the current transaction so all modifications to the backend
   * persistent store of the calendar server are made permanent.
   * (Should throw an Exception if no ongoing transaction exists)
   *
   * <p>We also update the synch state tables at this point.
   *
   * @throws CalFacadeException
   */
  public void commit() throws CalFacadeException {
    svci.updateSynchStates();

    if (synchInfo != null) {
      synchInfo.setLastsynch(CalFacadeUtil.isoDateTime(new Date(System.currentTimeMillis())));
      svci.updateSynchInfo(synchInfo);
    }

    svci.endTransaction();
  }

  /** Call if there has been an error during an update process.
   *
   * @throws CalFacadeException
   */
  public void rollbackTransaction() throws CalFacadeException {
    svci.rollbackTransaction();
  }

  /* --------------------------------------------------------------------
     Ical4j object methods
     -------------------------------------------------------------------- */

  /**
   * Returns all the Events associated with this conversation. The data
   * returned will be used for synchronization purposes and thus the state
   * of each event should also be returned.
   *
   * @return Collection of IcalSynchState objects.
   * @throws CalFacadeException
   */
  public Collection getAllVevents() throws CalFacadeException {
    return makeVeventsCollection(getAllEvents(true));
  }

  /**
   * Returns all the changed Events associated with this conversation. The data
   * returned will be used for synchronization purposes and thus the state
   * of each event should also be returned.
   *
   * @return Collection of IcalSynchState objects.
   * @throws CalFacadeException
   */
  public Collection getAllChangedVevents() throws CalFacadeException {
    return makeVeventsCollection(getAllEvents(false));
  }

  /** Updates the event given as parameter using the provided new data.
   *
   * <p>XXX With recurring events and overrides this may not be enough. We
   * probably need to use the same sort of code that caldav does to update
   * events
   *
   * @param val          Updated vevent.
   * @return true        if the update was succesful
   * @throws CalFacadeException
   */
  public boolean updateEvent(VEvent val) throws CalFacadeException {
    // FIXME - We need a subscription to the calendar we are synching - second par
    updateEvent(BwEventUtil.toEvent(svci.getIcalCallback(), null, null, val, debug).getEvent());

    return true;
  }

  /**
   * Deletes the event given as parameter..
   *
   * @param val          vevent defining event to delete.
   * @return true        if the update was succesful
   * @throws CalFacadeException
   */
  public boolean deleteEvent(VEvent val) throws CalFacadeException {
    // FIXME - We need a subscription to the calendar we are synching - second par
    return deleteEvent(BwEventUtil.toEvent(svci.getIcalCallback(), 
                                           null,  // BwCalendar 
                                           null,  // overrides 
                                           val, debug).getEvent());
  }

  /* --------------------------------------------------------------------
     Bedework object methods
     -------------------------------------------------------------------- */

  /**
   * Returns all the Events associated with this conversation. The data
   * returned will be used for synchronization purposes and thus the state
   * of each event should also be returned.
   *
   * @param returnAll   boolean true if we return SYNCHRONIZED also.
   * @return Collection of SynchStateVO objects.
   * @throws CalFacadeException
   */
  public Collection getAllEvents(boolean returnAll) throws CalFacadeException {
    Collection events = svci.getEvents(null, CalFacadeDefs.retrieveRecurMaster);

    if (debug) {
      getLogger().debug("getAllEvents(): svci returned " + events.size());
    }

    Iterator it = events.iterator();
    Vector v = new Vector();

    while (it.hasNext()) {
      EventInfo ei = (EventInfo)it.next();
      BwEvent ev = ei.getEvent();

      BwSynchState ss = svci.getSynchState(ev);
      if (debug) {
        //getLogger().debug("getAllEvents(): ev=" + ev);
        getLogger().debug("getAllEvents(): ss=" + ss);
      }

      if (ss == null) {
        /* This is the only place we add a synch state object. We do so
           because eiher we never synched or the event appeared since we last
           did a synch.
           */
        ss = new BwSynchState();

        ss.setUser(svci.getUser());
        ss.setDeviceId(deviceId);
        ss.setEvent(ev);
        ss.setGuid(ev.getGuid());
        ss.setSynchState(BwSynchState.NEW);

        svci.addSynchState(ss);
      } else if (ss.getSynchState() == BwSynchState.CLIENT_DELETED) {
        // ignore this one
        ss = null;
      } else if (ss.getSynchState() == BwSynchState.CLIENT_DELETED_UNDELIVERED) {
        /* We deliver a deleted state and will set the state to CLIENT_DELETED
         */
        ss.setSynchState(BwSynchState.DELETED);
        ss.setEvent(null);
      } else if ((ss.getSynchState() == BwSynchState.CLIENT_MODIFIED_UNDELIVERED) ||
                 (ss.getSynchState() == BwSynchState.CLIENT_MODIFIED)) {
        if (!returnAll &&
             (ss.getSynchState() == BwSynchState.CLIENT_MODIFIED)) {
          // ignore this one
          ss = null;
        } else {
          if (ss.getSynchState() == BwSynchState.CLIENT_MODIFIED) {
            ss.setSynchState(BwSynchState.SYNCHRONIZED);
          } else {
            /* We deliver a modified state and will set the state to CLIENT_MODIFIED
             */
            ss.setSynchState(BwSynchState.MODIFIED);
          }
          svci.getSynchData(ss);

          BwSynchData synchData = ss.getSynchData();

          if (synchData == null) {
            if (debug) {
              getLogger().debug("No event data present for id " + ev.getId());
            }
            throw new CalFacadeException("No event data present for id " + ev.getId());
          }

          String evData = synchData.getEventData();
          // FIXME - We need a subscription to the calendar we are synching - second par
          Collection c = trans.fromIcal(null, evData);
          if (c.size() != 1) {
            throw new CalFacadeException("Invalid event data: " + evData);
          }

          Iterator eit = c.iterator();
          EventInfo evinfo = (EventInfo)eit.next();

          ss.setEvent(evinfo.getEvent());
        }
      } else {
        /** If the event state is SYNCHRONIZED we look to see if the event
         * is modified by checking the  lastsynch against the event lastmod.
         */
        if (ss.getSynchState() == BwSynchState.SYNCHRONIZED) {
          /** See if the event has been modified since last synch */

          String lastsynch = synchInfo.getLastsynch();
          if ((lastsynch == null) ||
               (lastsynch.compareTo(ev.getLastmod()) <= 0)) {
            if (debug) {
              getLogger().debug("Event modified for id " + ev.getId());
            }

            ss.setSynchState(BwSynchState.MODIFIED);
          }
        }

        if (!returnAll &&
            (ss.getSynchState() == BwSynchState.SYNCHRONIZED)) {
          // Don't return this one.
          ss = null;
        }
      }

      if (ss != null) {
        v.add(ss);
      }
    }

    /** Append any deleted events
     */
    v.addAll(svci.getDeletedSynchStates());

    return v;
  }

  /**
   * Updates the event given as parameter using the provided new data.
   *
   * <p>This method will be called after getNewGuid for a new event.
   *
   * @param val          Updated event.
   * @return true        if the update was succesful
   * @throws CalFacadeException
   */
  public boolean updateEvent(BwEvent val) throws CalFacadeException {
    /** Get the synch state - will add it if it doesn't exist at the moment.
     */
    BwSynchState ss = getSynchState(val);

    /* We should check the access here - for the moment just see if it's
       public
       */
    if (!val.getPublick()) {
      svci.updateEvent(val);
    } else {
      /* Convert to an icalendar string and save it */
      BwSynchData sd = new BwSynchData(ss.getUser(), val.getId(),
                                       trans.toStringIcal(val));

      ss.setSynchData(sd);
      svci.setSynchData(ss);
    }

    return true;
  }

  /** Creates a new event based on the given data.
   *
   * @param val The Object containing event's data
   * @return True if the creation was successful
   * @throws CalFacadeException
   */
  public boolean addEvent(BwEvent val) throws CalFacadeException {
    // FIXME - We need a subscription to the calendar we are synching - first par
    svci.addEvent(null, val, null);

    return true;
  }

  /**
   * Deletes a particular event.
   *
   * @param val     The event to delete
   * @return boolean true if the deletion was successful
   * @throws CalFacadeException
   */
  public boolean deleteEvent(BwEvent val) throws CalFacadeException {
    EventInfo ei = svci.getEvent(val.getId());

    if (ei == null) {
      return false;
    }

    if (ei.getKind() == EventInfo.kindEntry) {
      CalSvcI.DelEventResult der = svci.deleteEvent(ei.getEvent(), true);
      return der.eventDeleted;
    }

    if (ei.getKind() == EventInfo.kindAdded) {
      svci.deleteEvent(ei.getEvent(), true);
    } else if (ei.getKind() == EventInfo.kindUndeletable) {
      svci.deleteSubscribedEvent(ei.getEvent());
    }

    return true;
  }

  /**
   * Find an event given the guid.
   *
   * @param val     The guid - must be non-null
   * @return EventVO if found or null
   * @throws CalFacadeException
   */
  public BwEvent findEvent(String val) throws CalFacadeException {
    // FIXME - We need a subscription (first par) to the calendar (second par)
    Collection eis = svci.getEvent(null, null, val, null, CalFacadeDefs.retrieveRecurMaster);
    if ((eis == null) || (eis.size() == 0)) {
      return null;
    }

    if (eis.size() > 1) {
      throw new CalFacadeException("More than one event returned for guid.");
    }

    EventInfo ei = (EventInfo)eis.iterator().next();

    return ei.getEvent();
  }

  /** Obtain a new guid for an event.
   *
   * <p>The synch process requires a guid for an event which is to be
   * created in advance of the actual data.
   *
   * <p>We will create a dummy event with a 0 start and end date and time.
   *
   * <p>This process only works if we (nearly) always update the newly
   * created event.
   *
   * <p>The event should be flagged as temporary and have its status changed
   * when the data arrives.
   *
   * <p>This could easily be changed by adding a reserveGuid method to svci.
   *
   * @return String guid
   * @throws CalFacadeException
   */
  public String getNewGuid() throws CalFacadeException {
    BwEvent ev = new BwEventObj();

    ev.setDtstart(CalFacadeUtil.getDateTime(new Date(0), false, false,
                                svci.getTimezones()));
    ev.setDtend(CalFacadeUtil.getDateTime(new Date(0), false, false,
                                svci.getTimezones()));
    ev.setSummary("Temp");

    // FIXME - We need a subscription to the calendar we are synching - first par
    svci.addEvent(null, ev, null);

    return ev.getGuid();
  }

  /* --------------------------------------------------------------------
     Convenience methods
     -------------------------------------------------------------------- */

  /** Return the current IcalTranslator
   *
   * @return translator
   */
  public IcalTranslator getTranslator() {
    return trans;
  }

  /* ====================================================================
                       Private methods
     ==================================================================== */

  /*
   * Make a collction of IcalSynchState from a Collection of SynchStateVO
   *
   * @param events    Collection of SynchStateVO
   * @return Collection of IcalSynchState objects.
   * @throws CalFacadeException
   */
  private Collection makeVeventsCollection(Collection events)
          throws CalFacadeException {
    Iterator it = events.iterator();
    Vector v = new Vector();

    while (it.hasNext()) {
      BwSynchState ss = (BwSynchState)it.next();

      IcalSynchState iss = new IcalSynchState();

      iss.setEvent(ss.getEvent());
      iss.setGuid(ss.getGuid());
      iss.setSynchState(ss.getSynchState());
      iss.setUser(ss.getUser());
      iss.setVevent(trans.toIcalEvent(ss.getEvent()));

      v.add(iss);
    }

    return v;
  }

  /* Get a synch state object forthe given event. If one does not exist
   * create it now and set it's state to NEW.
   *
   * <p>This is the only place we add a synch state object. We do so
   * because eiher we never synched or the event appeared since we last
   * did a synch
   *
   * @param ev            EventVO object .
   * @return SynchStateVO object
   */
  private BwSynchState getSynchState(BwEvent ev) throws CalFacadeException {
    BwSynchState ss = svci.getSynchState(ev);

    if (ss != null) {
      return ss;
    }

    ss = new BwSynchState();

    ss.setUser(svci.getUser());
    ss.setDeviceId(deviceId);
    ss.setEvent(ev);
    ss.setGuid(ev.getGuid());
    ss.setSynchState(BwSynchState.NEW);

    svci.addSynchState(ss);

    return ss;
  }

  /* Get a logger for messages
   */
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}


