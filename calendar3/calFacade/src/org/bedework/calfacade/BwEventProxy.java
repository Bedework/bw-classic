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
package org.bedework.calfacade;

import java.util.Collection;
import java.util.Iterator;

/** An event proxy in Bedework.If an event is an alias or reference to another
 * event, this class holds links to both. The referring event will hold user
 * changes, which override the values in the target.
 *
 * <p>For any collection we need to copy the entire collection into the
 * referring event if a change is made. We need a flag to indicate such changes.
 *
 * <p>We cannot just look at the values in the two objects becuase we have to
 * call the getXXX method to allow the persistance engine to retrieve the
 * collection.
 *
 * <p>We could also remove the current mode, that of creating an empty collection
 * in the get methods when none exists.
 *
 * <p>XXX Incomplete. Some fields we can handle easily (String mostly).
 * Problems still arise with fields like locations and recurrence stuff.
 *
 * @author Mike Douglass
 * @version 1.0
 */
public class BwEventProxy extends BwEvent {
  /** The referring event
   */
  private BwEventAnnotation ref;

  private boolean refChanged;

  /** Constructor
   *
   * @param ref
   */
  public BwEventProxy(BwEventAnnotation ref) {
    this.ref = ref;
  }

  /* ====================================================================
   *                      Bean methods
   * ==================================================================== */

  /** Get referenced event
   *
   * @return  BwEventAnnotation
   */
  public BwEventAnnotation getRef() {
    return ref;
  }

  /** Set the event change flag.
   *
   * @param  val     boolean true if event changed.
   */
  public void setRefChanged(boolean val) {
    refChanged = val;
  }

  /** See if the event has changed.
   *
   * @return  boolean   true if event changed.
   */
  public boolean getRefChanged() {
    if (refChanged) {
      return true;
    }

    if (!CalFacadeUtil.eqObjval(ref.getDtstart(), ref.getTarget().getDtstart())) {
      refChanged = true;
      return true;
    }

    if (!CalFacadeUtil.eqObjval(ref.getDtend(), ref.getTarget().getDtend())) {
      refChanged = true;
      return true;
    }

    return false;
  }

  /** Get the target from the ref
   *
   * @return BwEvent target of reference
   */
  public BwEvent getTarget() {
    return ref.getTarget();
  }

