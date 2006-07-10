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

package org.bedework.caldav.test;

/*
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
*/

import org.bedework.caldav.client.api.CaldavClientIo;
import org.bedework.caldav.client.api.CaldavResp;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.FileFilter;
import java.io.InputStream;
import java.io.LineNumberReader;
//import java.io.Reader;
//import java.net.Authenticator;
//import java.net.PasswordAuthentication;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeSet;

/** Try to fire requests at this thing.
 *
 * <p>Also occassionally used to test other components
 */
public class TestCalDav {
  private static boolean debug = true;

  private static String host = "localhost";

  private static int port = 8080;

  private static String user = "douglm";
  private static String pw = "bedework";

  private static String fileRepository = "/home/douglm/calendar3/caldavTest/caldavTestData/eg";

  private static boolean list = false;

  /* Name of file containing list of test names - located in dir */
  private static String testListName;

  private static String dirName = fileRepository;

  private static String fileName;

  private static CaldavClientIo cio;

  private static class TestFilter implements FileFilter {
    public boolean accept(File f) {
      return f.getName().endsWith(".test");
    }
  }

  private static class TestResult {
    String testName;
    boolean ok;
    int responseCode;
    boolean exception;
    String reason;

    TestResult(String testName, boolean ok, int responseCode, boolean exception, String reason) {
      this.testName = testName;
      this.ok = ok;
      this.responseCode = responseCode;
      this.exception = exception;
      this.reason = reason;
    }

    public String toString() {
      StringBuffer sb = new StringBuffer();
      pad(sb, testName, 10);
      sb.append(" ");
      pad(sb, String.valueOf(ok), 4);
      sb.append(" ");
      pad(sb, String.valueOf(responseCode), 4);
      sb.append(" Exc=");
      pad(sb, String.valueOf(exception), 4);
      if (reason != null) {
        sb.append(" ");
        sb.append(reason);
      }

      return sb.toString();
    }

    private static final String padding = "                           ";

    private void pad(StringBuffer sb, String val, int padlen) {
      int len = val.length();

      if (len <= padlen) {
        sb.append(padding.substring(0, padlen - len));
      }

      sb.append(val);
    }
  }

  private static ArrayList results = new ArrayList();

  /** Main method
   *
   * @param args
   */
  public static void main(String[] args) {
    try {
      if (!processArgs(args)) {
        return;
      }

      cio = new CaldavClientIo(host, port, debug);

      File dir = new File(dirName);

      if (!dir.isDirectory()) {
        System.out.println(dirName + "is not a directory.");
        usage();
        return;
      }

      if (fileName == null) {
        // Either use the test list or the sorted directory contents.

        ArrayList tests = new ArrayList();

        if (testListName != null) {
          File testList = new File(dirName + "/" + testListName);
          FileReader frdr = null;

          try {
            frdr = new FileReader(testList);
            LineNumberReader lnr = new LineNumberReader(frdr);

            do {
              String ln = lnr.readLine();

              if (ln == null) {
                break;
              }

              ln = ln.trim();

              if (ln.startsWith("#") || ln.length() == 0) {
                continue;
              }

              tests.add(new File(dirName + "/" + ln + ".test"));
            } while (true);
          } finally {
            if (frdr != null) {
              try {
                frdr.close();
              } catch (Throwable t) {}
            }
          }
        } else {
          File[] dirfiles = dir.listFiles(new TestFilter());
          TreeSet ts = new TreeSet();

          for (int i = 0; i < dirfiles.length; i++) {
            ts.add(dirfiles[i]);
          }

          Iterator it = ts.iterator();
          while (it.hasNext()) {
            tests.add(it.next());
          }
        }

        Iterator it = tests.iterator();
        while (it.hasNext()) {
          File testfile = (File)it.next();
          String fname = testfile.getName();
          String tname = fname.substring(0, fname.length() - 5);

          Req r = new Req(user, pw, testfile.getCanonicalPath());

          System.out.println("Test " + tname + ": " + r.description);

          if (!list) {
            runTest(r, tname);
          }
        }
      } else {
        Req r = new Req(user, pw, dirName + "/" + fileName + ".test");

        System.out.println("Test " + fileName + ": " + r.description);
        if (!list) {
          runTest(r, fileName);
        }
      }
    } catch (Throwable t) {
      System.out.println("********************************************");
      System.out.println("********************************************");
      t.printStackTrace();
      System.out.println("********************************************");
      System.out.println("********************************************");
    }

    System.out.println("--------------------------------------------------------------");
    Iterator it = results.iterator();
    int num = 0;
    int ok = 0;
    while (it.hasNext()) {
      TestResult tr = (TestResult)it.next();
      System.out.println(tr);
      num++;
      if (tr.ok) {
        ok++;
      }
    }
    System.out.println("--------------------------------------------------------------");
    System.out.println("Ran " + num + " tests with " + ok + " successful");
    System.out.println("--------------------------------------------------------------");
  }

