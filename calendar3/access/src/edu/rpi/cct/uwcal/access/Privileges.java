/*
 Copyright (c]) 2000-2005 University of Washington.  All rights reserved.

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
   NEGLIGENCE]) OR STRICT LIABILITY, ARISING OUT OF OR IN CONNECTION WITH
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
package edu.rpi.cct.uwcal.access;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

/** Define the privileges we recognize for the calendar.
 *
 * <p>These are based on webdav + caldav privileges and are flagged below as
 * W for webdav and C for caldav
 *
 * <p>Ideally we will initialise this once per session and reuse the objects
 * during processing.
 *
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class Privileges implements PrivilegeDefs {
  /* Webdav access control defines privileges in terms of a tree of rights.
     Here we define that tree (based on the RFC3744 description]).

     [DAV: all]  'A'
        |
        +-- [DAV: read] 'R'
               |
               +-- [DAV: read-acl]  'r'
               +-- [DAV: read-current-user-privilege-set] 'P'
               +-- [CALDAV:view-free-busy] 'F'
        |
        +-- [DAV: write] 'W'
               |
               +-- [DAV: write-acl] 'a'
               +-- [DAV: write-properties] 'p'
               +-- [DAV: write-content] 'c'
               +-- [DAV: bind] 'b'
               +-- [DAV: unbind] 'u'
        |
        +-- [DAV: unlock] 'U'

     We encode the acl as a character sequence. Privileges within that sequence
     are flagged by the characters above. The sequence of privileges is terminated
     by a blank, e.g.
              "ARAW "   is read write
              "DW "   is write denied

     We try not to expand acls but parse the character string to determine
     the allowed access. However, for acl manipulation which occurs much less
     frequently it is usually better to expand.
   */

  private final static Privilege[] privs = new Privilege[privMaxType + 1];

  static {
    privs[privAll] = new Privilege("all", "All privileges", privAll);

    privs[privRead] = new Privilege("read", "Read any calendar object", privRead);

    privs[privReadAcl] = new Privilege("read-acl", "Read calendar accls",
                                       privReadAcl);

    privs[privReadCurrentUserPrivilegeSet] =
      new Privilege("read-current-user-privilege-set",
                    "Read current user privilege set property",
                    privReadCurrentUserPrivilegeSet);

    privs[privReadFreeBusy] = new Privilege("view-free-busy",
                                            "View a users free busy information",
                                            privReadFreeBusy);

    privs[privWrite] = new Privilege("write", "Write any calendar object",
                                     privWrite);

    privs[privWriteAcl] = new Privilege("write-acl", "Write ACL", privWriteAcl);

    privs[privWriteProperties] = new Privilege("write-properties",
                                               "Write calendar properties",
                                               privWriteProperties);

    privs[privWriteContent] = new Privilege("write-content",
                                            "Write calendar content",
                                            privWriteContent);

    privs[privBind] = new Privilege("create", "Create a calendar object",
                                    privBind);

    privs[privUnbind] = new Privilege("delete", "Delete a calendar object",
                                      privUnbind);

    privs[privUnlock] = new Privilege("unlock", "Remove a lock",
                                      privUnlock);

    privs[privAll].addContainedPrivilege(privs[privRead]);
    privs[privAll].addContainedPrivilege(privs[privWrite]);
    privs[privAll].addContainedPrivilege(privs[privUnlock]);

    privs[privRead].addContainedPrivilege(privs[privReadAcl]);
    privs[privRead].addContainedPrivilege(privs[privReadCurrentUserPrivilegeSet]);
    privs[privRead].addContainedPrivilege(privs[privReadFreeBusy]);

    privs[privWrite].addContainedPrivilege(privs[privWriteAcl]);
    privs[privWrite].addContainedPrivilege(privs[privWriteProperties]);
    privs[privWrite].addContainedPrivilege(privs[privWriteContent]);
    privs[privWrite].addContainedPrivilege(privs[privBind]);
    privs[privWrite].addContainedPrivilege(privs[privUnbind]);

    privs[privNone] = Privilege.cloneDenied(privs[privAll]);
  }

  /** Constructor
   *
   */
  private Privileges() {
  }

  /**
   * @return Privilege defining all access
   */
  public static Privilege getPrivAll() {
    return privs[privAll];
  }

  /**
   * @return Privilege defining no access
   */
  public static Privilege getPrivNone() {
    return privs[privNone];
  }

  /** make a privilege defining the given priv type
   *
   * @param privType int access
   * @return Privilege defining access
   */
  public static Privilege makePriv(int privType) {
    return /*(Privilege)*/privs[privType]/*.clone()*/;
  }

  /** Returns a set of flags indicating if the indexed privilege (see above
   * for index) is allowed, denied or unspecified.
   *
   * @param acl
   * @return char[] access flags
   * @throws AccessException
   */
  public static PrivilegeSet fromEncoding(EncodedAcl acl) throws AccessException {
    char[] privStates = {
      unspecified,   // privAll
      unspecified,   // privRead
      unspecified,   // privReadAcl
      unspecified,   // privReadCurrentUserPrivilegeSet
      unspecified,   // privReadFreeBusy
      unspecified,   // privWrite
      unspecified,   // privWriteAcl
      unspecified,   // privWriteProperties
      unspecified,   // privWriteContent
      unspecified,   // privBind
      unspecified,   // privUnbind
      unspecified,   // privUnlock
      unspecified,   // privNone
    };

    while (acl.hasMore()) {
      char c = acl.getChar();
      if ((c == ' ') || (c == inheritedFlag)) {
        break;
      }
      acl.back();

      Privilege p = Privilege.findPriv(privs[privAll], privs[privNone], acl);
      if (p == null) {
        throw AccessException.badACL("unknown priv " + acl.getErrorInfo());
      }

      //System.out.println("found " + p);\

      // Set the states based on the priv we just found.
      setState(privStates, p, p.getDenial());
    }

    return new PrivilegeSet(privStates);
  }

  /** Skip all the privileges info.
   *
   * @param acl
   * @throws AccessException
   */
  public static void skip(EncodedAcl acl) throws AccessException {
    while (acl.hasMore()) {
      char c = acl.getChar();
      if ((c == ' ') || (c == inheritedFlag)) {
        break;
      }
    }
  }

  /** Returns the collection of privilege objects representing the access.
   * Used for acl manipulation..
   *
   * @param acl
   * @return Collection
   * @throws AccessException
   */
  public static Collection getPrivs(EncodedAcl acl) throws AccessException {
    ArrayList al = new ArrayList();

    while (acl.hasMore()) {
      char c = acl.getChar();
      if ((c == ' ') || (c == inheritedFlag)) {
        break;
      }
      acl.back();

      Privilege p = Privilege.findPriv(privs[privAll], privs[privNone], acl);
      if (p == null) {
        throw AccessException.badACL("unknown priv");
      }

      al.add(p);
    }

    return al;
  }

  private static void setState(char[] states, Privilege p, boolean denial) {
    if (!denial) {
      states[p.getIndex()] = allowed;
    } else {
      states[p.getIndex()] = denied;
    }

    /* Iterate over the children */

    Iterator it = p.iterateContainedPrivileges();
    while (it.hasNext()) {
      setState(states, (Privilege)it.next(), denial);
    }
  }
}

