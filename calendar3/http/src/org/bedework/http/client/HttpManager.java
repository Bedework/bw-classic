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

import org.bedework.calenv.CalEnv;
import org.bedework.calfacade.CalFacadeException;

import org.apache.commons.httpclient.HostConfiguration;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;

/** We want to be able to limit connections on a per user basis as well as
 *  a per system basis. The underlying class also sets a maximum number of
 *  connections allowed per host
 *
 *  <p>One of these objects will be used to get all http connections.
 *
 * @author Mike Douglass  douglm @ rpi.edu
 */
public class HttpManager extends MultiThreadedHttpConnectionManager {
  private int maxConnectionsPerUser;
  private int maxConnectionsPerHost;
  private int maxConnections;

  private String clientClassName;
  /** Constructor - will deliver clients of given class.
   *
   * @param clientClassName  String name of client class
   * @throws CalFacadeException
   */
  public HttpManager(String clientClassName) throws CalFacadeException {
    try {
      maxConnectionsPerUser = CalEnv.getGlobalIntProperty("http.connections.peruser");
      maxConnectionsPerHost = CalEnv.getGlobalIntProperty("http.connections.perhost");
      maxConnections = CalEnv.getGlobalIntProperty("http.connections");

      this.clientClassName = clientClassName;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /**
   * @param hostConfig
   * @return Client
   * @throws CalFacadeException
   */
  public Client getClient(HostConfiguration hostConfig) throws CalFacadeException {
    try {
      Class clazz = Class.forName(clientClassName);

      if (clazz == null) {
        throw new CalFacadeException("Class " + clientClassName + " not found");
      }

      Object o = clazz.newInstance();

      if (o == null) {
        throw new CalFacadeException("Class " + clientClassName +
                                     " cannot be instantiated");
      }

      if (!(o instanceof Client)) {
        throw new CalFacadeException("Class " + clientClassName +
                                  " is not a subclass of " +
                                  Client.class.getName());
      }

      Client cl = (Client)o;
      cl.setHttpConnectionManager(this);
      cl.setHostConfiguration(hostConfig);

      return  cl;
    } catch (CalFacadeException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }
}
