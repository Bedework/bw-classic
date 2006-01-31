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

package org.bedework.webadmin.event;

import org.bedework.appcommon.FormattedEvents;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.CalFacadeUtil;
import org.bedework.calfacade.filter.BwFilter;
import org.bedework.webadmin.PEAbstractAction;
import org.bedework.webadmin.PEActionForm;
import org.bedework.webcommon.BwSession;


import java.util.Collection;
import javax.servlet.http.HttpServletRequest;

/** This action sets up a list of events for potential modification.
 *
 * NOTE: urls should incorporate a collection index - not an event id.
 *
 * <p>Forwards to:<ul>
 *      <li>"doNothing"    input error or we want to ignore the request.</li>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"continue"     continue to list page.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class PEGetFormattedEventsAction extends PEAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webadmin.PEAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webadmin.PEActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwSession sess,
                         PEActionForm form) throws Throwable {
    /** Check access and set request parameters
     */
    if (!form.getAuthorisedUser()) {
      return "noAccess";
    }

    form.assignAlertEvent(false);
    form.assignAddingEvent(false);

    form.setFormattedEvents(new FormattedEvents(getEvents(false, form),
                                                form.getCalInfo(),
                                                form.fetchSvci().getTimezones()));

    return "continue";
  }

  /** Return events, if doing alerts we pick them out otherwise exclude them
   *
   * @return Collection  populated event value objects
   */
  private Collection getEvents(boolean alertEvent, PEActionForm form)
          throws Throwable {
    BwFilter filter = null;

    if (alertEvent) {
      /* XXX create a filter which filters on the appropriate field -
         or alternatively switch to a specific calendar.
       */
    }

    BwDateTime fromDate = null;

    if (!form.getListAllEvents()) {
      fromDate = todaysDateTime(form);
    }

    return form.fetchSvci().getEvents(null, filter, fromDate, null,
                                       CalFacadeDefs.retrieveRecurExpanded);
  }

  private BwDateTime todaysDateTime(PEActionForm form) throws Throwable {
    return CalFacadeUtil.getDateTime(new java.util.Date(System.currentTimeMillis()),
                                     true, false,
                                     form.fetchSvci().getTimezones());
  }
}

