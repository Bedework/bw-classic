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

package edu.rpi.sss.util.servlets.io;

import java.io.IOException;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import org.apache.log4j.Logger;

/** This class provides a useful form of the wrapped response.
 */
public class WrappedResponse extends HttpServletResponseWrapper {
  protected boolean debug = false;

  private transient Logger log;

  /** Constructor
   *
   * @param response
   * @param debug
   */
  public WrappedResponse(HttpServletResponse response,
                         boolean debug) {
    this(response, null, debug);
  }

  /** Constructor
   *
   * @param response
   * @param log
   * @param debug
   */
  public WrappedResponse(HttpServletResponse response,
                         Logger log,
                         boolean debug) {
    super(response);
    this.log = log;
    this.debug = debug;
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpServletResponse#sendError(int)
   */
  public void sendError(int sc) throws IOException {
    super.sendError(sc);
    if (debug) {
      getLogger().debug("sendError(" + sc + ")");
    }
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpServletResponse#setStatus(int)
   */
  public void setStatus(int sc) {
    super.setStatus(sc);
    if (debug) {
      getLogger().debug("setStatus(" + sc + ")");
    }
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpServletResponse#addHeader(java.lang.String, java.lang.String)
   */
  public void addHeader(String name, String value) {
    super.addHeader(name, value);
    if (debug) {
      getLogger().debug("addHeader(\"" + name + "\", \"" + value + "\")");
    }
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpServletResponse#setHeader(java.lang.String, java.lang.String)
   */
  public void setHeader(String name, String value) {
    super.setHeader(name, value);
    if (debug) {
      getLogger().debug("setHeader(\"" + name + "\", \"" + value + "\")");
    }
  }

  /* (non-Javadoc)
   * @see javax.servlet.ServletResponse#getBufferSize()
   */
  public int getBufferSize() {
    return 0;
  }

  /* (non-Javadoc)
   * @see javax.servlet.ServletResponse#flushBuffer()
   */
  public void flushBuffer() {
    if (debug) {
      getLogger().debug("flushBuffer called");
    }
  }

  /* We should probably have a setCharacterEncoding method as well and
   * subclasses can use the current character encoding to convert to String
   *
   * (non-Javadoc)
   * @see javax.servlet.ServletResponse#setContentType(java.lang.String)
   */
  public void setContentType(String type) {
    getResponse().setContentType(type);
    //if (debug) {
    //  getLogger().debug("setContentType(\"" + type + "\")");
    //}
  }

  /**
   *
   */
  public void close() {
  }

  /** Get a logger for messages
   *
   * @return Logger
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}

