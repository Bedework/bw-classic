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

package edu.rpi.cct.uwcal.caldav;

import org.bedework.icalendar.IcalUtil;
import org.bedework.icalendar.VEventUtil;

import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.data.CalendarParserImpl;
import net.fortuna.ical4j.data.UnfoldingReader;
import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.Date;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.PeriodList;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.property.DtStart;

import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.Socket;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeSet;

/** Temp to try to fire requests at this thing.
 *
 * <p>Also occassionally used to test other components
 */
public class TestCalDav {
  /** Main method
   *
   * @param args
   */
  public static void main(String[] args) {
    init();

    try {
      DtStart ds = new DtStart("TZID=US/Eastern:20060109T100000");
      System.out.println("ds=" + ds);

      DtStart ds2 = new DtStart(ds.getDate(), true);
      System.out.println("ds2=" + ds2);
    } catch (Throwable t) {
      t.printStackTrace();
    }


    for (int i = 0; i < args.length; i++) {
      if ("list-tests".equals(args[i])) {
        Iterator it = new TreeSet(reqs.keySet()).iterator();

        System.out.println("*****************  tests **************");
        while (it.hasNext()) {
          String tname = (String)it.next();
          Req r = (Req)reqs.get(tname);

          System.out.println("Test " + tname + ": " + r.description);
        }
        System.out.println("********************************************");
      } else if ("date-test".equals(args[i])) {
        testDates();
      } else if ("ical-test".equals(args[i])) {
        i++;
        testIcal(args[i]);
      } else {
        Req r = (Req)reqs.get(args[i]);

        if (r == null) {
          System.out.println("********************************************");
          System.out.println("********************************************");
          System.out.println("     Unknown test " + args[i]);
          System.out.println("     Try list-tests");
          System.out.println("********************************************");
          System.out.println("********************************************");
        } else {
          System.out.println("Test " + args[i] + ": " + r.description);
          doReq(r);
        }
      }
    }
  }

  static class Req {
    String description;
    byte[] headers;
    byte[] content;

    Req(String description, String headers, String content) {
      this.description = description;
      this.content = content.getBytes();

      if (content != null) {
        headers = headers +
            "Content-Length: " + this.content.length + "\n" +
            "\n";
      }

      this.headers = headers.getBytes();
    }
  }

  static void doReq(Req r) {
    try {
      Socket conn = new Socket("localhost", 8080);

      OutputStream out = conn.getOutputStream();

      out.write(r.headers);

      if (r.content != null) {
        out.write(r.content);
      }

      out.flush();

       InputStream in = conn.getInputStream();
       LineNumberReader lnr = new LineNumberReader(
            new InputStreamReader(in));

       do {
         String ln = lnr.readLine();

         if (ln == null) {
           break;
         }

         System.out.println(ln);
       } while (true);
    } catch (Throwable t) {
      t.printStackTrace();
    }
  }

  /*
      // Install the custom authenticator
    Authenticator.setDefault(new MyAuthenticator());

    // Access the page
    try {
        // Create a URL for the desired page
        URL url = new URL("http://hostname:80/index.html");

        // Read all the text returned by the server
        BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
        String str;
        while ((str = in.readLine()) != null) {
            // str is one line of text; readLine() strips the newline character(s)
        }
        in.close();
    } catch (MalformedURLException e) {
    } catch (IOException e) {
    }

    public class MyAuthenticator extends Authenticator {
        // This method is called when a password-protected URL is accessed
        protected PasswordAuthentication getPasswordAuthentication() {
            // Get information about the request
            String promptString = getRequestingPrompt();
            String hostname = getRequestingHost();
            InetAddress ipaddr = getRequestingSite();
            int port = getRequestingPort();

            // Get the username from the user...
            String username = "myusername";

            // Get the password from the user...
            String password = "mypassword";

            // Return the information
            return new PasswordAuthentication(username, password.toCharArray());
        }
    }
    -------------------------------------------------------
     try {
        // Construct data
        String data = URLEncoder.encode("key1", "UTF-8") + "=" + URLEncoder.encode("value1", "UTF-8");
        data += "&" + URLEncoder.encode("key2", "UTF-8") + "=" + URLEncoder.encode("value2", "UTF-8");

        // Send data
        URL url = new URL("http://hostname:80/cgi");
        URLConnection conn = url.openConnection();
        conn.setDoOutput(true);
        OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
        wr.write(data);
        wr.flush();

        // Get the response
        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String line;
        while ((line = rd.readLine()) != null) {
            // Process line...
        }
        wr.close();
        rd.close();
    } catch (Exception e) {
    }

*/

