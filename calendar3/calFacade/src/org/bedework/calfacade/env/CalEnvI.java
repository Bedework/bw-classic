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
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
package org.bedework.calfacade.env;

import org.bedework.calfacade.CalEnvException;

import java.io.Serializable;
import java.util.Properties;

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
public interface CalEnvI extends Serializable {
  /** Called after object is created
   *
   * @param appPrefix
   * @param debug
   * @throws CalEnvException
   */
  public void init (String appPrefix, boolean debug) throws CalEnvException;

  /** Return current app prefix
   *
   * @return String app prefix
   */
  public String getAppPrefix();

  /** Return all properties from the global environment.
   *
   * @return Properties    global properties object
   * @throws CalEnvException
   */
  public Properties getProperties() throws CalEnvException;

  /** Get required property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public String getProperty(String name) throws CalEnvException;

  /** Get optional property.
   *
   * @param name String property name
   * @return String value or null
   * @throws CalEnvException
   */
  public String getOptProperty(String name) throws CalEnvException;

  /** Return the value of the named property.
   *
   * @param name String property name
   * @return boolean value of property
   * @throws CalEnvException
   */
  public boolean getBoolProperty(String name) throws CalEnvException;

  /** Return the value of the named property.
   *
   * @param name String property name
   * @return int value of property
   * @throws CalEnvException
   */
  public int getIntProperty(String name) throws CalEnvException;

  /* ====================================================================
   *                 Methods returning global properties.
   * ==================================================================== */

  /** Get required global property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public String getGlobalProperty(String name) throws CalEnvException;

  /** Return the value of the named property or false if absent.
   *
   * @param name String unprefixed name
   * @return boolean value of global property
   * @throws CalEnvException
   */
  public boolean getGlobalBoolProperty(String name) throws CalEnvException;

  /** Return the value of the named property.
   *
   * @param name String unprefixed name
   * @return int value of global property
   * @throws CalEnvException
   */
  public int getGlobalIntProperty(String name) throws CalEnvException;

  /** Given a global property (hence the "Global" in the name) return an
   * object of that class. The class parameter is used to check that the
   * named class is an instance of that class.
   *
   * @param name String unprefixed name
   * @param cl   Class expected
   * @return     Object checked to be an instance of that class
   * @throws CalEnvException
   */
  public Object getGlobalObject(String name, Class cl) throws CalEnvException;

  /* ====================================================================
   *                 Methods returning application properties.
   * ==================================================================== */

  /** Get required app property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public String getAppProperty(String name) throws CalEnvException;

  /** Get optional app property.
   *
   * @param name String property name
   * @return String value or null
   * @throws CalEnvException
   */
  public String getAppOptProperty(String name) throws CalEnvException;

  /** Return the value of the named property or false if absent.
   *
   * @param name String unprefixed name
   * @return boolean value of global property
   * @throws CalEnvException
   */
  public boolean getAppBoolProperty(String name) throws CalEnvException;

  /** Return the value of the named property.
   *
   * @param name String unprefixed name
   * @return int value of global property
   * @throws CalEnvException
   */
  public int getAppIntProperty(String name) throws CalEnvException;

  /** Given an application property (hence the "App" in the name) return an
   * object of that class. The class parameter is used to check that the
   * named class is an instance of that class.
   *
   * @param name String unprefixed name
   * @param cl   Class expected
   * @return     Object checked to be an instance of that class
   * @throws CalEnvException
   */
  public Object getAppObject(String name, Class cl) throws CalEnvException;
}
