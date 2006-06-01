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
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calsvc.CalSvc;
import org.bedework.calsvci.CalSvcI;
import org.bedework.calsvci.CalSvcIPars;
import org.bedework.icalendar.IcalTranslator;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.HttpServletResponse;

/** Currently just a proof of concept. Takes a date range and does free/busy
 * queries for a list of users, then generates an aggregated free busy display.
 *
 * @author douglm
 *
 */
public class FreeBusyAggregator {
  private boolean debug = true;
  private CalSvcI svci;
  IcalTranslator trans;

  private static class UserInfo {
    /* user id for server authentication. May be null if anon ok */
    String authUser;
    String authPw;

    /* Whose free busy? */
    String account;

    String host;
    int port;

    boolean secure;

    String url;

    UserInfo(String authUser,
             String authPw,
             String account,
             String host,
             int port,
             boolean secure,
             String url) {
      this.authUser = authUser;
      this.authPw = authPw;
      this.account = account;
      this.host = host;
      this.port = port;
      this.secure = secure;
      this.url = url;
    }
  }

  private static class Response {
    UserInfo ui;

    int responseCode;

    Collection fbs = new ArrayList();
  }

  Collection uiList;

  private HashMap cioTable = new HashMap();

  private CaldavClientIo getCio(String host, int port) throws Throwable {
    CaldavClientIo cio = (CaldavClientIo)cioTable.get(host + port);

    if (cio == null) {
      cio = new CaldavClientIo(host, port, debug);

      cioTable.put(host + port, cio);
    }

    return cio;
  }

  private Req makeFreeBusyRequest(Date start, Date end, UserInfo ui) throws Throwable {
    Req req;

    if (ui.authUser == null) {
      req = new Req();
    } else {
      req = new Req(ui.authUser, ui.authPw);
    }

    req.setUrl(ui.url);
    req.setContentType("text/xml");
    req.setMethod("REPORT");
    req.addHeader("Depth", "0");

    req.addContentLine("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
    req.addContentLine("<C:free-busy-query xmlns:C=\"urn:ietf:params:xml:ns:caldav\">");
//    req.addContentLine("  <C:time-range start=\"" +
//                               CalFacadeUtil.isoDateTimeUTC(start) + "\"");
//    req.addContentLine("                end=\"" +
//                               CalFacadeUtil.isoDateTimeUTC(end) + "\"/>");
    req.addContentLine("  <C:time-range start=\"20060601T131358Z\"");
    req.addContentLine("                end=\"20060631T131358Z\"/>");
    req.addContentLine("</C:free-busy-query>");

    return req;
  }

  private void addUser(UserInfo ui) {
    if (uiList == null) {
      uiList = new ArrayList();
    }

    uiList.add(ui);
  }

  private void init() throws Throwable {
    /*
    addUser(new UserInfo("testuser01", "bedework", "douglm",
                         "localhost", 8080, false,
                         "/ucaldav/user/douglm"));
    addUser(new UserInfo("testuser01", "bedework", "johnsa",
                         "localhost", 8080, false,
                         "/ucaldav/user/johnsa"));
                         */
    /*
    addUser(new UserInfo("testuser02", "bedework", "testuser02",
                         "www.bedework.org", 80, false,
                         "/ucaldav/user/testuser02"));
                         */
    addUser(new UserInfo("douglm", "bedework", "douglm",
                         "localhost", 8080, false,
                         "/ucaldav/user/douglm"));
/*
    addUser(new UserInfo("testuser02", "bedework", "testuser02",
                         "www.bedework.org", 80, false,
                         "/ucaldav/user/testuser02"));
    addUser(new UserInfo("testuser08", "bedework", "testuser08",
                         "www.bedework.org", 80, false,
                         "/ucaldav/user/testuser08"));
*/
    getSvci(); //
  }

  private Collection getFreeBusy(Date start, Date end) throws Throwable {
    ArrayList responses = new ArrayList();
    Iterator it = uiList.iterator();

    while (it.hasNext()) {
      UserInfo ui = (UserInfo)it.next();

      Req r = makeFreeBusyRequest(start, end, ui);
      CaldavClientIo cio = getCio(ui.host, ui.port);
      Response resp = new Response();
      resp.ui = ui;

      responses.add(resp);

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
              " for account " + ui.account +
              ", host " + ui.host +
              " and url " + ui.url);
        continue;
      }

      CaldavResp cdresp = cio.getResponse();

      /* We expect a VCALENDAR object containg VFREEBUSY components
       */
      InputStream in = cdresp.getContentStream();

      Collection fbs = trans.fromIcal(null, new InputStreamReader(in));

      Iterator fbit = fbs.iterator();
      while (fbit.hasNext()) {
        Object o = fbit.next();

        if (o instanceof BwFreeBusy) {
          BwFreeBusy fb = (BwFreeBusy)o;

          fb.setWho(new BwUser(ui.account));
          resp.fbs.add(fb);
        }
      }
    }

