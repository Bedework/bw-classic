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

/** Allowed privileges for a principal
 *
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class PrivilegeSet implements Serializable, PrivilegeDefs, Comparable {
  private char[] privileges;

  /** Default privs for an owner
   */
  public static PrivilegeSet defaultOwnerPrivileges =
    new PrivilegeSet(denied,   // privAll
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
                     denied);   // privNone

  /** User home max privileges for non-super user
   * This allows us to turn off privileges which would allow delete or rename
   * for example.
   */
  public static PrivilegeSet userHomeMaxPrivileges =
    new PrivilegeSet(denied,   // privAll
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
                     allowed);   // privNone

  /** Default privs for a non owner
   */
  public static PrivilegeSet defaultNonOwnerPrivileges =
    new PrivilegeSet(denied,   // privAll
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
                     denied);   // privNone

  /**
   * @param privAllState
   * @param privReadState
   * @param privReadAclState
   * @param privReadCurrentUserPrivilegeSetState
   * @param privReadFreeBusyState
   * @param privWriteState
   * @param privWriteAclState
   * @param privWritePropertiesState
   * @param privWriteContentState
   * @param privBindState
   * @param privUnbindState
   * @param privUnlockState
   * @param privNoneState
   */
  public PrivilegeSet(char privAllState,
                      char privReadState,
                      char privReadAclState,
                      char privReadCurrentUserPrivilegeSetState,
                      char privReadFreeBusyState,
                      char privWriteState,
                      char privWriteAclState,
                      char privWritePropertiesState,
                      char privWriteContentState,
                      char privBindState,
                      char privUnbindState,
                      char privUnlockState,
                      char privNoneState) {
    privileges = new char[privMaxType + 1];

    privileges[privAll] = privAllState;
    privileges[privRead] = privReadState;
    privileges[privReadAcl] = privReadAclState;
    privileges[privReadCurrentUserPrivilegeSet] = privReadCurrentUserPrivilegeSetState;
    privileges[privReadFreeBusy] = privReadFreeBusyState;
    privileges[privWrite] = privWriteState;
    privileges[privWriteAcl] = privWriteAclState;
    privileges[privWriteProperties] = privWritePropertiesState;
    privileges[privWriteContent] = privWriteContentState;
    privileges[privBind] = privBindState;
    privileges[privUnbind] = privUnbindState;
    privileges[privUnlock] = privUnlockState;
    privileges[privNone] = privNoneState;
  }

  /**
   * @param privileges
   */
  public PrivilegeSet(char[] privileges) {
    this.privileges = privileges;
  }

  /**
   */
  public PrivilegeSet() {
    privileges = (char[])defaultNonOwnerPrivileges.getPrivileges().clone();
  }

  /** Default privs for an owner
   *
   * @return PrivilegeSet
   */
  public static PrivilegeSet makeDefaultOwnerPrivileges() {
    return (PrivilegeSet)defaultOwnerPrivileges.clone();
  }

  /** User home max privileges for non-super user
   * This allows us to turn off privileges which would allow delete or rename
   * for example.
   *
   * @return PrivilegeSet
   */
  public static PrivilegeSet makeUserHomeMaxPrivileges() {
    return (PrivilegeSet)userHomeMaxPrivileges.clone();
  }

  /** Default privs for a non owner
   *
   * @return PrivilegeSet
   */
  public static PrivilegeSet makeDefaultNonOwnerPrivileges() {
    return (PrivilegeSet)defaultNonOwnerPrivileges.clone();
  }

  /** Set the given privilege
   *
   * @param index
   * @param val
   */
  public void setPrivilege(int index, char val) {
    if (privileges == null) {
      privileges = (char[])defaultNonOwnerPrivileges.getPrivileges().clone();
    }

    privileges[index] = val;
  }

  /** Set the given privilege
   *
   * @param priv  Privilege object
   */
  public void setPrivilege(Privilege priv) {
    if (privileges == null) {
      privileges = (char[])defaultNonOwnerPrivileges.getPrivileges().clone();
    }

    if (priv.getDenial()) {
      privileges[priv.getIndex()] = denied;
    } else {
      privileges[priv.getIndex()] = allowed;
    }
  }

  /** Get the given privilege
   *
   * @param index
   * @return char
   */
  public char getPrivilege(int index) {
    if (privileges == null) {
      return unspecified;
    }

    return privileges[index];
  }

  /** Ensure thsi privilegeset has no privilege greater than those in the filter
   *
   * @param filter
   */
  public void filterPrivileges(PrivilegeSet filter) {
    if (privileges == null) {
      privileges = (char[])defaultNonOwnerPrivileges.getPrivileges().clone();
    }

    char[] filterPrivs = filter.getPrivileges();

    for (int pi = 0; pi < privileges.length; pi++) {
      if (privileges[pi] > filterPrivs[pi]) {
        privileges[pi] = filterPrivs[pi];
      }
    }
  }

  /** Retrun true if there is any allowed access
   *
   * @return boolean
   */
  public boolean getAnyAllowed() {
    if (privileges == null) {
      return false;
    }

    for (int pi = 0; pi < privileges.length; pi++) {
      char pr = privileges[pi];

      if (pr == allowed) {
        return true;
      }

      if (pr == allowedInherited) {
        return true;
      }
    }

    return false;
  }

  /** If current is null it is set to a cloned copy of morePriv otherwise the
   * privilege(s) in morePriv are merged into current.
   *
   * <p>Specified access overrides inherited access,<br/>
   * allowed overrides denied overrides unspecified so the order is, from
   * highest to lowest:<br/>
   *
   * allowed, denied, allowedInherited, deniedInherited, unspecified.
   *
   * <p>Only allowed and denied appear in encoded aces.
   *
   * @param current
   * @param morePriv
   * @param inherited   true if the ace was an inherited ace
   * @return PrivilegeSet  mergedPrivileges
   */
  public static PrivilegeSet mergePrivileges(PrivilegeSet current,
                                             PrivilegeSet morePriv,
                                             boolean inherited) {
    PrivilegeSet mp = (PrivilegeSet)morePriv.clone();

    if (inherited) {
      for (int i = 0; i <= privMaxType; i++) {
        char p = mp.getPrivilege(i);
        if (p == allowed) {
          mp.setPrivilege(i, allowedInherited);
        } else if (p == denied) {
          mp.setPrivilege(i, deniedInherited);
        }
      }
    }

    if (current == null) {
      return mp;
    }

    for (int i = 0; i <= privMaxType; i++) {
      char priv = mp.getPrivilege(i);
      if (current.getPrivilege(i) < priv) {
        current.setPrivilege(i, priv);
      }
    }

    return current;
  }

  /** Set all unspecified values to allowed for the owner or denied otherwise.
   *
   * @param isOwner
   */
  public void setUnspecified(boolean isOwner) {
    for (int pi = 0; pi < privileges.length; pi++) {
      if (privileges[pi] == unspecified) {
        if (isOwner) {
          privileges[pi] = allowed;
        } else {
          privileges[pi] = denied;
        }
      }
    }
  }

  /**
   * @return char[]  privileges for this object
   */
  public char[] getPrivileges() {
    return privileges;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compareTo(Object o) {
    if (this == o) {
      return 0;
    }

    if (!(o instanceof PrivilegeSet)) {
      return 1;
    }

    PrivilegeSet that = (PrivilegeSet)o;
    if (privileges == null) {
      if (that.privileges != null) {
        return -1;
      }

      return 0;
    }

    if (that.privileges != null) {
      return -1;
    }

    for (int pi = 0; pi < privileges.length; pi++) {
      char thisp = privileges[pi];
      char thatp = that.privileges[pi];

      if (thisp < thatp) {
        return -1;
      }

      if (thisp > thatp) {
        return -1;
      }
    }

    return 0;
  }

  public int hashCode() {
    int hc = 7;

    if (privileges == null) {
      return hc;
    }

    for (int pi = 0; pi < privileges.length; pi++) {
      hc *= privileges[pi];
    }

    return hc;
  }

  public boolean equals(Object o) {
    return compareTo(o) == 0;
  }

  public Object clone() {
    return new PrivilegeSet((char[])getPrivileges().clone());
  }

  public String toString() {
    StringBuffer sb = new StringBuffer("PrivilegeSet[");

    sb.append(privileges);
    sb.append("]");

    return sb.toString();
  }
}
