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

import org.bedework.caldav.client.api.CaldavClientIo;
import org.bedework.caldav.client.api.CaldavResp;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;

/** Handle interactions with caldav servers.
 *
 * @author Mike Douglass
 */
public class CalDavClient {
  private boolean debug;

  /* There is one entry per host + port. Because we are likely to make a number
   * of calls to the same host + port combination it makes sense to preserve
   * the objects between calls.
   */
  private HashMap cioTable = new HashMap();

  /**
   *
   */
  public static class Response {
    /** */
    public FBUserInfo ui;

    /** */
    public int responseCode;

    /** */
    public Collection fbs = new ArrayList();

    /** */
    public CaldavResp cdresp;
  }

  /** Constructor
   *
   * @param debug
   * @throws Throwable
   */
  public CalDavClient(boolean debug) throws Throwable {
    this.debug = debug;
  }

  /**
   * @param r
   * @param ui
   * @return Response
   * @throws Throwable
   */
  public Response send(Req r, FBUserInfo ui) throws Throwable {
    CaldavClientIo cio = getCio(ui.getHost(), ui.getPort());
    Response resp = new Response();
    resp.ui = ui;

    if (r.getAuth()) {
      resp.responseCode = cio.sendRequest(r.getMethod(), r.getUrl(),
                                          r.getUser(), r.getPw(),
                                          r.getHeaders(), 0,
                                          r.getContentType(),
                                          r.getContentLength(), r.getContentBytes());
    } else {
      resp.responseCode = cio.sendRequest(r.getMethod(), r.getUrl(),
                                          r.getHeaders(), 0,
                                          r.getContentType(), r.getContentLength(),
                                          r.getContentBytes());
    }

    if (resp.responseCode != HttpServletResponse.SC_OK) {
      error("Got response " + resp.responseCode +
            " for account " + ui.getAccount() +
            ", host " + ui.getHost() +
            " and url " + ui.getUrl());
      return resp;
    }

    resp.cdresp = cio.getResponse();

    return resp;
  }

  private CaldavClientIo getCio(String host, int port) throws Throwable {
    CaldavClientIo cio = (CaldavClientIo)cioTable.get(host + port);

    if (cio == null) {
      cio = new CaldavClientIo(host, port, debug);

      cioTable.put(host + port, cio);
    }

    return cio;
  }

  private void error(String msg) {
    System.err.println(msg);
  }
}
