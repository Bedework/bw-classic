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

import edu.rpi.sss.util.servlets.PresentationState;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.apache.struts.util.MessageResources;

/** This ought to be made pluggable. We need a session factory which uses
 * CalEnv to figure out which implementation to use.
 *
 * <p>This class represents a session for the Bedework web interface.
 * Some user state will be retained here.
 * We also provide a number of methods which act as the interface between
 * the web world and the calendar world.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class BwSessionImpl implements BwSession {
  /** Not completely valid in the j2ee world but it's only used to count sessions.
   */
  private static class Counts {
    long totalSessions = 0;
  }
  
  private static volatile HashMap countsMap = new HashMap();
  private long sessionNum = 0;

  /** True if we want debugging output
   */
  private boolean debug;

  /** The current user - null for guest
   */
  private String user;

  /** The application root
   */
  private String appRoot;

  /** The application name
   */
  private String appName;

  /** The current presentation state of the application
   */
  private PresentationState ps;

  /** Constructor for a Session
   *
   * @param user       String user id
   * @param appRoot
   * @param appName    String identifying particular application
   * @param ps
   * @param messages
     @param schemeHostPort The prefix for generatd urls referring to this server
   * @param debug      true for debugging output
   * @throws Throwable
   */
  public BwSessionImpl(String user,
                       String appRoot,
                       String appName,
                       PresentationState ps,
                       MessageResources messages,
                       String schemeHostPort,
                       boolean debug) throws Throwable {
    this.user = user;
    
    if (rootlessUri(appRoot)) {
      appRoot = "/" + appRoot;
    }

    this.appRoot = appRoot;
    this.appName = appName;
    this.ps = ps;
    this.debug = debug;

    /* NOTE: This is NOT intended to turn a relative URL into an
       absolute URL. It is a convenience for development which turns a
       not fully specified url into a url referring to the server.

       This will not work if they are treated as relative to the servlet.

       We also use the appRoot to derive the links to css and images. Once
       again, for this to work correctly. when the server and client are on
       different machines, the appRoot should not be fully specified.

       In production mode, the appRoot will normally be fully specified to a
       different web server.
     */
    if (!appRoot.toLowerCase().startsWith("http")) {
      StringBuffer sb = new StringBuffer(schemeHostPort);

      if (!appRoot.startsWith("/")) {
        sb.append("/");
      }
      sb.append(appRoot);

      appRoot = sb.toString();
    }

    if (ps != null) {
      if (ps.getAppRoot() == null) {
        ps.setAppRoot(appRoot);
      }
    }

    setSessionNum(appName);
  }

  /* ======================================================================
   *                     Property methods
   * ====================================================================== */

  /* (non-Javadoc)
   * @see org.bedework.webcommon.BwSession#getSessionNum()
   */
  public long getSessionNum() {
    return sessionNum;
  }

  /**
   * @param val
   */
  public void setAppName(String val) {
    appName = val;
  }

  /**
   * @return app name
   */
  public String getAppName() {
    return appName;
  }

  /**
   * @param val
   */
  public void setAppRoot(String val) {
    appRoot = val;
  }

  /**
   * @return app root
   */
  public String getAppRoot() {
    return appRoot;
  }

  /**
   * @param val
   */
  public void setUser(String val) {
    user = val;
  }

  /**
   * @return user
   */
  public String getUser() {
    return user;
  }

  /**
   * @param val
   */
  public void setPresentationState(PresentationState val) {
    ps = val;
    if (ps != null) {
      ps.setAppRoot(getAppRoot());
    }

    if (debug) {
      Logger.getLogger(this.getClass()).debug("appRoot=" + appRoot);
    }
  }

  /**
   * @return PresentationState
   */
  public PresentationState getPresentationState() {
    return ps;
  }

  /** Is this a guest user?
   *
   * @return boolean true for a guest
   */
  public boolean isGuest() {
    return user == null;
  }

  /**
    Does the given string represent a rootless URI?  A URI is rootless
    if it is not absolute (that is, does not contain a scheme like 'http')
    and does not start with a '/'
    @param uri String to test
    @return Is the string a rootless URI?  If the string is not a valid
      URI at all (for example, it is null), returns false
   */
  private boolean rootlessUri(String uri) {
    try {
      return !(uri == null || uri.startsWith("/") || new URI(uri).isAbsolute());
    } catch (URISyntaxException e) {  // not a URI at all
      return false;
    }
  }
  
  private void setSessionNum(String name) {
    try {
      synchronized (countsMap) {
        Counts c = (Counts)countsMap.get(name);
        
        if (c == null) {
          c = new Counts();
          countsMap.put(name, c);
        }
        
        sessionNum = c.totalSessions;
        c.totalSessions++;
      }
    } catch (Throwable t) {
    }
  }
}
