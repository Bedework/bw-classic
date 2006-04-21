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

import org.bedework.calfacade.base.BwShareableContainedDbentity;
import org.bedework.calfacade.ifs.Attendees;
import org.bedework.calfacade.ifs.AttendeesI;

import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.TreeSet;

/** An Event in Bedework.
 *
 * <p>From RFC2445<pre>
 *     A "VEVENT" calendar component is defined by the
 * following notation:
 *
 *   eventc     = "BEGIN" ":" "VEVENT" CRLF
 *                eventprop *alarmc
 *                "END" ":" "VEVENT" CRLF
 *
 *   eventprop  = *(
 *
 *              ; the following are optional,
 *              ; but MUST NOT occur more than once
 *
 *              class / created / description / dtstart / geo /
 *              last-mod / location / organizer / priority /
 *              dtstamp / seq / status / summary / transp /
 *              uid / url / recurid /
 *
 *              ; either 'dtend' or 'duration' may appear in
 *              ; a 'eventprop', but 'dtend' and 'duration'
 *              ; MUST NOT occur in the same 'eventprop'
 *
 *              dtend / duration /
 *
 *              ; the following are optional,
 *              ; and MAY occur more than once
 *
 *              attach / attendee / categories / comment /
 *              contact / exdate / exrule / rstatus / related /
 *              resources / rdate / rrule / x-prop
 *
 *              )
 * </pre>
 * Optional:
     class
     created          created
     description      description
     dtstart          dtstart
     geo
     last-mod         lastmod
     location         location
     organizer        organizerId
     priority         priority
     dtstamp          dtstamp
     seq              sequence
     status           status
     summary          summary
     transp           transparency
     uid              guid
     url              link
     recurid          recurrenceId

   One of or neither
     dtend            dtend
     duration         duration

   Optional and repeatable
      alarmc          alarms
      attach
      attendee        attendees
      categories      categories
      comment
      contact         sponsor
      exdate          exdates
      exrule
      rstatus
      related
      resources
      rdate           rdates
      rrule           rrules
      x-prop



  Extra non-rfc fields:
      private String cost;
      private UserVO creator;
      private boolean isPublic;
      private CalendarVO calendar;
      private RecurrenceVO recurrence;
      private char recurrenceStatus = 'N'; // Derived from above

 * --------------------------------------------------------------------
 *
 *
 *  @version 1.0
 */
public class BwEvent extends BwShareableContainedDbentity implements AttendeesI, Comparator {
  /** This may change - current caldav draft allows for an arbitrary name
   */
  private String name;

  private String summary;

  /** This should be set by the back end code.
   */
  public static final int maxDescriptionLength = 500;

  private String description;

  private BwDateTime dtstart;
  private BwDateTime dtend;

  /** Duration may be calculated or specified. The end will always
         be filled in to provide the calculated end time.
   */
  private String duration;

  /** */
  public static final char endTypeNone = 'N';
  /** */
  public static final char endTypeDate = 'E';
  /** */
  public static final char endTypeDuration = 'D';

  /** This will be one of the above.
   */
  private char endType = endTypeDate;

  private String link;
  private String status;
  private String cost;

  private boolean deleted;

  /** UTC datetime as specified in rfc */
  private String dtstamp;

  /** UTC datetime as specified in rfc */
  private String lastmod;

  /** UTC datetime as specified in rfc */
  private String created;

  /** RFC priority value
   */
  private int priority;

  /** RFC sequence value
   */
  private int sequence;

  /** For management of aliased events
   */
  private boolean categoriesChanged;

  /** A Set of BwCategory objects
   */
  private Collection categories = null;

  /** This may or may not be set to populate fully
   */
  private BwSponsor sponsor;

  /** This may or may not be set to populate fully
   */
  private BwLocation location;

  private int organizerId = CalFacadeDefs.unsavedItemKey;
  private BwOrganizer organizer;

  /** */
  public final static String transparencyOpaque = "OPAQUE";
  /** */
  public final static String transparencyTransparent = "TRANSPARENT";
  /** Transparency is used in free/busy time calculation
   *      transp     = "TRANSP" tranparam ":" transvalue CRLF

     tranparam  = *(";" xparam)

     transvalue = "OPAQUE"      ;Blocks or opaque on busy time searches.
                / "TRANSPARENT" ;Transparent on busy time searches.
        ;Default value is OPAQUE
   */
  private String transparency;

