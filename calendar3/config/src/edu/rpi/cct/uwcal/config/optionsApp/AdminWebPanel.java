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

import java.io.PrintStream;

/** Do admin properties
 *
 * @author Mike Douglass douglm @ rpi.edu
 */
public class AdminWebPanel extends AbstractOptionsPanel {
  private CheckBox standaloneApp;
  private CheckBox portlet;

  private TextField warName;
//  private CheckBox deployJ2ee;
//  private TextField earName;
  private TextField contextRoot;
  private TextField appRoot;
  private TextField resourcesDir;
  private TextField deploymentDir;

  private TextField securityDomain;
  private TextField securityPrefix;
  private CheckBox useSSL;

  private TextField description;
  private TextField displayName;
  private TextField name;

  private CheckBox autocreatesponsors;
  private CheckBox autodeletesponsors;
  private CheckBox autocreatelocations;
  private CheckBox autodeletelocations;
  private CheckBox editAllCategories;
  private CheckBox editAllLocations;
  private CheckBox editAllSponsors;
  private CheckBox categoryOptional;

  private CheckBox hour24;
  private TextField minincrement;
  private TextField admingroupsidprefix;
  private TextField admingroupsclass;

  private TextField portalPlatform;
  private TextField jetspeed2Roles;

  /** Constructor
   *
   * @param globals
   * @param index
   */
  public AdminWebPanel(Globals globals, int index) {
    super(globals, PropDefs.moduleAdminWebClient, index);

    standaloneApp = checkBox(PropDefs.propAdminStandaloneApp);
    portlet = checkBox(new OptionsCheckBox(this, globals,
                                           PropDefs.propAdminPortlet,
                                           true) {
      public void checkBoxAction(boolean val) {
        super.checkBoxAction(val);
        portalPlatform.setEnabled(val);
        jetspeed2Roles.setEnabled(val);
      }
    });

    warName = textField(PropDefs.propAdminWarName);

    /*
    -- need to override setvalue and en/disable j2ee fields
    deployJ2ee = checkBox(PropDefs.propAdminEditAllLocations);
    earName = textField(PropDefs.propAdminEarName);
     */

    contextRoot = textField(PropDefs.propAdminContextRoot);
    appRoot = textField(PropDefs.propAdminAppRoot);
    resourcesDir = textField(PropDefs.propAdminResourcesDir);
    deploymentDir = textField(PropDefs.propAdminDeployDir);

    addSeparator("security.options");
    securityDomain = textField(PropDefs.propAdminSecurityDomain);
    securityPrefix = textField(PropDefs.propAdminSecurityPrefix);
    useSSL = checkBox(PropDefs.propAdminSSL);

    description = textField(PropDefs.propAdminDescription);
    displayName = textField(PropDefs.propAdminDisplayName);
    name = textField(PropDefs.propAdminName);

    autocreatesponsors = checkBox(PropDefs.propAdminAutocreatesponsors);
    autodeletesponsors = checkBox(PropDefs.propAdminAutodeletesponsors);
    autocreatelocations = checkBox(PropDefs.propAdminAutocreatelocations);
    autodeletelocations = checkBox(PropDefs.propAdminAutodeletelocations);
    editAllCategories = checkBox(PropDefs.propAdminEditAllCategories);
    editAllLocations = checkBox(PropDefs.propAdminEditAllLocations);
    editAllSponsors = checkBox(PropDefs.propAdminEditAllSponsors);
    categoryOptional = checkBox(PropDefs.propAdminCategoryOptional);

    hour24 = checkBox(PropDefs.propAdminHour24);
    minincrement = textField(PropDefs.propAdminMinincrement);
    admingroupsidprefix = textField(PropDefs.propAdminAdminGroupsidPrefix);
    admingroupsclass = textField(PropDefs.propAdminGroupsclass, true);

    portalPlatform = textField(PropDefs.propAdminPortalPlatform);
    portalPlatform.setEnabled(portlet.getValue());
    jetspeed2Roles = textField(PropDefs.propAdminJetspeed2Roles);
    jetspeed2Roles.setEnabled(portlet.getValue());
  }

  public void saveProperties(PrintStream str) {
    saveTitle(str, PropDefs.moduleAdminWebClient);

    saveProperty(str, "admin.struts.errorheader",
                 "<p>" + globals.rsrc.getValueString("admin.strutserrorheader") +
                 "</p><ul>");
    saveProperty(str, "admin.struts.errorfooter", "</ul>");
    saveProperty(str, "admin.struts.messageheader", "<ul>");
    saveProperty(str, "admin.struts.messagefooter", "</ul>");

    saveSpace(str);

    saveProperty(str, "admin.app.version", "1.0");
    saveProperty(str, "admin.app.default.contenttype", "text/html");
    saveProperty(str, "admin.app.noxslt", "yes");
    saveProperty(str, "admin.app.nogroupallowed", "false");

    saveSpace(str);

    if (standaloneApp.getValue()) {
      saveProp(str, standaloneApp);
    }

    saveProp(str, warName);
    saveProperty(str, "admin.deploy.j2ee", "false");
    saveProperty(str, "admin.ear.name", warName.getValue());
    saveProp(str, contextRoot);
    saveProp(str, appRoot);
    saveProp(str, resourcesDir);
    saveProp(str, deploymentDir);

    saveSpace(str);

    saveProp(str, securityDomain);
    saveProp(str, securityPrefix);

    if (useSSL.getValue()) {
      saveProperty(str, globals.rsrc.getPropnameString(PropDefs.propAdminTransportGuarantee),
                   "CONFIDENTIAL");
    } else {
      saveProperty(str, globals.rsrc.getPropnameString(PropDefs.propAdminTransportGuarantee),
                   "NONE");
    }

    saveSpace(str);

    saveProp(str, description);
    saveProp(str, displayName);
    saveProp(str, name);

    saveSpace(str);

    saveProp(str, autocreatesponsors);
    saveProp(str, autodeletesponsors);
    saveProp(str, autocreatelocations);
    saveProp(str, autodeletelocations);
    saveProp(str, editAllCategories);
    saveProp(str, editAllLocations);
    saveProp(str, editAllSponsors);
    saveProp(str, categoryOptional);

    saveSpace(str);

    saveProp(str, hour24);
    saveProp(str, minincrement);
    saveProp(str, admingroupsidprefix);
    saveProp(str, admingroupsclass);

    saveSpace(str);

    String portal = portalPlatform.getValue();

    if ((portal != null) && (portal.trim().length() != 0) &&
        (!portal.equals("none"))) {
      saveProp(str, portalPlatform);
      saveProp(str, jetspeed2Roles);
    }
  }
}
