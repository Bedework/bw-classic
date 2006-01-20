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

package org.bedework.webadmin.timezones;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calsvci.CalSvcI;
import org.bedework.icalendar.IcalTranslator;
import org.bedework.icalendar.IcalUtil;
import org.bedework.webadmin.PEAbstractAction;
import org.bedework.webadmin.PEActionForm;
import org.bedework.webcommon.BwSession;

import edu.rpi.sss.util.xml.XmlUtil;


import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;

import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.ComponentList;
import net.fortuna.ical4j.model.Property;

import org.apache.struts.upload.FormFile;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
//import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/** This action imports the uploaded system timezone definitions.
 *
 * <p>Forwards to:<ul>
 *      <li>"noAccess"     user not authorised.</li>
 *      <li>"error"        some sort of error.</li>
 *      <li>"success"      processed.</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class PEUploadTimezonesAction extends PEAbstractAction {
  /* (non-Javadoc)
   * @see org.bedework.webadmin.PEAbstractAction#doAction(javax.servlet.http.HttpServletRequest, org.bedework.webcommon.BwSession, org.bedework.webadmin.PEActionForm)
   */
  public String doAction(HttpServletRequest request,
                         BwSession sess,
                         PEActionForm form) throws Throwable {
    /** Check access
     */
    if (!form.getAuthorisedUser()) {
      return "noAccess";
    }

    FormFile upFile = form.getUploadFile();

    if (upFile == null) {
      // Just forget it
      return "success";
    }

    InputStream is = upFile.getInputStream();

    /* The input file should look something like:
       <dir>
         <name>A-name</name>
         <dir>...</dir>
         <file>
           <name>file1.ics</name>
           <data>...</data>
         </file>
       </dir>

       We ignore the first name - it represents the root.
       Each <dir> element may contain other <dir> and <file> elements.
       Each <name> element is a path element
     */

    DirClass rootDir = parseTzDefs(new InputStreamReader(is));
    if (!rootDir.ok) {
      form.getErr().emit("org.bedework.error.timezones.parseerror",
                         rootDir.msg);
      return "error";
    }

    CalSvcI svci = form.getCalSvcI();

    if (!doDir(svci, rootDir, "", form)) {
      return "error";
    }

    form.getMsg().emit("org.bedework.pubevents.message.timezones.imported");

    return "success";
  }

  private boolean doDir(CalSvcI svci, DirClass dir, String indent,
                        PEActionForm form) throws Throwable {
    if (debug) {
      debugMsg(indent + "Dir: " + dir.cal.getName());
    }

    Iterator dit = dir.dirs.iterator();
    while (dit.hasNext()) {
      doDir(svci, (DirClass)dit.next(), indent + "  ", form);
    }

    Iterator tzit = dir.tzs.iterator();
    while (tzit.hasNext()) {
      Calendar ical = (Calendar)tzit.next();

      ComponentList cl = ical.getComponents();

      if (cl.size() != 1) {
        form.getErr().emit("org.bedework.error.timezones.dataerror",
                           cl.size() + " components in Calendar");
        return false;
      }

      Object o = cl.get(0);
      if (!(o instanceof VTimeZone)) {
        form.getErr().emit("org.bedework.error.timezones.dataerror",
                           "component in Calendar not VTimeZone");
        return false;
      }

      VTimeZone tz = (VTimeZone)o;
      String tzid = IcalUtil.getProperty(tz, Property.TZID).getValue();

      svci.saveTimeZone(tzid, tz);

      if (debug) {
        debugMsg(indent + "tzid: " + tzid);
      }
    }

    return true;
  }

  private static class DirClass {
    boolean ok = true;  // Set in root only
    String msg;
    BwCalendar cal; // The name will be set according to the dir/name

    Collection dirs = new Vector();

    /* Collection of Calendar obects
     */
    Collection tzs = new Vector();
  }

  private DirClass parseTzDefs(Reader rdr) throws Throwable {
    Document doc = null;
    boolean ok;
    String msg = null;

    try {
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setNamespaceAware(false);

      DocumentBuilder builder = factory.newDocumentBuilder();

      doc = builder.parse(new InputSource(rdr));
      ok = true;
    } catch (SAXException e) {
      msg = e.getMessage();
      ok = false;
    } catch (Throwable t) {
      msg = t.getMessage();
      ok = false;
    } finally {
      if (rdr != null) {
        try {
          rdr.close();
        } catch (Throwable t) {}
      }
    }

    if (!ok) {
      DirClass dir = new DirClass();
      dir.ok = false;
      dir.msg = msg;
      return dir;
    }

    return processDir(doc.getDocumentElement());
  }

  private DirClass processDir(Element dir) throws Throwable {
    DirClass d = new DirClass();
    Collection children = XmlUtil.getElements(dir);

    Iterator it = children.iterator();

    /* First is name */

    Element nmel = (Element)it.next();

    d.cal = new BwCalendar();
    d.cal.setName(XmlUtil.getElementContent(nmel));

    while (it.hasNext()) {
      Element el = (Element)it.next();

      if ("dir".equals(el.getTagName())) {
        d.dirs.add(processDir(el));
      } else if ("file".equals(el.getTagName())) {
        d.tzs.add(processFile(el));
      } else {
        throw new Exception("Expected <dir> or <file>, found: " + el.getTagName());
      }
    }

    return d;
  }

  private Calendar processFile(Element ics) throws Throwable {
    //NodeList ds = ics.getElementsByTagName("data");

    Collection children = XmlUtil.getElements(ics);

    Iterator it = children.iterator();

    /* First is name */

    Element el = (Element)it.next();
    if (!"name".equals(el.getTagName())) {
      throw new Exception("Expected <name>, found: " + el.getTagName());
    }

    /* Next is data */
    el = (Element)it.next();
    if (!"data".equals(el.getTagName())) {
      throw new Exception("Expected <data>, found: " + el.getTagName());
    }

    return IcalTranslator.getCalendar(XmlUtil.getElementContent(el));
  }
}

