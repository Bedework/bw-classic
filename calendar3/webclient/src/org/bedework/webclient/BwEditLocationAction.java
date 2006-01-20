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

package org.bedework.webclient;

import org.bedework.calfacade.BwLocation;
import org.bedework.calsvci.CalSvcI;


import javax.servlet.http.HttpServletRequest;

/**
 * Action to edit a Location
 *
 * <p>Request parameters<ul>
 *      <li>"updateLocation=anything" means we should try to update the current
 * location in form.editLocation.</li>
 *      <li>"locationId=nnn"    id of location to fetch for editing.</li>
 * </ul>
 *.
 * <p>Forwards to:<ul>
 *      <li>"doNothing"    for guest mode/invalid id or non-exiting location.</li>
 *      <li>"edit"         to edit the location.</li>
 *      <li>"success"      changes made.</li>
 * </ul>
 *
 * <p>Errors:<ul>
 *      <li>org.bedework.error.noaccess - when user has insufficient
 *            access (tries to edit public location)</li>
 * </ul>
 */
public class BwEditLocationAction extends BwCalAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webclient.BwCalAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webclient.BwActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwActionForm form) throws Throwable {
    if (form.getGuest()) {
      // Just ignore this
      return "doNothing";
    }

    String reqpar = request.getParameter("updateLocation");
    if (reqpar != null) {
      return updateLocation(request, form);
    }

    int locationId = form.getLocationId();

    if (locationId <= 0) {
      // Do nothing
      return "doNothing";
    }

    BwLocation loc = form.getCalSvcI().getLocation(locationId);

    if (loc == null) {
      return "doNothing";
    }

    if (loc.getPublick()) {
      form.getErr().emit("org.bedework.error.noaccess", "for that action");
      return "doNothing";
    }

    form.setEditLocation(loc);

    return "edit";
  }

  /** Update the db with the location in editLocation.
   *
   * @param request   Needed to locate session
   * @param form      Action form
   * @return String   forward name
   * @throws Throwable
   */
  public String updateLocation(HttpServletRequest request,
                               BwActionForm form) throws Throwable {
    CalSvcI svci = form.getCalSvcI();
    BwLocation loc = form.getEditLocation();

    svci.replaceLocation(loc);

    form.refreshIsNeeded();

    return "success";
  }
}
