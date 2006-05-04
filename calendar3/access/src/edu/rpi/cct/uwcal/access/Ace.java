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
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

/** Oject to represent an ace for a calendar entity or service.
 *
 * <p>An ACE consists of a 'who' and a denied or allowed 'how'. We encode
 * this as a sequence of characters with the who being a length encoded as
 * digits a blank then the characters.
 *
 * <p>The 'how' part is encoded as an allow/deny character followed by the
 * encoded privilege.
 *
 * <p>Encoded form is as follows:<ul>
 * <li><em>Byte 1</em><br/>
 * notWho or whoFlag </li>
 *
 * <li><em>Byte 2</em><br/>
 * whoType,   owner, user, group etc. </li>
 *
 * <li><em>Bytes 3...x</em><br/>
 * Encoded string who {@link EncodedAcl#encodeString(String)} </li>
 *
 * <li><em>Bytes x onwards</em><br/>
 * Encoded prvileges </li>
 * </ul>
 *
 * <p>The compareTo method orders the Aces according to the notWho, whoType and
 * who components. It does not take the actual privileges into account. There
 * should only be one entry per the above combination and the latest one on the
 * path should stand.
 *
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class Ace implements PrivilegeDefs, Serializable, Comparable {
  boolean debug;

  /* Who defines a principal, NotWho means the principal must not be
     defined by the 'who',e.g NOT IN group bgroup
   */
  private static final char whoFlag = 'W';
  private static final char notWhoFlag = 'N';

  private static final char whoFlagOwner = 'O';
  private static final char whoFlagUser = 'U';
  private static final char whoFlagGroup = 'G';
  private static final char whoFlagHost = 'H';
  private static final char whoFlagUnauthenticated = 'X';
  private static final char whoFlagAuthenticated = 'A';
  private static final char whoFlagOther = 'Z';
  private static final char whoFlagAll = 'L';

  /** Define for whom we are checking access */

  /** The entity owner */
  public static final int whoTypeOwner = 0;

  /** A named user */
  public static final int whoTypeUser = 1;

  /** A named group */
  public static final int whoTypeGroup = 2;

  /** A named host */
  public static final int whoTypeHost = 3;  // Named host

  /** An unauthenticated user */
  public static final int whoTypeUnauthenticated = 4;  // Unauthenticated user

  /** An authenticated user */
  public static final int whoTypeAuthenticated = 5;  // Authenticated user

  /** Somebody other than the owner */
  public static final int whoTypeOther = 6;

  /** Anywho */
  public static final int whoTypeAll = 7; // Unauth + auth

  private static final char[] whoTypeFlags = {
    whoFlagOwner,
    whoFlagUser,
    whoFlagGroup,
    whoFlagHost,
    whoFlagUnauthenticated,
    whoFlagAuthenticated,
    whoFlagOther,
    whoFlagAll
  };

  /** String name of each who type. These are keys to the resources for locale
   * specific displays
   *
   * @see edu.rpi.cct.uwcal.resources.UWCalResources
   */
  private static final String[] whoTypeNames = {
    "owner",              // whoTypeOwner,
    "user",               // whoTypeUser,
    "group",              // whoTypeGroup,
    "host",               // whoTypeHost,
    "unauthenticated",    // whoTypeUnauthenticated,
    "authenticated",      // whoTypeAuthenticated
    "other",              // whoFlagOther
    "all",                // whoFlagAll
  };

  private String who;

  private int whoType;

  private boolean notWho;

  /** array of allowed/denied/undefined indexed by Privilege index
   */
  private char[] how;

  /** Privilege objects defining the access. Used when manipulating acls
   */
  Collection privs;

  private boolean inherited;

  /** Constructor
   */
  public Ace() {
    this(false);
  }

  /** Constructor
   *
   * @param debug
   */
  public Ace(boolean debug) {
    this.debug = debug;
  }

  /** Constructor
   *
   * @param who
   * @param notWho
   * @param whoType
   * @param how
   */
  public Ace(String who,
             boolean notWho,
             int whoType,
             char[] how) {
    this.who = who;
    this.notWho = notWho;
    this.whoType = whoType;
    this.how = how;
  }

  /** Constructor
   *
   * @param who
   * @param notWho
   * @param whoType
   * @param p
   */
  public Ace(String who,
             boolean notWho,
             int whoType,
             Privilege p) {
    this.who = who;
    this.notWho = notWho;
    this.whoType = whoType;
    addPriv(p);
  }

  /** Constructor
   *
   * @param who
   * @param notWho
   * @param whoType
   */
  public Ace(String who,
             boolean notWho,
             int whoType) {
    this.who = who;
    this.notWho = notWho;
    this.whoType = whoType;
  }

  /** Set who this entry is for
   *
   * @param val
   */
  public void setWho(String val) {
    who = val;
  }

  /** Get who this entry is for
   *
   * @return String who
   */
  public String getWho() {
    return who;
  }

  /** Set the who/not who flag
   *
   * @param val
   */
  public void setNotWho(boolean val) {
    notWho = val;
  }

  /**
   *
   * @return boolean who/not who flag
   */
  public boolean getNotWho() {
    return notWho;
  }

  /** Set type of who
   *
   * @param val
   */
  public void setWhoType(int val) {
    whoType = val;
  }

  /**
   *
   * @return boolean  type of who
   */
  public int getWhoType() {
    return whoType;
  }

  /**
   * @param val char[] array of allowed/denied/undefined indexed by Privilege index
   */
  public void setHow(char[] val) {
    how = val;
  }

  /**
   *
   * @return char[] array of allowed/denied/undefined indexed by Privilege index
   */
  public char[] getHow() {
    return how;
  }

  /**
   *
   * @param val Collection of Privilege objects defining the access. Used when manipulating acls
   */
  public void setPrivs(Collection val) {
    privs = val;
  }

  /**
   *
   * @return Collection of Privilege objects defining the access. Used when manipulating acls
   */
  public Collection getPrivs() {
    if (privs == null) {
      privs = new ArrayList();
    }
    return privs;
  }

  /**
   *
   * @param val Privilege to add to Collection
   */
  public void addPriv(Privilege val) {
    getPrivs().add(val);
  }

  /** An ace is inherited if it is merged in from further up the path.
   *
   * @param val
   */
  public void setInherited(boolean val) {
    inherited = val;
  }

  /**
   * @return boolean
   */
  public boolean getInherited() {
    return inherited;
  }

  /** Return the merged privileges for all aces which match the name and whoType.
   *
   * @param acl
   * @param name
   * @param whoType
   * @return char[]    merged privileges if we find a match else null
   * @throws AccessException
   */
  public static char[] findMergedPrivilege(Acl acl,
                                           String name, int whoType) throws AccessException {
    char[] privileges = null;
    Iterator it = acl.getAces().iterator();

    while (it.hasNext()) {
      Ace ace = (Ace)it.next();

      if ((whoType == ace.getWhoType()) &&
          ((whoType == whoTypeUnauthenticated) ||
           (whoType == whoTypeOwner) ||
            ace.whoMatch(name))) {
        privileges = mergePrivileges(privileges, ace.getHow(),
                                     ace.getInherited());
      }
    }

    return privileges;
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
   * @return char[]  mergedPrivileges
   */
  public static char[] mergePrivileges(char[] current, char[] morePriv,
                                       boolean inherited) {
    char[] mp = (char[])morePriv.clone();

    if (inherited) {
      for (int i = 0; i <= privMaxType; i++) {
        char p = mp[i];
        if (p == allowed) {
          mp[i] = allowedInherited;
        } else if (p == denied) {
          mp[i] = deniedInherited;
        }
      }
    }
    if (current == null) {
      return mp;
    }

    for (int i = 0; i <= privMaxType; i++) {
      if (current[i] < mp[i]) {
        current[i] = mp[i];
      }
    }

    return current;
  }

  /* ====================================================================
   *                 Decoding methods
   * ==================================================================== */

  /** Skip over an ace
   *
   * @param acl
   * @throws AccessException
   */
  public void skip(EncodedAcl acl) throws AccessException {
    acl.skipString();
    while (acl.getChar() != ' ') {
    }
  }

  /** Search through the acl for a who that matches the given name and type..
   *
   * <p>That is, if we have a whoFlag and the String matches or a
   * notWhoFlag and the string does not match then return the length of
   * the entire 'who' section.
   *
   * <p>NOTE - I'm not sure of some of the semantics of the NOT thing. It's
   * pretty clear that matching a user is more specific than matching a
   * group but what's the inverted meaning?
   *
   * <p>If getPrivileges is true the Collection of privilege objects
   * defining the ace will be returned. This is needed for acl
   * manipulation rather than evaluation.
   *
   * @param acl
   * @param getPrivileges
   * @param name
   * @param whoType
   * @return boolean true if we find a match
   * @throws AccessException
   */
  public boolean decode(EncodedAcl acl,
                        boolean getPrivileges,
                        String name, int whoType) throws AccessException {
    acl.rewind();

    while (acl.hasMore()) {
      decodeWhoType(acl);

      if ((whoType != getWhoType()) || !whoMatch(name)) {
        skipHow(acl);
      } else {
        decodeHow(acl, getPrivileges);
        return true;
      }
    }

    return false;
  }

  /** Get the next ace in the acl.
   *
   * <p>If .getPrivileges is true the Collection of privilege objects
   * defining the ace will be returned. This is needed for acl
   * manipulation rather than evaluation.
   *
   * @param acl
   * @param getPrivileges
   * @throws AccessException
   */
  public void decode(EncodedAcl acl,
                     boolean getPrivileges) throws AccessException {
    decodeWhoType(acl);
    decodeHow(acl, getPrivileges);
  }

  /* ====================================================================
   *                 Encoding methods
   * ==================================================================== */

  /** Encode this object as a sequence of char. privs must have been set.
   *
   * @param acl   EncodedAcl
   * @throws AccessException
   */
  public void encode(EncodedAcl acl) throws AccessException {
    if (notWho) {
      acl.addChar(notWhoFlag);
    } else {
      acl.addChar(whoFlag);
    }

    acl.addChar(whoTypeFlags[whoType]);

    acl.encodeString(who);

    Iterator it = getPrivs().iterator();
    while (it.hasNext()) {
      Privilege p = (Privilege)it.next();
      p.encode(acl);
    }

    if (inherited) {
      acl.addChar(PrivilegeDefs.inheritedFlag);
    }

    acl.addChar(' ');  // terminate privs.
  }

  /** Provide a string representation for user display - this should probably
   * use a localized resource and be part of a display level. It also requires
   * the Privilege objects
   *
   * @return String representation
   */
  public String toUserString() {
    StringBuffer sb = new StringBuffer("(");

    if (getNotWho()) {
      sb.append("NOT ");
    }

    sb.append(whoTypeNames[whoType]);

    if ((whoType == whoTypeUser) ||
        (whoType == whoTypeGroup) ||
        (whoType == whoTypeHost)) {
      sb.append("=");
      sb.append(getWho());
    }

    sb.append(" ");

    Iterator it = privs.iterator();
    while (it.hasNext()) {
      Privilege p = (Privilege)it.next();
      sb.append(p.toUserString());
      sb.append(" ");
    }
    sb.append(")");

    return sb.toString();
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compareTo(Object o) {
    if (this == o) {
      return 0;
    }

    if (!(o instanceof Ace)) {
      return 1;
    }

    Ace that = (Ace)o;
    if (notWho != that.notWho) {
      if (notWho) {
        return -1;
      }
      return 1;
    }

    if (whoType < that.whoType) {
      return -1;
    }

    if (whoType > that.whoType) {
      return 1;
    }

    return compareWho(who, that.who);
  }

  public int hashCode() {
    int hc = 7;

    if (who != null) {
      hc *= who.hashCode();
    }

    if (notWho) {
      hc *= 2;
    }

    return hc *= whoType;
  }

  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }

    if (!(o instanceof Ace)) {
      return false;
    }

    Ace that = (Ace)o;

    return sameWho(who, that.who) &&
           (notWho == that.notWho) &&
           (whoType == that.whoType);
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("AceVO{who=");
    sb.append(who);
    sb.append(", notWho=");
    sb.append(notWho);
    sb.append(", whoType=");
    sb.append(whoTypeNames[whoType]);
    sb.append("(");
    sb.append(whoType);
    sb.append(")");
    if (how != null) {
      sb.append(", how=");
      sb.append(how);
    }

    sb.append(", \nprivs=[");

    Iterator it = getPrivs().iterator();
    while (it.hasNext()) {
      Privilege p = (Privilege)it.next();
      sb.append(p.toString());
      sb.append("\n");
    }
    sb.append("]");

    sb.append("}");

    return sb.toString();
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private boolean sameWho(String who1, String who2) {
    return compareWho(who1, who2) == 0;
  }

  private int compareWho(String who1, String who2) {
    if ((who1 == null) && (who2 == null)) {
      return 0;
    }

    if (who1 == null) {
      return -1;
    }

    if (who2 == null) {
      return 1;
    }

    return who1.compareTo(who2);
  }

  private boolean whoMatch(String name) {
    if ((name == null) && (getWho() == null)) {
      return !getNotWho();
    }

    if ((name == null) || (getWho() == null)) {
      return getNotWho();
    }

    boolean match = name.equals(getWho());
    if (getNotWho()) {
      match = !match;
    }

    return match;
  }

  private void decodeWhoType(EncodedAcl acl) throws AccessException {
    char c = acl.getChar();

    if (c == notWhoFlag) {
      notWho = true;
    } else if (c == whoFlag) {
      notWho = false;
    } else {
      throw AccessException.badACE("who/notWho flag");
    }

    c = acl.getChar();

    getWhoType:{
      for (whoType = 0; whoType < whoTypeFlags.length; whoType++) {
        if (c == whoTypeFlags[whoType]) {
          break getWhoType;
        }
      }

      throw AccessException.badACE("who type");
    }

    setWho(acl.getString());
  }

  private void skipHow(EncodedAcl acl) throws AccessException {
    Privileges.skip(acl);
  }

  private void decodeHow(EncodedAcl acl,
                         boolean getPrivileges) throws AccessException {
    int pos = acl.getPos();
    setHow(Privileges.fromEncoding(acl));
    if (getPrivileges) {
      acl.setPos(pos);
      setPrivs(Privileges.getPrivs(acl));
    }

    // See if we got an inherited flag
    acl.back();
    if (acl.getChar() == PrivilegeDefs.inheritedFlag) {
      inherited = true;
      if (acl.getChar() != ' ') {
        throw new AccessException("malformedAcl");
      }
    }
  }
}

