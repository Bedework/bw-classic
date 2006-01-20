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

package org.bedework.webconfig.props;

import org.bedework.webconfig.Defs;

import edu.rpi.sss.util.log.MessageEmit;

import java.io.Serializable;

import org.apache.log4j.Logger;

/** A property has a name - used by the web application for the tag, a value
 * and a suffix which is appended to the prefix defined by the collection of
 * which the property is a member.
 *
 * <p>For example the property defining the app root for the web admin client
 * has an internal tag name "approot" and a suffix of "app.root". The prefix for
 * the collection of webadmin properties would be "org.bedework.webadmin"
 * giving a property name of "org.bedework.webadmin.app.root"
 *
 * @author Mike Douglass
 */
public class ConfigProperty implements Defs, Serializable {
  private String name;
  private String value;
  private String suffix;
  private boolean required;
  private BooleanProperty onlyIf;
  private boolean advanced;

  private String groupName;

  protected boolean goodValue;

  /** Constructor for not-advanced
   *
   * @param name    String name
   * @param suffix  String suffix
   * @param required boolean
   */
  public ConfigProperty(String name, String suffix, boolean required) {
    this(name, suffix, required, null, false);
  }

  /** Constructor
   *
   * @param name     String name
   * @param suffix   String suffix
   * @param required boolean
   * @param advanced boolean
   */
  public ConfigProperty(String name, String suffix, boolean required,
                        boolean advanced) {
    this(name, suffix, required, null, false);
  }

  /** Constructor
   *
   * @param name       String name
   * @param suffix     String suffix
   * @param required boolean
   * @param onlyIf     BooleanProperty - if true this field is displayed and used
   */
  public ConfigProperty(String name, String suffix, boolean required,
                        BooleanProperty onlyIf) {
    this(name, suffix, required, onlyIf, false);
  }

  /** Constructor
   *
   * @param name       String name
   * @param suffix     String suffix
   * @param required boolean
   * @param onlyIf     BooleanProperty - if true this field is displayed and used
   * @param advanced   boolean
   */
  public ConfigProperty(String name, String suffix, boolean required,
                        BooleanProperty onlyIf, boolean advanced) {
    this.name = name;
    this.suffix = suffix;
    this.required = required;
    this.onlyIf = onlyIf;
    this.advanced = advanced;
  }

  /** Other property types override this
   *
   * @return int type of property
   */
  public int getType() {
    return typeString;
  }

  /** Get the name
   *
   * @return String name used for tags.
   */
  public String getName() {
    return name;
  }

  /** This is overrridden for validity checking
   *
   * @param val    String value
   */
  public void setValue(String val) {
    value = val;
  }

  /** Get the name
   *
   * @return String name used for tags.
   */
  public String getValue() {
    return value;
  }

  /** Get the external suffix
   *
   * @return String suffix
   */
  public String getSuffix() {
    return suffix;
  }

  /** Get the required flag
   *
   * @return boolean required
   */
  public boolean getRequired() {
    return required;
  }

  /** Get the show flag
   *
   * @return boolean show/not show
   */
  public boolean getShow() {
    if (onlyIf != null) {
      return onlyIf.getBooleanVal();
    }
    return true;
  }

  /** Get the advanced flag
   *
   * @return boolean advanced
   */
  public boolean getAdvanced() {
    return advanced;
  }

  /** Return the state of the goodValue flag after validate called
   *
   * @return boolean true for good value
   */
  public boolean getGoodValue() {
    return goodValue;
  }

  /** Set the group name
   *
   * @param val    String name.
   */
  public void setGroupName(String val) {
    groupName = val;
  }

  /** Get the group name
   *
   * @return String name.
   */
  public String getGroupName() {
    return groupName;
  }

  /** Called at update to set the error flag and emit a message
   *
   * @param err    MessageEmit object for error messages
   * @return boolean true for ok
   */
  public boolean validate(MessageEmit err) {
    if (!getShow()) {
      goodValue = true;
      return true;
    }

    goodValue = checkRequired(err);

    return goodValue;
  }

  /** Check for missing property
   *
   * @param err    MessageEmit object for error messages
   * @return boolean true for ok
   */
  public boolean checkRequired(MessageEmit err) {
    if (required && (getValue() == null)) {
      goodValue = false;
      err.emit("org.bedework.config.error.missingvalue", getGroupName(), getName());
    } else {
      goodValue = true;
    }

    return goodValue;
  }

  protected Logger getLog() {
    return Logger.getLogger(this.getClass());
  }

  protected void debugMsg(String msg) {
    getLog().debug(msg);
  }
}

