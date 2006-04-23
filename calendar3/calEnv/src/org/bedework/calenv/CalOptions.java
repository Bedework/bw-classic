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
package org.bedework.calenv;

import edu.rpi.sss.util.xml.XmlUtil;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Serializable;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

/** A start at saving properties in an xml format.
 *
 * <p>The file we parse is resource "/properties/calendar/bedework.options".
 *
 * <p>This needs some work but the idea is to allow something like:
 *
 * <pre>
 *   <bedework-options>
 *     <org>
 *       <bedework>
 *         <global>
 *           <module>
 *             <user-ldap-group classname="org.bedework.calcore.ldap.LdapConfigProperties">
 *               <initialContextFactory>com.sun.jndi.ldap.LdapCtxFactory</initialContextFactory>
 *               ...
 *             </user-ldap-group>
 *           </module>
 *         </global>
 *         <app>
 *           ...
 *         </app>
 *       </bedework>
 *     </org>
 *   </bedework-options>
 * </pre>
 *
 * <p>Then a call on get option for "org.bedework.module.user-ldap-group"
 * would return an object of class org.bedework.calcore.ldap.LdapConfigProperties.
 *
 * <p>Currently only String, int, Integer, boolean and Boolean parameter types
 * are supported for the setters.
 *
 * <p>Currently we're not supporting nested class definitions though it's not
 * such a stretch.
 *
 * @author Mike Douglass    douglm @ rpi.edu
 *
 */
public class CalOptions implements Serializable {
  /** Location of the options file */
  private static final String optionsFile =
      "/properties/calendar/options.xml";

  /* The internal representation */
  private static volatile OptionElement optionsRoot;

  static {
    try {
      initOptions();
    } catch (Throwable t) {
      Logger.getLogger(CalOptions.class).error("Init error", t);
      throw new RuntimeException(t);
    }
  }

  /** Global properties have this prefix.
   */
  public static final String globalPrefix = "org.bedework.global.";

  private static volatile Pattern splitPathPattern = Pattern.compile("\\.");

  private String appPrefix;

  /** Constructor. Create a caldav object using the given prefix.
   *
   * @param appPrefix
   * @param debug
   * @throws CalEnvException
   */
  public CalOptions(String appPrefix, boolean debug) throws CalEnvException {
    this.appPrefix = appPrefix;
  }

  private static void initOptions() throws CalEnvException {
    /* get an input stream for the options file */

    InputStream is = null;

    try {
      try {
        // The jboss?? way - should work for others as well.
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        is = cl.getResourceAsStream(optionsFile);
      } catch (Throwable clt) {}

      if (is == null) {
        // Try another way
        is = CalEnv.class.getResourceAsStream(optionsFile);
      }

      if (is == null) {
        throw new CalEnvException("Unable to load options file" +
                                  optionsFile);
      }

      /* We now parse the file into a simple options structure
       */
      optionsRoot = parseOptions(is);

      //if (debug) {
      //  pr.list(System.out);
      //  Logger.getLogger(CalEnv.class).debug(
      //      "file.encoding=" + System.getProperty("file.encoding"));
      //}
    } catch (CalEnvException cee) {
      throw cee;
    } catch (Throwable t) {
      Logger.getLogger(CalEnv.class).error("getEnv error", t);
      throw new CalEnvException(t.getMessage());
    } finally {
      if (is != null) {
        try {
          is.close();
        } catch (Throwable t1) {}
      }
    }
  }

  /** Return current app prefix
   *
   * @return String app prefix
   */
  public String getAppPrefix() {
    return appPrefix;
  }

  /** Get required property, throw exception if absent
   *
   * @param name String property name
   * @return Object value
   * @throws CalEnvException
   */
  public static Object getProperty(String name) throws CalEnvException {
    Object val = getOptProperty(name);

    if (val == null) {
      throw new CalEnvException("Missing property " + name);
    }

    return val;
  }

  /** Get optional property.
   *
   * @param name String property name
   * @return Object value
   * @throws CalEnvException
   */
  public static Object getOptProperty(String name) throws CalEnvException {
    return findValue(makePathElements(name));
  }

  /** Return the String value of the named property.
   *
   * @param name String property name
   * @return String value of property
   * @throws CalEnvException
   */
  public static String getStringProperty(String name) throws CalEnvException {
    Object val = getProperty(name);

    if (!(val instanceof String)) {
      throw new CalEnvException("org.bedework.calenv.bad.option.value");
    }

    return (String)val;
  }

