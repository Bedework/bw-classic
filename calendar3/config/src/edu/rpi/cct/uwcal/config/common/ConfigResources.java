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

import java.io.Serializable;
import java.util.ListResourceBundle;

/** Object to provide internationalized resources for the calendar suite
 * config module
 *
 * DO NOT alter the values of the "org.bedework.propname.xxx" properties.
 * These define the name of the associated property.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class ConfigResources extends ListResourceBundle implements Serializable {
  private static final Object[][] contents = {
    /* -------------- Labels, tooltips and explanatory text ------------- */

    /* modules */
    {"org.bedework.label.adminwebclient", "Admin Web Client"},
    {"org.bedework.tooltip.adminwebclient", "Install the Admin Web Client"},
    {"org.bedework.help.adminwebclient",
        "If selected the administrative web client will be \n" +
        "configured and deployed."},
    {"org.bedework.tab.adminwebclient", "Admin Web"},
    {"org.bedework.propname.adminwebclient", "org.bedework.install.admin.web"},

    {"org.bedework.label.publicwebclient", "Public Web Client"},
    {"org.bedework.tooltip.publicwebclient", "Install the Public Web Client"},
    {"org.bedework.help.publicwebclient",
        "If selected the public events web client will be \n" +
        "configured and deployed."},
    {"org.bedework.tab.publicwebclient", "Public Web"},
    {"org.bedework.propname.publicwebclient", "org.bedework.install.public.web"},

    {"org.bedework.label.personalwebclient", "Personal Web Client"},
    {"org.bedework.tooltip.personalwebclient", "Install the Personal Web Client"},
    {"org.bedework.help.personalwebclient",
        "If selected the personal events web client will be \n" +
        "configured and deployed."},
    {"org.bedework.tab.personalwebclient", "Personal Web"},
    {"org.bedework.propname.personalwebclient", "org.bedework.install.personal.web"},

    {"org.bedework.label.publiccaldav", "Public Caldav Server"},
    {"org.bedework.tooltip.publiccaldav", "Install the Public Caldav Server"},
    {"org.bedework.help.publiccaldav",
        "If selected the public events caldav server will be \n" +
        "configured and deployed."},
    {"org.bedework.tab.publiccaldav", "Public Caldav"},
    {"org.bedework.propname.publiccaldav", "org.bedework.install.public.caldav"},

    {"org.bedework.label.personalcaldav", "Personal Caldav Server"},
    {"org.bedework.tooltip.personalcaldav", "Install the Personal Caldav Server"},
    {"org.bedework.help.personalcaldav",
        "If selected the personal events caldav server will be \n" +
        "configured and deployed."},
    {"org.bedework.tab.personalcaldav", "Personal Caldav"},
    {"org.bedework.propname.personalcaldav", "org.bedework.install.personal.caldav"},

    /* flags */
    {"org.bedework.label.globals.advanced", "Advanced mode"},
    {"org.bedework.tooltip.globals.advanced", "If set show advanced options"},
    {"org.bedework.help.globals.advanced",
        "If set show advanced options"},
    {"org.bedework.propname.globals.advanced", "org.bedework.install.advanced"},

    {"org.bedework.tab.globaloptions", "Globals"},

    {"org.bedework.help.intro",
        "This client will configure and deploy the selected components of " +
        "the calendar system.\n" +

        "On the global tab select the components and set other global parameters " +
        "then configure each of the selected components on their respective panels.\n" +

        "The previous and next buttons will move through the tabs"},
    {"org.bedework.tab.intro", "Intro"},
    {"org.bedework.text.intro",
         "#\n" +
         "# Properties for all modules are saved below - even if they are not\n" +
         "# being deployed. The globals section defines which modules will be\n" +
         "# deployed as well as some other global properties."},

    /* ---------------------- Titles -------------------- */

    {"org.bedework.title.selectcomponents", "Select the components to configure and deploy"},

    {"org.bedework.title.security.options", "Security options"},

    {"org.bedework.title.globaloptions", "Global options"},
    {"org.bedework.title.intro", "Introduction"},
    {"org.bedework.title.adminwebclient", "Standalone Admin Web Client"},
    {"org.bedework.title.publicwebclient", "Standalone Public Web Client"},
    {"org.bedework.title.personalwebclient", "Standalone Personal Web Client"},
    {"org.bedework.title.adminportlet", "Admin Portlet"},
    {"org.bedework.title.publicportlet", "Public Portlet"},
    {"org.bedework.title.personalportlet", "Personal Portlet"},
    {"org.bedework.title.publiccaldav", "Public Caldav Server"},
    {"org.bedework.title.personalcaldav", "Personal Caldav Server"},

    /* ---------------------- Menus -------------------- */

    {"org.bedework.menu.file", "File"},
    {"org.bedework.menu.mnemonic.file", "f"},

    {"org.bedework.menu.file.new", "New"},
    {"org.bedework.menu.mnemonic.file.new", "n"},

    {"org.bedework.menu.file.open", "Open Properties..."},
    {"org.bedework.menu.mnemonic.file.open", "o"},

    {"org.bedework.menu.file.save", "Save"},
    {"org.bedework.menu.mnemonic.file.save", "s"},

    {"org.bedework.menu.file.saveas", "Save As..."},
    {"org.bedework.menu.mnemonic.file.saveas", ""},

    {"org.bedework.menu.file.exit", "Exit"},
    {"org.bedework.menu.mnemonic.file.exit", "x"},

    /* ---------------------- Buttons -------------------- */

    {"org.bedework.button.prev", "Previous"},
    {"org.bedework.tooltip.prev", "Go to the previous tab"},

    {"org.bedework.button.next", "Next"},
    {"org.bedework.tooltip.next", "Go to the next tab"},

    /* ---------------------- Global properties ------------------------- */

    {"org.bedework.label.globals.systemid", "Calendar System Id"},
    {"org.bedework.tooltip.globals.systemid",
        "Define a system id used in guid creation"},
    {"org.bedework.help.globals.systemid",
        "Define a system id used in guid creation. It should have a form " +
        "something like calendar@mysite.edu. It is not intended to represent " +
        "or define any particular host rather a single instance of a calendar " +
        "system."},
    {"org.bedework.propname.globals.systemid", "org.bedework.global.systemid"},

    {"org.bedework.label.globals.dirbrowsing", "Directory Browsing disallowed"},
    {"org.bedework.tooltip.globals.dirbrowsing",
        "Set if directory browsing is disallowed on web servers"},
    {"org.bedework.help.globals.dirbrowsing",
        "Set if directory browsing is disallowed on web servers that serve " +
        "the stylesheets from the app root. The filters discover the correct " +
        "path by checking each element down the path. If directory browsing is " +
        "not allowed marker files will be used instead."},
    {"org.bedework.propname.globals.dirbrowsing",
         "org.bedework.global.directory.browsing.disallowed"},

    {"org.bedework.label.globals.public.calroot", "Public Calendars Root"},
    {"org.bedework.tooltip.globals.public.calroot",
        "Root for public calendars"},
    {"org.bedework.help.globals.public.calroot",
        "Define the root of the public calendars path, usually something like " +
        "'public' resulting in a path of '/public'"},
    {"org.bedework.propname.globals.public.calroot",
        "org.bedework.global.public.calroot"},

    {"org.bedework.label.globals.user.calroot", "User Calendars Root"},
    {"org.bedework.tooltip.globals.user.calroot",
        "Root for user calendars"},
    {"org.bedework.help.globals.user.calroot",
        "Define the root of the user calendars path, usually something like " +
        "'user' resulting in a path of '/user'"},
    {"org.bedework.propname.globals.user.calroot",
        "org.bedework.global.user.calroot"},

    {"org.bedework.label.globals.default.user.calendar", "Default User Calendar Name"},
    {"org.bedework.tooltip.globals.default.user.calendar",
        "Default name for initial user calendar"},
    {"org.bedework.help.globals.default.user.calendar",
        "Define the default name for the user calendar, usually something like " +
        "'calendar' resulting in a path of '/user/user-id/calendaar'"},
    {"org.bedework.propname.globals.default.user.calendar",
        "org.bedework.global.default.user.calendar"},

    {"org.bedework.label.globals.public.user", "Public guest account name"},
    {"org.bedework.tooltip.globals.public.user",
        "User account for guest access. Used as a place holder for preferences."},
    {"org.bedework.help.globals.public.user",
        "User account for guest access. Used as a place holder for preferences." +
        "In particular it holds the subscriptions for the main public calendar" +
        "defining which public calendars will show in the default vies and providing " +
        "the list of calendars to select or subscribe to as a personal user."},
    {"org.bedework.propname.globals.public.user",
        "org.bedework.global.public.user"},

    {"org.bedework.label.globals.timezoneroot", "Timezones Root"},
    {"org.bedework.tooltip.globals.timezoneroot",
        "Root for user and public timezones"},
    {"org.bedework.help.globals.user.calroot",
        "Define the root of the timezones path, usually something like " +
        "'timezones' resulting in a path of '/public/timezones' and " +
        "'/user/user-id/timezones'"},
    {"org.bedework.propname.globals.timezoneroot",
        "org.bedework.global.timezoneroot"},

    {"org.bedework.label.globals.deploydir", "Deploy directory"},
    {"org.bedework.tooltip.globals.deploydir",
        "Directory for resulting deployable files"},
    {"org.bedework.help.globals.deploydir",
        "This is the directory deployable files will be copied to, that is  " +
        "war or ear files. Zipped runnable application files will be copied " +
        "to runnableDir. The predefined property ${org.bedework.appserver.dir} " +
        "can be used to define this value."},
    {"org.bedework.propname.globals.deploydir", "org.bedework.global.deploydir"},

    {"org.bedework.label.globals.runnabledir", "Runnable app directory"},
    {"org.bedework.tooltip.globals.runnabledir",
        "Directory for resulting runnableapplication files"},
    {"org.bedework.help.globals.runnabledir",
        "This is the directory runnable application files will be copied to," +
        " usually zipped up jars and shell scripts."},
    {"org.bedework.propname.globals.runnabledir", "org.bedework.global.runnabledir"},

    {"org.bedework.label.globals.userauthclass", "Calendar Authorization Class"},
    {"org.bedework.tooltip.globals.userauthclass",
        "Define the class which determines the user access rights"},
    {"org.bedework.help.globals.userauthclass",
        "Define the class which determines the user access rights. " +
        "The default version uses the calendar database - versions could be " +
        "written which used servlet roles."},
    {"org.bedework.propname.globals.userauthclass", "org.bedework.global.userauthclass"},

    {"org.bedework.label.globals.mailerclass", "Calendar Mailer Class"},
    {"org.bedework.tooltip.globals.mailerclass",
        "Define the class used for mailing events"},
    {"org.bedework.help.globals.mailerclass",
        "For the quickstart this is just a class to log a " +
        "message (DummyMailer). This needs to be replaced with your system specific " +
        "mailer if you wish tomail events or alarms."},
    {"org.bedework.propname.globals.mailerclass", "org.bedework.global.mailerclass"},

    {"org.bedework.label.globals.calintfclass", "Calendar Interface Implementation Class"},
    {"org.bedework.tooltip.globals.calintfclass",
        "Class which implements the Calintf interface"},
    {"org.bedework.help.globals.calintfclass",
        "Class which implements the Calintf interface."},
    {"org.bedework.propname.globals.calintfclass", "org.bedework.global.calintfclass"},

    {"org.bedework.label.globals.update.check.interval", "Update Check Interval (millisecs)"},
    {"org.bedework.tooltip.globals.update.check.interval",
        "Update check interval in millisecs"},
    {"org.bedework.help.globals.update.check.interval",
        "How often the back end checks for changes to the database."},
    {"org.bedework.propname.globals.update.check.interval",
        "org.bedework.global.update.check.interval"},

    /* ---------------------- Admin properties ------------------------- */

    /* Settable */

    {"org.bedework.label.admin.standalone.app", "Build standalone app"},
    {"org.bedework.tooltip.admin.standalone.app", "Build standalone app"},
    {"org.bedework.help.admin.standalone.app",
        "Build standalone app"},
    {"org.bedework.propname.admin.standalone.app", "org.bedework.webadmin.build.standalone.app"},

    {"org.bedework.label.admin.portlet", "Build portlet"},
    {"org.bedework.tooltip.admin.portlet", ""},
    {"org.bedework.help.admin.portlet",
        "Build portlet"},
    {"org.bedework.propname.admin.portlet", "org.bedework.webadmin.build.portlet"},

    {"org.bedework.label.admin.war", "War Name"},
    {"org.bedework.tooltip.admin.war", "Name of the generated war file"},
    {"org.bedework.help.admin.war",
        "Name of the generated war file"},
    {"org.bedework.propname.admin.war", "org.bedework.webadmin.war.name"},

    {"org.bedework.label.admin.j2ee.deploy", "Deploy on J2ee"},
    {"org.bedework.tooltip.admin.deploy", "Deploy Admin on J2ee"},
    {"org.bedework.help.admin.deploy",
        "Deploy Admin on J2ee as a ear file"},
    {"org.bedework.propname.admin.deploy", "org.bedework.webadmin.deploy.j2ee"},

    {"org.bedework.label.admin.ear", "Ear Name"},
    {"org.bedework.tooltip.admin.ear", "Name of the generated ear file"},
    {"org.bedework.help.admin.ear",
        "Name of the generated ear file"},
    {"org.bedework.propname.admin.ear", "org.bedework.webadmin.ear.name"},

    {"org.bedework.label.admin.context.root", "Context Root"},
    {"org.bedework.tooltip.admin.context.root", "Context Root"},
    {"org.bedework.help.admin.context.root",
        "Context Root for Admin client: This will currently only have effect " +
        "in the j2ee environment where the context root  is defined in ear " +
        "file configuration files"},
    {"org.bedework.propname.admin.context.root", "org.bedework.webadmin.app.context.root"},

    {"org.bedework.label.admin.app.root", "Application root"},
    {"org.bedework.tooltip.admin.app.root",
        "Where we keep the xsl stylesheets and resources"},
    {"org.bedework.help.admin.app.root",
        "Set admin.app.root to where we keep the xsl stylesheets and resources. " +
        "If this does not start with http: it will have the host and port " +
        "added as a prefix. This is mainly for development - generally this " +
        "should be a fully specified url pointing at the resource directory " +
        "usually in your sites web space."},
    {"org.bedework.propname.admin.app.root", "org.bedework.webadmin.app.root"},

    {"org.bedework.label.admin.resources.dir", "Resources for stuylesheets"},
    {"org.bedework.tooltip.admin.resources.dir",
        "Resources used by stylesheets for Admin client"},
    {"org.bedework.help.admin.resources.dir",
        "This defines a directory into which all the resources accessed via the " +
        "app root will be placed"},
    {"org.bedework.propname.admin.resources.dir", "org.bedework.webadmin.app.resources.dir"},

    {"org.bedework.label.admin.deploy.dir", "Deployment directory"},
    {"org.bedework.tooltip.admin.deploy.dir",
        "Deployment directory for Admin client"},
    {"org.bedework.help.admin.deploy.dir",
        "This defines a directory into which generated war or ear files will " +
        "be placed"},
    {"org.bedework.propname.admin.deploy.dir", "org.bedework.webadmin.app.deploy.dir"},

    {"org.bedework.label.admin.security.domain", "Security Domain for authentication"},
    {"org.bedework.tooltip.admin.security.domain",
        "Security Domain - must match domain configured in servlet container"},
    {"org.bedework.help.admin.security.domain",
        "Security domain is set in the web.xml file and should match one of " +
        "the domains configred into the servlet container"},
    {"org.bedework.propname.admin.security.domain", "org.bedework.webadmin.app.security.domain"},

    {"org.bedework.label.admin.security.prefix", "Security prefix"},
    {"org.bedework.tooltip.admin.security.prefix",
        "Security prefix is used to prefix role names etc"},
    {"org.bedework.help.admin.security.prefix",
        "Security prefix is used to prefix role names etc"},
    {"org.bedework.propname.admin.security.prefix", "org.bedework.webadmin.app.security.prefix"},

    {"org.bedework.label.admin.ssl", "Use SSL"},
    {"org.bedework.tooltip.admin.ssl", "Use SSL"},
    {"org.bedework.help.admin.ssl",
        "Use SSL for client sessions"},
    {"org.bedework.propname.admin.ssl", "org.bedework.webadmin.app.use.ssl"},

    {"org.bedework.propname.admin.transport.guarantee", "org.bedework.webadmin.app.transport.guarantee"},

    {"org.bedework.label.admin.description", "Descriptive Comment"},
    {"org.bedework.tooltip.admin.description", "Descriptive Comment"},
    {"org.bedework.help.admin.description",
        "Descriptive Comment for Admin client"},
    {"org.bedework.propname.admin.description", "org.bedework.webadmin.app.description"},

    {"org.bedework.label.admin.display.name", "Display Name"},
    {"org.bedework.tooltip.admin.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.help.admin.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.propname.admin.display.name", "org.bedework.webadmin.app.display.name"},

    {"org.bedework.label.admin.name", "Name for Admin client"},
    {"org.bedework.tooltip.admin.name", "Unique name for Admin client"},
    {"org.bedework.help.admin.name",
        "This should be unique at your site. It will appear in logs"},
    {"org.bedework.propname.admin.name", "org.bedework.webadmin.app.name"},

    {"org.bedework.label.admin.autocreatesponsors", "Automatically create sponsors"},
    {"org.bedework.tooltip.admin.autocreatesponsors", "Automatically create sponsors"},
    {"org.bedework.help.admin.autocreatesponsors",
        "Automatically create sponsors when no match is found?"},
    {"org.bedework.propname.admin.autocreatesponsors", "org.bedework.webadmin.app.autocreatesponsors"},

    {"org.bedework.label.admin.autodeletesponsors", "Automatically delete sponsors"},
    {"org.bedework.tooltip.admin.autodeletesponsors", "Automatically delete sponsors"},
    {"org.bedework.help.admin.autodeletesponsors",
        "Automatically delete sponsors when unused?"},
    {"org.bedework.propname.admin.autodeletesponsors", "org.bedework.webadmin.app.autodeletesponsors"},

    {"org.bedework.label.admin.autocreatelocations", "Automatically create locations"},
    {"org.bedework.tooltip.admin.autocreatelocations", "Automatically create locations"},
    {"org.bedework.help.admin.autocreatelocations",
        "Automatically create locations when no match is found?"},
    {"org.bedework.propname.admin.autocreatelocations", "org.bedework.webadmin.app.autocreatelocations"},

    {"org.bedework.label.admin.autodeletelocations", "Automatically delete locations"},
    {"org.bedework.tooltip.admin.autodeletelocations", "Automatically delete locations"},
    {"org.bedework.help.admin.autodeletelocations",
        "Automatically delete locations when unused?"},
    {"org.bedework.propname.admin.autodeletelocations", "org.bedework.webadmin.app.autodeletelocations"},

    {"org.bedework.label.admin.allowEditAllCategories", "Admins edit all categories"},
    {"org.bedework.tooltip.admin.allowEditAllCategories",
        "Allow administrators to edit categories they don't own"},
    {"org.bedework.help.admin.allowEditAllCategories",
        "Allow administrators to edit categories they don't own"},
    {"org.bedework.propname.admin.allowEditAllCategories",
        "org.bedework.webadmin.app.allowEditAllCategories"},

    {"org.bedework.label.admin.allowEditAllLocations", "Admins edit all locations"},
    {"org.bedework.tooltip.admin.allowEditAllLocations",
        "Allow administrators to edit locations they don't own"},
    {"org.bedework.help.admin.allowEditAllLocations",
        "Allow administrators to edit locations they don't own"},
    {"org.bedework.propname.admin.allowEditAllLocations",
        "org.bedework.webadmin.app.allowEditAllLocations"},

    {"org.bedework.label.admin.allowEditAllSponsors", "Admins edit all Sponsors"},
    {"org.bedework.tooltip.admin.allowEditAllSponsors",
        "Allow administrators to edit sponsors they don't own"},
    {"org.bedework.help.admin.allowEditAllSponsors",
        "Allow administrators to edit sponsors they don't own"},
    {"org.bedework.propname.admin.allowEditAllSponsors",
        "org.bedework.webadmin.app.allowEditAllSponsors"},

    {"org.bedework.label.admin.categoryOptional", "Categories are optional"},
    {"org.bedework.tooltip.admin.categoryOptional",
        "Allow categories to be optional for the administrative application"},
    {"org.bedework.help.admin.categoryOptional",
        "Allow categories to be optional for the administrative application"},
    {"org.bedework.propname.admin.categoryOptional",
        "org.bedework.webadmin.app.categoryOptional"},

    {"org.bedework.label.admin.hour24", "Use 24hour mode"},
    {"org.bedework.tooltip.admin.hour24", "Use 24hour mode"},
    {"org.bedework.help.admin.hour24",
        "Use 24hour mode"},
    {"org.bedework.propname.admin.hour24", "org.bedework.webadmin.app.hour24"},

    {"org.bedework.label.admin.minincrement", "Minutes increment"},
    {"org.bedework.tooltip.admin.minincrement", "Minutes increment"},
    {"org.bedework.help.admin.minincrement",
        "Minutes increment for Admin client"},
    {"org.bedework.propname.admin.minincrement", "org.bedework.webadmin.app.minincrement"},

    {"org.bedework.label.admin.admingroupsidprefix", "Id Prefix for Admin Groups"},
    {"org.bedework.tooltip.admin.admingroupsidprefix", "Id Prefix for Admin Groups"},
    {"org.bedework.help.admin.admingroupsidprefix",
        "Id Prefix for Admin Groups"},
    {"org.bedework.propname.admin.admingroupsidprefix", "org.bedework.webadmin.app.admingroupsidprefix"},

    {"org.bedework.label.admin.groupsclass", "Calendar Admin Groups Class"},
    {"org.bedework.tooltip.admin.groupsclass",
        "Define the class which determines the user groups"},
    {"org.bedework.help.admin.groupsclass",
        "Define the class which determines the user groups. " +
        "The default version uses the database tables. Versions could " +
        "be developed to use ldap for example"},
    {"org.bedework.propname.admin.groupsclass", "org.bedework.webadmin.groupsclass"},

    {"org.bedework.label.admin.portal.platform", "Portal platform"},
    {"org.bedework.tooltip.admin.portal.platform",
        "Portal platform - \"jetspeed2\" or \"none\""},
    {"org.bedework.help.admin.portal.platform",
        "Portal platform - \"jetspeed2\" or \"none\""},
    {"org.bedework.propname.admin.portal.platform", "org.bedework.webadmin.app.portal.platform"},

    {"org.bedework.label.admin.jetspeed2.roles", "Admin roles for jetspeed"},
    {"org.bedework.tooltip.admin.jetspeed2.roles", "Admin roles for jetspeed"},
    {"org.bedework.help.admin.jetspeed2.roles",
        "If we are building for jetspeed this property defines the roles which " +
        "will see the calendar admin tab. These roles may need to be defined " +
        "in jetspeed"},
    {"org.bedework.propname.admin.jetspeed2.roles", "org.bedework.webadmin.app.jetspeed2.roles"},

    /* ---------------------- Public Events properties ------------------------- */

    {"org.bedework.label.pubevents.standalone.app", "Build standalone app"},
    {"org.bedework.tooltip.pubevents.standalone.app", "Build standalone app"},
    {"org.bedework.help.pubevents.standalone.app",
        "Build standalone app"},
    {"org.bedework.propname.pubevents.standalone.app", "org.bedework.webpubevents.build.standalone.app"},

    {"org.bedework.label.pubevents.portlet", "Build portlet"},
    {"org.bedework.tooltip.pubevents.portlet", ""},
    {"org.bedework.help.pubevents.portlet",
        "Build portlet"},
    {"org.bedework.propname.pubevents.portlet", "org.bedework.webpubevents.build.portlet"},

    {"org.bedework.label.pubevents.war", "War Name"},
    {"org.bedework.tooltip.pubevents.war", "Name of the generated war file"},
    {"org.bedework.help.pubevents.war",
        "Name of the generated war file"},
    {"org.bedework.propname.pubevents.war", "org.bedework.webpubevents.war.name"},

    {"org.bedework.label.pubevents.j2ee.deploy", "Deploy on J2ee"},
    {"org.bedework.tooltip.pubevents.deploy", "Deploy Admin on J2ee"},
    {"org.bedework.help.pubevents.deploy",
        "Deploy Admin on J2ee as a ear file"},
    {"org.bedework.propname.pubevents.deploy", "org.bedework.webpubevents.deploy.j2ee"},

    {"org.bedework.label.pubevents.ear", "Ear Name"},
    {"org.bedework.tooltip.pubevents.ear", "Name of the generated ear file"},
    {"org.bedework.help.pubevents.ear",
        "Name of the generated ear file"},
    {"org.bedework.propname.pubevents.ear", "org.bedework.webpubevents.ear.name"},

    {"org.bedework.label.pubevents.context.root", "Context Root"},
    {"org.bedework.tooltip.pubevents.context.root", "Context Root"},
    {"org.bedework.help.pubevents.context.root",
        "Context Root for Public Events client: This will currently only have effect " +
        "in the j2ee environment where the context root  is defined in ear " +
        "file configuration files"},
    {"org.bedework.propname.pubevents.context.root", "org.bedework.webpubevents.app.context.root"},

    {"org.bedework.label.pubevents.app.root", "Application root"},
    {"org.bedework.tooltip.pubevents.app.root",
        "Where we keep the xsl stylesheets and resources"},
    {"org.bedework.help.pubevents.app.root",
        "Set pubevents.app.root to where we keep the xsl stylesheets and resources. " +
        "If this does not start with http: it will have the host and port " +
        "added as a prefix. This is mainly for development - generally this " +
        "should be a fully specified url pointing at the resource directory " +
        "usually in your sites web space."},
    {"org.bedework.propname.pubevents.app.root", "org.bedework.webpubevents.app.root"},

    {"org.bedework.label.pubevents.resources.dir", "Resources for stylesheets"},
    {"org.bedework.tooltip.pubevents.resources.dir",
        "Resources used by stylesheets for public client"},
    {"org.bedework.help.pubevents.resources.dir",
        "This defines a directory into which all the resources accessed via the " +
        "app root will be placed"},
    {"org.bedework.propname.pubevents.resources.dir", "org.bedework.webpubevents.app.resources.dir"},

    {"org.bedework.label.pubevents.deploy.dir", "Deployment directory"},
    {"org.bedework.tooltip.pubevents.deploy.dir",
        "Deployment directory for public client"},
    {"org.bedework.help.pubevents.deploy.dir",
        "This defines a directory into which generated war or ear files will " +
        "be placed"},
    {"org.bedework.propname.pubevents.deploy.dir", "org.bedework.webpubevents.app.deploy.dir"},

    /*
    {"org.bedework.label.pubevents.security.domain", "Security Domain for authentication"},
    {"org.bedework.tooltip.pubevents.security.domain",
        "Security Domain - must match domain configured in servlet container"},
    {"org.bedework.help.pubevents.security.domain",
        "Security domain is set in the web.xml file and should match one of " +
        "the domains configred into the servlet container"},
    {"org.bedework.propname.pubevents.security.domain", "org.bedework.webpubevents.app.security.domain"},

    {"org.bedework.label.pubevents.security.prefix", "Security prefix"},
    {"org.bedework.tooltip.pubevents.security.prefix",
        "Security prefix is used to prefix role names etc"},
    {"org.bedework.help.pubevents.security.prefix",
        "Security prefix is used to prefix role names etc"},
    {"org.bedework.propname.pubevents.security.prefix", "org.bedework.webpubevents.app.security.prefix"},

    {"org.bedework.label.pubevents.ssl", "Use SSL"},
    {"org.bedework.tooltip.pubevents.ssl", "Use SSL"},
    {"org.bedework.help.pubevents.ssl",
        "Use SSL for client sessions"},
    {"org.bedework.propname.pubevents.ssl", "org.bedework.webpubevents.app.use.ssl"},

    {"org.bedework.propname.pubevents.transport.guarantee", "org.bedework.webpubevents.app.transport.guarantee"},
    */

    {"org.bedework.label.pubevents.description", "Descriptive Comment"},
    {"org.bedework.tooltip.pubevents.description", "Descriptive Comment"},
    {"org.bedework.help.pubevents.description",
        "Descriptive Comment for Public Events client"},
    {"org.bedework.propname.pubevents.description", "org.bedework.webpubevents.app.description"},

    {"org.bedework.label.pubevents.display.name", "Display Name"},
    {"org.bedework.tooltip.pubevents.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.help.pubevents.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.propname.pubevents.display.name", "org.bedework.webpubevents.app.display.name"},

    {"org.bedework.label.pubevents.name", "Name for Public Events client"},
    {"org.bedework.tooltip.pubevents.name", "Unique name for Public Events client"},
    {"org.bedework.help.pubevents.name",
        "This should be unique at your site. It will appear in logs"},
    {"org.bedework.propname.pubevents.name", "org.bedework.webpubevents.app.name"},

    {"org.bedework.label.pubevents.hour24", "Use 24hour mode"},
    {"org.bedework.tooltip.pubevents.hour24", "Use 24hour mode"},
    {"org.bedework.help.pubevents.hour24",
        "Use 24hour mode"},
    {"org.bedework.propname.pubevents.hour24", "org.bedework.webpubevents.app.hour24"},

    {"org.bedework.label.pubevents.minincrement", "Minutes increment"},
    {"org.bedework.tooltip.pubevents.minincrement", "Minutes increment"},
    {"org.bedework.help.pubevents.minincrement",
        "Minutes increment for Admin client"},
    {"org.bedework.propname.pubevents.minincrement", "org.bedework.webpubevents.app.minincrement"},

    {"org.bedework.label.pubevents.skinset.name", "Default Skinset Name"},
    {"org.bedework.tooltip.pubevents.skinset.name", "Default Skinset Name"},
    {"org.bedework.help.pubevents.skinset.name",
        "This defines the name of the skin set from the quickstart build. " +
        "If you wish to create your own skin set, add a directory in " +
        "appsuite/uclient/resources/guest/web/ and set this property " +
        "equal to the directory name"},
    {"org.bedework.propname.pubevents.skinset.name", "org.bedework.webpubevents.app.skinset.name"},

    {"org.bedework.label.pubevents.showyeardata", "Allow display of entire years data"},
    {"org.bedework.tooltip.pubevents.showyeardata", "Allow display of entire years data"},
    {"org.bedework.help.pubevents.showyeardata",
        "Allow display of entire years data"},
    {"org.bedework.propname.pubevents.showyeardata", "org.bedework.webpubevents.app.showyeardata"},

    {"org.bedework.label.pubevents.default.view", "Default View (day, week, month)"},
    {"org.bedework.tooltip.pubevents.default.view", "Default View (day, week, month)"},
    {"org.bedework.help.pubevents.default.view",
        "Default View (day, week, month)"},
    {"org.bedework.propname.pubevents.default.view", "org.bedework.webpubevents.app.default.view"},

    {"org.bedework.label.pubevents.refresh.interval", "Refresh Time (milliseconds)"},
    {"org.bedework.tooltip.pubevents.refresh.interval", "Refresh Time (milliseconds)"},
    {"org.bedework.help.pubevents.refresh.interval",
        "Refresh Time (milliseconds)"},
    {"org.bedework.propname.pubevents.refresh.interval", "org.bedework.webpubevents.app.refresh.interval"},

    {"org.bedework.label.pubevents.refresh.action", "Refresh Action"},
    {"org.bedework.tooltip.pubevents.refresh.action", "Refresh Action"},
    {"org.bedework.help.pubevents.refresh.action",
        "Refresh Action"},
    {"org.bedework.propname.pubevents.refresh.action", "org.bedework.webpubevents.app.refresh.action"},

    {"org.bedework.label.pubevents.portal.platform", "Portal platform"},
    {"org.bedework.tooltip.pubevents.portal.platform",
        "Portal platform - \"jetspeed2\" or \"none\""},
    {"org.bedework.help.pubevents.portal.platform",
        "Portal platform - \"jetspeed2\" or \"none\""},
    {"org.bedework.propname.pubevents.portal.platform", "org.bedework.webpubevents.app.portal.platform"},

    {"org.bedework.label.pubevents.groupsclass", "Calendar User Groups Class"},
    {"org.bedework.tooltip.pubevents.groupsclass",
        "Define the class which determines the user groups"},
    {"org.bedework.help.pubevents.groupsclass",
        "Define the class which determines the user groups. " +
        "The default version uses the database tables. Versions could " +
        "be developed to use ldap for example"},
    {"org.bedework.propname.pubevents.groupsclass", "org.bedework.webpubevents.groupsclass"},

    /* ---------------------- Personal Events properties ------------------------- */

    {"org.bedework.label.personal.standalone.app", "Build standalone app"},
    {"org.bedework.tooltip.personal.standalone.app", "Build standalone app"},
    {"org.bedework.help.personal.standalone.app",
        "Build standalone app"},
    {"org.bedework.propname.personal.standalone.app", "org.bedework.webpersonal.build.standalone.app"},

    {"org.bedework.label.personal.portlet", "Build portlet"},
    {"org.bedework.tooltip.personal.portlet", ""},
    {"org.bedework.help.personal.portlet",
        "Build portlet"},
    {"org.bedework.propname.personal.portlet", "org.bedework.webpersonal.build.portlet"},

    {"org.bedework.label.personal.war", "War Name"},
    {"org.bedework.tooltip.personal.war", "Name of the generated war file"},
    {"org.bedework.help.personal.war",
        "Name of the generated war file"},
    {"org.bedework.propname.personal.war", "org.bedework.webpersonal.war.name"},

    {"org.bedework.label.personal.j2ee.deploy", "Deploy on J2ee"},
    {"org.bedework.tooltip.personal.deploy", "Deploy Admin on J2ee"},
    {"org.bedework.help.personal.deploy",
        "Deploy Admin on J2ee as a ear file"},
    {"org.bedework.propname.personal.deploy", "org.bedework.webpersonal.deploy.j2ee"},

    {"org.bedework.label.personal.ear", "Ear Name"},
    {"org.bedework.tooltip.personal.ear", "Name of the generated ear file"},
    {"org.bedework.help.personal.ear",
        "Name of the generated ear file"},
    {"org.bedework.propname.personal.ear", "org.bedework.webpersonal.ear.name"},

    {"org.bedework.label.personal.context.root", "Context Root"},
    {"org.bedework.tooltip.personal.context.root", "Context Root"},
    {"org.bedework.help.personal.context.root",
        "Context Root for Public Events client: This will currently only have effect " +
        "in the j2ee environment where the context root  is defined in ear " +
        "file configuration files"},
    {"org.bedework.propname.personal.context.root", "org.bedework.webpersonal.app.context.root"},

    {"org.bedework.label.personal.app.root", "Application root"},
    {"org.bedework.tooltip.personal.app.root",
        "Where we keep the xsl stylesheets and resources"},
    {"org.bedework.help.personal.app.root",
        "Set personal.app.root to where we keep the xsl stylesheets and resources. " +
        "If this does not start with http: it will have the host and port " +
        "added as a prefix. This is mainly for development - generally this " +
        "should be a fully specified url pointing at the resource directory " +
        "usually in your sites web space."},
    {"org.bedework.propname.personal.app.root", "org.bedework.webpersonal.app.root"},

    {"org.bedework.label.personal.resources.dir", "Resources for stylesheets"},
    {"org.bedework.tooltip.personal.resources.dir",
        "Resources used by stylesheets for personal client"},
    {"org.bedework.help.personal.resources.dir",
        "This defines a directory into which all the resources accessed via the " +
        "app root will be placed"},
    {"org.bedework.propname.personal.resources.dir", "org.bedework.webpersonal.app.resources.dir"},

    {"org.bedework.label.personal.deploy.dir", "Deployment directory"},
    {"org.bedework.tooltip.personal.deploy.dir",
        "Deployment directory for personal client"},
    {"org.bedework.help.personal.deploy.dir",
        "This defines a directory into which generated war or ear files will " +
        "be placed"},
    {"org.bedework.propname.personal.deploy.dir", "org.bedework.webpersonal.app.deploy.dir"},

    {"org.bedework.label.personal.security.domain", "Security Domain for authentication"},
    {"org.bedework.tooltip.personal.security.domain",
        "Security Domain - must match domain configured in servlet container"},
    {"org.bedework.help.personal.security.domain",
        "Security domain is set in the web.xml file and should match one of " +
        "the domains configred into the servlet container"},
    {"org.bedework.propname.personal.security.domain", "org.bedework.webpersonal.app.security.domain"},

    {"org.bedework.label.personal.security.prefix", "Security prefix"},
    {"org.bedework.tooltip.personal.security.prefix",
        "Security prefix is used to prefix role names etc"},
    {"org.bedework.help.personal.security.prefix",
        "Security prefix is used to prefix role names etc"},
    {"org.bedework.propname.personal.security.prefix", "org.bedework.webpersonal.app.security.prefix"},

    {"org.bedework.label.personal.ssl", "Use SSL"},
    {"org.bedework.tooltip.personal.ssl", "Use SSL"},
    {"org.bedework.help.personal.ssl",
        "Use SSL for client sessions"},
    {"org.bedework.propname.personal.ssl", "org.bedework.webpersonal.app.use.ssl"},

    {"org.bedework.propname.personal.transport.guarantee", "org.bedework.webpersonal.app.transport.guarantee"},

    {"org.bedework.label.personal.description", "Descriptive Comment"},
    {"org.bedework.tooltip.personal.description", "Descriptive Comment"},
    {"org.bedework.help.personal.description",
        "Descriptive Comment for Public Events client"},
    {"org.bedework.propname.personal.description", "org.bedework.webpersonal.app.description"},

    {"org.bedework.label.personal.display.name", "Display Name"},
    {"org.bedework.tooltip.personal.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.help.personal.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.propname.personal.display.name", "org.bedework.webpersonal.app.display.name"},

    {"org.bedework.label.personal.name", "Name for Public Events client"},
    {"org.bedework.tooltip.personal.name", "Unique name for Public Events client"},
    {"org.bedework.help.personal.name",
        "This should be unique at your site. It will appear in logs"},
    {"org.bedework.propname.personal.name", "org.bedework.webpersonal.app.name"},

    {"org.bedework.label.personal.hour24", "Use 24hour mode"},
    {"org.bedework.tooltip.personal.hour24", "Use 24hour mode"},
    {"org.bedework.help.personal.hour24",
        "Use 24hour mode"},
    {"org.bedework.propname.personal.hour24", "org.bedework.webpersonal.app.hour24"},

    {"org.bedework.label.personal.minincrement", "Minutes increment"},
    {"org.bedework.tooltip.personal.minincrement", "Minutes increment"},
    {"org.bedework.help.personal.minincrement",
        "Minutes increment for Admin client"},
    {"org.bedework.propname.personal.minincrement", "org.bedework.webpersonal.app.minincrement"},

    {"org.bedework.label.personal.skinset.name", "Default Skinset Name"},
    {"org.bedework.tooltip.personal.skinset.name", "Default Skinset Name"},
    {"org.bedework.help.personal.skinset.name",
        "This defines the name of the skin set from the quickstart build. " +
        "If you wish to create your own skin set, add a directory in " +
        "appsuite/uclient/resources/guest/web/ and set this property " +
        "equal to the directory name"},
    {"org.bedework.propname.personal.skinset.name", "org.bedework.webpersonal.app.skinset.name"},

    {"org.bedework.label.personal.showyeardata", "Allow display of entire years data"},
    {"org.bedework.tooltip.personal.showyeardata", "Allow display of entire years data"},
    {"org.bedework.help.personal.showyeardata",
        "Allow display of entire years data"},
    {"org.bedework.propname.personal.showyeardata", "org.bedework.webpersonal.app.showyeardata"},

    {"org.bedework.label.personal.default.view", "Default View (day, week, month)"},
    {"org.bedework.tooltip.personal.default.view", "Default View (day, week, month)"},
    {"org.bedework.help.personal.default.view",
        "Default View (day, week, month)"},
    {"org.bedework.propname.personal.default.view", "org.bedework.webpersonal.app.default.view"},

    {"org.bedework.label.personal.refresh.interval", "Refresh Time (milliseconds)"},
    {"org.bedework.tooltip.personal.refresh.interval", "Refresh Time (milliseconds)"},
    {"org.bedework.help.personal.refresh.interval",
        "Refresh Time (milliseconds)"},
    {"org.bedework.propname.personal.refresh.interval", "org.bedework.webpersonal.app.refresh.interval"},

    {"org.bedework.label.personal.refresh.action", "Refresh Action"},
    {"org.bedework.tooltip.personal.refresh.action", "Refresh Action"},
    {"org.bedework.help.personal.refresh.action",
        "Refresh Action"},
    {"org.bedework.propname.personal.refresh.action", "org.bedework.webpersonal.app.refresh.action"},

    {"org.bedework.label.personal.portal.platform", "Portal platform"},
    {"org.bedework.tooltip.personal.portal.platform",
        "Portal platform - \"jetspeed2\" or \"none\""},
    {"org.bedework.help.personal.portal.platform",
        "Portal platform - \"jetspeed2\" or \"none\""},
    {"org.bedework.propname.personal.portal.platform", "org.bedework.webpersonal.app.portal.platform"},

    {"org.bedework.label.personal.groupsclass", "Calendar User Groups Class"},
    {"org.bedework.tooltip.personal.groupsclass",
        "Define the class which determines the user groups"},
    {"org.bedework.help.personal.groupsclass",
        "Define the class which determines the user groups. " +
        "The default version uses the database tables. Versions could " +
        "be developed to use ldap for example"},
    {"org.bedework.propname.personal.groupsclass", "org.bedework.webpersonal.groupsclass"},

    /* ------------------ Public Caldav Server properties --------------- */

    {"org.bedework.label.caldav.public.war", "War Name"},
    {"org.bedework.tooltip.caldav.public.war", "Name of the generated war file"},
    {"org.bedework.help.caldav.public.war",
        "Name of the generated war file"},
    {"org.bedework.propname.caldav.public.war", "org.bedework.caldav.public.war.name"},

    {"org.bedework.label.caldav.public.j2ee.deploy", "Deploy on J2ee"},
    {"org.bedework.tooltip.caldav.public.deploy", "Deploy Admin on J2ee"},
    {"org.bedework.help.caldav.public.deploy",
        "Deploy Admin on J2ee as a ear file"},
    {"org.bedework.propname.caldav.public.deploy", "org.bedework.caldav.public.deploy.j2ee"},

    {"org.bedework.label.caldav.public.ear", "Ear Name"},
    {"org.bedework.tooltip.caldav.public.ear", "Name of the generated ear file"},
    {"org.bedework.help.caldav.public.ear",
        "Name of the generated ear file"},
    {"org.bedework.propname.caldav.public.ear", "org.bedework.caldav.public.ear.name"},

    {"org.bedework.label.caldav.public.context.root", "Context Root"},
    {"org.bedework.tooltip.caldav.public.context.root", "Context Root"},
    {"org.bedework.help.caldav.public.context.root",
        "Context Root for Public Caldav Server: This will currently only have effect " +
        "in the j2ee environment where the context root  is defined in ear " +
        "file configuration files"},
    {"org.bedework.propname.caldav.public.context.root", "org.bedework.caldav.public.context.root"},

    {"org.bedework.label.caldav.public.description", "Descriptive Comment"},
    {"org.bedework.tooltip.caldav.public.description", "Descriptive Comment"},
    {"org.bedework.help.caldav.public.description",
        "Descriptive Comment for Public Caldav Server"},
    {"org.bedework.propname.caldav.public.description", "org.bedework.caldav.public.description"},

    {"org.bedework.label.caldav.public.display.name", "Display Name"},
    {"org.bedework.tooltip.caldav.public.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.help.caldav.public.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.propname.caldav.public.display.name", "org.bedework.caldav.public.display.name"},

    {"org.bedework.label.caldav.public.name", "Name for Public Caldav server"},
    {"org.bedework.tooltip.caldav.public.name", "Unique name for Public Caldav server"},
    {"org.bedework.help.caldav.public.name",
        "This should be unique at your site. It will appear in logs"},
    {"org.bedework.propname.caldav.public.name", "org.bedework.caldav.public.name"},

    {"org.bedework.label.caldav.public.deploy.dir", "Deployment directory"},
    {"org.bedework.tooltip.caldav.public.deploy.dir",
        "Deployment directory for public events caldav server"},
    {"org.bedework.help.caldav.public.deploy.dir",
        "This defines a directory into which generated war or ear files will " +
        "be placed"},
    {"org.bedework.propname.caldav.public.deploy.dir", "org.bedework.caldav.public.deploy.dir"},

    {"org.bedework.label.caldav.public.groupsclass", "Calendar User Groups Class"},
    {"org.bedework.tooltip.caldav.public.groupsclass",
        "Define the class which determines the user groups"},
    {"org.bedework.help.caldav.public.groupsclass",
        "Define the class which determines the user groups. " +
        "The default version uses the database tables. Versions could " +
        "be developed to use ldap for example"},
    {"org.bedework.propname.caldav.public.groupsclass", "org.bedework.caldav.public.groupsclass"},

    /* ------------------ Personal Caldav Server properties --------------- */

    {"org.bedework.label.caldav.user.war", "War Name"},
    {"org.bedework.tooltip.caldav.user.war", "Name of the generated war file"},
    {"org.bedework.help.caldav.user.war",
        "Name of the generated war file"},
    {"org.bedework.propname.caldav.user.war", "org.bedework.caldav.user.war.name"},

    {"org.bedework.label.caldav.user.j2ee.deploy", "Deploy on J2ee"},
    {"org.bedework.tooltip.caldav.user.deploy", "Deploy Admin on J2ee"},
    {"org.bedework.help.caldav.user.deploy",
        "Deploy Admin on J2ee as a ear file"},
    {"org.bedework.propname.caldav.user.deploy", "org.bedework.caldav.user.deploy.j2ee"},

    {"org.bedework.label.caldav.user.ear", "Ear Name"},
    {"org.bedework.tooltip.caldav.user.ear", "Name of the generated ear file"},
    {"org.bedework.help.caldav.user.ear",
        "Name of the generated ear file"},
    {"org.bedework.propname.caldav.user.ear", "org.bedework.caldav.user.ear.name"},

    {"org.bedework.label.caldav.user.context.root", "Context Root"},
    {"org.bedework.tooltip.caldav.user.context.root", "Context Root"},
    {"org.bedework.help.caldav.user.context.root",
        "Context Root for Public Caldav Server: This will currently only have effect " +
        "in the j2ee environment where the context root  is defined in ear " +
        "file configuration files"},
    {"org.bedework.propname.caldav.user.context.root", "org.bedework.caldav.user.context.root"},

    {"org.bedework.label.caldav.user.security.domain", "Security Domain for authentication"},
    {"org.bedework.tooltip.caldav.user.security.domain",
        "Security Domain - must match domain configured in servlet container"},
    {"org.bedework.help.caldav.user.security.domain",
        "Security domain is set in the web.xml file and should match one of " +
        "the domains configred into the servlet container"},
    {"org.bedework.propname.caldav.user.security.domain", "org.bedework.caldav.user.security.domain"},

    {"org.bedework.label.caldav.user.security.prefix", "Security prefix"},
    {"org.bedework.tooltip.caldav.user.security.prefix",
        "Security prefix is used to prefix role names etc"},
    {"org.bedework.help.caldav.user.security.prefix",
        "Security prefix is used to prefix role names etc"},
    {"org.bedework.propname.caldav.user.security.prefix", "org.bedework.caldav.user.security.prefix"},

    {"org.bedework.label.caldav.user.ssl", "Use SSL"},
    {"org.bedework.tooltip.caldav.user.ssl", "Use SSL"},
    {"org.bedework.help.caldav.user.ssl",
        "Use SSL for client sessions"},
    {"org.bedework.propname.caldav.user.ssl", "org.bedework.caldav.user.use.ssl"},

    {"org.bedework.propname.caldav.user.transport.guarantee", "org.bedework.caldav.user.transport.guarantee"},

    {"org.bedework.label.caldav.user.description", "Descriptive Comment"},
    {"org.bedework.tooltip.caldav.user.description", "Descriptive Comment"},
    {"org.bedework.help.caldav.user.description",
        "Descriptive Comment for Public Caldav Server"},
    {"org.bedework.propname.caldav.user.description", "org.bedework.caldav.user.description"},

    {"org.bedework.label.caldav.user.display.name", "Display Name"},
    {"org.bedework.tooltip.caldav.user.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.help.caldav.user.display.name",
        "Display Name (used in configuration files)"},
    {"org.bedework.propname.caldav.user.display.name", "org.bedework.caldav.user.display.name"},

    {"org.bedework.label.caldav.user.name", "Name for Public Caldav server"},
    {"org.bedework.tooltip.caldav.user.name", "Unique name for Public Caldav server"},
    {"org.bedework.help.caldav.user.name",
        "This should be unique at your site. It will appear in logs"},
    {"org.bedework.propname.caldav.user.name", "org.bedework.caldav.user.name"},

    {"org.bedework.label.caldav.user.deploy.dir", "Deployment directory"},
    {"org.bedework.tooltip.caldav.user.deploy.dir",
        "Deployment directory for personal events caldav server"},
    {"org.bedework.help.caldav.user.deploy.dir",
        "This defines a directory into which generated war or ear files will " +
        "be placed"},
    {"org.bedework.propname.caldav.user.deploy.dir", "org.bedework.caldav.user.deploy.dir"},

    {"org.bedework.label.caldav.user.groupsclass", "Calendar User Groups Class"},
    {"org.bedework.tooltip.caldav.user.groupsclass",
        "Define the class which determines the user groups"},
    {"org.bedework.help.caldav.user.groupsclass",
        "Define the class which determines the user groups. " +
        "The default version uses the database tables. Versions could " +
        "be developed to use ldap for example"},
    {"org.bedework.propname.caldav.user.groupsclass", "org.bedework.caldav.user.groupsclass"},
  };

  public Object[][] getContents() {
      return contents;
  }
}


