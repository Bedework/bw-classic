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

package org.bedework.icalendar;

import org.bedework.calfacade.BwAttendee;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwOrganizer;
import org.bedework.calfacade.timezones.CalTimezones;

import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.Date;
import net.fortuna.ical4j.model.DateList;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.parameter.AltRep;
import net.fortuna.ical4j.model.parameter.Cn;
import net.fortuna.ical4j.model.parameter.CuType;
import net.fortuna.ical4j.model.parameter.DelegatedFrom;
import net.fortuna.ical4j.model.parameter.DelegatedTo;
import net.fortuna.ical4j.model.parameter.Dir;
import net.fortuna.ical4j.model.parameter.Language;
import net.fortuna.ical4j.model.parameter.Member;
import net.fortuna.ical4j.model.parameter.PartStat;
import net.fortuna.ical4j.model.parameter.Role;
import net.fortuna.ical4j.model.parameter.Rsvp;
import net.fortuna.ical4j.model.parameter.SentBy;
import net.fortuna.ical4j.model.parameter.Value;
import net.fortuna.ical4j.model.ParameterList;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.property.Attendee;
import net.fortuna.ical4j.model.property.DateListProperty;
import net.fortuna.ical4j.model.property.Organizer;
import net.fortuna.ical4j.model.property.Repeat;
import net.fortuna.ical4j.model.property.Trigger;
import net.fortuna.ical4j.model.PropertyList;

import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

import org.apache.log4j.Logger;

