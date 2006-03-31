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
package org.bedework.appcommon;

import org.bedework.calfacade.CalFacadeException;
import org.bedework.davdefs.CaldavTags;
import org.bedework.davdefs.WebdavTags;

import edu.rpi.cct.uwcal.access.Access;
import edu.rpi.cct.uwcal.access.Ace;
import edu.rpi.cct.uwcal.access.Acl;
import edu.rpi.cct.uwcal.access.Privilege;
import edu.rpi.sss.util.xml.QName;
import edu.rpi.sss.util.xml.XmlEmit;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;

/** Class to generate xml from an access specification. The resulting xml follows
 * the webdav acl spec rfc3744
 *
 *  @author Mike Douglass   douglm @ rpi.edu
 */
public class AccessUtil implements Serializable {
  public static final QName[] privTags = {
    WebdavTags.all,              // privAll = 0;
    WebdavTags.read,             // privRead = 1;
    WebdavTags.readAcl,          // privReadAcl = 2;
    WebdavTags.readCurrentUserPrivilegeSet,  // privReadCurrentUserPrivilegeSet = 3;
    CaldavTags.readFreeBusy,     // privReadFreeBusy = 4;
    WebdavTags.write,            // privWrite = 5;
    WebdavTags.writeAcl,         // privWriteAcl = 6;
    WebdavTags.writeProperties,  // privWriteProperties = 7;
    WebdavTags.writeContent,     // privWriteContent = 8;
    WebdavTags.bind,             // privBind = 9;
    WebdavTags.unbind,           // privUnbind = 10;
    WebdavTags.unlock,           // privUnlock = 11;
    null                         // privNone = 12;
  };

  private XmlEmit xml;

  /** Acls use tags in the webdav and caldav namespace. 
   *
   * @param xml
   */
  public AccessUtil(XmlEmit xml) {
    this.xml = xml;
  }

  /** (Re)set the xml writer
   *
   * @param val      xml Writer
   */
  public void setXml(XmlEmit val) {
    xml = val;
  }

  /** Override this to construct urls from the parameter
   *
   * @param who String
   * @return String href
   */
  public String makeUserHref(String who) {
    return who;
  }

  /** Override this to construct urls from the parameter
   *
   * @param who String
   * @return String href
   */
  public String makeGroupHref(String who) {
    return who;
  }

  public void emitAcl(Acl acl) throws CalFacadeException {
    try {
      Collection aces = acl.getAces();
      emitAces(aces);
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  public void emitAces(Collection aces) throws CalFacadeException {
    try {
      xml.openTag(WebdavTags.acl);

      if (aces != null) {
        Iterator it = aces.iterator();
        while (it.hasNext()) {
          Ace ace = (Ace)it.next();

          emitAce(ace, true);
          emitAce(ace, false);
        }
      }

      xml.closeTag(WebdavTags.acl);
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }
  
  /** Produce an xml representation of supported privileges. This is the same
   * at all points in the system and is identical to the webdav/caldav 
   * requirements.
   * 
   * @throws CalFacadeException
   */
  public void emitSupportedPrivSet() throws CalFacadeException {
    try {
      xml.openTag(WebdavTags.supportedPrivilegeSet);
      
      emitSupportedPriv(Access.getPrivs().getPrivAll());
      
      xml.closeTag(WebdavTags.supportedPrivilegeSet);
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  private void emitSupportedPriv(Privilege priv) throws Throwable {
    xml.openTag(WebdavTags.supportedPrivilege);
    
    xml.openTagNoNewline(WebdavTags.privilege);
    xml.emptyTagSameLine(privTags[priv.getIndex()]);
    xml.closeTagNoblanks(WebdavTags.privilege);
    
    if (priv.getAbstractPriv()) {
      xml.emptyTag(WebdavTags._abstract);
    }
    
    xml.property(WebdavTags.description, priv.getDescription());

    Iterator it = priv.iterateContainedPrivileges();
    while (it.hasNext()) {
      emitSupportedPriv((Privilege)it.next());
    }
    
    xml.closeTag(WebdavTags.supportedPrivilege);
  }
  
  private void emitAce(Ace ace, boolean denials) throws Throwable {
    Collection privs = ace.getPrivs();
    boolean emittedWho = false;

    QName tag;
    if (denials) {
      tag = WebdavTags.deny;
    } else {
      tag = WebdavTags.grant;
    }

    Iterator it = privs.iterator();
    while (it.hasNext()) {
      Privilege p = (Privilege)it.next();

      if (denials == p.getDenial()) {
        if (!emittedWho) {
          emitAceWho(ace);
          emittedWho = true;
        }

        xml.openTag(tag);
        xml.emptyTag(privTags[p.getIndex()]);
        xml.closeTag(tag);
      }
    }

    if (emittedWho) {
      xml.closeTag(WebdavTags.ace);
    }
  }

  private void emitAceWho(Ace ace) throws Throwable {
    xml.openTag(WebdavTags.ace);

    boolean invert = ace.getNotWho();

    if (ace.getWhoType() == Ace.whoTypeOther) {
      invert = !invert;
    }

    if (invert) {
      xml.openTag(WebdavTags.invert);
    }

    xml.openTag(WebdavTags.principal);

    int whoType = ace.getWhoType();

    /*
           <!ELEMENT principal (href)
                  | all | authenticated | unauthenticated
                  | property | self)>
    */

    if (whoType == Ace.whoTypeUser) {
      xml.property(WebdavTags.href, makeUserHref(ace.getWho()));
    } else if (whoType == Ace.whoTypeGroup) {
      xml.property(WebdavTags.href, makeGroupHref(ace.getWho()));
    } else if ((whoType == Ace.whoTypeOwner) ||
               (whoType == Ace.whoTypeOther)) {
      // Other is !owner
      xml.openTag(WebdavTags.property);
      xml.emptyTag(WebdavTags.owner);
      xml.closeTag(WebdavTags.property);
    } else if (whoType == Ace.whoTypeUnauthenticated) {
      xml.emptyTag(WebdavTags.unauthenticated);
    } else if (whoType == Ace.whoTypeAuthenticated) {
      xml.emptyTag(WebdavTags.authenticated);
    } else if (whoType == Ace.whoTypeAll) {
      xml.emptyTag(WebdavTags.all);
    } else  {
      throw new CalFacadeException("access.unknown.who");
    }

    xml.closeTag(WebdavTags.principal);

    if (invert) {
      xml.closeTag(WebdavTags.invert);
    }
  }
}
