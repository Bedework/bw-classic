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

package org.bedework.freebusyServer;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

import org.apache.commons.httpclient.Header;

/**
 * @author Mike Douglass douglm at rpi.edu
 *
 */
public class Req {
  private String user;
  private String pw;

  boolean auth;

  private String method;
  private String url;

  private Collection hdrs;
  private Header[] headers;

  private String contentType;
  Collection contentLines;
  byte[] contentBytes;

  /** Constructor
   *
   */
  public Req() {
  }

  /** Constructor
   *
   * @param user
   * @param pw
   */
  public Req(String user, String pw) {
    this.user = user;
    this.pw = pw;
    auth = true;
  }

  /**
   * @return String user
   */
  public String getUser() {
    return user;
  }

  /**
   * @return String pw
   */
  public String getPw() {
    return pw;
  }

  /**
   * @return boolean
   */
  public boolean getAuth() {
    return auth;
  }

  /**
   * @param val   String
   */
  public void setMethod(String val) {
    method = val;
  }

  /**
   * @return String
   */
  public String getMethod() {
    return method;
  }

  /**
   * @param val   String
   */
  public void setUrl(String val) {
    url = val;
  }

  /**
   * @return String url
   */
  public String getUrl() {
    return url;
  }

  /**
   * @param name
   * @param val
   */
  public void addHeader(String name, String val) {
    if (hdrs == null) {
      hdrs = new ArrayList();
    }

    hdrs.add(new Header(name, val));
  }

  /**
   * @return Header[]
   */
  public Header[] getHeaders() {
    if ((headers == null) && (hdrs != null)) {
      headers = (Header[])hdrs.toArray(new Header[hdrs.size()]);
    }

    return headers;
  }

  /**
   * @param val   String
   */
  public void setContentType(String val) {
    contentType = val;
  }

  /**
   * @return String
   */
  public String getContentType() {
    return contentType;
  }

  /**
   * @param val
   */
  public void addContentLine(String val) {
    if (contentLines == null) {
      contentLines = new ArrayList();
    }

    contentLines.add(val);
    contentBytes = null;
  }

  /**
   * @return int content length
   * @throws Throwable
   */
  public int getContentLength() throws Throwable {
    if (contentLines == null) {
      return 0;
    }

    return getBytes().length;
  }

  /**
   * @return byte[]  content bytes
   * @throws Throwable
   */
  public byte[] getContentBytes() throws Throwable {
    if (contentLines == null) {
      return null;
    }

    return getBytes();
  }

  private byte[] getBytes() {
    if (contentBytes != null) {
      return contentBytes;
    }

    StringBuffer sb = new StringBuffer();

    Iterator it = contentLines.iterator();
    while (it.hasNext()) {
      String ln = (String)it.next();

      sb.append(ln);
      sb.append("\n");
    }

    contentBytes = sb.toString().getBytes();

    return contentBytes;
  }
}
