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

package edu.rpi.cct.uwcal.config.common;

/** The names defined here are used as the suffix to a group of properties
 * defining some attribute of the suite.
 *
 * <p>To access the actual resource the name will be prefixed by a string
 * defining which kind of resource.
 *
 * For example, the definition below <br/>
 * propAdminWarName = "admin.war"<br/>
 * defines a group of properties which define the war name for the web admin
 * client.
 *
 * <p>These will be prefixed by, for example, "org.bedework.label." to get a
 * resource giving the label value, "org.bedework.tooltip." to get a value to
 * be used for the tooltip, etc.
 *
 * <p>The values defined here are usd in the panels when defining an input
 * field, e.g. a checkbox or textarea.
 *
 * @author  Mike Douglass    doulglm@rpi.edu
 */
public interface PropDefs {
  /* ======================== Names defining modules ==================== */
  /* These are used as the suffix to a number of properties */

  /** */
  public static final String moduleAdminWebClient = "adminwebclient";
  /** */
  public static final String modulePublicWebClient = "publicwebclient";
  /** */
  public static final String modulePersonalWebClient = "personalwebclient";
  /** */
  public static final String modulePublicCaldav = "publiccaldav";
  /** */
  public static final String modulePersonalCaldav = "personalcaldav";

  /* ========================== Global Properties ======================= */

  /** */
  public static final String propGlobalAdvanced = "globals.advanced";

  /** */
  public static final String propGlobalDeployDir = "globals.deploydir";

  /** */
  public static final String propGlobalSystemid = "globals.systemid";

  /** */
  public static final String propGlobalDirbrowsing = "globals.dirbrowsing";

  /** */
  public static final String propGlobalPublicCalroot = "globals.public.calroot";

  /** */
  public static final String propGlobalUserCalroot = "globals.user.calroot";

  /** */
  public static final String propGlobalDefaultUserCalendar = "globals.default.user.calendar";

  /** */
  public static final String propGlobalPublicUser = "globals.public.user";

  /** */
  public static final String propGlobalTimezoneRoot = "globals.timezoneroot";

  /** */
  public static final String propGlobalCalenv = "globals.calenv";

  /** */
  public static final String propGlobalUserauthclass = "globals.userauthclass";

  /** */
  public static final String propGlobalMailerclass = "globals.mailerclass";

  /** */
  public static final String propGlobalCalintfclass = "globals.calintfclass";

  /** */
  public static final String propGlobalUpdateCheckInterval = "globals.update.check.interval";

  /* ========================== Admin Properties ======================= */

  /** */
  public static final String propAdminStandaloneApp = "admin.standalone.app";

  /** */
  public static final String propAdminPortlet = "admin.portlet";

  /** */
  public static final String propAdminWarName = "admin.war";

  /** */
  public static final String propAdminJ2eeDeploy = "admin.j2ee.deploy";

  /** */
  public static final String propAdminEarName = "admin.ear";

  /** */
  public static final String propAdminContextRoot = "admin.context.root";

  /** */
  public static final String propAdminAppRoot = "admin.app.root";

  /** */
  public static final String propAdminResourcesDir = "admin.resources.dir";

  /** */
  public static final String propAdminDeployDir = "admin.deploy.dir";

  /** */
  public static final String propAdminSecurityDomain = "admin.security.domain";

  /** */
  public static final String propAdminSecurityPrefix = "admin.security.prefix";

  /** */
  public static final String propAdminSSL = "admin.ssl";

  /** */
  public static final String propAdminDescription = "admin.description";

  /** */
  public static final String propAdminDisplayName = "admin.display.name";

  /** */
  public static final String propAdminName = "admin.name";

  /** */
  public static final String propAdminTransportGuarantee = "admin.transport.guarantee";

  /** */
  public static final String propAdminAutocreatesponsors = "admin.autocreatesponsors";

  /** */
  public static final String propAdminAutodeletesponsors = "admin.autodeletesponsors";

  /** */
  public static final String propAdminAutocreatelocations = "admin.autocreatelocations";

  /** */
  public static final String propAdminAutodeletelocations = "admin.autodeletelocations";

  /** */
  public static final String propAdminEditAllCategories = "admin.allowEditAllCategories";

  /** */
  public static final String propAdminEditAllLocations = "admin.allowEditAllLocations";

  /** */
  public static final String propAdminEditAllSponsors = "admin.allowEditAllSponsors";

  /** */
  public static final String propAdminCategoryOptional = "admin.categoryOptional";

  /** */
  public static final String propAdminHour24 = "admin.hour24";

  /** */
  public static final String propAdminMinincrement = "admin.minincrement";

  /** */
  public static final String propAdminAdminGroupsidPrefix = "admin.admingroupsidprefix";

  /** */
  public static final String propAdminGroupsclass = "admin.groupsclass";

  /** */
  public static final String propAdminPortalPlatform = "admin.portal.platform";

  /** */
  public static final String propAdminJetspeed2Roles = "admin.jetspeed2.roles";

  /* ======================= Public Events Properties =================== */

  /** */
  public static final String propPubeventsStandaloneApp = "pubevents.standalone.app";

  /** */
  public static final String propPubeventsPortlet = "pubevents.portlet";

  /** */
  public static final String propPubeventsWarName = "pubevents.war";

  /** */
  public static final String propPubeventsJ2eeDeploy = "pubevents.j2ee.deploy";

  /** */
  public static final String propPubeventsEarName = "pubevents.ear";

  /** */
  public static final String propPubeventsContextRoot = "pubevents.context.root";

  /** */
  public static final String propPubeventsAppRoot = "pubevents.app.root";

  /** */
  public static final String propPubeventsResourcesDir = "pubevents.resources.dir";

