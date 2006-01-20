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

/**
 *   @author Mike Douglass   douglm @ rpi.edu
 */
public class PublicWebPanel extends AbstractOptionsPanel {
  private CheckBox standaloneApp;
  private CheckBox portlet;

  private TextField warName;
  //private CheckBox deployJ2ee;
  //private TextField earName;
  private TextField contextRoot;
  private TextField appRoot;
  private TextField resourcesDir;
  private TextField deploymentDir;

  private TextField description;
  private TextField displayName;
  private TextField name;

  private CheckBox hour24;
  private TextField minincrement;
  private TextField skinsetName;
  private TextField showyeardata;
  private TextField defaultView;
  private TextField refreshInterval;
  private TextField refreshAction;
  private TextField groupsclass;

  private TextField portalPlatform;

  /** Constructor
   *
   * @param globals
   * @param index
   */
  public PublicWebPanel(Globals globals, int index) {
    super(globals, PropDefs.modulePublicWebClient, index);

    standaloneApp = checkBox(PropDefs.propPubeventsStandaloneApp);
    portlet = checkBox(new OptionsCheckBox(this, globals,
                                           PropDefs.propPubeventsPortlet,
                                           true) {
      public void checkBoxAction(boolean val) {
        super.checkBoxAction(val);
        portalPlatform.setEnabled(val);
      }
    });

    warName = textField(PropDefs.propPubeventsWarName);

    /*
    -- need to override setvalue and en/disable j2ee fields
    deployJ2ee = checkBox(PropDefs.propPubeventsEditAllLocations);
    earName = textField(PropDefs.propPubeventsEarName);
     */

    contextRoot = textField(PropDefs.propPubeventsContextRoot);
    appRoot = textField(PropDefs.propPubeventsAppRoot);
    resourcesDir = textField(PropDefs.propPubeventsResourcesDir);
    deploymentDir = textField(PropDefs.propPubeventsDeployDir);

    description = textField(PropDefs.propPubeventsDescription);
    displayName = textField(PropDefs.propPubeventsDisplayName);
    name = textField(PropDefs.propPubeventsName);

    hour24 = checkBox(PropDefs.propPubeventsHour24);
    minincrement = textField(PropDefs.propPubeventsMinincrement);
    skinsetName = textField(PropDefs.propPubeventsSkinsetName);
    showyeardata = textField(PropDefs.propPubeventsShowyeardata);
    defaultView = textField(PropDefs.propPubeventsDefaultView);
    refreshInterval = textField(PropDefs.propPubeventsRefreshInterval);
    refreshAction = textField(PropDefs.propPubeventsRefreshAction);
    groupsclass = textField(PropDefs.propPubeventsGroupsclass);

    portalPlatform = textField(PropDefs.propPubeventsPortalPlatform);
    portalPlatform.setEnabled(portlet.getValue());
  }

  public void saveProperties(PrintStream str) {
    saveTitle(str, PropDefs.modulePublicWebClient);

    saveProperty(str, "pubevents.struts.errorheader", "<errors><ul>");
    saveProperty(str, "pubevents.struts.errorfooter", "</ul></errors>");
    saveProperty(str, "pubevents.struts.messageheader", "<messages><ul>");
    saveProperty(str, "pubevents.struts.messagefooter", "</ul></messages>");

    saveSpace(str);

    saveProperty(str, "pubevents.app.version", "1.0");
    saveProperty(str, "pubevents.app.default.contenttype", "text/xml");
    saveProperty(str, "pubevents.app.web.xml", "guest/web.xml");

    saveSpace(str);

    if (standaloneApp.getValue()) {
      saveProp(str, standaloneApp);
    }

    saveProp(str, warName);
    saveProperty(str, "pubevents.deploy.j2ee", "false");
    saveProperty(str, "pubevents.ear.name", warName.getValue());
    saveProp(str, contextRoot);
    saveProp(str, appRoot);
    saveProp(str, resourcesDir);
    saveProp(str, deploymentDir);

    saveSpace(str);

    saveProp(str, description);
    saveProp(str, displayName);
    saveProp(str, name);

    saveSpace(str);

    saveProp(str, hour24);
    saveProp(str, minincrement);
    saveProp(str, skinsetName);
    saveProp(str, showyeardata);
    saveProp(str, defaultView);
    saveProp(str, refreshInterval);
    saveProp(str, refreshAction);
    saveProp(str, groupsclass);

    saveSpace(str);

    String portal = portalPlatform.getValue();

    if ((portal != null) && (portal.trim().length() != 0) &&
        (!portal.equals("none"))) {
      saveProp(str, portalPlatform);
    }
  }
}