  /** For management of aliased events
   */
  private boolean attendeesChanged;

  private Collection attendees;

  private Attendees attendeesHelper = new Attendees();

  private boolean recurring;

  /** For management of aliased events
   */
  private boolean recurrenceChanged;

  /** This object, if present, holds rfc2445 recurrence information.
   */
  private BwRecurrence recurrence;

  /** The guid for the event. Generated by the system or by external sources when
   * imported.
   */
  private String guid;

  /** Constructor
   */
  protected BwEvent() {
    super();
  }

  /** Constructor
   *
   * @param owner        BwUser user who owns the entity
   * @param publick      boolean true if this is a public entity
   * @param creator      BwUser user who created the entity
   * @param access
   * @param summary      String  Short description
   * @param description  String Long description
   * @param dtstart      DateTimeVO start
   * @param dtend        DateTimeVO end
   * @param link         String URL with more info
   * @param cost         String Cost to attend
   * @param organizer    OrganizerVO object
   * @param location     event's location
   * @param sponsor      event's sponsor
   * @param guid         String guid value
   * @param transparency String value
   * @param dtstamp      String UTC last modification time
   * @param lastmod      String UTC last modification time
   * @param created      String UTC creation datetime
   * @param priority     int rfc priority
   * @param sequence     int rfc sequence
   * @param recurrence   RecurrenceVO information
   */
  protected BwEvent(BwUser owner,
                    boolean publick,
                    BwUser creator,
                    String access,
                    String summary,
                    String description,
                    BwDateTime dtstart,
                    BwDateTime dtend,
                    String link,
                    String cost,
                    BwOrganizer organizer,
                    BwLocation location,
                    BwSponsor sponsor,
                    String guid,
                    String transparency,
                    String dtstamp,
                    String lastmod,
                    String created,
                    int priority,
                    int sequence,
                    BwRecurrence recurrence) {
    super(owner, publick, creator, access);
    this.summary = summary;
    this.description = description;
    this.dtstart = dtstart;
    this.dtend = dtend;
    this.link = link;
    this.cost = cost;
    setOrganizer(organizer);
    this.location = location;
    this.sponsor = sponsor;
    this.guid = guid;
    this.transparency = transparency;
    this.dtstamp = dtstamp;
    this.lastmod = lastmod;
    this.created = created;
    this.priority = priority;
    this.sequence = sequence;
  }

  /* ====================================================================
   *                      Bean methods
   * ==================================================================== */

  /** Set the event's name
   *
   * @param val    String event's name
   */
  public void setName(String val) {
    name = val;
  }

  /** Get the event's name.
   *
   * @return String   event's name
   */
  public String getName() {
    return name;
  }

  /** Set the event's summary
   *
   * @param val    String event's summary
   */
  public void setSummary(String val) {
    summary = val;
  }

  /** Get the event's summary
   *
   * @return String   event's summary
   */
  public String getSummary() {
    return summary;
  }

  /** Set the event's long description
   *
   * @param val    String event's short description
   */
  public void setDescription(String val) {
    description = val;
  }

  /** Get the event's long description
   *
   *  @return String   event's long description
   */
  public String getDescription() {
    return description;
  }

  /** Set the event's start
   *
   *  @param  val   Event's start
   */
  public void setDtstart(BwDateTime val) {
    dtstart = val;
  }

  /** Get the event's start
   *
   *  @return The event's start
   */
  public BwDateTime getDtstart() {
    return dtstart;
  }

  /** Set the event's end
   *
   *  @param  val   Event's end
   */
  public void setDtend(BwDateTime val) {
    dtend = val;
  }

  /** Get the event's end
   *
   *  @return The event's end
   */
  public BwDateTime getDtend() {
    return dtend;
  }

  /** Set the event endType flag
   *
   *  @param  val    char endType
   */
  public void setEndType(char val) {
    endType = val;
  }

  /** get the event end Type
   *
   *  @return char    end Type
   */
  public char getEndType() {
    return endType;
  }