  static boolean processArgs(String[] args) throws Throwable {
    if (args == null) {
      return false;
    }

    for (int i = 0; i < args.length; i++) {
      if (args[i].equals("-debug")) {
        debug = true;
      } else if (args[i].equals("-ndebug")) {
        debug = false;
      } else if ("-list".equals(args[i])) {
        list = true;
      } else if (argpar("-dir", args, i)) {
        i++;
        dirName = args[i];
      } else if (argpar("-host", args, i)) {
        i++;
        host = args[i];
      } else if (argpar("-port", args, i)) {
        i++;
        port = Integer.parseInt(args[i]);
      } else if (argpar("-user", args, i)) {
        i++;
        user = args[i];
      } else if (argpar("-pw", args, i)) {
        i++;
        pw = args[i];
      } else if (argpar("-testlist", args, i)) {
        i++;
        testListName = args[i];
      } else if ((fileName == null) && argpar("-test", args, i)) {
        i++;
        fileName = args[i];
      } else {
        System.out.println("Illegal argument: " + args[i]);
        usage();
        return false;
      }
    }

    return true;
  }

  static boolean argpar(String n, String[] args, int i) throws Exception {
    if (!args[i].equals(n)) {
      return false;
    }

    if ((i + 1) == args.length) {
      throw new Exception("Invalid args");
    }
    return true;
  }

  static void usage() {
    System.out.println("Usage:");
    System.out.println("args   -debug");
    System.out.println("       -ndebug");
    System.out.println("       -host hostname");
    System.out.println("       -port int");
    System.out.println("       -user username");
    System.out.println("       -pw pwstring");
    System.out.println("       -dir dirname");
    System.out.println("            set location of tests");
    System.out.println("       -list");
    System.out.println("            Just list test file[s]");
    System.out.println("       -test testname");
    System.out.println("            run given test [in given directory]");
    System.out.println("");
    System.out.println("For example");
    System.out.println("   -dir mytestdir");
    System.out.println("             Run all the tests in given directory");
    System.out.println("   -dir mytestdir -testlist mylist");
    System.out.println("             Run all the test in given directory named in the");
    System.out.println("             file mylist in that directory.");
  }

  private static boolean runTest(Req r, String tname) {
    try {
      int respCode;
      if (r.getAuth()) {
        respCode = cio.sendRequest(r.getMethod(), r.getPrefixedUrl(),
                                   user, pw, r.getHdrs(), r.getDepth(),
                                   r.getContentType(),
                                   r.getContentLength(), r.getContentBytes());
      } else {
        respCode = cio.sendRequest(r.getMethod(), r.getPrefixedUrl(),
                                   r.getHdrs(), r.getDepth(),
                                   r.getContentType(), r.getContentLength(),
                                   r.getContentBytes());
      }

      CaldavResp resp = cio.getResponse();

      InputStream in = resp.getContentStream();

      if (in != null) {
        readContent(in, resp.getContentLength(), resp.getCharset());
      }

      int expected = r.getExpectedResponse();

      boolean ok = (expected < 0) || (expected == respCode);

      results.add(new TestResult(tname, ok, respCode, false, null));

      return ok;
    } catch (Throwable t) {
      results.add(new TestResult(tname, false, 0, true, t.getMessage()));
      t.printStackTrace();
      return false;
    } finally {
      cio.close();
    }
  }

  static void readContent(InputStream in, long expectedLen,
                          String charset) throws Throwable {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    int len = 0;

    if (debug) {
      System.out.println("Read content - expected=" + expectedLen);
    }

    boolean hadLf = false;
    boolean hadCr = false;

    while ((expectedLen < 0) || (len < expectedLen)) {
      int ich = in.read();
      if (ich < 0) {
        break;
      }

      len++;

      if (ich == '\n') {
        if (hadLf) {
          System.out.println("");
          hadLf = false;
          hadCr = false;
        } else {
          hadLf = true;
        }
      } else if (ich == '\r') {
        if (hadCr) {
          System.out.println("");
          hadLf = false;
          hadCr = false;
        } else {
          hadCr = true;
        }
      } else if (hadCr || hadLf) {
        hadLf = false;
        hadCr = false;

        if (baos.size() > 0) {
          String ln = new String(baos.toByteArray(), charset);
          System.out.println(ln);
        }

        baos.reset();
        baos.write(ich);
      } else {
        baos.write(ich);
      }
    }

    if (baos.size() > 0) {
      String ln = new String(baos.toByteArray(), charset);

      System.out.println(ln);
    }
  }

  /*
  private static class CaldavAuthenticator extends Authenticator {
    private String user;
    private char[] pw;

    CaldavAuthenticator(String user, String pw) {
      this.user = user;
      this.pw = pw.toCharArray();
    }

    protected PasswordAuthentication getPasswordAuthentication() {
      return new PasswordAuthentication(user, pw);
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
        / *
      } else if (o instanceof VTimeZone) {
        VTimeZone vtz = (VTimeZone)o;

        debugMsg("Got timezone: \n" + vtz.toString());
        * /
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

  /* * Convert the given string representation of an Icalendar object to a
   * Calendar object
   *
   * @param rdr
   * @return Calendar
   * @throws Throwable
   * /
  public static Calendar getCalendar(Reader rdr) throws Throwable {
    System.setProperty("ical4j.unfolding.relaxed", "true");
    CalendarBuilder bldr = new CalendarBuilder(new CalendarParserImpl());

    return bldr.build(new UnfoldingReader(rdr));
  }

  private static void msg(String msg) {
    System.out.println(msg);
  }*/
}

