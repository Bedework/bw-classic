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

package edu.rpi.cct.webdav.servlet.common;

import edu.rpi.cct.webdav.servlet.shared.WebdavBadRequest;
import edu.rpi.cct.webdav.servlet.shared.WebdavException;
import edu.rpi.cct.webdav.servlet.shared.WebdavIntfException;
import edu.rpi.cct.webdav.servlet.shared.WebdavNsIntf;
import edu.rpi.cct.webdav.servlet.shared.WebdavTags;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

/** Class to handle WebDav ACLs
 *
 *  @author Mike Douglass   douglm@rpi.edu
 */
public class AclMethod extends MethodBase {
  /** Called at each request
   */
  public void init() {
  }

  public void doMethod(HttpServletRequest req,
                       HttpServletResponse resp) throws WebdavException {
    if (debug) {
      trace("AclMethod: doMethod");
    }

    Document doc = parseContent(req, resp);

    if (doc == null) {
      return;
    }

    startEmit(resp);

    WebdavNsIntf.AclInfo ainfo = processDoc(doc, getResourceUri(req));

    processResp(req, resp, ainfo);
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  /* We process the parsed document and produce a Collection of request
   * objects to process.
   */
  private WebdavNsIntf.AclInfo processDoc(Document doc, String uri) throws WebdavException {
    try {
      WebdavNsIntf intf = getNsIntf();

      WebdavNsIntf.AclInfo ainfo = intf.startAcl(uri);

      Element root = doc.getDocumentElement();

      /* We expect an acl root element containing 0 or more ace elemnts
         <!ELEMENT acl (ace)* >
       */
      if (!nodeMatches(root, WebdavTags.acl)) {
        throw new WebdavBadRequest();
      }

      Element[] children = getChildren(root);

      for (int i = 0; i < children.length; i++) {
        Element curnode = children[i];

        if (!nodeMatches(curnode, WebdavTags.ace)) {
          throw new WebdavBadRequest();
        }

        processAcl(ainfo, curnode);
      }

      return ainfo;
    } catch (Throwable t) {
      error(t.getMessage());
      if (debug) {
        t.printStackTrace();
      }

      throw WebdavIntfException.serverError();
    }
  }

  /* Process an acl<br/>
         <!ELEMENT ace ((principal | invert), (grant|deny), protected?,
                         inherited?)>
         <!ELEMENT grant (privilege+)>
         <!ELEMENT deny (privilege+)>

         protected and inherited are for acl display
   */
  private void processAcl(WebdavNsIntf.AclInfo ainfo, Node nd) throws WebdavException {
    WebdavNsIntf intf = getNsIntf();

    Element[] children = getChildren(nd);

    if (children.length != 2) {
      throw new WebdavBadRequest();
    }

    Element curnode = children[0];
    boolean inverted = false;

    /* Require principal or invert */

    if (nodeMatches(curnode, WebdavTags.principal)) {
    } else if (nodeMatches(curnode, WebdavTags.invert)) {
      /*  <!ELEMENT invert principal>       */

      inverted = true;
      curnode = getOnlyChild(curnode);
    } else {
      throw new WebdavBadRequest();
    }

    intf.parseAcePrincipal(ainfo, curnode, inverted);

    /* Require grant or deny */

    curnode = children[1];

    boolean grant = false;

    if (nodeMatches(curnode, WebdavTags.grant)) {
      grant = true;
    } else if (!nodeMatches(curnode, WebdavTags.deny)) {
      throw new WebdavBadRequest();
    }

    children = getChildren(curnode);

    for (int i = 0; i < children.length; i++) {
      curnode = children[i];

      if (!nodeMatches(curnode, WebdavTags.privilege)) {
        throw new WebdavBadRequest();
      }

      intf.parsePrivilege(ainfo, curnode, grant);
    }
  }

  private void processResp(HttpServletRequest req,
                          HttpServletResponse resp,
                          WebdavNsIntf.AclInfo ainfo) throws WebdavException {
    WebdavNsIntf intf = getNsIntf();

    intf.updateAccess(ainfo);
  }
}

