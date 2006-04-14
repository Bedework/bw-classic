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
package org.bedework.appcommon;

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwFreeBusyComponent;
import org.bedework.calfacade.BwPrincipal;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;

import net.fortuna.ical4j.model.Period;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

/** Reformatted free busy information for display.
 * We build a collection of these to represent the free busy. Each one represents
 * a day only with each period starting at the given number of minutes into the
 * day.
 *
 * <p>With a suitably formatted free busy query we can produce this object to
 * make presentation a relatively simple prospect.
 *
 * @author Mike Douglass douglm @ rpi.edu
 *
 */
public class FormattedFreeBusy {
  /** Who's free busy? Normally a user - could be a room.
   */
  private BwPrincipal who;

  private BwDateTime start;
  private BwDateTime end;

  /** Collection of FbPeriod
   */
  private Collection times;

  public static class FbPeriod {
    int minutesStart;
    int minutesLength;
    int type; // From BwFreeBusyComponent

    public FbPeriod(int minutesStart, int minutesLength, int type) {
      this.minutesStart = minutesStart;
      this.minutesLength = minutesLength;
      this.type = type;
    }

    /** Start time on minutes
     *
     * @return int
     */
    public int getMinutesStart() {
      return minutesStart;
    }

    /** Length of free busy
     *
     * @return int
     */
    public int getMinutesLength() {
      return minutesLength;
    }

    /** type of free busy
     *
     * @return int
     */
    public int getType() {
      return type;
    }

    /** Get the start as a 4 digit String hours and minutes value
     *
     * @return String start time
     */
    public String getStartTime() {
      return CalFacadeUtil.getTimeFromMinutes(getMinutesStart());
    }
  }

  public FormattedFreeBusy(BwFreeBusy fb) throws CalFacadeException {
    setWho(fb.getWho());
    setStart(fb.getStart());
    setEnd(fb.getEnd());

    /* We expect a number of BwFreeBusyComponent each containing a single
     * free busy period.
     */
    long startMillis = getStart().makeDate().getTime();

    Iterator it = fb.iterateTimes();

    while (it.hasNext()) {
      BwFreeBusyComponent fbc = (BwFreeBusyComponent)it.next();

      Iterator pit = fbc.iteratePeriods();
      while (pit.hasNext()) {
        Period p = (Period)pit.next();

        long pstartMillis = p.getStart().getTime();
        int plen = Math.round((p.getEnd().getTime() - pstartMillis) / 60000);
        int pstart = Math.round((pstartMillis - startMillis) / 60000);

        addTime(new FbPeriod(pstart, plen, fbc.getType()));
      }
    }
  }

  /** who owns or asked for
   *
   * @param val BwPrincipal
   */
  public void setWho(BwPrincipal val) {
    who = val;
  }

  /**
   * @return BwPrincipal
   */
  public BwPrincipal getWho() {
    return who;
  }

  /**
   * @param val
   */
  public void setStart(BwDateTime val) {
    start = val;
  }

  /**
   * @return BwDateTime start
   */
  public BwDateTime getStart() {
    return start;
  }

  /**
   * @param val
   */
  public void setEnd(BwDateTime val) {
    end = val;
  }

  /**
   * @return BwDateTime end
   */
  public BwDateTime getEnd() {
    return end;
  }

  /** Get the free busy periods
   *
   * @return Collection    of FbPeriod
   */
  public Collection getTimes() {
    if (times == null) {
      times = new ArrayList();
    }
    return times;
  }

  /** Add a free/busy period
   *
   * @param val
   */
  public void addTime(FbPeriod val) {
    getTimes().add(val);
  }

  /** Iterate over free/busy periods
   *
   * @return Iterator
   */
  public Iterator iterateTimes() {
    return getTimes().iterator();
  }
}