  private static class Ev {
    int evnum;
    String start;
    String end;

    Ev(int evnum, String start, String end) {
      this.evnum = evnum;
      this.start = start;
      this.end = end;
    }

    public String toString() {
      return "Ev: {evnum=" + evnum + " start=" + start + " end=" + end + "}";
    }
  }

  /** Test date range checks */
  static void testDates() {
    Ev[] evs = {
      new Ev(1, "20051028", "20051029"),
      new Ev(2, "20051028", "20051028"),
      new Ev(3, "20051028T000000", "20051029T000000"),
      new Ev(4, "20051028T100000", "20051028T110000"),
    };

    testDate(evs, "20051028", "20051029");
    testDate(evs, "20051027", "20051028");

    System.out.println(" ");
    testDate(evs, "20051028", "20051028");
    testDate(evs, "20051027", "20051027");

    System.out.println(" ");
    testDate(evs, "20051028T000000", "20051029T000000");
    testDate(evs, "20051027T000000", "20051028T000000");

    Ev[] evs2 = {
       new Ev(1, "20051001T000000", "20051114T000000"),
       new Ev(2, "20051023T090000", "20051023T100000"),
       new Ev(3, "20051023T140014", "20051023T163014"),
       new Ev(4, "20051024T000000", "20051028T000000"),
       new Ev(5, "20051024T040012", "20051024T050012"),
       new Ev(6, "20051024T090000", "20051028T170000"),
       new Ev(7, "20051024T140025", "20051024T150025"),
       new Ev(8, "20051026T140000", "20051026T160000"),
       new Ev(9, "20051026T160004", "20051026T170004"),
       new Ev(10, "20051026T170000", "20051026T190000"),
       new Ev(11, "20051026T173031", "20051026T193031"),
       new Ev(12, "20051026T183015", "20051026T183015"),
       new Ev(13, "20051026T185545", "20051223T185545"),
       new Ev(14, "20051026T193019", "20051026T210019"),
       new Ev(15, "20051027T190010", "20051027T210010"),
       new Ev(16, "20051028T103031", "20051028T113031"),
       new Ev(17, "20051028T190015", "20051028T213015"),
       new Ev(18, "20051028T190018", "20051028T210018"),
    };

    System.out.println("Try dividing into days: ");

    testDate(evs2, "20051028T000000", "20051029T000000");
  }

  static void testDate(Ev[] evs, String start, String end) {
    for (int i = 0; i < evs.length; i++) {
      Ev ev = evs[i];

      /*
       (DTSTART <= start AND DTEND > start) OR
       (DTSTART <= start AND DTSTART+DURATION > start) OR
       (DTSTART >= start AND DTSTART < end) OR
       (DTEND   > start AND DTEND <= end)
       */

      int evstSt = ev.start.compareTo(start);
      int evendSt = ev.end.compareTo(start);

      boolean passes1 = (evstSt <= 0 && evendSt > 0);
      boolean passes2 = (evstSt >= 0 && ev.start.compareTo(end) < 0);
      boolean passes3 = (evendSt > 0 && ev.end.compareTo(end) <= 0);

      boolean passes = passes1 || passes2 || passes3;

      System.out.println(ev +
                         " start=" + start + " end=" + end +
                         " passes=" + passes + "(" +
                         passes1 + ", " + passes2 + ", " + passes3 + ")");
    }
    System.out.println(" ");
  }

  /** Some ical tests - read a file and say something about it.
   *
   * @param fileName String anme of file.
   */
  static void testIcal(String fileName) {
    try {
      Calendar cal = getCalendar(new FileReader(fileName));
      calInfo(cal);
    } catch (Throwable t) {
      t.printStackTrace();
    }
  }

