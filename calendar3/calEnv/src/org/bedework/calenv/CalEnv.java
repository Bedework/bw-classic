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

import java.io.InputStream;
import java.io.Serializable;
import java.util.Properties;
import org.apache.log4j.Logger;

/** An interface to the outside world - the methods here provide access to
 * properties and resources supplied by the environment. The concrete class
 * is site specific and its name is defined in the build time properties.
 *
 * <p>The name of the supplied concrete class will be built into the
 * resource "/properties/calendar/env.properties".
 *
 * <p>This is required as a minimum to get the system going. Other properties
 * may be stored elsewhere and can be initialised through a call to one of
 * the abstract init methods, either from the web conetxt or from the ejb
 * context for example.
 *
 * <p>Alternatively, put all the properties in that file.
 *
 * <p>This approach needs revisiting to split out core parameters, those
 * that affect the back end only and those that are client only.
 */
public class CalEnv implements Serializable {
  /** Location of the properties file */
  private static final String propertiesFile =
      "/properties/calendar/env.properties";

  private static volatile Properties pr;

  private static volatile Integer lockit = new Integer(0);

  /** Global properties have this prefix.
   */
  public static final String globalPrefix = "org.bedework.global.";

  private String appPrefix;

  /** Constructor. Create a caldav object using the given prefix.
   *
   * @param appPrefix
   * @param debug
   * @throws CalEnvException
   */
  public CalEnv(String appPrefix, boolean debug) throws CalEnvException {
    this.appPrefix = appPrefix;
  }

  private static Properties getPr() throws CalEnvException {
    synchronized (lockit) {
      if (pr != null) {
        return pr;
      }

      /** Load properties file */

      pr = new Properties();
      InputStream is = null;

      try {
        try {
          // The jboss?? way - should work for others as well.
          ClassLoader cl = Thread.currentThread().getContextClassLoader();
          is = cl.getResourceAsStream(propertiesFile);
        } catch (Throwable clt) {}

        if (is == null) {
          // Try another way
          is = CalEnv.class.getResourceAsStream(propertiesFile);
        }

        if (is == null) {
          throw new CalEnvException("Unable to load properties file" +
                                      propertiesFile);
        }

        pr.load(is);

        //if (debug) {
        //  pr.list(System.out);
        //  Logger.getLogger(CalEnv.class).debug(
        //      "file.encoding=" + System.getProperty("file.encoding"));
        //}
        return pr;
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
  }
  
  /** Return current app prefix
   * 
   * @return String app prefix
   */
  public String getAppPrefix() {
    return appPrefix;
  }

  /** Return all properties from the global environment.
   *
   * @return Properties    global properties object
   * @throws CalEnvException
   */
  public Properties getProperties() throws CalEnvException {
    return getPr();
  }

  /** Get required property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public static String getProperty(String name) throws CalEnvException {
    String val = getPr().getProperty(name);

    if (val == null) {
      throw new CalEnvException("Missing property " + name);
    }

    return val;
  }

  /** Get optional property.
   *
   * @param name String property name
   * @return String value or null
   * @throws CalEnvException
   */
  public static String getOptProperty(String name) throws CalEnvException {
    String val = getPr().getProperty(name);

    return val;
  }

  /** Return the value of the named property.
   *
   * @param name String property name
   * @return boolean value of property
   * @throws CalEnvException
   */
  public static boolean getBoolProperty(String name) throws CalEnvException {
    String val = getProperty(name);

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
    String val = getProperty(name);

    try {
      return Integer.valueOf(val).intValue();
    } catch (Throwable t) {
      throw new CalEnvException("Invalid property " + name + " = " + val);
    }
  }

  /* ====================================================================
   *                 Methods returning global properties.
   * ==================================================================== */

  /** Get required global property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public static String getGlobalProperty(String name) throws CalEnvException {
    return getProperty(globalPrefix + name);
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
      String className = getGlobalProperty(name);

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
   * @return String value
   * @throws CalEnvException
   */
  public String getAppProperty(String name) throws CalEnvException {
    return getProperty(appPrefix + name);
  }

  /** Get optional app property.
   *
   * @param name String property name
   * @return String value or null
   * @throws CalEnvException
   */
  public String getAppOptProperty(String name) throws CalEnvException {
    return getOptProperty(appPrefix + name);
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
      String className = getAppProperty(name);

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
}

