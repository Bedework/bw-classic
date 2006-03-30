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

import org.bedework.davdefs.WebdavTags;

import edu.rpi.cct.webdav.servlet.shared.WebdavException;
import edu.rpi.cct.webdav.servlet.shared.WebdavNsNode;
import edu.rpi.cct.webdav.servlet.shared.WebdavProperty;
import edu.rpi.cct.webdav.servlet.shared.WebdavStatusCode;
import edu.rpi.sss.util.xml.QName;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.net.URI;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** Class called to handle PROPFIND
 *
 *   @author Mike Douglass   douglm@rpi.edu
 */
public class PropFindMethod extends MethodBase {
  /**
   */
  public static class PropRequest {
    //private static final int reqPropNone = 0;
    private static final int reqProp = 1;
    private static final int reqPropName = 2;
    private static final int reqPropAll = 3;

    int reqType;

    PropRequest(int reqType)  {
      this.reqType = reqType;
    }

    /** For the prop element we build a Collection of WebdavProperty
     */
    Vector props;
  }

  private PropRequest parsedReq;

  /** Called at each request
   */
  public void init() {
  }

  public void doMethod(HttpServletRequest req,
                       HttpServletResponse resp) throws WebdavException {
    if (debug) {
      trace("PropFindMethod: doMethod");
    }

    Document doc = parseContent(req, resp);

    if (doc == null) {
      // Treat as allprop request
      parsedReq = new PropRequest(PropRequest.reqPropAll);
    }

    startEmit(resp);

    if (doc != null) {
      int st = processDoc(doc);

      if (st != HttpServletResponse.SC_OK) {
        resp.setStatus(st);
        throw new WebdavException(st);
      }
    }

    int depth = Headers.depth(req);

    if (debug) {
      trace("PropFindMethod: depth=" + depth);
    }

    processResp(req, resp, depth);
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private int processDoc(Document doc) throws WebdavException {
    try {
      Element root = doc.getDocumentElement();
      Element[] children = getChildren(root);

      for (int i = 0; i < children.length; i++) {
        Element curnode = children[i];

        String nm = curnode.getLocalName();
        String ns = curnode.getNamespaceURI();

        if (debug) {
          trace("reqtype: " + nm + " ns: " + ns);
        }

        parsedReq = tryPropRequest(curnode);
        if (parsedReq != null) {
          break;
        }
      }

      return HttpServletResponse.SC_OK;
    } catch (Throwable t) {
      System.err.println(t.getMessage());
      if (debug) {
        t.printStackTrace();
      }

      return HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
    }
  }

  /** See if the current node represents a valid propfind element
   * and return with a request if so. Otherwise return null.
   *
   * @param nd
   * @return PropRequest
   * @throws WebdavException
   */
  public PropRequest tryPropRequest(Node nd) throws WebdavException {
    if (nodeMatches(nd, WebdavTags.allprop)) {
      return new PropRequest(PropRequest.reqPropAll);
    }

    if (nodeMatches(nd, WebdavTags.prop)) {
      return parseProps(nd);
    }

    if (nodeMatches(nd, WebdavTags.propname)) {
      return new PropRequest(PropRequest.reqPropName);
    }

    return null;
  }

  /** Just a list of property names in any namespace.
   *
   * @param nd
   * @return PropRequest
   * @throws WebdavException
   */
  public PropRequest parseProps(Node nd) throws WebdavException {
    PropRequest pr = new PropRequest(PropRequest.reqProp);
    pr.props = new Vector();

    Element[] children = getChildren(nd);

    for (int i = 0; i < children.length; i++) {
      Element propnode = children[i];

      WebdavProperty prop = new WebdavProperty(
               new QName(propnode.getNamespaceURI(),
                         propnode.getLocalName()),
                         null);

      if (debug) {
        trace("prop: " + prop.getTag());
      }
      addNs(prop.getTag().getNamespaceURI());

      pr.props.addElement(prop);
    }

    return pr;
  }

  /**
   * @param req
   * @param resp
   * @param depth
   * @throws WebdavException
   */
  public void processResp(HttpServletRequest req,
                          HttpServletResponse resp,
                          int depth) throws WebdavException {
    resp.setStatus(WebdavStatusCode.SC_MULTI_STATUS);
    resp.setContentType("text/xml; charset=UTF-8");

    String resourceUri = getResourceUri(req);
    if (debug) {
      trace("About to get node at " + resourceUri);
    }

    WebdavNsNode node = getNsIntf().getNode(resourceUri);

    openTag(WebdavTags.multistatus);

    if (node != null) {
      doNodeAndChildren(node, 0, depth);
    }

    closeTag(WebdavTags.multistatus);

    flush();
  }

  /**
   * @param node
   * @param pr
   * @param status
   * @throws WebdavException
   */
  public void doNodeProperties(WebdavNsNode node,
                                PropRequest pr,
                                int status) throws WebdavException {
    addHref(node);

    openTag(WebdavTags.propstat);

    if (pr != null) {
      openTag(WebdavTags.prop);

      if (status == HttpServletResponse.SC_OK) {
        if (node.getExists()) {
          if (pr.reqType == PropRequest.reqProp) {
            status = doPropFind(node, pr);
          } else if (pr.reqType == PropRequest.reqPropName) {
            status = doPropNames(node);
          } else if (pr.reqType == PropRequest.reqPropAll) {
            status = doPropAll(node);
          }
        } else {
          status = HttpServletResponse.SC_NOT_FOUND;
        }
      }

      closeTag(WebdavTags.prop);
    }

    if ((status != HttpServletResponse.SC_OK) ||
        getNsIntf().getReturnMultistatusOk()) {
      property(WebdavTags.status, "HTTP/1.1 " + status + " " +
                   WebdavStatusCode.getMessage(status));
    }

    closeTag(WebdavTags.propstat);
  }

  private void doNodeAndChildren(WebdavNsNode node,
                                 int curDepth,
                                 int maxDepth) throws WebdavException {
    openTag(WebdavTags.response);

    doNodeProperties(node, parsedReq, HttpServletResponse.SC_OK);

    closeTag(WebdavTags.response);

    flush();

    curDepth++;

    if (curDepth > maxDepth) {
      return;
    }

    Iterator children = getNsIntf().getChildren(node);

    while (children.hasNext()) {
      WebdavNsNode child = (WebdavNsNode)children.next();

      doNodeAndChildren(child, curDepth, maxDepth);
    }
  }

  /* Build the response for a single node for a propfind request
   */
  private int doPropFind(WebdavNsNode node, PropRequest preq) throws WebdavException {
    Enumeration en = preq.props.elements();

    while (en.hasMoreElements()) {
      WebdavProperty pr = (WebdavProperty)en.nextElement();
      QName tag = pr.getTag();
      String ns = tag.getNamespaceURI();

      /* Deal with webdav properties */
      if (ns.equals(WebdavTags.namespace)) {
        if (tag.equals(WebdavTags.creationdate)) {
          // dav 13.1
          if (node.getCreDate() != null) {
            property(WebdavTags.creationdate, node.getCreDate());
          }
        } else if (tag.equals(WebdavTags.displayname)) {
          // dav 13.2
          property(WebdavTags.displayname, node.getName());
        } else if (tag.equals(WebdavTags.getcontentlanguage)) {
          // dav 13.3
        } else if (tag.equals(WebdavTags.getcontentlength)) {
          // dav 13.4
        } else if (tag.equals(WebdavTags.getcontenttype)) {
          // dav 13.5
          getNsIntf().generatePropContenttype(node);
        } else if (tag.equals(WebdavTags.getetag)) {
          // dav 13.6
          property(WebdavTags.getetag, getEntityTag(node, true));
        } else if (tag.equals(WebdavTags.getlastmodified)) {
          // dav 13.7
          if (node.getLastmodDate() != null) {
            property(WebdavTags.getlastmodified, node.getLastmodDate());
          }
        } else if (tag.equals(WebdavTags.lockdiscovery)) {
          // dav 13.8
        } else if (tag.equals(WebdavTags.resourcetype)) {
          // dav 13.9
          getNsIntf().generatePropResourcetype(node);
        } else if (tag.equals(WebdavTags.source)) {
          // dav 13.10
        } else if (tag.equals(WebdavTags.supportedlock)) {
          // dav 13.11
        } else if (tag.equals(WebdavTags.owner)) {
          // access 5.1
          openTag(WebdavTags.owner);
          property(WebdavTags.href, getNsIntf().makeUserHref(node.getOwner()));
          closeTag(WebdavTags.owner);
        } else if (tag.equals(WebdavTags.supportedPrivilegeSet)) {
          // access 5.2
          getNsIntf().emitSupportedPrivSet(node);
        } else if (tag.equals(WebdavTags.currentUserPrivilegeSet)) {
          // access 5.3
        } else if (tag.equals(WebdavTags.acl)) {
          // access 5.4
          getNsIntf().emitAcl(node);
        } else if (tag.equals(WebdavTags.aclRestrictions)) {
          // access 5.5
        } else if (tag.equals(WebdavTags.inheritedAclSet)) {
          // access 5.6
        } else if (tag.equals(WebdavTags.principalCollectionSet)) {
          // access 5.7
        }
      } else {
      }
    }

    return HttpServletResponse.SC_OK;
  }

  /* Build the response for a single node for a propnames request
   */
  private int doPropNames(WebdavNsNode node) throws WebdavException {
    return HttpServletResponse.SC_OK;
  }

  /* Build the response for a single node for an allprop request
   */
  private int doPropAll(WebdavNsNode node) throws WebdavException {
    doLockDiscovery(node);
    property(WebdavTags.supportedlock,
                 getNsIntf().getSupportedLocks());

    doNodeNsProperties(node);

    property(WebdavTags.creationdate, node.getCreDate());

    property(WebdavTags.displayname, node.getName());

    if (node.getCollection()) {
      getNsIntf().generatePropResourcetype(node);
//      propertyTagVal(WebdavTags.resourcetype,
//                     WebdavTags.collection);
    }

    if (node.getAllowsGet()) {
      property(WebdavTags.getcontentlength,
               String.valueOf(node.getContentLen()));
      property(WebdavTags.getcontenttype, node.getContentType());
    }

    property(WebdavTags.getlastmodified, node.getLastmodDate());

    return HttpServletResponse.SC_OK;
  }

  /* Build the lockdiscovery response for a single node
   */
  private void doLockDiscovery(WebdavNsNode node) throws WebdavException {
  }

  /* Does all the properties special to the underlying namespace
   */
  private void doNodeNsProperties(WebdavNsNode node) throws WebdavException {
    Enumeration en = getNsIntf().getProperties(node);

    while (en.hasMoreElements()) {
      WebdavProperty prop = (WebdavProperty)en.nextElement();

      property(prop.getTag(), prop.getPval());
    }
  }

  private void addHref(WebdavNsNode node) throws WebdavException {
    try {
      if (debug) {
        trace("Adding href " + getUrlPrefix() + node.getEncodedUri());
      }

      String url = getUrlPrefix() + new URI(node.getEncodedUri()).toASCIIString();
      property(WebdavTags.href, url);
    } catch (WebdavException wde) {
      throw wde;
    } catch (Throwable t) {
      throw new WebdavException(t);
    }
  }
}