  /** Get optional property.
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public static String getOptStringProperty(String name) throws CalEnvException {
    Object val = findValue(makePathElements(name));

    if (val == null) {
      return null;
    }

    if (!(val instanceof String)) {
      throw new CalEnvException("org.bedework.calenv.bad.option.value");
    }

    return (String)val;
  }

  /** Return the value of the named property.
   *
   * @param name String property name
   * @return boolean value of property
   * @throws CalEnvException
   */
  public static boolean getBoolProperty(String name) throws CalEnvException {
    String val = getStringProperty(name);

    val = val.toLowerCase();

    return "true".equals(val) || "yes".equals(val);
  }

  /** Return the value of the named property.
   *
   * @param name String property name
   * @return int value of property
   * @throws CalEnvException
   */
  public static int getIntProperty(String name) throws CalEnvException {
    String val = getStringProperty(name);

    try {
      return Integer.valueOf(val).intValue();
    } catch (Throwable t) {
      throw new CalEnvException("org.bedework.calenv.bad.option.value");
    }
  }

  /* ====================================================================
   *                 Methods returning global properties.
   * ==================================================================== */

  /** Get required global property, throw exception if absent
   *
   * @param name String property name
   * @return Object value
   * @throws CalEnvException
   */
  public static Object getGlobalProperty(String name) throws CalEnvException {
    return getProperty(globalPrefix + name);
  }

  /** Get required global property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public static String getGlobalStringProperty(String name) throws CalEnvException {
    return getStringProperty(globalPrefix + name);
  }

  /** Return the value of the named property or false if absent.
   *
   * @param name String unprefixed name
   * @return boolean value of global property
   * @throws CalEnvException
   */
  public static boolean getGlobalBoolProperty(String name) throws CalEnvException {
    return getBoolProperty(globalPrefix + name);
  }

  /** Return the value of the named property.
   *
   * @param name String unprefixed name
   * @return int value of global property
   * @throws CalEnvException
   */
  public static int getGlobalIntProperty(String name) throws CalEnvException {
    return getIntProperty(globalPrefix + name);
  }

  /** Given a global property (hence the "Global" in the name) return an
   * object of that class. The class parameter is used to check that the
   * named class is an instance of that class.
   *
   * @param name String unprefixed name
   * @param cl   Class expected
   * @return     Object checked to be an instance of that class
   * @throws CalEnvException
   */
  public static Object getGlobalObject(String name, Class cl) throws CalEnvException {
    try {
      String className = getGlobalStringProperty(name);

      Object o = Class.forName(className).newInstance();

      if (o == null) {
        throw new CalEnvException("Class " + className + " not found");
      }

      if (!cl.isInstance(o)) {
        throw new CalEnvException("Class " + className +
                                  " is not a subclass of " +
                                  cl.getName());
      }

      return o;
    } catch (CalEnvException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new CalEnvException(t);
    }
  }

  /* ====================================================================
   *                 Methods returning application properties.
   * ==================================================================== */

  /** Get required app property, throw exception if absent
   *
   * @param name String property name
   * @return Object value
   * @throws CalEnvException
   */
  public Object getAppProperty(String name) throws CalEnvException {
    return getProperty(appPrefix + name);
  }

  /** Get required app property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public String getAppStringProperty(String name) throws CalEnvException {
    return getStringProperty(appPrefix + name);
  }

  /** Get optional app property.
   *
   * @param name String property name
   * @return Object value or null
   * @throws CalEnvException
   */
  public Object getAppOptProperty(String name) throws CalEnvException {
    return getOptProperty(appPrefix + name);
  }

  /** Get optional app property.
   *
   * @param name String property name
   * @return String value or null
   * @throws CalEnvException
   */
  public String getAppOptStringProperty(String name) throws CalEnvException {
    return getOptStringProperty(appPrefix + name);
  }

  /** Return the value of the named property or false if absent.
   *
   * @param name String unprefixed name
   * @return boolean value of global property
   * @throws CalEnvException
   */
  public boolean getAppBoolProperty(String name) throws CalEnvException {
    return getBoolProperty(appPrefix + name);
  }

  /** Return the value of the named property.
   *
   * @param name String unprefixed name
   * @return int value of global property
   * @throws CalEnvException
   */
  public int getAppIntProperty(String name) throws CalEnvException {
    return getIntProperty(appPrefix + name);
  }

