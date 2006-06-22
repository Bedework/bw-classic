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

import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwUser;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
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
  private IcalTrans trans;

  private FBInfoSet infoset;

  private Req makeFreeBusyRequest(Date start, Date end, FBUserInfo ui) throws Throwable {
    Req req;

    if (ui.getAuthUser() == null) {
      req = new Req();
    } else {
      req = new Req(ui.getAuthUser(), ui.getAuthPw());
    }

    req.setUrl(ui.getUrl());
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

  private void init() throws Throwable {
    infoset = new FBInfoSet();
    trans = new IcalTrans(debug);
  }

  private Collection getFreeBusy(Date start, Date end) throws Throwable {
    ArrayList responses = new ArrayList();
    Iterator it = infoset.getAll().iterator();

    CalDavClient cd = new CalDavClient(debug);

    while (it.hasNext()) {
      FBUserInfo ui = (FBUserInfo)it.next();

      Req r = makeFreeBusyRequest(start, end, ui);
      CalDavClient.Response resp = cd.send(r, ui);

      responses.add(resp);

      if (resp.responseCode != HttpServletResponse.SC_OK) {
        continue;
      }

      /* We expect a VCALENDAR object containg VFREEBUSY components
       */
      InputStream in = resp.cdresp.getContentStream();

      Collection fbs = trans.getFreeBusy(new InputStreamReader(in));

      Iterator fbit = fbs.iterator();
      while (fbit.hasNext()) {
        Object o = fbit.next();

        if (o instanceof BwFreeBusy) {
          BwFreeBusy fb = (BwFreeBusy)o;

          fb.setWho(new BwUser(ui.getAccount()));
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
      trans.close();
    } catch (Throwable t) {
    }
  }

  /* ====================================================================
   *                         Private methods
   * ==================================================================== */

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
        CalDavClient.Response resp = (CalDavClient.Response)it.next();

        if (resp.responseCode != HttpServletResponse.SC_OK) {
          out("Response code for " + resp.ui.getAccount() + " = " + resp.responseCode);
        } else {

        }
      }
    } catch (Throwable t) {
      t.printStackTrace();
      fba.error(t.getMessage());
    }
  }

  private void error(String msg) {
    System.err.println(msg);
  }

  private static void out(String msg) {
    System.out.println(msg);
  }
}