  /** Set the event's duration
   *
   *  @param val   string duration
   */
  public void setDuration(String val) {
   duration = val;
  }

  /** Get the event's duration
   *
   * @return the event's duration
   */
  public String getDuration() {
    return duration;
  }

  /** Set the event's URL
   *
   *  @param val   string URL
   */
  public void setLink(String val) {
    link = val;
  }

  /** Get the event's URL
   *
   * @return the event's URL
   */
  public String getLink() {
    return link;
  }

  /** Set the event deleted flag
   *
   *  @param val    boolean true if the event is deleted
   */
  public void setDeleted(boolean val) {
    deleted = val;
  }

  /** Get the event deleted flag
   *
   *  @return boolean    true if the event is deleted
   */
  public boolean getDeleted() {
    return deleted;
  }

  /** Set the event's status - must be one of
   *  CONFIRMED, TENTATIVE, or CANCELLED
   *
   *  @param val     status
   */
  public void setStatus(String val) {
    status = val;
  }

  /** Get the event's status
   *
   * @return String event's status
   */
  public String getStatus() {
    return status;
  }

  /** Set the event's cost
   *
   * @param val    String event's cost
   */
  public void setCost(String val) {
    cost = val;
  }

  /** Get the event's cost
   *
   * @return String   the event's cost
   */
  public String getCost() {
    return cost;
  }

  /** Set the event's organizer
   *
   * @param val    OrganizerVO event's organizer
   */
  public void setOrganizer(BwOrganizer val) {
    organizer = val;
    if (organizer == null) {
      organizerId = CalFacadeDefs.unsavedItemKey;
    } else {
      organizerId = organizer.getId();
    }
  }

  /** Get the event's organizer
   *
   * @return OrganizerVO   the event's organizer
   */
  public BwOrganizer getOrganizer() {
    return organizer;
  }

  /** Get the event's organizerId
   *
   * @return int   the event's organizer id
   */
  public int getOrganizerId() {
    return organizerId;
  }

  /**
   * @param val
   */
  public void setDtstamp(String val) {
    dtstamp = val;
  }

  /**
   * @return String datestamp
   */
  public String getDtstamp() {
    return dtstamp;
  }

  /**
   * @param val
   */
  public void setLastmod(String val) {
    lastmod = val;
  }

  /**
   * @return String lastmod
   */
  public String getLastmod() {
    return lastmod;
  }

  /**
   * @param val
   */
  public void setCreated(String val) {
    created = val;
  }

  /**
   * @return String created
   */
  public String getCreated() {
    return created;
  }

  /** Set the rfc priority for this event
   *
   * @param val    rfc priority number
   */
  public void setPriority(int val) {
    priority = val;
  }

  /** Get the events rfc priority
   *
   * @return int    the events rfc priority
   */
  public int getPriority() {
    return priority;
  }

  /** Set the rfc sequence for this event
   *
   * @param val    rfc sequence number
   */
  public void setSequence(int val) {
    sequence = val;
  }

  /** Get the events rfc sequence
   *
   * @return int    the events rfc sequence
   */
  public int getSequence() {
    return sequence;
  }

  /** Set the events sponsor
   *
   * @param val  SponsorVO events sponsor
   */
  public void setSponsor(BwSponsor val) {
    sponsor = val;
  }

  /**
    Get the event's sponsor
    @return SponsorVO   event's sponsor
   */
  public BwSponsor getSponsor() {
    return sponsor;
  }

  /**
   * @param val
   */
  public void setLocation(BwLocation val) {
    location = val;
  }

  /**
   * @return  BwLocation or null
   */
  public BwLocation getLocation() {
    return location;
  }

  /** Set the event's guid
   *
   * @param val    String event's guid
   */
  public void setGuid(String val) {
    guid = val;
  }

  /** Get the event's guid
   *
   * @return String   event's guid
   */
  public String getGuid() {
    return guid;
  }

  /** Set the event's transparency
   *
   * @param val    String event's transparency
   */
  public void setTransparency(String val) {
    transparency = val;
  }

  /** Get the event's transparency
   *
   * @return String   the event's transparency
   */
  public String getTransparency() {
    return transparency;
  }

