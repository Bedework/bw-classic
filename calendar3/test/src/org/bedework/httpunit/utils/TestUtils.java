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

package org.bedework.httpunit.utils;

import com.meterware.httpunit.BlockElement;
import com.meterware.httpunit.HTMLSegment;
import com.meterware.httpunit.TableCell;
import com.meterware.httpunit.WebConversation;
import com.meterware.httpunit.WebForm;
import com.meterware.httpunit.WebLink;
import com.meterware.httpunit.WebRequest;
import com.meterware.httpunit.WebResponse;
import com.meterware.httpunit.WebTable;

import org.apache.log4j.Logger;

/** Class to handle some of the http interactions for the test suite.
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class TestUtils {
  private String urlBase;
  private String contextRoot;

  protected WebConversation wc;

  /** Many operations leave this populated with the last response
   */
  protected WebResponse resp;

  private int failures;
  private int successes;

  private Logger log;

  /**
   * @param urlBase
   * @param contextRoot
   * @param wc
   */
  public TestUtils(String urlBase,
                   String contextRoot,
                   WebConversation wc) {
    this.urlBase = urlBase;
    this.contextRoot = contextRoot;
    this.wc = wc;
  }

  /**
   * @return web response
   */
  public WebResponse getLastResponse() {
    return resp;
  }

  /**
   * @param val
   */
  public void setLastResponse(WebResponse val) {
    resp = val;
  }

  /** Do forms based servlet authentication.
   *
   * <p>If our servlet runner is tomcat it seems to send a redirect directly after
   * the auth. Do the redirect to get to a known state.
   *
   * <p>Returns with resp as the first application page after authentication
   *
   * @param id
   * @param pw
   * @return web response
   * @throws Throwable
   */
  public WebResponse doServletFormsAuth(String id, String pw) throws Throwable {
    resp = wc.getResponse(url(null, null));

    /** Should have the login form */
    WebForm form = resp.getForms()[0];

    form.setParameter("j_username", id);
    form.setParameter("j_password", pw);
    form.submit();

    resp = wc.getCurrentPage();

    /** At this point we might get a refresh from tomcat - it gives us the
        "application is loading" thing. */
    WebRequest wreq = resp.getRefreshRequest();

    if (wreq != null) {
      /* Wait a bit and do it again */
      int delay = resp.getRefreshDelay();

      Thread.sleep(delay * 1000);

      resp = wc.getResponse(wreq);
    }

    return resp;
  }

  /** We expect the current response to have a table with the given id.
   *
   * @param id
   * @param tableDescription
   * @return web table
   */
  public WebTable expectTableWithID(String id, String tableDescription) {
    return  expectTableWithID(resp, id, tableDescription);
  }

  /** We expect the given response to have a table with the given id.
   *
   * @param seg
   * @param id
   * @param tableDescription
   * @return web table
   */
  public WebTable expectTableWithID(HTMLSegment seg,
                                    String id, String tableDescription) {
    try {
      WebTable tbl = seg.getTableWithID(id);

      if (tbl == null) {
        fail("Couldn't find " + tableDescription + " with id " + id);
        return null;
      }

      return tbl;
    } catch (Throwable t) {
      fail(t);
      return null;
    }
  }

  /** We expect the current response to have a link with the given text.
   *
   * @param val
   * @param linkDescription
   * @return web link
   */
  public WebLink expectLinkWithText(String val, String linkDescription) {
    return  expectLinkWithText(resp, val, linkDescription);
  }

  /** We expect the given response to have a link with the given name.
   *
   * @param seg
   * @param val
   * @param linkDescription
   * @return web link
   */
  public WebLink expectLinkWithText(HTMLSegment seg,
                                    String val, String linkDescription) {
    try {
      WebLink link = seg.getLinkWith(val);

      if (link == null) {
        fail("Couldn't find " + linkDescription + " with val " + val);
        return null;
      }

      return link;
    } catch (Throwable t) {
      fail(t);
      return null;
    }
  }

  /** Given a table, a row, a col and link text return an expected link.
   *
   * @param tbl
   * @param row
   * @param col
   * @param val
   * @param linkDescription
   * @return web link
   */
  public WebLink expectLinkWithText(WebTable tbl, int row, int col,
                                    String val, String linkDescription) {
    TableCell cell = tbl.getTableCell(row, col);
    WebLink link = expectLinkWithText(cell, val, linkDescription);

    if (link == null) {
      dumpBlock(cell);
    }

    return link;
  }

  /** Build a url from the base, context root, action and request.
   *
   * <p>A lot of the time the url is constructed for us. We can use this to build
   * our own urls.
   *
   * @param action
   * @param request
   * @return String
   */
  public String url(String action, String request) {
    StringBuffer sb = new StringBuffer(urlBase);

    sb.append("/");
    sb.append(contextRoot);

    if (action == null) {
      return sb.toString();
    }

    sb.append("/");
    sb.append(action);

    if (request != null) {
      sb.append("?");
      sb.append(request);
    }

    return sb.toString();
  }

  /**
   * @param block
   */
  public void dumpBlock(BlockElement block) {
    info("========== Start block ==============");
    try {
      info(block.getText());
    } catch (Throwable t) {
      fail(t);
    }
    info("============ End block ==============");
  }

  /**
   * @param resp
   */
  public void dumpResponse(WebResponse resp) {
    info("========== Start response ==============");
    try {
      info(resp.getText());
    } catch (Throwable t) {
      fail(t);
    }
    info("============ End response ==============");
  }

  /**
   *
   */
  public void printStats() {
    info("=========================================");
    info("successes: " + successes);
    info("failures: " + failures);
    info("=========================================");
  }

  /**
   * @param msg
   */
  public void info(String msg) {
    getLogger().info(msg);
  }

  /**
   * @param msg
   */
  public void succeed(String msg) {
    successes++;
    info("succeeded: " + msg);
  }

  /**
   * @param t
   */
  public void succeed(Throwable t) {
    successes++;
    getLogger().info("succeeded with expected exception: ", t);
  }

  /**
   * @param msg
   */
  public void fail(String msg) {
    failures++;
    getLogger().error("Failed: " + msg);
  }

  /**
   * @param t
   */
  public void fail(Throwable t) {
    failures++;
    getLogger().error("Failed with exception", t);
  }

  /* Get a logger for messages
   */
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}

