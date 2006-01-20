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
package org.bedework.calfacade.svc;

import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.ifs.Groups;

/** An interface to handle calendar admin groups.
 *
 * <p>Groups may be stored in a site specific manner so the actual
 * implementation used is a build-time configuration option. They may be
 * ldap directory based or implemented by storing in the calendar database.
 *
 * <p>Methods may throw an unimplemented exception if functions are not
 * available.
 *
 * <p>If a user is a member of more than one group the admin client should
 * ask which group they want.
 *
 * <p>Events etc are owned by the group which has it's own owner id. It's
 * important that the group owner ids are distinct from user ids. This is
 * dealt with by a configurable prefix and suffix appended to all group ids.
 *
 * <p>If a user is not a member of any group they own the events.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 2.2
 */
public interface AdminGroups extends Groups {
  /** Find a group given the event owner.
   *
   * @param  owner          BwUser event owner
   * @return BwAdminGroup   group object
   * @exception CalFacadeException If there's a problem
   */
  public BwAdminGroup findGroupByEventOwner(BwUser owner)
      throws CalFacadeException;
}