  /**
   * @param val
   */
  public void setCategoriesChanged(boolean val) {
    categoriesChanged = val;
  }

  /**
   * @return  boolean true if categories chganged
   */
  public boolean getCategoriesChanged() {
    return categoriesChanged;
  }

  /**
   * @param val
   */
  public void setCategories(Collection val) {
    categories = val;
  }

  /**
   * @return Collection of categories
   */
  public Collection getCategories() {
    if (categories == null) {
      categories = new TreeSet();
    }

    return categories;
  }

  /**
   * @param val
   */
  public void setAttendeesChanged(boolean val) {
    attendeesChanged = val;
  }

  /**
   * @return  boolean true if attendees changed
   */
  public boolean getAttendeesChanged() {
    return attendeesChanged;
  }

  /** Set the attendees collection
   *
   * @param val    Collection of attendees
   */
  public void setAttendees(Collection val) {
    attendees = val;
    getAttendeesHelper().setAttendees(val);
  }

  /** Get the attendees
   *
   *  @return Collection     attendees list
   */
  public Collection getAttendees() {
    if (attendees == null) {
      attendees = new TreeSet();
      getAttendeesHelper().setAttendees(attendees);
    }

    return attendees;
  }

  /**
   * @param val
   */
  public void setRecurring(boolean val) {
    recurring = val;
  }

  /**
   * @return boolean recurrence has changed
   */
  public boolean getRecurring() {
    return recurring;
  }

  /**
   * @param val
   */
  public void setRecurrenceChanged(boolean val) {
    recurrenceChanged = val;
  }

  /**
   * @return boolean recurrence has changed
   */
  public boolean getRecurrenceChanged() {
    return recurrenceChanged;
  }

  /** Set rfc2445 recurrence information for this event
   *
   * @param val       BwRecurrence information
   */
  public void setRecurrence(BwRecurrence val) {
    recurrence = val;
  }

  /** Get rfc2445 recurrence information for this event
   *
   * @return BwReccurrence information
   */
  public BwRecurrence getRecurrence() {
    if (recurrence == null) {
      recurrence = new BwRecurrence();
    }
    return recurrence;
  }

  /** Set recurrence id
   *
   * @param val       String recurrence id
   */
  public void setRecurrenceId(String val) {
    getRecurrence().setRecurrenceId(val);
  }

  /* ====================================================================
   *                   Mappng methods
   * ==================================================================== */

  /**
   * @return int entity type
   */
  public int getEntityType() {
    return CalFacadeDefs.entityTypeEvent;
  }

