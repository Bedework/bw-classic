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
package edu.rpi.cct.uwcal.access;

import java.io.Serializable;

/** Some privilege definitions.
 *
 *  @author Mike Douglass   douglm@rpi.edu
 */
public interface PrivilegeDefs extends Serializable {
  /* old allowed and old denied allow us to respecify the flags allowing for
   * inherited access
   */
  /** Old allowed flag - appears in old acls being converted to new form
   */
  public static final char oldAllowed = '3';

  /** Old denied privilege.
   */
  public static final char oldDenied = '2';

  /* The following flags must sort with values in the order:
   * allowed, denied, allowedInherited, deniedInherited, unspecified.
   */

  /** Allowed flag - appears in acls
   */
  public static final char allowed = 'y';

  /** A denied privilege is a privilege, e.g. read which is denied to the
     associated 'who' - appears in ace.
   */
  public static final char denied = 'n';

  /** This only appears in the final result from Privileges.fromEncoding
   */
  public static final char allowedInherited = 'Y';

  /** This only appears in the final result from Privileges.fromEncoding
   */
  public static final char deniedInherited = 'N';

  /** This only appears in the final result from Privileges.fromEncoding
   */
  public static final char unspecified = '?';

  /** Shows an ace was inherited - appears in ace
   */
  public static final char inheritedFlag = 'I';

  // ENUM
  /** Define a privilege type index
   */

  /** All access
   */
  public static final int privAll = 0;

  /** Read access
   */
  public static final int privRead = 1;

  /** Read acl access
   */
  public static final int privReadAcl = 2;

  /** read current user privs access
   */
  public static final int privReadCurrentUserPrivilegeSet = 3;

  /** Read free busy access
   */
  public static final int privReadFreeBusy = 4;

  /** Write access
   */
  public static final int privWrite = 5;

  /** Write acl access
   */
  public static final int privWriteAcl = 6;

  /** Write properties access
   */
  public static final int privWriteProperties = 7;

  /** Write content (change) access
   */
  public static final int privWriteContent = 8;

  /** Bind (create) access
   */
  public static final int privBind = 9;

  /** Unbind (destroy) access
   */
  public static final int privUnbind = 10;

  /** Unlock access
   */
  public static final int privUnlock = 11;

  /** Deny all access - used frequently? */
  public static final int privNone = 12;

  /** Max access index
   */
  public static final int privMaxType = 12;

  /** Indicate any allowed access will do
   */
  public static final int privAny = privMaxType + 1;


  /* !!!!!!!!!!!!!!!!!! need default access - i.e. remove any mention of who
   */

  /** Single char encoding
   */
  public final static char[] privEncoding = {
    'A',     // privAll

    'R',     // privRead
    'r',     // privReadAcl
    'P',     // privReadCurrentUserPrivilegeSet
    'F',     // privReadFreeBusy

    'W',     // privWrite
    'a',     // privWriteAcl
    'p',     // privWriteProperties
    'c',     // privWriteContent
    'b',     // privBind
    'u',     // privUnbind

    'U',     // privUnlock

    'N',     // privNone
  };

  /** Default privs for an owner
   * /
  public char[] defaultOwnerPrivileges = {
    allowed,   // privAll
    allowed,   // privRead
    allowed,   // privReadAcl
    allowed,   // privReadCurrentUserPrivilegeSet
    allowed,   // privReadFreeBusy
    allowed,   // privWrite
    allowed,   // privWriteAcl
    allowed,   // privWriteProperties
    allowed,   // privWriteContent
    allowed,   // privBind
    allowed,   // privUnbind
    allowed,   // privUnlock
    allowed,   // privNone
  };

  /** User home max privileges for non-super user
   * This allows us to turn off privileges which would allow delete or rename
   * for example.
   * /
  public char[] userHomeMaxPrivileges = {
     denied,   // privAll
    allowed,   // privRead
    allowed,   // privReadAcl
    allowed,   // privReadCurrentUserPrivilegeSet
    allowed,   // privReadFreeBusy
     denied,   // privWrite
    allowed,   // privWriteAcl
    allowed,   // privWriteProperties
    allowed,   // privWriteContent
     denied,   // privBind
     denied,   // privUnbind
    allowed,   // privUnlock
    allowed,   // privNone
  };

  /** Default privs for a non owner
   * /
  public char[] defaultNonOwnerPrivileges = {
    denied,   // privAll
    denied,   // privRead
    denied,   // privReadAcl
    denied,   // privReadCurrentUserPrivilegeSet
    denied,   // privReadFreeBusy
    denied,   // privWrite
    denied,   // privWriteAcl
    denied,   // privWriteProperties
    denied,   // privWriteContent
    denied,   // privBind
    denied,   // privUnbind
    denied,   // privUnlock
    denied,   // privNone
  };*/

}

