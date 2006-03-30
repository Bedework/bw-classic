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

/** Class to handle access control. Because we may be evaluating access 
 * frequently we try do so without creating (many) objects.
 *
 * <p>This class is created for a session or perhaps a thread and reused to
 * evaluate access. For the manipulation of acls when changing them or
 * displaying allowed access, efficiency isn't such a  great concern so we
 * will normally represent the access as a  number of objects.
 *
 *  @author Mike Douglass   douglm @ rpi.edu
 */
public class Access implements Serializable {
  private boolean debug;

  /** The acl we use for evaluation of access.
   */
  private final static Acl acl = new Acl();

  /** Defines no access */
  public final static Privilege none = acl.makePriv(Privileges.privNone);

  /** Defines full access to an object */
  public final static Privilege all = acl.makePriv(Privileges.privAll);

  /** Defines read access to an object */
  public final static Privilege read = acl.makePriv(Privileges.privRead);

  /** Defines write access to an object */
  public final static Privilege write = acl.makePriv(Privileges.privWrite);

  /** Defines write access to an object */
  public final static Privilege writeContent = acl.makePriv(Privileges.privWriteContent);

  /** Privilege set giving read access to an object */
  public final static Privilege[] privSetRead = {read};

  /** Privilege set giving read/write access to an object */
  public final static Privilege[] privSetReadWrite = {read, write};

  /** Default access for public entities
   */
  private static String defaultPublicAccess;

  /** Default access for personal entities
   */
  private static String defaultPersonalAccess;

  /** Constructor
   *
   * @param debug    boolean true fro debug on
   * @throws AccessException
   */
  public Access(boolean debug) throws AccessException {
    this.debug = debug;
    acl.setDebug(debug);

    /** Calculate default access strings */

    /** Public - write owner, read others, read unauthenticated */
    acl.clear();
    acl.addAce(new Ace(null, false, Ace.whoTypeOwner, all));
    acl.addAce(new Ace(null, false, Ace.whoTypeOther, read));
    acl.addAce(new Ace(null, false, Ace.whoTypeUnauthenticated, read));
    defaultPublicAccess = new String(acl.encode());

    acl.clear();
    acl.addAce(new Ace(null, false, Ace.whoTypeOwner, all));
    acl.addAce(new Ace(null, false, Ace.whoTypeOther, none));
    defaultPersonalAccess = new String(acl.encode());
  }

  /** Get the default public access
   *
   * @return String value for default access
   */
  public String getDefaultPublicAccess() {
    return defaultPublicAccess;
  }

  /**
   *
   * @return String default user access
   */
  public String getDefaultPersonalAccess() {
    return defaultPersonalAccess;
  }

  /** Get a Privilege object representing the given access
   *
   * @param priv int access level
   * @return Privilege object defining access
   */
  public Privilege makePriv(int priv) {
    return acl.makePriv(priv);
  }

  /** Get the Privileges object from the defautl acl
   *
   * @param privs Privileges 
   * @return Privilege object defining access
   */
  public static Privileges getPrivs() {
    return acl.getPrivs();
  }

  /** Evaluating an ACL
   *
   * <p>The process of evaluating access is as follows:
   *
   * <p>For an unauthenticated (guest) user we look for an entry with an
   * unauthenticated 'who' field. If none exists access is denied othewise the
   * indicated privileges are used to determine access.
   *
   * <p>If the principal is authenticated there are a number of steps in the process
   * which are executed in the following order:
   *
   * <ol>
   * <li>If the principal is the owner then use the given access or the default.</li>
   *
   * <li>If there is a specific ACE for the user use that. </li>
   *
   * <li>Find all group entries for the given user's groups. If there is more than
   * one combine them with the more permissive taking precedence, e.g
   * write allowed overrides write denied
   * <p>If any group entries were found we're done.</li>
   *
   * <li>if there is an 'other' entry (i.e. not Owner) use that.</li>
   *
   * <li>if there is an authenticated entry use that.</li>
   *
   * <li>Otherwise apply defaults - for the owner full acccess, for any others no
   * access</li>
   *
   * @param who      Acl.Principal defining who is trying to get access
   * @param owner    String owner of object
   * @param how      Privilege set definign desired access
   * @param aclString String defining current acls for object
   * @return boolean allowed/disallowed
   * @throws AccessException
   */
  public boolean evaluateAccess(AccessPrincipal who, String owner,
                                Privilege[] how, String aclString)
          throws AccessException {
    return acl.evaluateAccess(who, owner, how, aclString.toCharArray());
  }

  /** convenience method
   *
   * @param who      Acl.Principal defining who is trying to get access
   * @param owner    String owner of object
   * @param how      Privilege set defining desired access
   * @param aclChars char[] defining current acls for object
   * @return boolean allowed/disallowed
   * @throws AccessException
   */
  public boolean evaluateAccess(AccessPrincipal who, String owner,
                                Privilege[] how, char[] aclChars)
          throws AccessException {
    return acl.evaluateAccess(who, owner, how, aclChars);
  }

  /** convenience method - check for read access
   *
   * @param who      Acl.Principal defining who is trying to get access
   * @param owner    String owner of object
   * @param aclChars char[] defining current acls for object
   * @return boolean allowed/disallowed
   * @throws AccessException
   */
  public boolean checkRead(AccessPrincipal who, String owner,
                           char[] aclChars)
          throws AccessException {
    return acl.evaluateAccess(who, owner, privSetRead, aclChars);
  }

  /** convenience method - check for read write access
   *
   * @param who      Acl.Principal defining who is trying to get access
   * @param owner    String owner of object
   * @param aclChars char[] defining current acls for object
   * @return boolean allowed/disallowed
   * @throws AccessException
   */
  public boolean checkReadWrite(AccessPrincipal who, String owner,
                                char[] aclChars)
          throws AccessException {
    return acl.evaluateAccess(who, owner, privSetReadWrite, aclChars);
  }

  /** convenience method - check for given access
   *
   * @param who      Acl.Principal defining who is trying to get access
   * @param owner    String owner of object
   * @param priv     int desired access as defined above
   * @param aclChars char[] defining current acls for object
   * @return boolean allowed/disallowed
   * @throws AccessException
   */
  public boolean evaluateAccess(AccessPrincipal who, String owner,
                                int priv, char[] aclChars)
          throws AccessException {
    if (debug) {
    }

    return acl.evaluateAccess(who, owner,
                              new Privilege[]{acl.makePriv(priv)},
                              aclChars);
  }
}