  private static void calInfo(Calendar cal) throws Throwable {
    ComponentList clist = cal.getComponents();

    Iterator it = clist.iterator();

    while (it.hasNext()) {
      Object o = it.next();

      msg("Got component " + o.getClass().getName());

      if (o instanceof VEvent) {
        VEvent ev = (VEvent)o;

        eventInfo(ev);
        /*
      } else if (o instanceof VTimeZone) {
        VTimeZone vtz = (VTimeZone)o;

        debugMsg("Got timezone: \n" + vtz.toString());
        */
      }
    }
  }

  private static void eventInfo(VEvent ev) throws Throwable {
    String desc = IcalUtil.getPropertyVal(ev, Property.DESCRIPTION);

    if (desc != null) {
      msg(desc);
      msg("");
    }

    Date start = ev.getStartDate().getDate();
    Date until = VEventUtil.getLatestRecurrenceDate(ev, true);
    if (until == null) {
      msg("Unlimited recurrence");
    } else {
      msg("Latest recurrence at " + until);

      PeriodList pl = ev.getConsumedTime(start, until);

      Iterator it = pl.iterator();

      while (it.hasNext()) {
        Period p = (Period)it.next();

        msg("period - start=" + p.getStart() + " end=" + p.getEnd());
      }
    }
  }

  /** Convert the given string representation of an Icalendar object to a
   * Calendar object
   *
   * @param rdr
   * @return Calendar
   * @throws Throwable
   */
  public static Calendar getCalendar(Reader rdr) throws Throwable {
    System.setProperty("ical4j.unfolding.relaxed", "true");
    CalendarBuilder bldr = new CalendarBuilder(new CalendarParserImpl());

    return bldr.build(new UnfoldingReader(rdr));
  }

  static HashMap reqs = new HashMap();

