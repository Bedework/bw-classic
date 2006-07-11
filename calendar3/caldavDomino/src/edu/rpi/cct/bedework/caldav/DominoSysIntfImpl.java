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
package edu.rpi.cct.bedework.caldav;

import org.bedework.caldav.client.api.CaldavClientIo;
import org.bedework.caldav.client.api.CaldavReq;
import org.bedework.caldav.client.api.CaldavResp;
import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwFreeBusy;
import org.bedework.calfacade.BwFreeBusyComponent;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.ifs.CalTimezones;

import edu.rpi.cct.uwcal.caldav.IcalTrans;
import edu.rpi.cct.uwcal.caldav.SysIntf;
import edu.rpi.cct.webdav.servlet.shared.WebdavException;
import edu.rpi.cct.webdav.servlet.shared.WebdavIntfException;

import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.TimeZone;

import org.apache.commons.httpclient.NoHttpResponseException;
import org.apache.log4j.Logger;

import java.io.Reader;
import java.io.Serializable;
import java.net.URI;
import java.net.URL;
import java.net.URLDecoder;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** Domino implementation of SysIntf.
 *
 * @author Mike Douglass douglm at rpi.edu
 */
public class DominoSysIntfImpl implements SysIntf {
  /* There is one entry per host + port. Because we are likely to make a number
   * of calls to the same host + port combination it makes sense to preserve
   * the objects between calls.
   */
  private HashMap cioTable = new HashMap();

  /* These could come from a db
   */
  private static class DominoInfo implements Serializable {
    String host;
    int port;
    String urlPrefix;
    boolean secure;

    DominoInfo(String host, int port, String urlPrefix, boolean secure) {
      this.host = host;
      this.port = port;
      this.urlPrefix = urlPrefix;
      this.secure= secure;
    }

    /**
     * @return String
     */
    public String getHost() {
      return host;
    }

    /**
     * @return int
     */
    public int getPort() {
      return port;
    }

    /**
     * @return String
     */
    public boolean getSecure() {
      return secure;
    }

    /**
     * @return String
     */
    public String getUrlPrefix() {
      return urlPrefix;
    }
  }

  private static final DominoInfo egenconsultingInfo =
    new DominoInfo("t1.egenconsulting.com", 80, "/servlet/Freetime", false);

  private static final DominoInfo showcase2Info =
    new DominoInfo("showcase2.notes.net", 443, "/servlet/Freetime", true);

  private static final HashMap serversInfo = new HashMap();

  static {
    serversInfo.put("egenconsulting", egenconsultingInfo);
    serversInfo.put("showcase2", showcase2Info);
  }

  private boolean debug;

  private transient Logger log;

  /* Prefix for our properties */
  private String envPrefix;

  private String account;

  private IcalTrans trans;

