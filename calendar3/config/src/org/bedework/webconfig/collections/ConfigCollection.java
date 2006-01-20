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

package org.bedework.webconfig.collections;

import org.bedework.webconfig.props.BooleanProperty;
import org.bedework.webconfig.props.ConfigProperty;

import edu.rpi.sss.util.log.MessageEmit;

import java.io.Serializable;
import java.util.Collection;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Properties;
import java.util.Vector;

/** A collection of properties perhaps for a bedework component or global
 * properties. The name is to identify the collection - probably as an xml
 * tag, the prefix does not include the "org.bedework." and is used to build
 * property names.
 *
 * <p>The names should be unique within the application, but the prefixes
 * may not be. This provides a way of grouping related properties.
 *
 * @author Mike Douglass
 */
public class ConfigCollection implements Serializable {
  private String name;
  private String prefix;
  private BooleanProperty onlyIf;
  private boolean show = true;

  private Collection properties;
  private Hashtable pmap;

  /** Constructor
   *
   * @param name    String name
   * @param prefix  String prefix
   */
  public ConfigCollection(String name, String prefix) {
    this.name = name;
    this.prefix = prefix;
  }

  /** Constructor
   *
   * @param name    String name
   * @param prefix  String prefix
   * @param onlyIf     BooleanProperty - if true this Collection is displayed and used
   */
  public ConfigCollection(String name, String prefix,
                          BooleanProperty onlyIf) {
    this.name = name;
    this.prefix = prefix;
    this.onlyIf = onlyIf;
  }

  /** Constructor
   *
   * @param name    String name
   * @param prefix  String prefix
   * @param show    boolean - if true this Collection is displayed and used
   */
  public ConfigCollection(String name, String prefix,
                          boolean show) {
    this.name = name;
    this.prefix = prefix;
    this.show = show;
  }

  /** Get the name
   *
   * @return String name used for tags.
   */
  public String getName() {
    return name;
  }

  /** Get the external prefix
   *
   * @return String prefix
   */
  public String getPrefix() {
    return prefix;
  }

  /** Get the show flag
   *
   * @return boolean show/not show
   */
  public boolean getShow() {
    if (onlyIf != null) {
      return onlyIf.getBooleanVal();
    }
    return show;
  }

  /** Get the collection of properties
   *
   * @return Collection of properties
   */
  public Collection getProperties() {
    if (properties == null) {
      properties = new Vector();
      pmap = new Hashtable();
    }
    return properties;
  }

  /** Add a property to the collection
   *
   * @param val
   * @throws Throwable
   */
  public void addProperty(ConfigProperty val) throws Throwable {
    String name = val.getName();
    Collection c = getProperties();

    if (pmap.get(name) != null) {
      throw new Exception("Duplicate property name " + name);
    }

    c.add(val);
    val.setGroupName(getName());
    pmap.put(name, val);
  }

  /** Iterate over the collection
   *
   * @return Iterator over the properties
   */
  public Iterator iterator() {
    return getProperties().iterator();
  }

  /** Find a property by name
   *
   * @param name  property name
   * @return ConfigProperty or null
   */
  public ConfigProperty findProperty(String name) {
    return (ConfigProperty)pmap.get(name);
  }

  /** Initialise the Collection from the properties
   *
   * @param props  properties object with initial values
   * @param err    MessageEmit object for error messages
   * @return boolean true for all ok
   */
  public boolean initialise(Properties props, MessageEmit err) {
    boolean goodValues = true;

    Iterator it = iterator();
    while (it.hasNext()) {
      ConfigProperty cf = (ConfigProperty)it.next();
      String pname = "org.bedework." + getPrefix() + "." + cf.getSuffix();
      String pval = (String)props.get(pname);

      if (pval != null) {
        cf.setValue(pval);
      }

      if (!cf.validate(err)) {
        goodValues = false;
      }
    }

    return goodValues;
  }

  /** Reset all flagged booleans ready for incoming data
   *
   */
  public void resetFlagged() {
    Iterator it = iterator();
    while (it.hasNext()) {
      ConfigProperty cf = (ConfigProperty)it.next();

      if (cf instanceof BooleanProperty) {
        BooleanProperty bf = (BooleanProperty)cf;

        bf.resetIfFlagged();
      }
    }
  }

  /** Save the Collection values in the properties
   *
   * @param props  properties object
   * @param err    MessageEmit object for error messages
   * @return boolean true for all ok
   */
  public boolean save(Properties props, MessageEmit err) {
    boolean goodValues = true;

    Iterator it = iterator();
    while (it.hasNext()) {
      ConfigProperty cf = (ConfigProperty)it.next();
      String pname = "org.bedework." + getPrefix() + "." + cf.getSuffix();
      String pval = cf.getValue();

      if (!cf.validate(err)) {
        goodValues = false;
      } else if (pval != null) {
        props.put(pname, pval);
      }
    }

    return goodValues;
  }

  /** Validate all the properties
   *
   * @param err    MessageEmit object for error messages
   * @return boolean true for all ok
   */
  public boolean validate(MessageEmit err) {
    boolean goodValues = true;

    if (!getShow()) {
      return goodValues;
    }

    Iterator it = iterator();
    while (it.hasNext()) {
      ConfigProperty cf = (ConfigProperty)it.next();

      if (!cf.validate(err)) {
        goodValues = false;
      }
    }

    return goodValues;
  }
}

