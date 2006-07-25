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
package org.bedework.caldav.client.api;

import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.timezones.CalTimezones;
import org.bedework.calsvc.CalSvc;
import org.bedework.calsvci.CalSvcI;
import org.bedework.calsvci.CalSvcIPars;
import org.bedework.icalendar.IcalTranslator;

import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Dur;
import net.fortuna.ical4j.model.ParameterList;
import net.fortuna.ical4j.model.PropertyList;
import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.parameter.TzId;
import net.fortuna.ical4j.model.property.Attendee;
import net.fortuna.ical4j.model.property.Description;
import net.fortuna.ical4j.model.property.DtStart;
import net.fortuna.ical4j.model.property.Duration;
import net.fortuna.ical4j.model.property.Location;
import net.fortuna.ical4j.model.property.Summary;
import net.fortuna.ical4j.model.property.Uid;
import net.fortuna.ical4j.model.property.Url;

import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URI;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import org.hibernate.Hibernate;
import org.hibernate.id.Configurable;
import org.hibernate.id.UUIDHexGenerator;

/** Translate to/from ical. This requires the ability to get timezone info so
 * we use the bedework svci and ical translator.
 *
 * @author Mike Douglass
 */
public class BwIcalTrans {
  private transient UUIDHexGenerator uuidGen;

  private boolean debug;

  private String envPrefix;
  private transient CalSvcI svci;
  private transient IcalTranslator trans;

  /** Constructor
   *
   * @param envPrefix
   * @param debug
   */
  public BwIcalTrans(String envPrefix, boolean debug) {
    this.debug = debug;
  }

  /**
   * @throws CalFacadeException
   */
  public void open() throws CalFacadeException {
    getSvci();
  }

  /** Get all of the timezone ids.
   *
   * @return List  of TimeZoneInfo
   * @throws CalFacadeException
   */
  public List getTimeZoneIds() throws CalFacadeException {
    return svci.getTimeZoneIds();
  }

  /**
   * @return CalTimezones
   * @throws CalFacadeException
   */
  public CalTimezones getTimezones() throws CalFacadeException {
    return svci.getTimezones();
  }

  /**
   * @return TimeZone
   * @throws CalFacadeException
   */
  public TimeZone getDefaultTimeZone() throws CalFacadeException {
    return svci.getTimezones().getDefaultTimeZone();
  }

  /**
   * @param tzid
   * @return TimeZone
   * @throws CalFacadeException
   */
  public TimeZone getTimeZone(String tzid) throws CalFacadeException {
    return svci.getTimezones().getTimeZone(tzid);
  }

  /**
   * @param startDt
   * @param tzid
   * @param duration - int minutes
   * @param summary
   * @param description
   * @param location
   * @param uri  - URI or null
   * @param attendees
   * @return Calendar
   * @throws Throwable
   */
  public Calendar makeMeeting(String startDt,
                              String tzid,
                              int duration,
                              String summary,
                              String description,
                              String location,
                              URI uri,
                              Collection attendees) throws Throwable {
    String guid = getGuid();

    Calendar vcal = IcalTranslator.newIcal();

    VEvent ev = new VEvent();

    vcal.getComponents().add(ev);

    PropertyList props = ev.getProperties();

    TzId tz = new TzId(tzid);
    ParameterList aList = new ParameterList();

    aList.add(tz);

    props.add(new DtStart(aList, startDt));

    props.add(new Duration(new Dur(0, 0, duration, 0)));

    props.add(new Uid(guid));

    if (summary != null) {
      props.add(new Summary(summary));
    }

    if (description != null) {
      props.add(new Description(description));
    }

    if (location != null) {
      props.add(new Location(location));
    }

    if (uri != null) {
      props.add(new Url(uri));
    }

    if (attendees != null) {
      Iterator it = attendees.iterator();
      while (it.hasNext()) {
        String a = (String)it.next();
        Attendee att = new Attendee("MAILTO:" + a);
        props.add(att);
      }
    }

    return vcal;
  }

  /**
   *
   * @throws CalFacadeException
   */
  private void getSvci() throws CalFacadeException {
    if (svci != null) {
      if (!svci.isOpen()) {
        svci.open();
        svci.beginTransaction();
      }

      return;
    }

    svci = new CalSvc();
    /* account is what we authenticated with.
     * user, if non-null, is the user calendar we want to access.
     */
    CalSvcIPars pars = new CalSvcIPars(null, // account,
                                       null, // account,
                                       null, // calSuite,
                                       envPrefix,
                                       false,  // publicAdmin
                                       true,    // caldav
                                       null, // synchId
                                       debug);
    svci.init(pars);

    svci.open();
    svci.beginTransaction();

    trans = new IcalTranslator(svci.getIcalCallback(), debug);
  }

  /**
   * @param in
   * @return Collection
   * @throws Throwable
   */
  public Collection getFreeBusy(Reader in) throws Throwable {
    return trans.fromIcal(null, in);
  }

  /**
   * @param in
   * @return Collection
   * @throws Throwable
   */
  public Collection getFreeBusy(InputStreamReader in) throws Throwable {
    return trans.fromIcal(null, in);
  }

  /**
   * @throws CalFacadeException
   */
  public void close() throws CalFacadeException {
    if ((svci == null) || !svci.isOpen()) {
      return;
    }

    try {
      svci.endTransaction();
    } catch (CalFacadeException cfe) {
      try {
        svci.close();
      } catch (Throwable t1) {
      }
      svci = null;
      throw cfe;
    }

    try {
      svci.close();
    } catch (CalFacadeException cfe) {
      svci = null;
      throw cfe;
    }
  }

  /* ====================================================================
   *                         Private methods
   * ==================================================================== */

  private String getGuid() {
    return "CAL-" + (String)getUuidGen().generate(null, null) +
           "freebusy.bedework.org";
  }

  /* Use the hibernate uid generator */
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
