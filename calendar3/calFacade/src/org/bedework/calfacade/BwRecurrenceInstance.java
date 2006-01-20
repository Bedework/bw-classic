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
import java.util.Comparator;

/**
 * Class to represent an instance of a recurrence. An instance is represented by
 * the date and time of its dtStart and dtEnd together with a recurrence id. We
 * maintain a reference to the master event and a possibly null reference to
 * an overiding event object which contains changes, (annotations etc) to that
 * instance.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public class BwRecurrenceInstance implements Comparable, Comparator, Serializable {
  /** Start date, either from calculated recurrence or explicitly set for this
   * instance
   */
  private BwDateTime dtstart;

  /** End date, either from calculated recurrence or explicitly set for this
   * instance
   */
  private BwDateTime dtend;

  /** Value of the recurrence id.
   */
  private String recurrenceId;

  /** Reference to the master event.
   */
  private BwEvent master;

  /** An overriding instance
   */
  private BwEventAnnotation override;

  /** Constructor
   *
   */
  public BwRecurrenceInstance() {
  }

  /** Constructor
   *
   * @param dtstart      BwDateTime start
   * @param dtend        BwDateTime end
   * @param recurrenceId
   * @param master
   * @param override
   */
  public BwRecurrenceInstance(BwDateTime dtstart,
                              BwDateTime dtend,
                              String recurrenceId,
                              BwEvent master,
                              BwEventAnnotation override) {
    this.dtstart = dtstart;
    this.dtend = dtend;
    this.recurrenceId = recurrenceId;
    this.master = master;
    this.override = override;
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
   * @return Returns the master.
   */
  public BwEvent getMaster() {
    return master;
  }

  /**
   * @param val The master to set.
   */
  public void setMaster(BwEvent val) {
    master = val;
  }

  /**
   * @return Returns the override.
   */
  public BwEventAnnotation getOverride() {
    return override;
  }

  /**
   * @param val The override to set.
   */
  public void setOverride(BwEventAnnotation val) {
    override = val;
  }

  /* ====================================================================
   *                   Object methods
   *  =================================================================== */

  public int compare(Object o1, Object o2) {
    if (o1 == o2) {
      return 0;
    }

    if (!(o1 instanceof BwRecurrenceInstance)) {
      return -1;
    }

    if (!(o2 instanceof BwRecurrenceInstance)) {
      return 1;
    }

    BwRecurrenceInstance inst1 = (BwRecurrenceInstance)o1;
    BwRecurrenceInstance inst2 = (BwRecurrenceInstance)o2;

    int res = inst1.getMaster().compareTo(inst2.getMaster());
    if (res != 0) {
      return res;
    }

    return inst1.getRecurrenceId().compareTo(inst2.getRecurrenceId());
  }

  public int compareTo(Object o2) {
    return compare(this, o2);
  }

  public int hashCode() {
    return getRecurrenceId().hashCode();
  }

  /* We always use the compareTo method
   */
  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    return compareTo(obj) == 0;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwRecurrenceInstance{dtStart=");
    sb.append(getDtstart());
    sb.append(", dtEnd=");
    sb.append(getDtend());
    sb.append(", recurrenceId=");
    sb.append(getRecurrenceId());
    sb.append(", master=");
    sb.append(getMaster().getId());

    if (getOverride() != null)
    sb.append("}");

    return sb.toString();
  }
}
