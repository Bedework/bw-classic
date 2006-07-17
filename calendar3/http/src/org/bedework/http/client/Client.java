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
package org.bedework.http.client;

import org.bedework.calfacade.CalFacadeException;

import java.io.InputStream;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HeaderElement;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpMethodBase;
import org.apache.commons.httpclient.methods.ByteArrayRequestEntity;
import org.apache.commons.httpclient.methods.DeleteMethod;
import org.apache.commons.httpclient.methods.EntityEnclosingMethod;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.OptionsMethod;
import org.apache.commons.httpclient.methods.PutMethod;

/** A client
 *
 * @author Mike Douglass  douglm @ rpi.edu
 */
public class Client extends HttpClient {
  private HttpMethodBase method;

  /** Constructor
   */
  public Client() {
    super();
  }

  /** Constructor
   *
   * @param mngr
   */
  public Client(HttpManager mngr) {
    super(mngr);
  }

  /** Specify the next method by name.
   *
   * @param name
   * @param uri
   * @throws CalFacadeException
   */
  public void setMethodName(String name, String uri) throws CalFacadeException {
    name = name.toUpperCase();

    if ("PUT".equals(name)) {
      setMethod(new PutMethod(uri));
    } else if ("GET".equals(name)) {
      setMethod(new GetMethod(uri));
    } else if ("DELETE".equals(name)) {
      setMethod(new DeleteMethod(uri));
    } else if ("OPTIONS".equals(name)) {
      setMethod(new OptionsMethod(uri));
    } else {
      throw new CalFacadeException("Illegal method: " + name);
    }
  }

  /** Set the method for the next request/response
   *
   * @param val
   */
  public void setMethod(HttpMethodBase val) {
    method = val;
  }

  /** Get the method for the next request/response
   *
   * @return HttpMethod
   */
  public HttpMethod getMethod() {
    return method;
  }

  /** Send content
   *
   * @param content
   * @param contentType
   * @throws CalFacadeException
   */
  public void setContent(byte[] content, String contentType) throws CalFacadeException {
    if (!(method instanceof EntityEnclosingMethod)) {
      throw new CalFacadeException("Invalid operation for method " + method.getName());
    }

    EntityEnclosingMethod eem = (EntityEnclosingMethod)method;

    eem.setRequestEntity(new ByteArrayRequestEntity(content, contentType));
  }

  /** Execute the current method and return the status code
   *
   * @return int    status code
   * @throws CalFacadeException
   */
  public int execute() throws CalFacadeException {
    try {
      return executeMethod(method);
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /**
   * @return  int sttaus code from last request
   * @throws CalFacadeException
   */
  public int getStatusCode() throws CalFacadeException {
    try {
      return method.getStatusCode();
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /**
   * @return String response character set
   * @throws CalFacadeException
   */
  public String getResponseCharSet() throws CalFacadeException {
    try {
      return method.getResponseCharSet();
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /**
   * @return String content type
   * @throws CalFacadeException
   */
  public String getResponseContentType() throws CalFacadeException {
    try {
      Header hdr = method.getResponseHeader("Content-Type");
      if (hdr == null) {
        return null;
      }

      HeaderElement[] els = hdr.getElements();
      if (els.length != 1) {
        throw new CalFacadeException("Bad content type " + hdr.getValue());
      }

      return els[0].getValue();
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /**
   * @return long content length
   * @throws CalFacadeException
   */
  public long getResponseContentLength() throws CalFacadeException {
    try {
      return method.getResponseContentLength();
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /**
   * Returns the response body of the HTTP method, if any, as an {@link InputStream}.
   * If response body is not available, returns <tt>null</tt>
   *
   * @return InputStream    response body
   * @throws CalFacadeException
   */
  public InputStream getResponseBodyAsStream() throws CalFacadeException {
    try {
      return method.getResponseBodyAsStream();
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /**
   * Returns the response body of the HTTP method, if any, as a {@link String}.
   * If response body is not available or cannot be read, returns <tt>null</tt>
   * The string conversion on the data is done using the character encoding specified
   * in <tt>Content-Type</tt> header.
   *
   * Note: This will cause the entire response body to be buffered in memory. A
   * malicious server may easily exhaust all the VM memory. It is strongly
   * recommended, to use getResponseAsStream if the content length of the response
   * is unknown or resonably large.
   *
   * @return The response body.
   * @throws CalFacadeException
   */
  public String getResponseBodyAsString() throws CalFacadeException {
    try {
      return method.getResponseBodyAsString();
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }
}