    return responses;
  }

  /**
   *
   */
  public void close() {
    try {
      close(svci);
    } catch (Throwable t) {
    }
  }

  /* ====================================================================
   *                         Private methods
   * ==================================================================== */

  /** Use this for timezones
   *
   * @return CalSvcI
   * @throws CalFacadeException
   */
  private CalSvcI getSvci() throws CalFacadeException {
    boolean publicMode = true;

    if (svci != null) {
      if (!svci.isOpen()) {
        svci.open();
        svci.beginTransaction();
      }

      return svci;
    }

    svci = new CalSvc();
    /* account is what we authenticated with.
     * user, if non-null, is the user calendar we want to access.
     */
    CalSvcIPars pars = new CalSvcIPars(null, // account,
                                       null, // account,
                                       null, // calSuite,
                                       "org.bedework.app.freebusy.",
                                       publicMode,
                                       true,    // caldav
                                       null, // synchId
                                       debug);
    svci.init(pars);

    svci.open();
    svci.beginTransaction();

    trans = new IcalTranslator(svci.getIcalCallback(), debug);

    return svci;
  }

  private void close(CalSvcI svci) throws CalFacadeException {
    if ((svci == null) || !svci.isOpen()) {
      return;
    }

    try {
      svci.endTransaction();
    } catch (CalFacadeException cfe) {
      try {
        svci.close();
      } catch (Throwable t1) {
      }
      svci = null;
      throw cfe;
    }

    try {
      svci.close();
    } catch (CalFacadeException cfe) {
      svci = null;
      throw cfe;
    }
  }

  boolean processArgs(String[] args) throws Throwable {
    if (args == null) {
      return true;
    }

    for (int i = 0; i < args.length; i++) {
      if (args[i].equals("-debug")) {
        debug = true;
      } else if (args[i].equals("-ndebug")) {
        debug = false;
      } else {
        error("Illegal argument: '" + args[i] + "'");
        usage();
        return false;
      }
    }

    return true;
  }

  void usage() {
    System.out.println("Usage:");
    System.out.println("args   -appname name");
    System.out.println("       -f restorefilename");
    System.out.println("");
  }

  boolean argpar(String n, String[] args, int i) throws Exception {
    if (!args[i].equals(n)) {
      return false;
    }

    if ((i + 1) == args.length) {
      throw new Exception("Invalid args");
    }
    return true;
  }

  private void error(String msg) {
    System.err.println(msg);
  }

  /** Main
   *
   * @param args
   */
  public static void main(String[] args) {
    FreeBusyAggregator fba = new FreeBusyAggregator();

    try {
      fba.init();

      Calendar cal = Calendar.getInstance();
      cal.add(Calendar.WEEK_OF_YEAR, 1);

      Collection responses = fba.getFreeBusy(new Date(), cal.getTime());

      fba.close();

      Iterator it = responses.iterator();
      while (it.hasNext()) {
        Response resp = (Response)it.next();

        if (resp.responseCode != HttpServletResponse.SC_OK) {
          out("Response code for " + resp.ui.account + " = " + resp.responseCode);
        } else {

        }
      }
    } catch (Throwable t) {
      t.printStackTrace();
      fba.error(t.getMessage());
    }
  }

  private static void out(String msg) {
    System.out.println(msg);
  }
}
