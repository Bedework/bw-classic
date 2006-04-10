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

import edu.rpi.cct.uwcal.access.Acl.CurrentAccess;

import java.io.Serializable;
import java.util.Comparator;

/** This class provides information about an event for a specific user and
 * session.
 *
 * <p>This class allows us to handle thread, or user, specific information.
 *
 * @author Mike Douglass       douglm @ rpi.edu
 */
public class CoreEventInfo implements Comparable, Comparator, Serializable {
  protected BwEvent event;

  /* This object contains information giving the current users access rights to
   * the entity.
   */
  private CurrentAccess currentAccess;

  /** Constructor
   *
   */
  public CoreEventInfo() {
  }

  /** Constructor
   *
   */
  public CoreEventInfo(BwEvent event, CurrentAccess currentAccess) {
    this.event = event;
    this.currentAccess = currentAccess;
  }

  /**
   * @param val
   */
  public void setEvent(BwEvent val) {
    event = val;
  }

  /**
   * @return BwEvent associated with this object
   */
  public BwEvent getEvent() {
    return event;
  }

  /* Set the current users access rights.
   *
   * @param val  CurrentAccess
   */
  public void setCurrentAccess(CurrentAccess val) {
    currentAccess = val;
  }

  /* Get the current users access rights.
   *
   * @return  CurrentAccess
   */
  public CurrentAccess getCurrentAccess() {
    return currentAccess;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compare(Object o1, Object o2) {
    if (!(o1 instanceof CoreEventInfo)) {
      return -1;
    }

    if (!(o2 instanceof CoreEventInfo)) {
      return 1;
    }

    if (o1 == o2) {
      return 0;
    }

    CoreEventInfo e1 = (CoreEventInfo)o1;
    CoreEventInfo e2 = (CoreEventInfo)o2;

    return e1.getEvent().compare(e1.getEvent(), e2.getEvent());
  }

  public int compareTo(Object o2) {
    return compare(this, o2);
  }

  public int hashCode() {
    return getEvent().hashCode();
  }

  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (!(obj instanceof CoreEventInfo)) {
      return false;
    }

    return compareTo(obj) == 0;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("EventInfo{eventid=");

    if (getEvent() == null) {
      sb.append("UNKNOWN");
    } else {
      sb.append(getEvent().getId());
    }

    return sb.toString();
  }
}
