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
package org.bedework.calcore.hibernate;

import edu.rpi.cct.uwcal.access.Access;
import edu.rpi.cct.uwcal.access.Ace;
import edu.rpi.cct.uwcal.access.Acl;
import edu.rpi.cct.uwcal.access.PrivilegeDefs;
import edu.rpi.cct.uwcal.access.Acl.CurrentAccess;

import org.bedework.calfacade.base.BwShareableContainedDbentity;
import org.bedework.calfacade.base.BwShareableDbentity;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeAccessException;
import org.bedework.calfacade.CalFacadeException;

import org.apache.log4j.Logger;

import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeSet;

/** An access helper class
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
class AccessUtil implements PrivilegeDefs {
  private boolean debug;

  /** For evaluating access control
   */
  private Access access;

  private boolean superUser;

  private BwUser authUser;

  private transient Logger log;

  /* Information created and saved about access on a given path.
   */
  private class PathInfo implements Serializable {
    String path;   // The key
    Acl pathAcl;   // Merged acl for the path.
    char[] encoded;
  }

  private HashMap pathInfoTable = new HashMap();

  /* ====================================================================
   *                   Constructor
   * ==================================================================== */

  AccessUtil(boolean debug) throws CalFacadeException {
    this.debug = debug;
    try {
      access = new Access(debug);
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  void setSuperUser(boolean val) {
    superUser = val;
  }
  
  boolean getSuperUser() {
    return superUser;
  }
  
  void setAuthUser(BwUser val) {
    authUser = val;
  }

  /** Called at request start
   *
   */
  public void open() {
  }

  /** Called at request end
   *
   */
  public void close() {
  }

  /* ====================================================================
   *                   Access control
   * ==================================================================== */

  /** Get the default public access
   *
   * @return String value for default access
   */
  public String getDefaultPublicAccess() {
    return access.getDefaultPublicAccess();
  }

  /**
   *
   * @return String default user access
   */
  public String getDefaultPersonalAccess() {
    return access.getDefaultPersonalAccess();
  }

  /** Change the access to the given calendar entity using the supplied aces.
   *
   * @param ent      BwShareableDbentity 
   * @param aces     Collection of ace objects
   * @throws CalFacadeException
   */
  public void changeAccess(BwShareableDbentity ent, 
                           Collection aces) throws CalFacadeException {
    try {
      Acl acl = checkAccess(ent, privWriteAcl, false).acl;

      Iterator it = aces.iterator();
      while (it.hasNext()) {
        Ace ace = (Ace)it.next();

        acl.removeAccess(ace);
        acl.addAce(ace);
      }

      ent.setAccess(new String(acl.encode()));
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /** Return a Collection of the objects after checking access
   *
   * @param ents          Collection of BwShareableDbentity
   * @param desiredAccess access we want
   * @param nullForNoAccess boolean flag behaviour on no access
   * @return Collection   of checked objects
   * @throws CalFacadeException for no access or other failure
   */
  public Collection checkAccess(Collection ents, int desiredAccess,
                                boolean nullForNoAccess)
          throws CalFacadeException {
    TreeSet out = new TreeSet();

    Iterator it = ents.iterator();

    while (it.hasNext()) {
      BwShareableDbentity sdbe = (BwShareableDbentity)it.next();
      if (checkAccess(sdbe, desiredAccess, nullForNoAccess).accessAllowed) {
        out.add(sdbe);
      }
    }

    return out;
  }

  /* Check access for the given entity. Returns the current access
   */
  CurrentAccess checkAccess(BwShareableDbentity ent, int desiredAccess,
                      boolean returnResult) throws CalFacadeException {
    if (ent == null) {
      return null;
    }

    if (debug) {
      String cname = ent.getClass().getName();
      getLog().debug("Check access for object " +
                     cname.substring(cname.lastIndexOf(".") + 1) +
                     " with id " + ent.getId());
    }

    try {
      CurrentAccess ca;
      String account = ent.getOwner().getAccount();
      
      char[] aclChars = getAclChars(ent);

      if (desiredAccess == privRead) {
        ca = access.checkRead(authUser, account, aclChars);
      } else if (desiredAccess == privWrite) {
        ca = access.checkReadWrite(authUser, account, aclChars);
      } else {
        ca = access.evaluateAccess(authUser, account, desiredAccess, aclChars);
      }

      if ((authUser != null) && superUser) {
        // Nobody can stop us - BWAAA HAA HAA
        ca.accessAllowed = true; 
      }
      
      if (!ca.accessAllowed && !returnResult) {
        throw new CalFacadeAccessException();
      }

      return ca;
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /* If the entity is not a calendar we merge the access in with the container
   * access then return the merged aces.
   *
   * For a calendar we just use the access for the calendar.
   *
   * The calendar/container access might be cached in the pathInfoTable.
   */
  private char[] getAclChars(BwShareableDbentity ent) throws CalFacadeException {
    if (ent instanceof BwShareableContainedDbentity) {
      BwCalendar container;

      if (ent instanceof BwCalendar) {
        container = (BwCalendar)ent;
      } else {
        container = ((BwShareableContainedDbentity)ent).getCalendar();
      }

      String path = container.getPath();
      PathInfo pi = (PathInfo)pathInfoTable.get(path);

      if (pi == null) {
        pi = getPathInfo(container);
        pathInfoTable.put(path, pi);
      }

      char[] aclChars = pi.encoded;

      if (ent instanceof BwCalendar) {
        return aclChars;
      }

      /* Create a merged access string from the entity access and the
       * container access
       */

      String entAccess = ent.getAccess();
      if (entAccess == null) {
        // Nomerge needed
        return aclChars;
      }

      try {
        Acl acl = new Acl();
        acl.decode(aclChars);
        acl.merge(entAccess.toCharArray());

        return acl.getEncoded();
      } catch (Throwable t) {
        throw new CalFacadeException(t);
      }
    }

    /* This is a way of making other objects sort of shareable.
     * The objects are locations, sponsors and categories.
     *
     * We store the default access in the owner principal and manipulate that to give
     * us some degree of sharing.
     *
     * In effect, the owner becomes the container for the object.
     */

    String aclString = null;
    String entAccess = ent.getAccess();
    BwUser owner = ent.getOwner();

    if (ent instanceof BwCategory) {
      aclString = owner.getCategoryAccess();
    } else if (ent instanceof BwLocation) {
      aclString = owner.getLocationAccess();
    } else if (ent instanceof BwSponsor) {
      aclString = owner.getSponsorAccess();
    }

    if (aclString == null) {
      if (entAccess == null) {
        if (ent.getPublick()) {
          return access.getDefaultPublicAccess().toCharArray();
        }
        return access.getDefaultPersonalAccess().toCharArray();
      }
      return entAccess.toCharArray();
    }

    if (entAccess == null) {
      return aclString.toCharArray();
    }

    try {
      Acl acl = new Acl();
      acl.decode(aclString.toCharArray());
      acl.merge(entAccess.toCharArray());

      return acl.getEncoded();
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /* Create a merged Acl for the given calendar.
   */
  private PathInfo getPathInfo(BwCalendar cal) throws CalFacadeException {
    boolean isPublic = cal.getPublick();
    Acl acl = null;
    PathInfo pi = new PathInfo();

    pi.path = cal.getPath();

    try {
      while (cal != null) {
        String aclString = cal.getAccess();

        /* Validity check. The system MUST be set up so that /public and /user
         * have the appropriate default access stored as the acl string.
         *
         * Failure to do so results in incorrect evaluation of access. We'll
         * check it here.
         */
        if ((aclString == null) && (cal.getCalendar() == null)) {
          // At root
          if (isPublic) {
            throw new CalFacadeException("Public calendars must have access set at root");
          }

          // XXX temp - set this in /user
          aclString = access.getDefaultPersonalAccess();
        }

        if (acl == null) {
          acl = new Acl();
          if (aclString != null) {
            acl.decode(aclString);
          }
        } else if (aclString != null) {
          acl.merge(aclString.toCharArray());
        }

        cal = cal.getCalendar();
      }

      pi.pathAcl = acl;
      pi.encoded = acl.getEncoded();

      return pi;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  private Logger getLog() {
    if (log == null) {
      log = Logger.getLogger(getClass());
    }

    return log;
  }
}

