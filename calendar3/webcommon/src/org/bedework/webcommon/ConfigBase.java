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
package org.bedework.webcommon;

import java.io.Serializable;

/** Common configuration properties for the clients
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public class ConfigBase implements Serializable {
  /* True if we should auto-create sponsors. Some sites may wish to control
   * the creation of sponsors to enforce consistency in their use. If this
   * is true we create a sponsor as we create events. If false the sponsor
   * must already exist.
   */
  private boolean autoCreateSponsors = true;

  /* True if we should auto-create locations. Some sites may wish to control
   * the creation of locations to enforce consistency in their use. If this
   * is true we create a location as we create events. If false the location
   * must already exist.
   */
  private boolean autoCreateLocations = true;

  /* True if we should auto-delete sponsors. Some sites may wish to control
   * the deletion of sponsors to enforce consistency in their use. If this
   * is true we delete a sponsor when it becomes unused.
   */
  private boolean autoDeleteSponsors = true;

  /* True if we should auto-delete locations. Some sites may wish to control
   * the deletion of locations to enforce consistency in their use. If this
   * is true we delete a location when it becomes unused.
   */
  private boolean autoDeleteLocations = true;

  private boolean hour24;

  private int minIncrement;

  private boolean showYearData;

  private String logPrefix;

  private String refreshAction;

  private int refreshInterval;

  private String calSuite;

  /** Constructor
   *
   */
  public ConfigBase() {
  }

  /** True if we should auto-create sponsors. Some sites may wish to control
   * the creation of sponsors to enforce consistency in their use. If this
   * is true we create a sponsor as we create events. If false the sponsor
   * must already exist.
   *
   * @param val
   */
  public void setAutoCreateSponsors(boolean val) {
    autoCreateSponsors = val;
  }

  /**
   * @return boolean
   */
  public boolean getAutoCreateSponsors() {
    return autoCreateSponsors;
  }

  /** True if we should auto-create locations. Some sites may wish to control
   * the creation of locations to enforce consistency in their use. If this
   * is true we create a location as we create events. If false the location
   * must already exist.
   *
   * @param val
   */
  public void setAutoCreateLocations(boolean val) {
    autoCreateLocations = val;
  }

  /**
   * @return boolean
   */
  public boolean getAutoCreateLocations() {
    return autoCreateLocations;
  }

  /** True if we should auto-delete sponsors. Some sites may wish to control
   * the deletion of sponsors to enforce consistency in their use. If this
   * is true we delete a sponsor when it becomes unused.
   *
   * @param val
   */
  public void setAutoDeleteSponsors(boolean val) {
    autoDeleteSponsors = val;
  }

  /**
   * @return boolean
   */
  public boolean getAutoDeleteSponsors() {
    return autoDeleteSponsors;
  }

  /** True if we should auto-delete locations. Some sites may wish to control
   * the deletion of locations to enforce consistency in their use. If this
   * is true we delete a location when it becomes unused.
   *
   * @param val
   */
  public void setAutoDeleteLocations(boolean val) {
    autoDeleteLocations = val;
  }

  /**
   * @return boolean
   */
  public boolean getAutoDeleteLocations() {
    return autoDeleteLocations;
  }

  /**
   * @param val
   */
  public void setHour24(boolean val) {
    hour24 = val;
  }

  /**
   * @return bool
   */
  public boolean getHour24() {
    return hour24;
  }

  /**
   * @param val
   */
  public void setMinIncrement(int val) {
    minIncrement = val;
  }

  /**
   * @return int
   */
  public int getMinIncrement() {
    return minIncrement;
  }

  /** True if we show data on year viewws.
   *
   * @param val
   */
  public void setShowYearData(boolean val) {
    showYearData = val;
  }

  /**
   * @return boolean
   */
  public boolean getShowYearData() {
    return showYearData;
  }

  /**
   * @param val
   */
  public void setLogPrefix(String val) {
    logPrefix = val;
  }

  /**
   * @return String
   */
  public String getLogPrefix() {
    return logPrefix;
  }

  /**
   * @param val
   */
  public void setRefreshAction(String val) {
    refreshAction = val;
  }

  /**
   * @return String
   */
  public String getRefreshAction() {
    return refreshAction;
  }

  /**
   * @param val
   */
  public void setRefreshInterval(int val) {
    refreshInterval = val;
  }

  /**
   * @return int
   */
  public int getRefreshInterval() {
    return refreshInterval;
  }

  /**
   * @param val
   */
  public void setCalSuite(String val) {
    calSuite = val;
  }

  /**
   * @return String
   */
  public String getCalSuite() {
    return calSuite;
  }

  /** Copy this object to val.
   *
   * @param val
   */
  public void copyTo(ConfigBase val) {
    val.setAutoCreateSponsors(getAutoCreateSponsors());
    val.setAutoCreateLocations(getAutoCreateLocations());
    val.setAutoDeleteSponsors(getAutoDeleteSponsors());
    val.setAutoDeleteLocations(getAutoDeleteLocations());
    val.setHour24(getHour24());
    val.setMinIncrement(getMinIncrement());
    val.setShowYearData(getShowYearData());
    val.setLogPrefix(getLogPrefix());
    val.setRefreshAction(getRefreshAction());
    val.setRefreshInterval(getRefreshInterval());
    val.setCalSuite(getCalSuite());
  }

  public Object clone() {
    ConfigBase conf = new ConfigBase();

    copyTo(conf);

    return conf;
  }
}