  static void init() {
    /* ------------------------------------------------------------------
     *     Section 8.3.1 draft 5 - timerange - no auth
     * ------------------------------------------------------------------ */

    reqs.put("eg1", new Req(
        "Section 8.3.1 draft 5 - timerange - no auth",

        "REPORT /pubcaldav/public/ HTTP/1.1\n" +
        "Host: localhost\n" +
//        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<C:calendar-query xmlns:D=\"DAV:\"\n" +
        "                  xmlns:C=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <D:prop>\n" +
        "    <D:getetag/>\n" +
        "  </D:prop>\n" +
        "  <C:calendar-data>\n" +
        "    <C:comp name=\"VCALENDAR\">\n" +
        "      <C:allprop/>\n" +
        "      <C:comp name=\"VEVENT\">\n" +
        "        <C:prop name=\"X-ABC-GUID\"/>\n" +
        "        <C:prop name=\"UID\"/>\n" +
        "        <C:prop name=\"DTSTART\"/>\n" +
        "        <C:prop name=\"DTEND\"/>\n" +
        "        <C:prop name=\"DURATION\"/>\n" +
        "        <C:prop name=\"EXDATE\"/>\n" +
        "        <C:prop name=\"EXRULE\"/>\n" +
        "        <C:prop name=\"RDATE\"/>\n" +
        "        <C:prop name=\"RRULE\"/>\n" +
        "        <C:prop name=\"LOCATION\"/>\n" +
        "        <C:prop name=\"SUMMARY\"/>\n" +
        "      </C:comp>\n" +
        "      <C:comp name=\"VTIMEZONE\">\n" +
        "        <C:allprop/>\n" +
        "        <C:allcomp/>\n" +
        "      </C:comp>\n" +
        "    </C:comp> \n" +
        "  </C:calendar-data>\n" +
        "  <C:filter> <!-- a comment -->\n" +
        "    <C:comp-filter name=\"VCALENDAR\">\n" +
        "      <C:comp-filter name=\"VEVENT\">\n" +
        "        <C:time-range start=\"20040902T000000Z\"\n" +
        "                      end=\"20040902T235959Z\"/>\n" +
        "      </C:comp-filter>\n" +
        "    </C:comp-filter>\n" +
        "  </C:filter>\n" +
        "</C:calendar-query>\n"));

    /* ------------------------------------------------------------------
     *     Section 8.3.1 draft 5 - timerange - auth
     * ------------------------------------------------------------------ */

    reqs.put("eg2", new Req(
        "Section 8.3.1 draft 5 - timerange - auth",

        "REPORT /ucaldav/user/caluser/calendar/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<C:calendar-query xmlns:D=\"DAV:\"\n" +
        "                  xmlns:C=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <D:prop>\n" +
        "    <D:getetag/>\n" +
        "  </D:prop>\n" +
        "  <C:calendar-data>\n" +
        "    <C:comp name=\"VCALENDAR\">\n" +
        "      <C:allprop/>\n" +
        "      <C:comp name=\"VEVENT\">\n" +
        "        <C:prop name=\"X-ABC-GUID\"/>\n" +
        "        <C:prop name=\"UID\"/>\n" +
        "        <C:prop name=\"DTSTART\"/>\n" +
        "        <C:prop name=\"DTEND\"/>\n" +
        "        <C:prop name=\"DURATION\"/>\n" +
        "        <C:prop name=\"EXDATE\"/>\n" +
        "        <C:prop name=\"EXRULE\"/>\n" +
        "        <C:prop name=\"RDATE\"/>\n" +
        "        <C:prop name=\"RRULE\"/>\n" +
        "        <C:prop name=\"LOCATION\"/>\n" +
        "        <C:prop name=\"SUMMARY\"/>\n" +
        "      </C:comp>\n" +
        "      <C:comp name=\"VTIMEZONE\">\n" +
        "        <C:allprop/>\n" +
        "        <C:allcomp/>\n" +
        "      </C:comp>\n" +
        "    </C:comp> \n" +
        "  </C:calendar-data>\n" +
        "  <C:filter> <!-- a comment -->\n" +
        "    <C:comp-filter name=\"VCALENDAR\">\n" +
        "      <C:comp-filter name=\"VEVENT\">\n" +
        "        <C:time-range start=\"20050402T000000Z\"\n" +
        "                      end=\"20050602T235959Z\"/>\n" +
        "      </C:comp-filter>\n" +
        "    </C:comp-filter>\n" +
        "  </C:filter>\n" +
        "</C:calendar-query>\n"));

    /* ------------------------------------------------------------------
     *     All data for caluser
     * ------------------------------------------------------------------ */

    reqs.put("eg3", new Req(
         "All data for caluser",

        "REPORT /ucaldav/user/caluser/calendar/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<C:calendar-query xmlns:D=\"DAV:\"\n" +
        "                  xmlns:C=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <D:prop>\n" +
        "    <D:getetag/>\n" +
        "  </D:prop>\n" +
        "  <C:calendar-data/>\n" +
        "  <C:filter> <!-- a comment -->\n" +
        "    <C:comp-filter name=\"VCALENDAR\">\n" +
        "      <C:comp-filter name=\"VEVENT\">\n" +
        "      </C:comp-filter>\n" +
        "    </C:comp-filter>\n" +
        "  </C:filter>\n" +
        "</C:calendar-query>\n"));

    /* ------------------------------------------------------------------
     *     All public data (a lot)
     * ------------------------------------------------------------------ */

    reqs.put("eg4", new Req(
        "All public data (a lot)",

        "REPORT /pubcaldav/public/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<C:calendar-query xmlns:D=\"DAV:\"\n" +
        "                  xmlns:C=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <D:prop>\n" +
        "    <D:getetag/>\n" +
        "  </D:prop>\n" +
        "  <C:calendar-data/>\n" +
        "  <C:filter> <!-- a comment -->\n" +
        "    <C:comp-filter name=\"VCALENDAR\">\n" +
        "      <C:comp-filter name=\"VEVENT\">\n" +
        "      </C:comp-filter>\n" +
        "    </C:comp-filter>\n" +
        "  </C:filter>\n" +
        "</C:calendar-query>\n"));

    /* ------------------------------------------------------------------
     *     8.4.1 multiget,auth + hrefs
     * ------------------------------------------------------------------ */

    reqs.put("eg5", new Req(
        "8.4.1 multiget,auth + hrefs",

        "REPORT /ucaldav/user/caluser/calendar/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<C:calendar-multiget xmlns:D=\"DAV:\"\n" +
        "                     xmlns:C=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <D:prop>\n" +
        "    <D:getetag/>\n" +
        "  </D:prop>\n" +
        "  <C:calendar-data>\n" +
        "    <C:comp name=\"VCALENDAR\">\n" +
        "      <C:allprop/>\n" +
        "      <C:comp name=\"VEVENT\">\n" +
        "        <C:prop name=\"X-ABC-GUID\"/>\n" +
        "        <C:prop name=\"UID\"/>\n" +
        "        <C:prop name=\"DTSTART\"/>\n" +
        "        <C:prop name=\"DTEND\"/>\n" +
        "        <C:prop name=\"DURATION\"/>\n" +
        "        <C:prop name=\"EXDATE\"/>\n" +
        "        <C:prop name=\"EXRULE\"/>\n" +
        "        <C:prop name=\"RDATE\"/>\n" +
        "        <C:prop name=\"RRULE\"/>\n" +
        "        <C:prop name=\"LOCATION\"/>\n" +
        "        <C:prop name=\"SUMMARY\"/>\n" +
        "      </C:comp>\n" +
        "      <C:comp name=\"VTIMEZONE\">\n" +
        "        <C:allprop/>\n" +
        "        <C:allcomp/>\n" +
        "      </C:comp>\n" +
        "    </C:comp> \n" +
        "  </C:calendar-data>\n" +
        "  <D:href>http://localhost/ucaldav/user/caluser/calendar/2657-uwcal-demouwcalendar@mysite.edu.ics</D:href>" +
        "  <D:href>http://localhost/ucaldav/user/caluser/calendar/2658-uwcal-demouwcalendar@mysite.edu.ics</D:href>" +
        "  <D:href>http://localhost/ucaldav/user/caluser/calendar/84488E9AF4B99BAEAFF3970240E57BC1-0.ics</D:href>" +
        "  <D:href>http://localhost/ucaldav/user/caluser/calendar/bogus.ics</D:href>" +
        "  <D:href>http://localhost/ucaldav/user/caluser/calendar/2656-uwcal-demouwcalendar@mysite.edu.ics</D:href>" +
        "</C:calendar-multiget>"));

    /* ------------------------------------------------------------------
     *     Mozilla lightning query
     * ------------------------------------------------------------------ */

    reqs.put("eg6", new Req(
        "Mozilla lightning query",

        "REPORT /ucaldav/user/caluser/calendar/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<calendar-query xmlns=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <calendar-data/>\n" +
        "  <filter>\n" +
        "    <comp-filter name=\"VCALENDAR\">\n" +
        "      <comp-filter name=\"VEVENT\">\n" +
        "        <time-range start=\"20050529T000000\" end=\"20050604T235959\"/>\n" +
        "      </comp-filter>\n" +
        "    </comp-filter>\n" +
        "  </filter>\n" +
        "</calendar-query>"));

    /* ------------------------------------------------------------------
     *     8.4.1 multiget,auth + relative hrefs
     * ------------------------------------------------------------------ */

    reqs.put("eg7", new Req(
        "8.4.1 multiget,auth + hrefs",

        "REPORT /ucaldav/user/caluser/calendar/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<C:calendar-multiget xmlns:D=\"DAV:\"\n" +
        "                     xmlns:C=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <D:prop>\n" +
        "    <D:getetag/>\n" +
        "  </D:prop>\n" +
        "  <C:calendar-data>\n" +
        "    <C:comp name=\"VCALENDAR\">\n" +
        "      <C:allprop/>\n" +
        "      <C:comp name=\"VEVENT\">\n" +
        "        <C:prop name=\"X-ABC-GUID\"/>\n" +
        "        <C:prop name=\"UID\"/>\n" +
        "        <C:prop name=\"DTSTART\"/>\n" +
        "        <C:prop name=\"DTEND\"/>\n" +
        "        <C:prop name=\"DURATION\"/>\n" +
        "        <C:prop name=\"EXDATE\"/>\n" +
        "        <C:prop name=\"EXRULE\"/>\n" +
        "        <C:prop name=\"RDATE\"/>\n" +
        "        <C:prop name=\"RRULE\"/>\n" +
        "        <C:prop name=\"LOCATION\"/>\n" +
        "        <C:prop name=\"SUMMARY\"/>\n" +
        "      </C:comp>\n" +
        "      <C:comp name=\"VTIMEZONE\">\n" +
        "        <C:allprop/>\n" +
        "        <C:allcomp/>\n" +
        "      </C:comp>\n" +
        "    </C:comp> \n" +
        "  </C:calendar-data>\n" +
        "  <D:href>/ucaldav/user/caluser/calendar/2657-uwcal-demouwcalendar@mysite.edu.ics</D:href>" +
        "  <D:href>/ucaldav/user/caluser/calendar/2658-uwcal-demouwcalendar@mysite.edu.ics</D:href>" +
        "  <D:href>/ucaldav/user/caluser/calendar/84488E9AF4B99BAEAFF3970240E57BC1-0.ics</D:href>" +
        "  <D:href>/ucaldav/user/caluser/calendar/bogus.ics</D:href>" +
        "  <D:href>/ucaldav/user/caluser/calendar/2656-uwcal-demouwcalendar@mysite.edu.ics</D:href>" +
        "</C:calendar-multiget>"));

    /* ------------------------------------------------------------------
        8.3.3 Example: Retrieval of event by UID
     * ------------------------------------------------------------------ */

    reqs.put("eg8", new Req(
        "8.4.1 multiget,auth + hrefs",

        "REPORT /ucaldav/user/caluser/calendar/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>" +
        "<C:calendar-query xmlns:C=\"urn:ietf:params:xml:ns:caldav\">" +
        "  <D:prop xmlns:D=\"DAV:\">" +
        "    <D:getetag/>" +
        "  </D:prop>" +
        "  <C:calendar-data/>" +
        "  <C:filter>" +
        "    <C:comp-filter name=\"VCALENDAR\">" +
        "      <C:comp-filter name=\"VEVENT\">" +
        "        <C:prop-filter name=\"UID\">" +
        "          <C:text-match" +
        "             caseless=\"no\">2685-uwcal-demouwc</C:text-match>" +
        "        </C:prop-filter>" +
        "      </C:comp-filter>" +
        "    </C:comp-filter>" +
        "  </C:filter>" +
        "</C:calendar-query>"));

    /* ------------------------------------------------------------------
        Mulberry style create event and alarm
     * ------------------------------------------------------------------ */

    reqs.put("eg9", new Req(
        "event + alarm",

        "PUT /ucaldav/user/caluser/calendar/6252D6C40A8308BFE25BBDE6zzzzzx-0.ics HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Content-Type: text/calendar\n",

        "BEGIN:VCALENDAR\n" +
        "CALSCALE:GREGORIAN\n" +
        "PRODID:-//Cyrusoft International\\, Inc.//Mulberry v4.0//EN\n" +
        "VERSION:2.0\n" +
        "BEGIN:VEVENT\n" +
        "DESCRIPTION:try an alarm\n" +
        "DTSTAMP:20050621T001530Z\n" +
        "DTSTART:20050621T001500\n" +
        "DURATION:PT1H\n" +
        "LOCATION:here\n" +
        "SUMMARY:try alarm\n" +
        "UID:F672FCF76FABFDE020E0F30F@D76FAF7B10D9E8D2D41F779D\n" +
        "BEGIN:VALARM\n" +
        "ACTION:EMAIL\n" +
        "DESCRIPTION:try alarm\n" +
        "DURATION:PT5M\n" +
        "REPEAT:1\n" +
        "SUMMARY:hi there\n" +
        "ATTENDEE:douglm@rpi.edu\n" +
        "TRIGGER;RELATED=START:-PT3M\n" +
        "X-MULBERRY-ALARM-STATUS:PENDING\n" +
        "END:VALARM\n" +
        "END:VEVENT\n" +
        "END:VCALENDAR"));

    /* ------------------------------------------------------------------
     *  Interop test (sort of) event with attendee
     * ------------------------------------------------------------------ */

    reqs.put("eg10", new Req(
        "event + attendee",

        "PUT /ucaldav/user/caluser/calendar/6252D6C40A8308BFE25BBDEAzzzzzw-0.ics HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Content-Type: text/calendar\n",

        "BEGIN:VCALENDAR\n" +
        "VERSION:2.0\n" +
        "PRODID:-//OracleCalDAVTest//OracleCalDAVTest\n" +
        "BEGIN:VEVENT\n" +
        "UID:OracleCalDAVTest.Meeting11-a\n" +
        "LOCATION:Seattle bis\n" +
        "SUMMARY:OracleCalDAVTest.Meeting 1.1bis\n" +
        "DTSTART:20050608T190000Z\n" +
        "DTEND:20050608T200000Z\n" +
        "ORGANIZER:MAILTO:douglm@rpi.edu\n" +
        "ATTENDEE:MAILTO:johnsa@rpi.edu\n" +
        "END:VEVENT\n" +
        "END:VCALENDAR"));

    /* ------------------------------------------------------------------
     *  Interop test (sort of) report events with organizers
     * ------------------------------------------------------------------ */

    reqs.put("eg11", new Req(
        "Report events with organizer",

        "REPORT /ucaldav/user/caluser/calendar/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<C:calendar-query xmlns:C=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <D:prop xmlns:D=\"DAV:\">\n" +
        "    <D:getetag/>\n" +
        "  </D:prop>\n" +
        "  <C:calendar-data/>\n" +
        "  <C:filter>\n" +
        "    <C:comp-filter name=\"VCALENDAR\">\n" +
        "      <C:comp-filter name=\"VEVENT\">\n" +
        "        <C:prop-filter name=\"ORGANIZER\">\n" +
        "          <C:is-defined/>\n" +
        "        </C:prop-filter>\n" +
        "      </C:comp-filter>\n" +
        "    </C:comp-filter>\n" +
        "  </C:filter>\n" +
        "</C:calendar-query>"));

    /* ------------------------------------------------------------------
     *  Free/busy request
     * ------------------------------------------------------------------ */

    reqs.put("eg12", new Req(
        "Free/busy request",

        "REPORT /ucaldav/user/caluser/calendar/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 1\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<C:free-busy-query xmlns:C=\"urn:ietf:params:xml:ns:caldav\">\n" +
        "  <C:time-range start=\"20050701T000000Z\"\n" +
        "                  end=\"20050731T240000Z\"/>\n" +
        "</C:free-busy-query>"));

    /* ------------------------------------------------------------------
     *     Simple GET with a space in the uri
     * ------------------------------------------------------------------ */

    reqs.put("eg13", new Req(
        "Simple GET with a space in the uri",

        "GET /pubcaldav/public/General%20Calendars/Construction/CAL-ff808081-05e65fdd-0105-e6604c09-05a6.ics HTTP/1.1\n" +
        "Host: localhost\n",

        ""));

    /* ------------------------------------------------------------------
     *     Set caluser/calendar access
     * ------------------------------------------------------------------ */

    reqs.put("eg14", new Req(
        "Set caluser/calendar access",

        "ACL /ucaldav/user/caluser/calendar HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<D:acl xmlns:D=\"DAV:\">\n" +
        "  <D:ace>\n" +
        "    <D:principal>\n" +
        "      <D:href>http://www.example.com/users/douglm</D:href>\n" +
        "    </D:principal>\n" +
        "    <D:grant>\n" +
        "      <D:privilege><D:read/></D:privilege>\n" +
        "      <D:privilege><D:write/></D:privilege>\n" +
        "    </D:grant>\n" +
        "  </D:ace>\n" +
        "  <D:ace>\n" +
        "    <D:principal>\n" +
        "      <D:property><D:owner/></D:property>\n" +
        "    </D:principal>\n" +
        "    <D:grant>\n" +
        "      <D:privilege><D:read-acl/></D:privilege>\n" +
        "      <D:privilege><D:write-acl/></D:privilege>\n" +
        "    </D:grant>\n" +
        "  </D:ace>\n" +
        "  <D:ace>\n" +
        "    <D:principal><D:all/></D:principal>\n" +
        "    <D:grant>\n" +
        "      <D:privilege><D:read/></D:privilege>\n" +
        "    </D:grant>\n" +
        "  </D:ace>\n" +
        "</D:acl>"));

    /* ------------------------------------------------------------------
     *     propfind to display caluser/calendar access
     * ------------------------------------------------------------------ */

    reqs.put("eg15", new Req(
        "propfind to display caluser/calendar access",

        "PROPFIND /ucaldav/user/caluser/calendar HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 0\n" +
        "Content-Type: text/xml\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<D:propfind xmlns:D=\"DAV:\">\n" +
        "  <D:prop>\n" +
        "    <D:getetag/>\n" +
        "    <D:owner/>\n" +
        "    <D:acl/>\n" +
        "  </D:prop>\n" +
        "</D:propfind>"));

    /* ------------------------------------------------------------------
     *     mkcol: create a collection
     * ------------------------------------------------------------------ */

    reqs.put("eg16", new Req(
        "mkcol: create a collection",

        "MKCOL /ucaldav/user/caluser/newcol HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n",

        ""));

    /* ------------------------------------------------------------------
     *     mkcalendar: create a calendar collection
     * ------------------------------------------------------------------ */

    reqs.put("eg17", new Req(
        "mkcalendar: create a collection",

        "MKCALENDAR /ucaldav/user/caluser/newcol/newcalendar HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n",

        ""));

    /* ------------------------------------------------------------------
     *     propfind on user
     * ------------------------------------------------------------------ */

    reqs.put("eg18", new Req(
        "propfind on user",

        "PROPFIND /ucaldav/user/caluser/ HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Depth: 2\n",

        "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
        "<D:propfind xmlns:D=\"DAV:\">\n" +
        "  <D:prop>\n" +
        "    <D:getcontentlength/>\n" +
        "    <D:getcontenttype/>\n" +
        "    <D:resourcetype/>\n" +
        "  </D:prop>\n" +
        "</D:propfind>"));

    /* ------------------------------------------------------------------
     *     Event recurring every 8 days.
     * ------------------------------------------------------------------ */

    reqs.put("eg19", new Req(
        "recur every 8 days",

        "PUT /ucaldav/user/caluser/calendar/6252D6C40A8308BFE25BBDErecur-0.ics HTTP/1.1\n" +
        "Host: localhost\n" +
        "Authorization: Basic Y2FsdXNlcjp1d2NhbA==\n" +
        "Content-Type: text/calendar\n",

        "BEGIN:VCALENDAR\n" +
        "CALSCALE:GREGORIAN\n" +
        "PRODID:-//Cyrusoft International\\, Inc.//Mulberry v4.0//EN\n" +
        "VERSION:2.0\n" +
        "BEGIN:VEVENT\n" +
        "DTSTAMP:20051201T142047Z\n" +
        "DTSTART:20051204T120000\n" +
        "DURATION:PT1H\n" +
        "RRULE:FREQ=DAILY;COUNT=3;INTERVAL=8\n" +
        "SUMMARY:recurring every 8 days\n" +
        "UID:2B60C4C24727BA3B98789C72@D76FAF7B10D9E8D2D41F779C\n" +
        "END:VEVENT\n" +
        "END:VCALENDAR"));

    /* ------------------------------------------------------------------
     *     Nothing to do with caldav
     * ------------------------------------------------------------------ */

    reqs.put("eg99", new Req(
        "Nothing to do with caldav",

        "GET /news/update.do?catcenterkey=45&skinName=rss HTTP/1.1\n" +
        "Host: localhost\n",

        ""));

  }

  private static void msg(String msg) {
    System.out.println(msg);
  }
}