  /** Given an application property (hence the "App" in the name) return an
   * object of that class. The class parameter is used to check that the
   * named class is an instance of that class.
   *
   * @param name String unprefixed name
   * @param cl   Class expected
   * @return     Object checked to be an instance of that class
   * @throws CalEnvException
   */
  public Object getAppObject(String name, Class cl) throws CalEnvException {
    try {
      String className = getAppStringProperty(name);

      Object o = Class.forName(className).newInstance();

      if (o == null) {
        throw new CalEnvException("Class " + className + " not found");
      }

      if (!cl.isInstance(o)) {
        throw new CalEnvException("Class " + className +
                                  " is not a subclass of " +
                                  cl.getName());
      }

      return o;
    } catch (CalEnvException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new CalEnvException(t);
    }
  }

  /* Given a path element array find the corresponding value(s)
   *
   */
  private static Object findValue(String[] pathElements) {
    return findValue(optionsRoot, pathElements, -1);
  }

  private static Object findValue(OptionElement subroot,
                                  String[] pathElements, int pos) {
    if (pos >= 0) {
      // Not at root.
      if (!pathElements[pos].equals(subroot.name)) {
        return null;
      }
    }

    if (subroot.isValue) {
      // pos must be last entry
      if ((pos + 1) != pathElements.length) {
        return null;
      }
      return subroot.val;
    }

    pos++;
    if (pos == pathElements.length) {
      return null;
    }

    /* look to children for some value */

    Iterator it = subroot.getChildren().iterator();
    Object singleRes = null;
    ArrayList multiRes = null;

    while (it.hasNext()) {
      Object res = findValue((OptionElement)it.next(), pathElements, pos);
      if (res != null) {
        if (singleRes != null) {
          multiRes = new ArrayList();
          appendResult(singleRes, multiRes);
          singleRes = null;
          appendResult(res, multiRes);
        } else if (multiRes != null) {
          appendResult(res, multiRes);
        } else {
          singleRes = res;
        }
      }
    }

    if (multiRes != null) {
      return multiRes;
    }

    return singleRes;
  }

  private static void appendResult(Object res, ArrayList multiRes) {
    if (res instanceof Collection) {
      multiRes.addAll((Collection)res);
    } else {
      multiRes.add(res);
    }
  }

  /** Parse the input stream and return the internal representation.
   *
   * @param is         InputStream
   * @return OptionElement root of parsed options.
   * @exception CalEnvException Some error occurred.
   */
  private static OptionElement parseOptions(InputStream is) throws CalEnvException{
    Reader rdr = null;

    try {
      rdr = new InputStreamReader(is);

      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setNamespaceAware(false);

      DocumentBuilder builder = factory.newDocumentBuilder();

      Document doc = builder.parse(new InputSource(rdr));

      /* We expect a root element named "bedework-options" */

      Element root = doc.getDocumentElement();

      if (!root.getNodeName().equals("bedework-options")) {
        throw new CalEnvException("org.bedework.bad.options");
      }

      OptionElement oel = new OptionElement();
      oel.name = "root";

      doChildren(oel, root, null);

      return oel;
    } catch (CalEnvException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new CalEnvException(t);
    } finally {
      if (rdr != null) {
        try {
          rdr.close();
        } catch (Throwable t) {}
      }
    }
  }

  private static void doChildren(OptionElement oel, Element subroot,
                                 Object val) throws CalEnvException {
    try {
      if (!XmlUtil.hasChildren(subroot)) {
        // Leaf node
        String ndval = XmlUtil.getElementContent(subroot);
        String name = subroot.getNodeName();

        if (val == null) {
          // Add a leaf node and return
          OptionElement valnode = new OptionElement();
          valnode.name = name;
          valnode.isValue = true;
          valnode.val = ndval;
          oel.addChild(valnode);

          return;
        }

        // Val is an object which should have a setter for the property

        Method meth = findMethod(val, name);

        Class[] parClasses = meth.getParameterTypes();
        if (parClasses.length != 1) {
          throw new CalEnvException("org.bedework.calenv.invalid.setter");
        }

        Class parClass = parClasses[0];
        Object par = null;
        if (parClass.getName().equals("java.lang.String")) {
          par = ndval;
        } else if (parClass.getName().equals("int") ||
            parClass.getName().equals("java.lang.Integer")) {
          par = Integer.valueOf(ndval);
        } else if (parClass.getName().equals("boolean") ||
            parClass.getName().equals("java.lang.Boolean")) {
          par = Boolean.valueOf(ndval);
        } else {
          throw new CalEnvException("org.bedework.calenv.unsupported.setter");
        }

        Object[] pars = new Object[]{par};

        meth.invoke(val, pars);
        return;
      }

      Element[] children = XmlUtil.getElementsArray(subroot);

      /* Non leaf nodes - call recursively with each of the children
       */
      for (int i = 0; i < children.length; i++) {
        Element el = children[i];

        String className = XmlUtil.getAttrVal(el, "classname");
        OptionElement valnode = new OptionElement();
        valnode.name = el.getNodeName();
        oel.addChild(valnode);

        if (className != null) {
          /* This counts as a leaf node. All children provide values for the
           * object.
           */
          if (val != null) {
            throw new CalEnvException("org.bedework.calenv.nested.classes.unsupported");
          }

          val = Class.forName(className).newInstance();
          valnode.isValue = true;
          valnode.val = val;
        } else {
          /* Just a non-leaf node */
        }

        doChildren(valnode, el, val);
      }
    } catch (CalEnvException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new CalEnvException(t);
    }
  }

