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

package org.bedework.webcommon;

import java.io.IOException;
import java.lang.IllegalStateException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import org.apache.log4j.Logger;

/** This class must be installed as a filter for a Bedework web application.
 *
 * <p>We assume that any CalSvci object must remain open until after the jsp
 * has done its stuff, i.e. after the action returns but before we finally
 * deliver the response. This filter uses a callback object stored as an
 * attribute in the session.
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class BwSvciFilter implements Filter {
  protected ServletContext ctx;

  protected boolean debug = false;

  private transient Logger log;

  public void init(FilterConfig cnfg) throws ServletException {
    ctx = cnfg.getServletContext();
    String temp = cnfg.getInitParameter("debug");

    try {
      int debugVal = Integer.parseInt(temp);

      debug = (debugVal > 2);
    } catch (Exception e) {}
  }

  public void doFilter(ServletRequest req,
                       ServletResponse resp,
                       FilterChain chain)
          throws IOException, ServletException {
    HttpServletRequest hreq = (HttpServletRequest)req;
    HttpSession sess = hreq.getSession();
    BwCallback cb = null;

    try {
      cb = getCb(sess, "in");

      String spath = hreq.getServletPath();
      boolean actionUrl = (spath != null) && (spath.endsWith(".do"));

      if (cb != null) {
        cb.in(actionUrl);
      }

      chain.doFilter(req, resp);

      cb = getCb(sess, "out");
      if (cb != null) {
        cb.out();
      }
    } catch (Throwable t) {
      getLogger().error("Callback exception: ", t);
      throw new ServletException(t);
    } finally {
      try {
        cb = getCb(sess, "close");

        if (cb != null) {
          cb.close();
        }
      } catch (Throwable t) {
        getLogger().error("Callback exception: ", t);
        throw new ServletException(t);
      }
    }
  }

  public void destroy() {
  }

  private BwCallback getCb(HttpSession sess,
                              String tracer) throws Throwable {
    if (sess == null) {
      if (debug) {
        getLogger().debug(tracer + " no session object");
      }
      return null;
    }

    try {
      BwCallback cb = (BwCallback)sess.getAttribute(BwCallback.cbAttrName);
      if (debug) {
        if (cb != null) {
          getLogger().debug(tracer + " Obtained BwCallback object");
        } else {
          getLogger().debug(tracer + " no BwCallback available");
        }
      }

      return cb;
    } catch (IllegalStateException ise) {
      // Invalidated session - assume logged out
      if (debug) {
        getLogger().debug(tracer + " Invalidated session - assume logged out");
      }
      return null;
    }
  }

  /** Get a logger for messages
   *
   * @return Logger
   */
  public Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}


