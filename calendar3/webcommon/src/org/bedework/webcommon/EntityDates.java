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

package org.bedework.webcommon;

import org.bedework.calsvci.CalSvcI;

import edu.rpi.sss.util.log.MessageEmit;

/** The dates (and/or duration which define when an entity happens. These are
 * stored in objects which allow manipulation of indiviual date and time
 * components.
 *
 * This is the base class for entity specific classes.
 */
public class EntityDates {
  protected boolean debug;

  protected CalSvcI svci;

  protected boolean hour24;

  protected int minIncrement;

  protected MessageEmit err;

  /** Used for generating labels
   */
  private TimeDateComponents forLabels;

  /** Constructor
   *
   * @param svci
   * @param hour24
   * @param minIncrement
   * @param err
   * @param debug
   */
  public EntityDates(CalSvcI svci, boolean hour24, int minIncrement,
                     MessageEmit err, boolean debug) {
    this.svci = svci;
    this.hour24 = hour24;
    this.minIncrement = minIncrement;
    this.err = err;
    this.debug = debug;
  }

  /**
   * @return  TimeDateComponents for labels
   */
  public TimeDateComponents getForLabels() {
    if (forLabels == null) {
      getNowTimeComponents();
    }

    return forLabels;
  }

  /** Return an initialised TimeDateComponents representing now
   *
   * @return TimeDateComponents  initialised object
   */
  public TimeDateComponents getNowTimeComponents() {
    try {
      TimeDateComponents tc = new TimeDateComponents(svci, minIncrement,
                                                     hour24,
                                                     debug);

      tc.setNow();

      forLabels = tc;

      return tc;
    } catch (Throwable t) {
      if (debug) {
        t.printStackTrace();
      }
      err.emit(t);
      return null;
    }
  }
}