  /* ====================================================================
   *                   Attendees update and query methods
   * ==================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#iterateAttendees()
   */
  public Iterator iterateAttendees() {
    return getAttendeesHelper().iterateAttendees();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#clearAttendees()
   */
  public void clearAttendees() {
    getAttendeesHelper().clearAttendees();
    setAttendees(attendeesHelper.getAttendees());
    setAttendeesChanged(true);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#addAttendee(org.bedework.calfacade.BwAttendee)
   */
  public void addAttendee(BwAttendee val) {
    getAttendeesHelper().addAttendee(val);
    setAttendees(attendeesHelper.getAttendees());
    setAttendeesChanged(true);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#addAttendeeEmail(java.lang.String)
   */
  public void addAttendeeEmail(String val) {
    getAttendeesHelper().addAttendeeEmail(val);
    setAttendees(attendeesHelper.getAttendees());
    setAttendeesChanged(true);
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#getAttendeeEmailList()
   */
  public String[] getAttendeeEmailList() {
    if (attendees == null) {
      return null;
    }

    return attendeesHelper.getAttendeeEmailList();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.ifs.AttendeesI#copyAttendees()
   */
  public Collection copyAttendees() {
    if (attendees == null) {
      return null;
    }

    return attendeesHelper.copyAttendees();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.AttendeesI#cloneAttendees()
   */
  public Collection cloneAttendees() {
    if (attendees == null) {
      return null;
    }

    return attendeesHelper.cloneAttendees();
  }

  /* ====================================================================
   *                   Categories update and query methods
   * ==================================================================== */

  /** Get an <code>Iterator</code> over the event's categories
   *
   * @return Iterator  over the event's categories
   */
  public Iterator iterateCategories() {
    return getCategories().iterator();
  }

  /** clear the event's categories
   */
  public void clearCategories() {
    getCategories().clear();
    setCategoriesChanged(true);
  }

  /**
   * @param val
   */
  public void addCategory(BwCategory val) {
    Collection cats = getCategories();

    if (!cats.contains(val)) {
      cats.add(val);
      setCategoriesChanged(true);
    }
  }

  /** Get the first category or null.
   *
   * @return BwCategory first category or null.
   */
  public BwCategory getFirstCategory() {
    Iterator it = iterateCategories();

    if (!it.hasNext()) {
      return null;
    }

    return (BwCategory)it.next();
  }

  /** Check the categories for the same entity
   *
   * @param val        Category to test
   * @return boolean   true if the event has a particular category
   */
  public boolean hasCategory(BwCategory val) {
    return getCategories().contains(val);
  }

  /* ====================================================================
   *                   Conveniece methods
   * ==================================================================== */

  /** Return an object holding just enough for free busy calculation
   *
   * @return BwEvent object.
   */
  public BwEvent makeFreeBusyEvent() {
    BwEvent res = new BwEvent();

    res.setDtend(getDtend());
    res.setDtstart(getDtstart());
    res.setDuration(getDuration());
    res.setEndType(getEndType());
    res.setGuid(getGuid());
    res.setTransparency(getTransparency());

    return res;
  }

  /** Return a BwDuration populated from the String duration.
   *
   * @return BwDuration
   * @throws CalFacadeException
   */
  public BwDuration makeDurationBean() throws CalFacadeException {
    return BwDuration.makeDuration(getDuration());
  }

  /** Add our stuff to the StringBuffer
   *
   * @param sb    StringBuffer for result
   */
   protected void toStringSegment(StringBuffer sb) {
    super.toStringSegment(sb);
    sb.append(", deleted=");
    sb.append(getDeleted());
    sb.append(", dtstamp=");
    sb.append(getDtstamp());
    sb.append(", lastmod=");
    sb.append(getLastmod());
    sb.append(", created=");
    sb.append(getCreated());
    sb.append(", priority=");
    sb.append(getPriority());
    sb.append(", sequence=");
    sb.append(getSequence());
    sb.append(", dtstart=");
    sb.append(getDtstart());
    sb.append(", dtend=");
    sb.append(getDtend());
    sb.append(", guid=");
    sb.append(getGuid());
    sb.append(", summary=");
    sb.append(getSummary());
    sb.append(", description=");
    String desc = getDescription();
    if (desc == null) {
      sb.append("null");
    } else {
      int len = Math.min(40, desc.length());
      sb.append(desc.substring(0, len));
    }
    sb.append(", organizer=");
    sb.append(getOrganizer());
    sb.append(", recurrence=");
    sb.append(getRecurrence());
  }

   /** Copy this objects fields into the parameter. Don't clone many of the
    * referenced objects
    *
    * @param ev
    */
   public void shallowCopyTo(BwEvent ev) {
     super.shallowCopyTo(ev);
     ev.setName(getName());
     ev.setSummary(getSummary());
     ev.setDescription(getDescription());
     ev.setDtstart(getDtstart());
     ev.setDtend(getDtend());
     ev.setEndType(getEndType());
     ev.setDuration(getDuration());
     ev.setLink(getLink());
     ev.setDeleted(getDeleted());
     ev.setStatus(getStatus());
     ev.setCost(getCost());

     ev.setOrganizer(getOrganizer());

     ev.setDtstamp(getDtstamp());
     ev.setLastmod(getLastmod());
     ev.setCreated(getCreated());
     ev.setPriority(getPriority());
     ev.setSequence(getSequence());

     ev.setSponsor(getSponsor());

     ev.setLocation(getLocation());

     ev.setGuid(getGuid());
     ev.setTransparency(getTransparency());

     /* XXX shallow copy categories */
     Iterator it = iterateCategories();
     TreeSet cs = new TreeSet();

     while (it.hasNext()) {
       BwCategory c = (BwCategory)it.next();

       cs.add(c);
     }

     ev.setCategories(cs);

     ev.setAttendees(copyAttendees());
     ev.setRecurring(getRecurring());

     ev.setRecurrence((BwRecurrence)getRecurrence().clone());
   }

  /** Copy this objects fields into the parameter
   *
   * @param ev
   */
  public void copyTo(BwEvent ev) {
    super.copyTo(ev);
    ev.setName(getName());
    ev.setSummary(getSummary());
    ev.setDescription(getDescription());
    ev.setDtstart(getDtstart());
    ev.setDtend(getDtend());
    ev.setEndType(getEndType());
    ev.setDuration(getDuration());
    ev.setLink(getLink());
    ev.setDeleted(getDeleted());
    ev.setStatus(getStatus());
    ev.setCost(getCost());

    BwOrganizer org = getOrganizer();
    if (org != null) {
      org = (BwOrganizer)org.clone();
    }
    ev.setOrganizer(org);

    ev.setDtstamp(getDtstamp());
    ev.setLastmod(getLastmod());
    ev.setCreated(getCreated());
    ev.setPriority(getPriority());
    ev.setSequence(getSequence());

    BwSponsor sp = getSponsor();
    if (sp != null) {
      sp = (BwSponsor)sp.clone();
    }
    ev.setSponsor(sp);

    BwLocation loc = getLocation();
    if (loc != null) {
      loc = (BwLocation)loc.clone();
    }
    ev.setLocation(loc);

    ev.setGuid(getGuid());
    ev.setTransparency(getTransparency());

    /* categories */
    Iterator it = iterateCategories();
    TreeSet cs = new TreeSet();

    while (it.hasNext()) {
      BwCategory c = (BwCategory)it.next();

      cs.add((BwCategory)c.clone());
    }

    ev.setCategories(cs);

    ev.setAttendees(cloneAttendees());
    ev.setRecurring(getRecurring());

    ev.setRecurrence((BwRecurrence)getRecurrence().clone());
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compare(Object o1, Object o2) {
    if (!(o1 instanceof BwEvent)) {
      return -1;
    }

    if (!(o2 instanceof BwEvent)) {
      return 1;
    }

    if (o1 == o2) {
      return 0;
    }

    BwEvent e1 = (BwEvent)o1;
    BwEvent e2 = (BwEvent)o2;

    /* If the guids are the same it's the same event for non recurring.
       For recurring events the recurrence id must also be equal.
     * /
    int res = e1.getGuid().compareTo(e2.getGuid());
    if (res == 0) {
      if (!e1.getRecurring()) {
        return 0;
      }

      /* Recurring - only the same if the recurrence id is equal * /
      return CalFacadeUtil.cmpObjval(e1.getRecurrence().getRecurrenceId(),
                                     e2.getRecurrence().getRecurrenceId());
    }

    res = e1.getDtstart().compareTo(e2.getDtstart());
    if (res != 0) {
      return res;
    }

    res = e1.getDtend().compareTo(e2.getDtend());
    if (res != 0) {
      return res;
    }

    /* Dates are the same - try summary. * /

    res = e1.getSummary().compareTo(e2.getSummary());
    if (res != 0) {
      return res;
    }

    // Just use guid
    return e1.getGuid().compareTo(e2.getGuid());
    */
    /* If the guids are the same it's the same event for non recurring.
       For recurring events the recurrence id must also be equal.
     */
    int res = e1.getGuid().compareTo(e2.getGuid());
    if ((res == 0) && (!e1.getRecurring())) {
      return 0;
    }

    if (!e2.getRecurring()) {
      return 1;
    }

    /* Both recurring - only the same if the recurrence id is equal */
    return CalFacadeUtil.cmpObjval(e1.getRecurrence().getRecurrenceId(),
                                   e2.getRecurrence().getRecurrenceId());
  }

  public int compareTo(Object o2) {
    return compare(this, o2);
  }

  public int hashCode() {
    return getGuid().hashCode();
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("BwEvent{");

    toStringSegment(sb);

    sb.append("}");

    return sb.toString();
  }

  private Attendees getAttendeesHelper() {
    if (attendeesHelper == null) {
      attendeesHelper = new Attendees();
    }

    return attendeesHelper;
  }
}
