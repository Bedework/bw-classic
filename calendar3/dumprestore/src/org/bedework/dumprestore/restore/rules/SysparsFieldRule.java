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
package org.bedework.dumprestore.restore.rules;

import org.bedework.calfacade.BwSystem;
import org.bedework.dumprestore.restore.RestoreGlobals;

/**
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class SysparsFieldRule extends EntityFieldRule {
  SysparsFieldRule(RestoreGlobals globals) {
    super(globals);
  }

  public void field(String name) throws Exception {
    BwSystem ent = (BwSystem)top();

    if (taggedEntityId(ent, name)) {
      return;
    }

    /* Any values set in syspars take precedence */

    if (name.equals("name")) {
      ent.setName(parval(globals.syspars.getName(), stringFld()));
    } else if (name.equals("tzid")) {
      ent.setTzid(parval(globals.syspars.getTzid(), stringFld()));
    } else if (name.equals("systemid")) {
       ent.setSystemid(parval(globals.syspars.getSystemid(), stringFld()));
    } else if (name.equals("publicCalendarRoot")) {
      ent.setPublicCalendarRoot(parval(globals.syspars.getPublicCalendarRoot(),
                                       stringFld()));
    } else if (name.equals("userCalendarRoot")) {
      ent.setUserCalendarRoot(parval(globals.syspars.getUserCalendarRoot(), stringFld()));
    } else if (name.equals("userDefaultCalendar")) {
      ent.setUserDefaultCalendar(parval(globals.syspars.getUserDefaultCalendar(), stringFld()));
    } else if (name.equals("defaultTrashCalendar")) {
      ent.setDefaultTrashCalendar(parval(globals.syspars.getDefaultTrashCalendar(), stringFld()));
    } else if (name.equals("userInbox")) {
      ent.setUserInbox(parval(globals.syspars.getUserInbox(), stringFld()));
    } else if (name.equals("userOutbox")) {
      ent.setUserOutbox(parval(globals.syspars.getUserOutbox(), stringFld()));
    } else if (name.equals("defaultUserViewName")) {
      ent.setDefaultUserViewName(parval(globals.syspars.getDefaultUserViewName(), stringFld()));

    } else if (name.equals("publicUser")) {
      ent.setPublicUser(parval(globals.syspars.getPublicUser(), stringFld()));

    } else if (name.equals("httpConnectionsPerUser")) {
      ent.setHttpConnectionsPerUser(parval(globals.syspars.getHttpConnectionsPerUser(),
                                           globals.sysparsSetHttpConnectionsPerUser,
                                           intFld()));
    } else if (name.equals("httpConnectionsPerHost")) {
      ent.setHttpConnectionsPerHost(parval(globals.syspars.getHttpConnectionsPerHost(),
                                           globals.sysparsSetHttpConnectionsPerHost,
                                           intFld()));
    } else if (name.equals("httpConnections")) {
      ent.setHttpConnections(parval(globals.syspars.getHttpConnections(),
                                    globals.sysparsSetHttpConnections,
                                    intFld()));

    } else if (name.equals("maxPublicDescriptionLength")) {
      ent.setMaxPublicDescriptionLength(intFld());
    } else if (name.equals("maxUserDescriptionLength")) {
      ent.setMaxUserDescriptionLength(intFld());
    } else if (name.equals("maxUserEntitySize")) {
      ent.setMaxUserEntitySize(intFld());
    } else if (name.equals("defaultUserQuota")) {
      if (globals.sysparsSetDefaultUserQuota) {
        ent.setDefaultUserQuota(globals.syspars.getDefaultUserQuota());
      } else {
        ent.setDefaultUserQuota(longFld());
      }

    } else if (name.equals("userauthClass")) {
      ent.setUserauthClass(parval(globals.syspars.getUserauthClass(), stringFld()));
    } else if (name.equals("mailerClass")) {
      ent.setMailerClass(parval(globals.syspars.getMailerClass(), stringFld()));
    } else if (name.equals("admingroupsClass")) {
      ent.setAdmingroupsClass(parval(globals.syspars.getAdmingroupsClass(), stringFld()));
    } else if (name.equals("usergroupsClass")) {
      ent.setUsergroupsClass(parval(globals.syspars.getUsergroupsClass(), stringFld()));
    } else {
      unknownTag(name);
    }
  }

  private int parval(int sysparVal, boolean isSet, int val) {
    if (isSet) {
      return sysparVal;
    }

    return val;
  }

  private String parval(String sysparVal, String val) {
    if (sysparVal != null) {
      return sysparVal;
    }

    return val;
  }
}