  /* ====================================================================
   *                   BwDbentity methods
   * ==================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setId(int)
   */
  public void setId(int val) {
    throw new RuntimeException("Immutable");
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getId()
   */
  public int getId() {
    return ref.getId();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setSeq(int)
   */
  public void setSeq(int val) {
    throw new RuntimeException("Immutable");
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getSeq()
   */
  public int getSeq() {
    return ref.getSeq();
  }

  /* ====================================================================
   *                   BwOwnedDbentity methods
   * ==================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.calfacade.base.BwOwnedDbentity#setOwner(org.bedework.calfacade.BwUser)
   */
  public void setOwner(BwUser val) {
    if (!CalFacadeUtil.eqObjval(ref.getOwner(), val)) {
      ref.setOwner(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.base.BwOwnedDbentity#getOwner()
   */
  public BwUser getOwner() {
    return ref.getOwner();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.base.BwOwnedDbentity#setPublick(boolean)
   */
  public void setPublick(boolean val) {
    if (getPublick() != val) {
      throw new RuntimeException("Immutable");
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.base.BwOwnedDbentity#getPublick()
   */
  public boolean getPublick() {
    return ref.getPublick() || getTarget().getPublick();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setCreator(org.bedework.calfacade.BwUser)
   */
  public void setCreator(BwUser val) {
    throw new RuntimeException("Immutable");
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getCreator()
   */
  public BwUser getCreator() {
    return getTarget().getCreator();
  }

  /** Set the access
   *
   * @param val    String access
   */
  public void setAccess(String val) {
    if (!CalFacadeUtil.eqObjval(ref.getAccess(), val)) {
      ref.setAccess(val);
      setRefChanged(true);
    }
  }

  /** Get the access
   *
   * @return String   access
   */
  public String getAccess() {
    String val = ref.getAccess();
    if (val != null) {
      return val;
    }

    return getTarget().getAccess();
  }

  /** Set the event's calendar
   *
   * @param val    BwCalendar event's calendar
   */
  public void setCalendar(BwCalendar val) {
    ref.setCalendar(val);
  }

  /** Get the event's calendar
   *
   * @return CalendarVO   the event's calendar
   */
  public BwCalendar getCalendar() {
    BwCalendar val = ref.getCalendar();
    if (val != null) {
      return val;
    }

    return getTarget().getCalendar();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setName(java.lang.String)
   */
  public void setName(String val) {
    ref.setName(val);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getName()
   */
  public String getName() {
    String val = ref.getName();
    if (val != null) {
      return val;
    }

    return getTarget().getName();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setSummary(java.lang.String)
   */
  public void setSummary(String val) {
    if (!CalFacadeUtil.eqObjval(ref.getSummary(), val)) {
      ref.setSummary(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getSummary()
   */
  public String getSummary() {
    String val = ref.getSummary();
    if (val != null) {
      return val;
    }

    return getTarget().getSummary();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setDescription(java.lang.String)
   */
  public void setDescription(String val) {
    if (!CalFacadeUtil.eqObjval(ref.getDescription(), val)) {
      ref.setDescription(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getDescription()
   */
  public String getDescription() {
    String val = ref.getDescription();
    if (val != null) {
      return val;
    }

    return getTarget().getDescription();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setDtstart(org.bedework.calfacade.BwDateTime)
   */
  public void setDtstart(BwDateTime val) {
    if (!CalFacadeUtil.eqObjval(ref.getDtstart(), val)) {
      ref.setDtstart(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getDtstart()
   */
  public BwDateTime getDtstart() {
    return ref.getDtstart();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setDtend(org.bedework.calfacade.BwDateTime)
   */
  public void setDtend(BwDateTime val) {
    if (!CalFacadeUtil.eqObjval(ref.getDtend(), val)) {
      ref.setDtend(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getDtend()
   */
  public BwDateTime getDtend() {
    return ref.getDtend();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setEndType(char)
   */
  public void setEndType(char val) {
    if (getEndType() != val) {
      ref.setEndType(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getEndType()
   */
  public char getEndType() {
    return ref.getEndType();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setDuration(java.lang.String)
   */
  public void setDuration(String val) {
    if (!CalFacadeUtil.eqObjval(ref.getDuration(), val)) {
      ref.setDuration(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getDuration()
   */
  public String getDuration() {
    String val = ref.getDuration();
    if (val != null) {
      return val;
    }

    return getTarget().getDuration();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setLink(java.lang.String)
   */
  public void setLink(String val) {
    if (!CalFacadeUtil.eqObjval(ref.getLink(), val)) {
      ref.setLink(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getLink()
   */
  public String getLink() {
    String val = ref.getLink();
    if (val != null) {
      return val;
    }

    return getTarget().getLink();
  }

  /** Set the event deleted flag
   *
   *  @param val    boolean true if the event is deleted
   */
  public void setDeleted(boolean val) {
    ref.setDeleted(val);
  }

  /** Get the event deleted flag
   *
   *  @return boolean    true if the event is deleted
   */
  public boolean getDeleted() {
    if (getTarget().getDeleted()) {
      return true;
    }
    return ref.getDeleted();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setStatus(char)
   */
  public void setStatus(String val) {
    if (!CalFacadeUtil.eqObjval(ref.getStatus(), val)) {
      ref.setStatus(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getStatus()
   */
  public String getStatus() {
    String val = ref.getStatus();
    if (val != null) {
      return val;
    }

    return getTarget().getStatus();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#setCost(java.lang.String)
   */
  public void setCost(String val) {
    if (!CalFacadeUtil.eqObjval(ref.getCost(), val)) {
      ref.setCost(val);
      setRefChanged(true);
    }
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.BwEvent#getCost()
   */
  public String getCost() {
    String val = ref.getCost();
    if (val != null) {
      return val;
    }

    return getTarget().getCost();
  }

  /** Set the event's organizer
   *
   * @param val    OrganizerVO event's organizer
   */
  public void setOrganizer(BwOrganizer val) {
    if (!CalFacadeUtil.eqObjval(ref.getStatus(), val)) {
      throw new RuntimeException("Immutable");
    }
  }

  /** Get the event's organizer
   *
   * @return OrganizerVO   the event's organizer
   */
  public BwOrganizer getOrganizer() {
    return getTarget().getOrganizer();
  }

  /** Get the event's organizerId
   *
   * @return int   the event's organizer id
   */
  public int getOrganizerId() {
    return getTarget().getOrganizerId();
  }

  public void setDtstamp(String val) {
    ref.setDtstamp(val);
  }

  public String getDtstamp() {
    String val = ref.getDtstamp();
    if (val != null) {
      return val;
    }

    return getTarget().getDtstamp();
  }

  public void setLastmod(String val) {
    ref.setLastmod(val);
  }

  public String getLastmod() {
    String val = ref.getLastmod();
    if (val != null) {
      return val;
    }

    return getTarget().getLastmod();
  }

  public void setCreated(String val) {
    ref.setCreated(val);
  }

  public String getCreated() {
    String val = ref.getCreated();
    if (val != null) {
      return val;
    }

    return getTarget().getCreated();
  }

  /** Set the rfc priority for this event
   *
   * @param val    rfc priority number
   */
  public void setPriority(int val) {
    ref.setPriority(val);
  }

  /** Get the events rfc priority
   *
   * @return int    the events rfc priority
   */
  public int getPriority() {
    return ref.getPriority();
  }

  /** Set the rfc sequence for this event
   *
   * @param val    rfc sequence number
   */
  public void setSequence(int val) {
    ref.setSequence(val);
  }

  /** Get the events rfc sequence
   *
   * @return int    the events rfc sequence
   */
  public int getSequence() {
    return ref.getSequence();
  }

  /** Set the events sponsor
   *
   * @param val  SponsorVO events sponsor
   */
  public void setSponsor(BwSponsor val) {
    ref.setSponsor(val);
  }

  /**
    Get the event's sponsor
    @return SponsorVO   event's sponsor
   */
  public BwSponsor getSponsor() {
    BwSponsor val = ref.getSponsor();
    if (val != null) {
      return val;
    }

    return getTarget().getSponsor();
  }

  public void setLocation(BwLocation val) {
    ref.setLocation(val);
  }

  public BwLocation getLocation() {
    BwLocation val = ref.getLocation();
    if (val != null) {
      return val;
    }

    return getTarget().getLocation();
  }

  /** Set the event's guid
   *
   * @param val    String event's guid
   */
  public void setGuid(String val) {
    ref.setGuid(val);
  }

  /** Get the event's guid
   *
   * @return String   event's guid
   */
  public String getGuid() {
    String val = ref.getGuid();
    if (val != null) {
      return val;
    }

    return getTarget().getGuid();
  }

  /** Set the event's transparency
   *
   * @param val    String event's transparency
   */
  public void setTransparency(String val) {
    ref.setTransparency(val);
  }

  /** Get the event's transparency
   *
   * @return String   the event's transparency
   */
  public String getTransparency() {
    String val = ref.getTransparency();
    if (val != null) {
      return val;
    }

    return getTarget().getTransparency();
  }

  public void setCategoriesChanged(boolean val) {
    throw new RuntimeException("Immutable");
  }

  public boolean getCategoriesChanged() {
    if (ref.getCategoriesChanged()) {
      return true;
    }
    return getTarget().getCategoriesChanged();
  }

  public void setCategories(Collection val) {
    ref.setCategories(val);
    ref.setCategoriesChanged(true);
  }

  public Collection getCategories() {
    if (ref.getCategoriesChanged()) {
      return ref.getCategories();
    }
    return getTarget().getCategories();
  }

  public void setAttendeesChanged(boolean val) {
    throw new RuntimeException("Immutable");
  }

  public boolean getAttendeesChanged() {
    if (ref.getAttendeesChanged()) {
      return true;
    }
    return getTarget().getAttendeesChanged();
  }

  /** Set the attendees collection
   *
   * @param val    Collection of attendees
   */
  public void setAttendees(Collection val) {
    ref.setAttendees(val);
    ref.setAttendeesChanged(true);
  }

  /** Get the attendees
   *
   *  @return Collection     attendees list
   */
  public Collection getAttendees() {
    if (ref.getAttendeesChanged()) {
      return ref.getAttendees();
    }
    return getTarget().getAttendees();
  }

  public void setRecurring(boolean val) {
    throw new RuntimeException("Immutable");
  }

  public boolean getRecurring() {
    return ref.getRecurring() || getTarget().getRecurring();
  }

  public void setRecurrenceChanged(boolean val) {
    throw new RuntimeException("Immutable");
  }

  public boolean getRecurrenceChanged() {
    if (ref.getRecurrenceChanged()) {
      return true;
    }
    return getTarget().getRecurrenceChanged();
  }

  /** Set rfc2445 recurrence information for this event
   *
   * @param val       BwRecurrence information
   */
  public void setRecurrence(BwRecurrence val) {
    ref.setRecurrence(val);
  }

  /** Get rfc2445 recurrence information for this event
   *
   * @return BwReccurrence information
   */
  public BwRecurrence getRecurrence() {
    if (ref.getRecurrenceChanged()) {
      return ref.getRecurrence();
    }
    return getTarget().getRecurrence();
  }

  /** Set recurrence id in the override
   *
   * @param val       String recurrence id
   */
  public void setRecurrenceId(String val) {
    ref.getRecurrence().setRecurrenceId(val);
    ref.setRecurrenceChanged(true);
  }

  /* ====================================================================
   *                   Attendees update and query methods
   * ==================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#iterateAttendees()
   */
  public Iterator iterateAttendees() {
    if (ref.getAttendeesChanged()) {
      return ref.iterateAttendees();
    }
    return getTarget().iterateAttendees();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#clearAttendees()
   */
  public void clearAttendees() {
    ref.clearAttendees();
    ref.setAttendeesChanged(true);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#addAttendee(org.bedework.calfacade.BwAttendee)
   */
  public void addAttendee(BwAttendee val) {
    ref.addAttendee(val);
    ref.setAttendeesChanged(true);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#addAttendeeEmail(java.lang.String)
   */
  public void addAttendeeEmail(String val) {
    ref.addAttendeeEmail(val);
    ref.setAttendeesChanged(true);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#getAttendeeEmailList()
   */
  public String[] getAttendeeEmailList() {
    if (ref.getAttendeesChanged()) {
      return ref.getAttendeeEmailList();
    }
    return getTarget().getAttendeeEmailList();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.ifs.AttendeesI#copyAttendees()
   */
  public Collection copyAttendees() {
    if (ref.getAttendeesChanged()) {
      return ref.copyAttendees();
    }

    return getTarget().copyAttendees();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#cloneAttendees()
   */
  public Collection cloneAttendees() {
    if (ref.getAttendeesChanged()) {
      return ref.cloneAttendees();
    }
    return getTarget().cloneAttendees();
  }

  /* ====================================================================
   *                   Categories update and query methods
   * ==================================================================== */

  public Iterator iterateCategories() {
    if (ref.getCategoriesChanged()) {
      return ref.iterateCategories();
    }
    return getTarget().iterateCategories();
  }

  public void clearCategories() {
    ref.clearCategories();
    ref.setCategoriesChanged(true);
  }

  public void addCategory(BwCategory val) {
    ref.addCategory(val);
    ref.setCategoriesChanged(true);
  }

  public BwCategory getFirstCategory() {
    if (ref.getCategoriesChanged()) {
      return ref.getFirstCategory();
    }
    return getTarget().getFirstCategory();
  }

  public boolean hasCategory(BwCategory val) {
    if (ref.getCategoriesChanged()) {
      return ref.hasCategory(val);
    }
    return getTarget().hasCategory(val);
  }

  /* ====================================================================
   *                           Factory methods
   * ==================================================================== */

  /** Creates an annotation object for the given event then returns a proxy
   * object to handle it.
   *
   * @param ev  BwEvent object to annotate
   * @param owner
   * @return BwEventProxy object
   * @throws CalFacadeException
   */
  public static BwEventProxy makeAnnotation(BwEvent ev, BwUser owner)
          throws CalFacadeException {
    BwEventAnnotation override = new BwEventAnnotation();
    override.setTarget(ev);

    /* XXX This should be a parameter */
    override.setMaster(ev);

    BwDateTime start = ev.getDtstart();
    BwDateTime end = ev.getDtend();

    override.setDtstart(start);
    override.setDtend(end);
    override.setDuration(BwDateTime.makeDuration(start, end).toString());
    override.setEndType(ev.getEndType());
    override.setCreator(ev.getCreator());
    override.setGuid(ev.getGuid());

    if (owner != null) {
      override.setOwner(owner);
    } else {
      override.setOwner(ev.getOwner());
    }

    return new BwEventProxy(override);
  }

  /* ====================================================================
   *                   Recurrence update and query methods
   * ==================================================================== */

  public BwDuration makeDurationBean() throws CalFacadeException {
    String duration = ref.getDuration();
    if (duration == null) {
      duration = getTarget().getDuration();
    }
    return BwDuration.makeDuration(duration);
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer("BwEventProxy{");

    sb.append(ref.toString());

    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    return new BwEventProxy((BwEventAnnotation)ref.clone());
  }
}