/** Class to provide utility methods for ical4j classes
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class IcalUtil {
  /** Make an organizer
   *
   * @param orgProp
   * @param ev
   * @return BwOrganizer
   * @throws Throwable
   */
  public static BwOrganizer getOrganizer(Organizer orgProp, BwEvent ev)
          throws Throwable {
    BwOrganizer org = new BwOrganizer();

    org.setOwner(ev.getOwner());
    org.setPublick(ev.getPublick());

    org.setOrganizerUri(orgProp.getValue());

    ParameterList pars = orgProp.getParameters();

    org.setCn(IcalUtil.getOptStr(pars, "CN"));
    org.setDir(getOptStr(pars, "DIR"));
    org.setLanguage(getOptStr(pars, "LANGUAGE"));
    org.setSentBy(getOptStr(pars, "SENT-BY"));

    return org;
  }

  /** make an attendee
   *
   * @param val
   * @return Attendee
   * @throws Throwable
   */
  public static Attendee setAttendee(BwAttendee val) throws Throwable {
    Attendee prop = new Attendee(val.getAttendeeUri());

    ParameterList pars = prop.getParameters();

    String temp = val.getCn();
    if (temp != null) {
      pars.add(new Cn(temp));
    }
    temp = val.getCuType();
    if (temp != null) {
      pars.add(new CuType(temp));
    }
    temp = val.getDelegatedFrom();
    if (temp != null) {
      pars.add(new DelegatedFrom(temp));
    }
    temp = val.getDelegatedTo();
    if (temp != null) {
      pars.add(new DelegatedTo(temp));
    }
    temp = val.getDir();
    if (temp != null) {
      pars.add(new Dir(temp));
    }
    temp = val.getLanguage();
    if (temp != null) {
      pars.add(new Language(temp));
    }
    temp = val.getMember();
    if (temp != null) {
      pars.add(new Member(temp));
    }
    temp = val.getRole();
    if (temp != null) {
      pars.add(new Role(temp));
    }
    temp = val.getPartstat();
    if (temp != null) {
      pars.add(new PartStat(temp));
    }
    temp = val.getSentBy();
    if (temp != null) {
      pars.add(new SentBy(temp));
    }

    if (val.getRsvp()) {
      pars.add(Rsvp.TRUE);
    }

    return prop;
  }

  /**
   * @param val
   * @return Organizer
   * @throws Throwable
   */
  public static Organizer setOrganizer(BwOrganizer val) throws Throwable {
    ParameterList pars = new ParameterList();

    String temp = val.getCn();
    if (temp != null) {
      pars.add(new Cn(temp));
    }
    temp = val.getDir();
    if (temp != null) {
      pars.add(new Dir(temp));
    }
    temp = val.getLanguage();
    if (temp != null) {
      pars.add(new Language(temp));
    }
    temp = val.getSentBy();
    if (temp != null) {
      pars.add(new SentBy(temp));
    }

    Organizer prop = new Organizer(pars, val.getOrganizerUri());

    return prop;
  }

  /**
   * @param attProp
   * @return BwAttendee
   * @throws Throwable
   */
  public static BwAttendee getAttendee(Attendee attProp) throws Throwable {
    BwAttendee att = new BwAttendee();

    att.setAttendeeUri(attProp.getValue());

    ParameterList pars = attProp.getParameters();

    att.setCn(getOptStr(pars, "CN"));
    att.setCuType(getOptStr(pars, "CUTYPE"));
    att.setDelegatedFrom(getOptStr(pars, "DELEGATED-FROM"));
    att.setDelegatedTo(getOptStr(pars, "DELEGATED-TO"));
    att.setDir(getOptStr(pars, "DIR"));
    att.setLanguage(getOptStr(pars, "LANGUAGE"));
    att.setMember(getOptStr(pars, "MEMBER"));
    att.setPartstat(getOptStr(pars, "PARTSTAT"));
    att.setRole(getOptStr(pars, "ROLE"));
    att.setSentBy(getOptStr(pars, "SENT-BY"));

    Parameter par = pars.getParameter("RSVP");
    if (par != null) {
      att.setRsvp(((Rsvp)par).getRsvp().booleanValue());
    }

    return att;
  }

  static class TriggerVal {
    String trigger;
    boolean triggerStart;
    boolean triggerDateTime;
  }

  /**
   * @param pl
   * @return TriggerVal
   * @throws Throwable
   */
  public static TriggerVal getTrigger(PropertyList pl) throws Throwable {
    Trigger prop = (Trigger)pl.getProperty(Property.TRIGGER);
    if (prop == null) {
      throw new IcalMalformedException("Invalid alarm - no trigger");
    }

    TriggerVal tr = new TriggerVal();

    tr.trigger = prop.getValue();

    if (prop.getDateTime() != null) {
      tr.triggerDateTime = true;
      return tr;
    }

    ParameterList pars = prop.getParameters();

    if (pars == null) {
      tr.triggerStart = true;
      return tr;
    }

    Parameter par = pars.getParameter("RELATED");
    if (par == null) {
      tr.triggerStart = true;
      return tr;
    }

    tr.triggerStart = "START".equals(par.getValue());
    return tr;
  }

  static class DurationRepeat {
    String duration;
    int repeat;
  }

  /** Both or none appear once only
   *
   * @param pl
   * @return DurationRepeat
   * @throws Throwable
   */
  public static DurationRepeat getDurationRepeat(PropertyList pl) throws Throwable {
    DurationRepeat dr = new DurationRepeat();

    Property prop = pl.getProperty(Property.DURATION);
    if (prop == null) {
      return dr;
    }

    dr.duration = prop.getValue();

    prop = pl.getProperty(Property.REPEAT);
    if (prop == null) {
      throw new IcalMalformedException("Invalid alarm - no repeat");
    }

    dr.repeat = ((Repeat)prop).getCount();

    return dr;
  }

  /**
   * @param val
   * @param timezones
   * @return Collection
   * @throws Throwable
   */
  public static Collection makeDateTimes(DateListProperty val,
                                         CalTimezones timezones) throws Throwable {
    DateList dl = val.getDates();
    TreeSet ts = new TreeSet();
    Parameter par = getParameter(val, "VALUE");
    boolean isDateType = (par != null) && (par.equals(Value.DATE));
    String tzidval = null;
    Parameter tzid = getParameter(val, "TZID");
    if (tzid != null) {
      tzidval = tzid.getValue();
    }

    Iterator it = dl.iterator();
    while (it.hasNext()) {
      BwDateTime dtv = new BwDateTime();

      Date dt = (Date)it.next();

      dtv.init(isDateType, dt.toString(), tzidval, timezones);

      ts.add(dtv);
    }

    return ts;
  }

  /**
   * @param cal
   * @param comp
   */
  public static void addComponent(Calendar cal, Component comp) {
    cal.getComponents().add(comp);
  }

  /**
   * @param comp
   * @param val
   */
  public static void addProperty(Component comp, Property val) {
    PropertyList props =  comp.getProperties();

    props.add(val);
  }

  /**
   * @param prop
   * @param val
   */
  public static void addParameter(Property prop, Parameter val) {
    ParameterList parl =  prop.getParameters();

    parl.add(val);
  }

  /**
   * @param prop
   * @param name
   * @return Parameter
   */
  public static Parameter getParameter(Property prop, String name) {
    ParameterList parl =  prop.getParameters();

    if (parl == null) {
      return null;
    }

    return parl.getParameter(name);
  }

  /**
   * @param comp
   * @param name
   * @return Property
   */
  public static Property getProperty(Component comp, String name) {
    PropertyList props =  comp.getProperties();

    return props.getProperty(name);
  }

  /**
   * @param comp
   * @param name
   * @return PropertyList
   */
  public static PropertyList getProperties(Component comp, String name) {
    PropertyList props =  comp.getProperties();

    props = props.getProperties(name);
    if ((props != null) && (props.size() == 0)) {
      return null;
    }

    return props;
  }

  /** Return an Iterator over required String attributes
   *
   * @param pl
   * @param name
   * @return Iterator over required String attributes
   * @throws Throwable
   */
  public static Iterator getReqStrs(PropertyList pl, String name) throws Throwable {
   PropertyList props = pl.getProperties(name);

   if ((props == null) || props.isEmpty()) {
      throw new IcalMalformedException("Missing required property " + name);
    }

    return props.iterator();
  }

  /** Return required string property
   *
   * @param pl
   * @param name
   * @return String
   * @throws Throwable
   */
  public static String getReqStr(PropertyList pl, String name) throws Throwable {
    Property prop = pl.getProperty(name);
    if (prop == null) {
      throw new IcalMalformedException("Missing required property " + name);
    }

    return prop.getValue();
  }

  /** Return optional string property
   *
   * @param pl
   * @param name
   * @return String or null
   * @throws Throwable
   */
  public static String getOptStr(PropertyList pl, String name) throws Throwable {
    Property prop = pl.getProperty(name);
    if (prop == null) {
      return null;
    }

    return prop.getValue();
  }

  /**
   * @param comp
   * @param name
   * @return String
   */
  public static String getPropertyVal(Component comp, String name) {
    Property prop =  getProperty(comp, name);
    if (prop == null) {
      return null;
    }

    return prop.getValue();
  }

  /** Return optional string parameter
   *
   * @param pl
   * @param name
   * @return String
   * @throws Throwable
   */
  public static String getOptStr(ParameterList pl, String name) throws Throwable {
    Parameter par = pl.getParameter(name);
    if (par == null) {
      return null;
    }

    return par.getValue();
  }

  /** Return the AltRep parameter if it exists
   *
   * @param prop
   * @return AltRep
   */
  public static AltRep getAltRep(Property prop) {
    return (AltRep)prop.getParameters().getParameter("ALTREP");
  }

  /** Always return a DateTime object
   *
   * @param dt
   * @return DateTime
   * @throws Throwable
   */
  public static DateTime makeDateTime(BwDateTime dt) throws Throwable {
    /** Ignore tzid for the moment */
    return new DateTime(dt.getDtval());
  }

  /**
   * @return Logger
   */
  public static Logger getLog() {
    return Logger.getLogger(IcalUtil.class);
  }

  /**
   * @param t
   */
  public static void error(Throwable t) {
    getLog().error(IcalUtil.class, t);
  }

  /**
   * @param msg
   */
  public static void warn(String msg) {
    getLog().warn(msg);
  }

  /**
   * @param msg
   */
  public static void debugMsg(String msg) {
    getLog().debug(msg);
  }
}

