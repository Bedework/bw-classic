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

import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwFreeBusyComponent;
import org.bedework.calfacade.CalFacadeException;

import net.fortuna.ical4j.model.component.VFreeBusy;
import net.fortuna.ical4j.model.parameter.FbType;
import net.fortuna.ical4j.model.PeriodList;
import net.fortuna.ical4j.model.property.FreeBusy;

import java.util.Iterator;

/**
 *   @author Mike Douglass   douglm @ rpi.edu
 */
public class VFreeUtil extends IcalUtil {

  /** Make a VFreeBusy object from a FreeBusyVO.
   */
  /**
   * @param val
   * @return VFreeBusy
   * @throws CalFacadeException
   */
  public static VFreeBusy toVFreeBusy(BwFreeBusy val) throws CalFacadeException {
    try {
      VFreeBusy vfb = new VFreeBusy(IcalUtil.makeDateTime(val.getStart()),
                                    IcalUtil.makeDateTime(val.getEnd()));

      Iterator it = val.iterateTimes();
      while (it.hasNext()) {
        BwFreeBusyComponent fbc = (BwFreeBusyComponent)it.next();
        FreeBusy fb = new FreeBusy();

        int type = fbc.getType();
        if (type == BwFreeBusyComponent.typeBusy) {
          addParameter(fb, FbType.BUSY);
        } else if (type == BwFreeBusyComponent.typeFree) {
          addParameter(fb, FbType.FREE);
        } else if (type == BwFreeBusyComponent.typeBusyUnavailable) {
          addParameter(fb, FbType.BUSY_UNAVAILABLE);
        } else if (type == BwFreeBusyComponent.typeBusyTentative) {
          addParameter(fb, FbType.BUSY_TENTATIVE);
        } else {
          throw new CalFacadeException("Bad free-busy type " + type);
        }

        Iterator pit = fbc.iteratePeriods();
        PeriodList pl =  fb.getPeriods();

        while (pit.hasNext()) {
          pl.add(pit.next());
        }

        vfb.getProperties().add(fb);
      }

      return vfb;
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }
}