  /** */
  public static final String propPubeventsDeployDir = "pubevents.deploy.dir";

  /*
  public static final String propPubeventsSecurityDomain = "pubevents.security.domain";

  public static final String propPubeventsSecurityPrefix = "pubevents.security.prefix";

  public static final String propPubeventsSSL = "pubevents.ssl";

  public static final String propPubeventsTransportGuarantee = "pubevents.transport.guarantee";
  */

  /** */
  public static final String propPubeventsDescription = "pubevents.description";

  /** */
  public static final String propPubeventsDisplayName = "pubevents.display.name";

  /** */
  public static final String propPubeventsName = "pubevents.name";

  /** */
  public static final String propPubeventsHour24 = "pubevents.hour24";

  /** */
  public static final String propPubeventsMinincrement = "pubevents.minincrement";

  /** */
  public static final String propPubeventsSkinsetName = "pubevents.skinset.name";

  /** */
  public static final String propPubeventsShowyeardata = "pubevents.showyeardata";

  /** */
  public static final String propPubeventsDefaultView = "pubevents.default.view";

  /** */
  public static final String propPubeventsRefreshInterval = "pubevents.refresh.interval";

  /** */
  public static final String propPubeventsRefreshAction = "pubevents.refresh.action";

  /** */
  public static final String propPubeventsPortalPlatform = "pubevents.portal.platform";

  /** */
  public static final String propPubeventsGroupsclass = "pubevents.groupsclass";

  /* ======================= Personal Events Properties =================== */

  /** */
  public static final String propPersonalStandaloneApp = "personal.standalone.app";

  /** */
  public static final String propPersonalPortlet = "personal.portlet";

  /** */
  public static final String propPersonalWarName = "personal.war";

  /** */
  public static final String propPersonalJ2eeDeploy = "personal.j2ee.deploy";

  /** */
  public static final String propPersonalEarName = "personal.ear";

  /** */
  public static final String propPersonalContextRoot = "personal.context.root";

  /** */
  public static final String propPersonalAppRoot = "personal.app.root";

  /** */
  public static final String propPersonalResourcesDir = "personal.resources.dir";

  /** */
  public static final String propPersonalDeployDir = "personal.deploy.dir";

  /** */
  public static final String propPersonalSecurityDomain = "personal.security.domain";

  /** */
  public static final String propPersonalSecurityPrefix = "personal.security.prefix";

  /** */
  public static final String propPersonalSSL = "personal.ssl";

  /** */
  public static final String propPersonalTransportGuarantee = "personal.transport.guarantee";

  /** */
  public static final String propPersonalDescription = "personal.description";

  /** */
  public static final String propPersonalDisplayName = "personal.display.name";

  /** */
  public static final String propPersonalName = "personal.name";

  /** */
  public static final String propPersonalHour24 = "personal.hour24";

  /** */
  public static final String propPersonalMinincrement = "personal.minincrement";

  /** */
  public static final String propPersonalSkinsetName = "personal.skinset.name";

  /** */
  public static final String propPersonalShowyeardata = "personal.showyeardata";

  /** */
  public static final String propPersonalDefaultView = "personal.default.view";

  /** */
  public static final String propPersonalRefreshInterval = "personal.refresh.interval";

  /** */
  public static final String propPersonalRefreshAction = "personal.refresh.action";

  /** */
  public static final String propPersonalPortalPlatform = "personal.portal.platform";

  /** */
  public static final String propPersonalGroupsclass = "personal.groupsclass";

  /* =================== Public Caldav Server Properties ================ */

  /** */
  public static final String propPublicCaldavWarName = "caldav.public.war";

  /** */
  public static final String propPublicCaldavJ2eeDeploy = "caldav.public.j2ee.deploy";

  /** */
  public static final String propPublicCaldavEarName = "caldav.public.ear";

  /** */
  public static final String propPublicCaldavContextRoot = "caldav.public.context.root";

  /** */
  public static final String propPublicCaldavDescription = "caldav.public.description";

  /** */
  public static final String propPublicCaldavDisplayName = "caldav.public.display.name";

  /** */
  public static final String propPublicCaldavName = "caldav.public.name";

  /** */
  public static final String propPublicCaldavDeployDir = "caldav.public.deploy.dir";

  /** */
  public static final String propPublicCaldavGroupsclass = "caldav.public.groupsclass";

  /* ================= Personal Caldav Server Properties ================ */

  /** */
  public static final String propPersonalCaldavWarName = "caldav.user.war";

  /** */
  public static final String propPersonalCaldavJ2eeDeploy = "caldav.user.j2ee.deploy";

  /** */
  public static final String propPersonalCaldavEarName = "caldav.user.ear";

  /** */
  public static final String propPersonalCaldavContextRoot = "caldav.user.context.root";

  /** */
  public static final String propPersonalCaldavSecurityDomain = "caldav.user.security.domain";

  /** */
  public static final String propPersonalCaldavSecurityPrefix = "caldav.user.security.prefix";

  /** */
  public static final String propPersonalCaldavSSL = "caldav.user.ssl";

  /** */
  public static final String propPersonalCaldavTransportGuarantee = "caldav.user.transport.guarantee";

  /** */
  public static final String propPersonalCaldavDescription = "caldav.user.description";

  /** */
  public static final String propPersonalCaldavDisplayName = "caldav.user.display.name";

  /** */
  public static final String propPersonalCaldavName = "caldav.user.name";

  /** */
  public static final String propPersonalCaldavDeployDir = "caldav.user.deploy.dir";

  /** */
  public static final String propPersonalCaldavGroupsclass = "caldav.user.groupsclass";
}