  /* We've been dealing with property names - convert the dotted notation to a path
   */
  private static String[] makePathElements(String val) {
    synchronized (splitPathPattern) {
      return splitPathPattern.split(val, 0);
    }
  }

  /* We've been dealing with property names - convert the dotted notation to a path
   * /
  private static PathSegment makePath(String val) {
    return new PathSegment(makePathElements(val));
  }

  private static class PathSegment {
    String[] pathElements;
    PathSegment nextSegment;

    PathSegment(String[] pathElements) {
      this.pathElements = pathElements;
    }

    String[] getPathElements() {
      return pathElements;
    }

    PathSegment getNextSegment() {
      return nextSegment;
    }

    void appendSegment(PathSegment val) {
      if (nextSegment == null) {
        nextSegment = val;
      } else {
        nextSegment.appendSegment(val);
      }
    }
  }

  private static class PathIterator implements Iterator {
    PathSegment[] segs;
    int segi;
    PathSegment seg;
    String[] pathElements;
    int elpos;

    PathIterator(PathSegment[] val) {
      segs = val;
      if (segs.length > 0) {
        seg = segs[0];
        pathElements = seg.getPathElements();
      }
    }

    public boolean hasNext() {
      if (seg == null) {
        return false;
      }

      if ((pathElements != null) && (elpos < pathElements.length)) {
        return true;
      }

      return hasNextSeg(segi);
    }

    public Object next() {
      if ((pathElements == null) || (elpos >= pathElements.length)) {
        return getNext();
      }

      String pe = pathElements[elpos];
      elpos++;

      return pe;
    }

    public void remove() {
      throw new RuntimeException("Can't do this");
    }

    /* Move to next seg * /
    private Object getNext() {
      segi++;
      if (segi >= segs.length) {
        throw new RuntimeException("org.bedework.no.next");
      }

      seg = segs[segi];

      if (seg != null) {
        pathElements = seg.getPathElements();
        elpos = 0;
        if ((pathElements != null) && (pathElements.length > 0)) {
          String pe = pathElements[elpos];
          elpos++;

          return pe;
        }
      }

      return getNext();
    }

    private boolean hasNextSeg(int si) {
      si++;
      if (si >= segs.length) {
        return false;
      }

      PathSegment sg = segs[si];

      if (sg != null) {
        String[] els = sg.getPathElements();
        if ((els != null) && (els.length > 0)) {
          return true;
        }
      }

      return hasNextSeg(si);
    }
  }
  */

  /** Just a restatement of the xml element
   *
   * @author Mike Douglass
   */
  private static class OptionElement {
    /** */
    public String name;

    /** */
    public boolean isValue;
    /** */
    public Object val;

    /** */
    public ArrayList children;

    /**
     * @return Collection
     */
    public Collection getChildren() {
      if (children == null) {
        children = new ArrayList();
      }
      return children;
    }

    /** Add a child
     *
     * @param val OptionElement
     */
    public void addChild(OptionElement val) {
      getChildren().add(val);
    }
  }

  private static Method findMethod(Object val, String name) throws CalEnvException {
    String methodName = "set" + name.substring(0, 1).toUpperCase() +
                        name.substring(1);
    Method[] meths = val.getClass().getMethods();
    Method meth = null;

    for (int i = 0; i < meths.length; i++) {
      Method m = meths[i];

      if (m.getName().equals(methodName)) {
        if (meth != null) {
          throw new CalEnvException("org.bedework.calenv.multiple.setters");
        }
        meth = m;
      }
    }

    if (meth == null) {
      throw new CalEnvException("org.bedework.calenv.no.setters");
    }

    return meth;
  }
}
