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

package org.bedework.caldav.client.api;

import org.bedework.calfacade.CalFacadeException;
import org.bedework.http.client.caldav.CaldavClient;
import org.bedework.http.client.DepthHttpMethod;
import org.bedework.http.client.HttpManager;

import java.io.InputStream;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HostConfiguration;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.contrib.ssl.BaseProtocolSocketFactory;
import org.apache.commons.httpclient.methods.EntityEnclosingMethod;
import org.apache.commons.httpclient.protocol.Protocol;
//import org.apache.commons.httpclient.protocol.ProtocolSocketFactory;
//import org.apache.commons.httpclient.protocol.SSLProtocolSocketFactory;
import org.apache.commons.ssl.TrustMaterial;
import org.apache.log4j.Logger;

import sun.misc.BASE64Encoder;

/** Class to do basic IO with a caldav server for a client.
 *
 * @author  Mike Douglass douglm @ rpi.edu
 */
public class CaldavClientIo {
  private boolean debug;

  private Logger log;

  private static HttpManager httpManager;

  private CaldavClient client;

  private int status;

  /**
   * @param host
   * @param port
   * @param timeOut - millisecs, 0 for no timeout
   * @param debug
   * @throws Throwable
   */
  public CaldavClientIo(String host, int port, int timeOut,
                        boolean debug) throws Throwable {
    this(host, port, timeOut, false, debug);
  }

  /**
   * @param host
   * @param port
   * @param timeOut - millisecs, 0 for no timeout
   * @param secure
   * @param debug
   * @throws Throwable
   */
  public CaldavClientIo(String host, int port, int timeOut, boolean secure,
                        boolean debug) throws Throwable {
    if (httpManager == null) {
      httpManager = new HttpManager("org.bedework.http.client.caldav.CaldavClient");
    }

    HostConfiguration config = new HostConfiguration();

    if (secure) {
      /*
      ProtocolSocketFactory pfact = new SSLProtocolSocketFactory();
      Protocol pr = new Protocol("https", pfact, port);
      Protocol.registerProtocol( "https", pr);
      */
      BaseProtocolSocketFactory f = new BaseProtocolSocketFactory();

      warn("Trusting all certificates");
      // might as well trust the usual suspects:
      //f.addTrustMaterial(TrustMaterial.CACERTS);
      f.addTrustMaterial(TrustMaterial.TRUST_ALL);

      // here's where we start trusting usertrust.com's CA:
      //f.addTrustMaterial(new TrustMaterial(pemCert));

      Protocol trustHttps = new Protocol("https", f, 443);
      Protocol.registerProtocol("https", trustHttps);


      config.setHost(host, port, trustHttps);
    } else {
      config.setHost(host, port);
    }
    /*
    if (secure) {
      config.setHost(new URI("https://" + host + ":" + port, false));
    } else {
      config.setHost(new URI("http://" + host + ":" + port, false));
    }
    */
    if (debug) {
      debugMsg("uri set to " + config.getHostURL());
    }

    httpManager.getParams().setConnectionTimeout(timeOut);

    client = (CaldavClient)httpManager.getClient(config);

    this.debug = debug;
  }

  /** Send an unauthenticated request to the server
   *
   * @param method
   * @param url
   * @param hdrs
   * @param depth
   * @param contentType
   * @param contentLen
   * @param content
   * @return int    status code
   * @throws Throwable
   */
  public int sendRequest(String method, String url,
                         Header[] hdrs, String depth,
                         String contentType, int contentLen,
                         byte[] content) throws Throwable {
    return sendRequest(method, url, null, null, hdrs, depth,
                       contentType, contentLen, content);
  }

  /** Send an authenticated request to the server
   *
   * @param method
   * @param url
   * @param user
   * @param pw
   * @param hdrs
   * @param depth
   * @param contentType
   * @param contentLen
   * @param content
   * @return int    status code
   * @throws Throwable
   */
  public int sendRequest(String method, String url, String user, String pw,
                         Header[] hdrs, String depth,
                         String contentType, int contentLen,
                         byte[] content) throws Throwable {
    int sz = 0;
    if (content != null) {
      sz = content.length;
    }

    if (debug) {
       debugMsg("About to send request: method=" + method +
                " contentLen=" + contentLen +
                " content.length=" + sz);
    }

    client.setMethodName(method, url);

    HttpMethod meth = client.getMethod();

    if (meth instanceof DepthHttpMethod) {
      ((DepthHttpMethod)meth).setDepth(depth);
    }

    if (user != null) {
      String upw = user + ":" + pw;

      meth.setRequestHeader("Authorization",
                            "Basic " +
                            new String(new BASE64Encoder().encode (upw.getBytes())));
    }

    if (hdrs != null) {
      for (int i = 0; i < hdrs.length; i++) {
        meth.setRequestHeader(hdrs[i]);
      }
    }

    if (meth instanceof EntityEnclosingMethod) {
      if (contentType == null) {
        contentType = "text/xml";
      }

      if (content != null) {
        client.setContent(content, contentType);
      }
    }

    status = client.execute();

    return status;
  }

  /** Get the response to the last request
   *
   * @return CaldavResp objct representing response
   * @throws Throwable
   */
  public CaldavResp getResponse() throws Throwable {
    return new Response(client, debug);
  }

  /**
   *
   */
  public void close() {
  }

  private static class Response implements CaldavResp {
//    private boolean debug;

    CaldavClient client;

    Response(CaldavClient client, boolean debug) throws Throwable {
      this.client = client;
//      this.debug = debug;
    }

    public int getRespCode() throws CalFacadeException {
      return client.getStatusCode();
    }

    public String getContentType() throws CalFacadeException {
      return client.getResponseContentType();
    }

    public long getContentLength() throws CalFacadeException {
      return client.getResponseContentLength();
    }

    public String getCharset() throws CalFacadeException {
      return client.getResponseCharSet();
    }

    public InputStream getContentStream() throws CalFacadeException {
      try {
        return client.getResponseBodyAsStream();
      } catch (Throwable t) {
        throw new CalFacadeException(t);
      }
    }

    public String getResponseBodyAsString() throws CalFacadeException {
      try {
        return client.getResponseBodyAsString();
      } catch (Throwable t) {
        throw new CalFacadeException(t);
      }
    }
  }

  /** ===================================================================
   *                   Logging methods
   *  =================================================================== */

  /**
   * @return Logger
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void debugMsg(String msg) {
    getLogger().debug(msg);
  }

  protected void error(Throwable t) {
    getLogger().error(this, t);
  }

  protected void warn(String msg) {
    getLogger().warn(msg);
  }

  protected void logIt(String msg) {
    getLogger().info(msg);
  }

  protected void trace(String msg) {
    getLogger().debug(msg);
  }
}