  public void init(HttpServletRequest req,
                   String envPrefix,
                   String account,
                   boolean debug) throws WebdavIntfException {
    try {
      this.envPrefix = envPrefix;
      this.account = account;
      this.debug = debug;

      trans = new IcalTrans(debug);
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  public void addEvent(BwCalendar cal,
                       BwEvent event,
                       Collection overrides) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public void updateEvent(BwEvent event) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public Collection getEventsExpanded(BwCalendar cal) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public Collection getEvents(BwCalendar cal,
                              int recurRetrieval) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public Collection getEvents(BwCalendar cal,
                              BwDateTime startDate, BwDateTime endDate,
                              int recurRetrieval) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public Collection findEventsByName(BwCalendar cal, String val)
              throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public void deleteEvent(BwEvent ev) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public BwFreeBusy getFreeBusy(BwCalendar cal,
                                String account,
                                BwDateTime start,
                                BwDateTime end) throws WebdavException {
    /* Create a url something like:
     *  http://t1.egenconsulting.com:80/servlet/Freetime/John?start-min=2006-07-11T12:00:00Z&start-max=2006-07-16T12:00:00Z
     */
    try {
      String serviceName = getServiceName(cal.getPath());

      DominoInfo di = (DominoInfo)serversInfo.get(serviceName);
      if (di == null) {
        throw WebdavIntfException.badRequest();
      }

      CaldavReq req = new CaldavReq();

      req.setMethod("GET");
      req.setUrl(di.getUrlPrefix() + "/" +
                 cal.getOwner().getAccount() + "?" +
                 "start-min=" + makeDateTime(start) + "&" +
                 "start-max=" + makeDateTime(end));

      CaldavResp resp = send(req, di);

      return null;
    } catch (WebdavIntfException wie) {
      throw wie;
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  public void updateAccess(BwCalendar cal,
                           Collection aces) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public void updateAccess(BwEvent ev,
                           Collection aces) throws WebdavIntfException{
    throw new WebdavIntfException("unimplemented");
  }

  public void makeCollection(String name, boolean calendarCollection,
                             String parentPath) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public BwCalendar getCalendar(String path) throws WebdavIntfException {
    // XXX Just fake it up for the moment.
    /* The path should always start with /server-name/user
     */

    List l = splitUri(path, true);

    String namePart = (String)l.get(l.size() - 1);

    BwCalendar cal = new BwCalendar();
    cal.setName(namePart);
    cal.setPath(path);

    String owner = (String)l.get(1);

    cal.setOwner(new BwUser(owner));

    return cal;
  }

  public Calendar toCalendar(BwEvent ev) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public Calendar toCalendar(Collection evs) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public Collection fromIcal(BwCalendar cal, Reader rdr) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public CalTimezones getTimezones() throws WebdavIntfException {
    try {
      return getTrans().getTimezones();
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  public TimeZone getDefaultTimeZone() throws WebdavIntfException {
    try {
      return getTrans().getDefaultTimeZone();
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  public String toStringTzCalendar(String tzid) throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public int getMaxUserEntitySize() throws WebdavIntfException {
    throw new WebdavIntfException("unimplemented");
  }

  public void close() throws WebdavIntfException {
    try {
      trans.close();
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  /* ====================================================================
   *                         Private methods
   * ==================================================================== */

  private IcalTrans getTrans() throws WebdavIntfException {
    try {
      trans.open();

      return trans;
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  private String makeDateTime(BwDateTime dt) throws WebdavIntfException {
    try {
      String utcdt = dt.getDate();

      StringBuffer sb = new StringBuffer();

      // from 20060716T120000Z make 2006-07-16T12:00:00Z
      //      0   4 6    1 3
      sb.append(sb.substring(0, 4));
      sb.append("-");
      sb.append(sb.substring(4, 6));
      sb.append("-");
      sb.append(sb.substring(6, 11));
      sb.append(":");
      sb.append(sb.substring(11, 13));
      sb.append(":");
      sb.append(sb.substring(13));

      return sb.toString();
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  private net.fortuna.ical4j.model.DateTime makeIcalDateTime(String val)
          throws WebdavIntfException {
    try {
      net.fortuna.ical4j.model.DateTime icaldt =
        new net.fortuna.ical4j.model.DateTime(val);
      //icaldt.setUtc(true);
      return icaldt;
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }
  }

  private List splitUri(String uri, boolean decoded) throws WebdavIntfException {
    try {
      /*Remove all "." and ".." components */
      if (decoded) {
        uri = new URI(null, null, uri, null).toString();
      }

      uri = new URI(uri).normalize().getPath();
      if (debug) {
        debugMsg("Normalized uri=" + uri);
      }

      uri = URLDecoder.decode(uri, "UTF-8");

      if (!uri.startsWith("/")) {
        return null;
      }

      if (uri.endsWith("/")) {
        uri = uri.substring(0, uri.length() - 1);
      }

      String[] ss = uri.split("/");
      int pathLength = ss.length - 1;  // First element is empty string

      if (pathLength < 2) {
        throw WebdavIntfException.badRequest();
      }

      List l = Arrays.asList(ss);
      return l.subList(1, l.size());
    } catch (Throwable t) {
      if (debug) {
        error(t);
      }
      throw WebdavIntfException.badRequest();
    }
  }

  private String getServiceName(String path) {
    int pos = path.indexOf("/", 1);

    if (pos < 0) {
      return path.substring(1);
    }

    return path.substring(1, pos);
  }

  /**
   * @param r
   * @param di
   * @param url
   * @return CaldavResp
   * @throws Throwable
   */
  private CaldavResp send(CaldavReq r, DominoInfo di) throws Throwable {
    CaldavClientIo cio = getCio(di.getHost(), di.getPort(), di.getSecure());

    int responseCode;

    try {
      if (r.getAuth()) {
        responseCode = cio.sendRequest(r.getMethod(), r.getUrl(),
                                       r.getUser(), r.getPw(),
                                       r.getHeaders(), 0,
                                       r.getContentType(),
                                       r.getContentLength(), r.getContentBytes());
      } else {
        responseCode = cio.sendRequest(r.getMethod(), r.getUrl(),
                                       r.getHeaders(), 0,
                                       r.getContentType(), r.getContentLength(),
                                       r.getContentBytes());
      }

      if (responseCode != HttpServletResponse.SC_OK) {
        if (debug) {
          debugMsg("Got response " + responseCode +
                   " for url " + r.getUrl() +
                   ", host " + di.getHost());
        }

        throw new WebdavIntfException(responseCode);
      }
    } catch (WebdavIntfException wie) {
      throw wie;
    } catch (NoHttpResponseException nhre) {
      throw new WebdavIntfException(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
    } catch (Throwable t) {
      throw new WebdavIntfException(t);
    }

    return cio.getResponse();
  }

  private CaldavClientIo getCio(String host, int port, boolean secure) throws Throwable {
    CaldavClientIo cio = (CaldavClientIo)cioTable.get(host + port + secure);

    if (cio == null) {
      cio = new CaldavClientIo(host, port, 30 * 1000, secure, debug);

      cioTable.put(host + port + secure, cio);
    }

    return cio;
  }

  /* ====================================================================
   *                        Protected methods
   * ==================================================================== */

  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void trace(String msg) {
    getLogger().debug(msg);
  }

  protected void debugMsg(String msg) {
    getLogger().debug(msg);
  }

  protected void warn(String msg) {
    getLogger().warn(msg);
  }

  protected void error(String msg) {
    getLogger().error(msg);
  }

  protected void error(Throwable t) {
    getLogger().error(this, t);
  }

  protected void logIt(String msg) {
    getLogger().info(msg);
  }
}
