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

/** An Event Annotation in Bedework
 *
 *  @author Mike Douglass
 *  @version 1.0
 */
public class BwEventAnnotation extends BwEvent {
  /** The event this one annotates. (which may itself be an annotation)
   */
  private BwEvent target;

  private BwEvent master;

  /** Constructor
   */
  public BwEventAnnotation() {
    super();
  }

  /* ====================================================================
   *                      Bean methods
   * ==================================================================== */

  /**
   * @param val
   */
  public void setTarget(BwEvent val) {
    target = val;
  }

  /**
   * @return BwEvent target of this reference
   */
  public BwEvent getTarget() {
    return target;
  }

  /** The ultimate master event. This is always a real event. For
   * recurring events it is the master event - for non recurring it is
   * the unannotated original event.
   *
   * <p>This allows us to do a single fetch of all related annotations
   *
   * @param val
   */
  public void setMaster(BwEvent val) {
    master = val;
  }

  /**
   * @return BwEvent master for this reference
   */
  public BwEvent getMaster() {
    return master;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer("BwEventAnnotation{");

    toStringSegment(sb);
    sb.append(", target=");
    sb.append(getTarget().getId());
    sb.append(", master=");
    sb.append(getMaster().getId());

    sb.append("}");

    return sb.toString();
  }

  public Object clone() {
    BwEventAnnotation ev = new BwEventAnnotation();

    copyTo(ev);
    ev.setTarget(getTarget());
    ev.setMaster(getMaster());

    return ev;
  }
}
