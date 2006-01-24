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

import edu.rpi.sss.util.log.MessageEmit;

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
public class IntProperty extends ConfigProperty {
  private int intVal;

  /** Constructor
   *
   * @param name    String name
   * @param suffix  String suffix
   * @param required boolean true for a required field
   */
  public IntProperty(String name, String suffix, boolean required) {
    super(name, suffix, required, false);
  }

  /** Constructor
   *
   * @param name     String name
   * @param suffix   String suffix
   * @param required boolean true for a required field
   * @param advanced boolean
   */
  public IntProperty(String name, String suffix, boolean required,
                           boolean advanced) {
    super(name, suffix, required, advanced);
  }

  /** Set the value
   *
   * @param val boolean
   */
  public void setIntVal(int val) {
    intVal = val;
  }

  /** Get the value
   *
   * @return boolean val
   */
  public int getIntVal() {
    return intVal;
  }

  /** We're int
   *
   * @return int type of property
   */
  public int getType() {
    return typeInt;
  }

  /** Called at update to set the error flag and emit a message
   *
   * @param err    MessageEmit object for error messages
   * @return boolean true for ok
   */
  public boolean validate(MessageEmit err) {
    goodValue = true;

    if (!getShow()) {
      return true;
    }

    try {
      setIntVal(Integer.parseInt(getValue()));
    } catch (Throwable t) {
      err.emit("org.bedework.config.error.badvalue", getName(), getValue());
      goodValue = false;
    }

    return goodValue;
  }
}

