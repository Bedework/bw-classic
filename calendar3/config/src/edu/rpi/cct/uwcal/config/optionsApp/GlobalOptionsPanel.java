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

package edu.rpi.cct.uwcal.config.optionsApp;

import edu.rpi.cct.uwcal.config.common.PropDefs;
import edu.rpi.cct.uwcal.config.optionsApp.common.CheckBox;
import edu.rpi.cct.uwcal.config.optionsApp.common.TextField;

import java.awt.GridBagConstraints;
import java.io.PrintStream;
import java.util.HashMap;

/** This panel handles the global options set first. These allow the deployer
 * to indicate which components they want to install and those global options
 * which affect all components.
 *
 * All properties are save as a named profile. There may be a number of these
 * profiles. Associated with each profile is a deployment directory into which
 * the configured files are deployed.
 *
 * <p>Installable components are<ul>
 * <li>Admin standalone web app</li>
 * <li>Public events standalone web app</li>
 * <li>Personal events standalone web app</li>
 * <li>Admin portlet</li>
 * <li>Public events portlet</li>
 * <li>Personal events portlet</li>
 * <li>Public events caldav server</li>
 * <li>Personal events caldav server</li>
 * </ul>
 *
 * Global properties are:
 * <ul>
 * <li>Directory browsing allowed</li>
 * <ul>
 */
public abstract class GlobalOptionsPanel extends AbstractOptionsPanel {
  private HashMap moduleFlags = new HashMap();

  TextField deployDir;
  TextField systemid;
  CheckBox dirbrowsing;
  TextField publicCalroot;
  TextField userCalroot;
  TextField defaultUserCalendar;
  TextField publicUser;
  TextField timezoneroot;

  TextField userauthclass;
  TextField mailerclass;
  TextField calintfclass;
  TextField updateCheckInterval;

  /** Constructor
   *
   * @param globals
   * @param index
   */
  public GlobalOptionsPanel(Globals globals, int index) {
    super(globals, "globaloptions", index);

    showTitleText("selectcomponents");

    moduleCheckBox(PropDefs.moduleAdminWebClient);
    moduleCheckBox(PropDefs.modulePublicWebClient);
    moduleCheckBox(PropDefs.modulePersonalWebClient);
    moduleCheckBox(PropDefs.modulePublicCaldav);
    moduleCheckBox(PropDefs.modulePersonalCaldav);

    addSeparator();

    globals.advanced = checkBox(new OptionsCheckBox(this, globals,
                                             PropDefs.propGlobalAdvanced,
                                             true) {
      public void checkBoxAction(boolean val) {
        super.checkBoxAction(val);
        GlobalOptionsPanel.this.globals.redraw();
      }
    });

    deployDir = textField(PropDefs.propGlobalDeployDir, false);
    systemid = textField(PropDefs.propGlobalSystemid, false);
    dirbrowsing = checkBox(PropDefs.propGlobalDirbrowsing, false);

    publicCalroot = textField(PropDefs.propGlobalPublicCalroot, false);
    userCalroot = textField(PropDefs.propGlobalUserCalroot, false);
    defaultUserCalendar = textField(PropDefs.propGlobalDefaultUserCalendar, false);
    publicCalroot = textField(PropDefs.propGlobalPublicUser, false);
    timezoneroot = textField(PropDefs.propGlobalTimezoneRoot, false);

    /* Advanced fields */
    userauthclass = textField(PropDefs.propGlobalUserauthclass, true);
    mailerclass = textField(PropDefs.propGlobalMailerclass, true);
    calintfclass = textField(PropDefs.propGlobalCalintfclass, true);
    updateCheckInterval = textField(PropDefs.propGlobalUpdateCheckInterval, true);
  }

  public void saveProperties(PrintStream str) {
    saveTitle(str, "globaloptions");

    saveProp(str, PropDefs.moduleAdminWebClient);
    saveProp(str, PropDefs.modulePublicWebClient);
    saveProp(str, PropDefs.modulePersonalWebClient);
    saveProp(str, PropDefs.modulePublicCaldav);
    saveProp(str, PropDefs.modulePersonalCaldav);

    saveSpace(str);

    saveProp(str, globals.advanced);

    saveProp(str, systemid);
    saveProp(str, dirbrowsing);

    saveProp(str, publicCalroot);
    saveProp(str, userCalroot);
    saveProp(str, defaultUserCalendar);
    saveProp(str, publicUser);
    saveProp(str, timezoneroot);

    saveProp(str, userauthclass);
    saveProp(str, mailerclass);
    saveProp(str, calintfclass);
    saveProp(str, updateCheckInterval);
  }

  /**
   * @param moduleName
   * @return true if named calendar module is enabled
   */
  public boolean getModuleEnabled(String moduleName) {
    CheckBox cb = getModuleCb(moduleName);
    if (cb == null) {
      throw new RuntimeException("Bad name " + moduleName);
    }

    return cb.getValue();
  }

  /** Given property state changed
   *
   * @param propName
   * @param val
   */
  public abstract void stateChanged(String propName, boolean val);

  private CheckBox getModuleCb(String moduleName) {
    return (CheckBox)moduleFlags.get(moduleName);
  }

  protected void saveProp(PrintStream str, String moduleName) {
    saveProperty(str, globals.rsrc.getPropnameString(moduleName),
                 String.valueOf(getModuleCb(moduleName).getValue()));
  }

  private CheckBox moduleCheckBox(String resourceName) {
    CheckBox cb = new CheckBox(this, resourceName, globals.rsrc, globals.props,
                               true, false) {
      public void checkBoxAction(boolean val) {
        super.checkBoxAction(val);
        stateChanged(resourceName, val);
      }
    };

    moduleFlags.put(resourceName, cb);

    label(resourceName);
    constraints.fill = GridBagConstraints.HORIZONTAL;
    constraints.weightx = 1.0;
    addComponent(cb, row, 1);
    row++;

    return cb;
  }
}

