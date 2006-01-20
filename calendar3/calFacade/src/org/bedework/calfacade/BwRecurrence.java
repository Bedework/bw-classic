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

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
//import java.util.Date;
import java.util.TreeSet;

/**
 * Recurrence information. This is not stored in a separate tables but is a
 * component of the including class.
 *
 * <p>The information consists of the following components<ul>
 * <li>Zero or more exclusion date/times</li>
 * <li>Zero or more exception rules</li>
 * <li>Zero or more recurrence date/times</li>
 * <li>One or more recurrence rules</li>
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public class BwRecurrence implements Serializable {
  /** Collection of String rrule values
   */
  private Collection rrules;

  /** Collection of String exrule values
   */
  private Collection exrules;

  /** Collection of DateTimeVO rdate values
   */
  private Collection rdates;

  /** Collection of DateTimeVO exdate values
   */
  private Collection exdates;

  /** recurrence-id for a specific instance.
   */
  private String recurrenceId;

  /** Where known this will be the absolute latest date for this recurring
   * event. This field will be null for infinite events.
   */
  private String latestDate;

  /** True for a master entry that has expansions in the recurrance
   * instances table. Such an event will have an entry for the master as well
   * as all derived events.
   */
  private boolean expanded;

  /** Constructor
   *
   */
  public BwRecurrence() {
  }

  /** Constructor
   *
   * @param rrules        Collection of String
   * @param exrules       Collection of String
   * @param rdates        Collection of String
   * @param exdates       Collection of String
   * @param recurrenceId
   * @param latestDate
   * @param expanded
   */
  public BwRecurrence(Collection rrules,
                      Collection exrules,
                      Collection rdates,
                      Collection exdates,
                      String recurrenceId,
                      String latestDate,
                      boolean expanded) {
    this.rrules = rrules;
    this.exrules = exrules;
    this.rdates = rdates;
    this.exdates = exdates;
    this.recurrenceId = recurrenceId;
    this.latestDate = latestDate;
    this.expanded = expanded;
  }

  /**
   * @param val
   */
  public void setRrules(Collection val) {
    rrules = val;
  }

  /**
   * @return   Collection of String
   */
  public Collection getRrules() {
    if (rrules == null) {
      rrules = new TreeSet();
    }

    return rrules;
  }

  /**
   * @param val
   */
  public void setExrules(Collection val) {
    exrules = val;
  }

  /**
   * @return   Collection of String
   */
  public Collection getExrules() {
    if (exrules == null) {
      exrules = new TreeSet();
    }

    return exrules;
  }

  /**
   * @param val
   */
  public void setRdates(Collection val) {
    rdates = val;
  }

  /**
   * @return   Collection of String
   */
  public Collection getRdates() {
    if (rdates == null) {
      rdates = new TreeSet();
    }

    return rdates;
  }

  /**
   * @param val
   */
  public void setExdates(Collection val) {
    exdates = val;
  }

  /**
   * @return    Collection of String
   */
  public Collection getExdates() {
    if (exdates == null) {
      exdates = new TreeSet();
    }

    return exdates;
  }

  /** Set the event's recurrence id
   *
   *  @param val     recurrence id
   */
  public void setRecurrenceId(String val) {
     recurrenceId = val;
  }

  /** Get the event's recurrence id
   *
   * @return the event's recurrence id
   */
  public String getRecurrenceId() {
    return recurrenceId;
  }

  /**
   * @param val
   */
  public void setLatestDate(String val) {
    latestDate = val;
  }

  /**
   * @return    String latest date
   */
  public String getLatestDate() {
    return latestDate;
  }

  /**
   * @param val
   */
  public void setExpanded(boolean val) {
    expanded = val;
  }

  /**
   * @return   boolean true if expanded
   */
  public boolean getExpanded() {
    return expanded;
  }

  /* ====================================================================
   *                   Update and convenience methods
   * ==================================================================== */

  /** Get an <code>Iterator</code> over the event's rrules
   *
   * @return Iterator  over the event's rrules
   */
  public Iterator iterateRrules() {
    return getRrules().iterator();
  }

  /**
   * @param val
   */
  public void addRrule(String val) {
    Collection rs = getRrules();

    if (!rs.contains(val)) {
      rs.add(val);
    }
  }

  /** Get an <code>Iterator</code> over the event's exrules
   *
   * @return Iterator  over the event's exrules
   */
  public Iterator iterateExrules() {
    return getExrules().iterator();
  }

  /**
   * @param val
   */
  public void addExrule(String val) {
    Collection rs = getExrules();

    if (!rs.contains(val)) {
      rs.add(val);
    }
  }

  /** Get an <code>Iterator</code> over the event's rdates
   *
   * @return Iterator  over the event's rdates
   */
  public Iterator iterateRdates() {
    return getRdates().iterator();
  }

  /**
   * @param val
   */
  public void addRdate(BwDateTime val) {
    Collection rds = getRdates();

    if (!rds.contains(val)) {
      rds.add(val);
    }
  }

  /** Get an <code>Iterator</code> over the event's exdates
   *
   * @return Iterator  over the event's exdates
   */
  public Iterator iterateExdates() {
    return getExdates().iterator();
  }

  /**
   * @param val
   */
  public void addExdate(BwDateTime val) {
    Collection rds = getExdates();

    if (!rds.contains(val)) {
      rds.add(val);
    }
  }

  /* ====================================================================
   *                   Object methods
   *  =================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwRecurrence{latestDate=");
    sb.append(getLatestDate());
    sb.append(", recurrenceId=");
    sb.append(getRecurrenceId());
    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    return new BwRecurrence((Collection)((TreeSet)getRrules()).clone(),
                            (Collection)((TreeSet)getExrules()).clone(),
                            (Collection)((TreeSet)getRdates()).clone(),
                            (Collection)((TreeSet)getExdates()).clone(),
                            getRecurrenceId(),
                            getLatestDate(),
                            getExpanded());
  }
}
