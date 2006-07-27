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

/** An interface delivering properties in an xml format.
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
public interface CalOptionsI extends Serializable {
  /** Called after object is created
   *
   * @param appPrefix
   * @param debug
   * @throws CalEnvException
   */
  public void init(String appPrefix, boolean debug) throws CalEnvException;

  /** Return current app prefix
   *
   * @return String app prefix
   */
  public String getAppPrefix();

  /** Get required property, throw exception if absent
   *
   * @param name String property name
   * @return Object value
   * @throws CalEnvException
   */
  public Object getProperty(String name) throws CalEnvException;

  /** Get optional property.
   *
   * @param name String property name
   * @return Object value
   * @throws CalEnvException
   */
  public Object getOptProperty(String name) throws CalEnvException;

  /** Return the String value of the named property.
   *
   * @param name String property name
   * @return String value of property
   * @throws CalEnvException
   */
  public String getStringProperty(String name) throws CalEnvException;

  /** Get optional property.
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public String getOptStringProperty(String name) throws CalEnvException;

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
   * @return Object value
   * @throws CalEnvException
   */
  public Object getGlobalProperty(String name) throws CalEnvException;

  /** Get required global property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public String getGlobalStringProperty(String name) throws CalEnvException;

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
   * @return Object value
   * @throws CalEnvException
   */
  public Object getAppProperty(String name) throws CalEnvException;

  /** Get required app property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws CalEnvException
   */
  public String getAppStringProperty(String name) throws CalEnvException;

  /** Get optional app property.
   *
   * @param name String property name
   * @return Object value or null
   * @throws CalEnvException
   */
  public Object getAppOptProperty(String name) throws CalEnvException;

  /** Get optional app property.
   *
   * @param name String property name
   * @return String value or null
   * @throws CalEnvException
   */
  public String getAppOptStringProperty(String name) throws CalEnvException;

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
