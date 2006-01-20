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
import org.bedework.webconfig.props.IntProperty;
import org.bedework.webconfig.props.ConfigProperty;

/** Web personal client properties.
 *
 * @author Mike Douglass
 */
public class Webpersonal extends ConfigCollection {
  /** Constructor
   *
   * @param onlyIf   BooleanProperty - display collection only if true
   * @throws Throwable
   */
  public Webpersonal(BooleanProperty onlyIf) throws Throwable {
    super("webpersonal", "webpersonal", onlyIf);

    addProperty(new ConfigProperty("defaultContentType", "app.default.contenttype", true));

    addProperty(new BooleanProperty("standalone.app", "build.standalone.app", true));

    BooleanProperty jetspeedportlet = new BooleanProperty("jetspeedPortlet", "build.jetspeed.portlet", true);
    addProperty(jetspeedportlet);

    BooleanProperty uportalportlet = new BooleanProperty("uportalPortlet", "build.uportal.portlet", true);
    addProperty(uportalportlet);

    addProperty(new ConfigProperty("war", "war.name", true));

    BooleanProperty j2ee = new BooleanProperty("j2ee.deploy", "deploy.j2ee", true);

    addProperty(j2ee);

    addProperty(new ConfigProperty("ear", "ear.name", true, j2ee));

    addProperty(new ConfigProperty("context.root", "context.root", true));

    addProperty(new ConfigProperty("app.root", "app.root", true));

    addProperty(new ConfigProperty("resources.dir", "app.resources.dir", true));

    addProperty(new ConfigProperty("deploy.dir", "deploy.dir", true));

    addProperty(new ConfigProperty("envprefix", "env.prefix", true));

    addProperty(new ConfigProperty("web.xml", "app.web.xml", true));

    addProperty(new ConfigProperty("security.domain", "app.security.domain", true));

    addProperty(new ConfigProperty("security.prefix", "app.security.prefix", true));

    addProperty(new ConfigProperty("transport.guarantee", "app.transport.guarantee", true));

    // We really want this to set the value of the above to NONE or CONFIDENTIAL
    //addProperty(new BooleanProperty("ssl", "use.ssl", true));

    addProperty(new ConfigProperty("description", "app.description", true));

    addProperty(new ConfigProperty("display.name", "app.display.name", true));

    addProperty(new ConfigProperty("name", "app.name", true));

    addProperty(new BooleanProperty("hour24", "app.hour24", true));

    addProperty(new IntProperty("minincrement", "app.minincrement", true));

    addProperty(new ConfigProperty("skinset.name", "app.skinset.name", true));

    addProperty(new BooleanProperty("showyeardata", "app.showyeardata", true));

    addProperty(new ConfigProperty("default.view", "app.default.view", true));

    addProperty(new IntProperty("refresh.interval", "app.refresh.interval", true));

    addProperty(new ConfigProperty("refresh.action", "app.refresh.action", true));
  }
}

