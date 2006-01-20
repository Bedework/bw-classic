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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletContext;
import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import org.apache.log4j.Logger;

/** This class must be installed as a request listener for a UWCal web application.
 *
 * <p>We assume that any CalSvci object must remain open until after the jsp
 * has done its stuff, i.e. after the action returns but before we finally
 * deliver the response. This listener uses a callback object stored as an
 * attribute in the session.
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class BwRequestListener implements ServletRequestListener {
  /* Set as a config parameter */
  private String attrName;

  protected boolean debug = false;

  public void requestInitialized(ServletRequestEvent sre) {
    HttpServletRequest req = (HttpServletRequest)sre.getServletRequest();
    HttpSession sess = req.getSession();

    if (attrName == null) {
      init(sess);
    }

    BwCallback cb = null;

    try {
      cb = getCb(sess, "in");

      String spath = req.getServletPath();
      boolean actionUrl = (spath != null) && (spath.endsWith(".do"));

      if (cb != null) {
        cb.in(actionUrl);
      }
    } catch (Throwable t) {
      getLogger().error("Callback exception: ", t);
      throw new RuntimeException(t);
    }
  }

  public void requestDestroyed(ServletRequestEvent sre) {
    HttpServletRequest req = (HttpServletRequest)sre.getServletRequest();
    HttpSession sess = req.getSession();

    if (attrName == null) {
      init(sess);
    }

    BwCallback cb = null;

    try {
      cb = getCb(sess, "in");

      if (cb != null) {
        cb.out();
      }
    } catch (Throwable t) {
      getLogger().error("Callback exception: ", t);
      throw new RuntimeException(t);
    } finally {
      cb = getCb(sess, "close");

      if (cb != null) {
        try {
          cb.close();
        } catch (Throwable t) {
          getLogger().error("Callback exception: ", t);
          throw new RuntimeException(t);
        }
      }
    }
  }

  private void init(HttpSession sess) {
    ServletContext ctx = sess.getServletContext();
    String temp = ctx.getInitParameter("debug");

    try {
      int debugVal = Integer.parseInt(temp);

      debug = (debugVal > 2);
    } catch (Exception e) {}

    attrName = ctx.getInitParameter("org.uwcal.svcicb.sessionAttrName");
    if (attrName == null) {
      throw new RuntimeException("Must supply sessionAttrName for request listener");
    }

  }

  private BwCallback getCb(HttpSession sess,
                              String tracer) {
    if (sess == null) {
      if (debug) {
        getLogger().debug(tracer + " no session object");
      }
      return null;
    }

    try {
      BwCallback cb = (BwCallback)sess.getAttribute(attrName);
      if (debug) {
        if (cb != null) {
          getLogger().debug(tracer + " Obtained UWCalCallback object");
        } else {
          getLogger().debug(tracer + " no UWCalCallback available");
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

  private Logger getLogger() {
    return Logger.getLogger(this.getClass());
  }
}


