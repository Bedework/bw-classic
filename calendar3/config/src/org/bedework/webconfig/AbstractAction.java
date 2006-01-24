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

package org.bedework.webconfig;

import org.bedework.calenv.CalEnv;
import org.bedework.webcommon.BwSession;
import org.bedework.webcommon.BwSessionImpl;
import org.bedework.webcommon.BwWebUtil;
import org.bedework.webconfig.collections.Caldavpersonal;
import org.bedework.webconfig.collections.Caldavpublic;
import org.bedework.webconfig.collections.ConfigCollection;
import org.bedework.webconfig.collections.Globals;
import org.bedework.webconfig.collections.Modules;
import org.bedework.webconfig.collections.Webadmin;
import org.bedework.webconfig.collections.Webconfig;
import org.bedework.webconfig.collections.Webpersonal;
import org.bedework.webconfig.collections.Webpublic;
import org.bedework.webconfig.props.BooleanProperty;
import org.bedework.webconfig.props.ConfigProperty;

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.jsp.JspUtil;
import edu.rpi.sss.util.jsp.UtilAbstractAction;
import edu.rpi.sss.util.jsp.UtilActionForm;

import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.util.MessageResources;

/** There are 3 opeations for this simple client <ul>
 * <li>load properties</li>
 * <li>refresh</li>
 * <li>save properties</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public abstract class AbstractAction extends UtilAbstractAction implements Defs {
  public String getId() {
    return getClass().getName();
  }

  public String performAction(HttpServletRequest request,
                              HttpServletResponse response,
                              UtilActionForm frm,
                              MessageResources messages) throws Throwable {
    String forward = "success";
    ActionForm form = (ActionForm)frm;

    setup(request, form, messages);

    try {
      forward = doAction(request, response, form);
    } catch (Throwable t) {
      form.getErr().emit("org.bedework.client.error.exc", t.getMessage());
      form.getErr().emit(t);
    }

    if (form.getPropertyCollections().size() == 0) {
      // Load the default properties
      Properties pr = Util.getPropertiesFromResource(defaultProperties);
      resetProperties(pr, form);
    }

    return forward;
  }

  /** This is the routine which does the work.
   *
   * @param request   Needed to locate session
   * @param response
   * @param form       Action form
   * @return String   forward name
   * @throws Throwable
   */
  public abstract String doAction(HttpServletRequest request,
                                  HttpServletResponse response,
                                  ActionForm form) throws Throwable;

  /** Set up for incoming request
   *
   * <p>We also carry out a number of web related operations.
   *
   * @param request       HttpServletRequest Needed to locate session
   * @param form          Action form
   * @param messages      MessageResources needed for the resources
   * @throws Throwable
   */
  public void setup(HttpServletRequest request,
                    ActionForm form,
                    MessageResources messages) throws Throwable {
    BwSession s = BwWebUtil.getState(request);

    if (s != null) {
    } else {
      CalEnv env = getEnv(form);
      String appName = env.getAppProperty("app.name");
      String appRoot = env.getAppProperty("app.root");

      s = new BwSessionImpl(form.getCurrentUser(), appRoot, appName,
                            form.getPresentationState(), messages,
                            form.getSchemeHostPort(), debug);

      BwWebUtil.setState(request, s);
    }
  }

  protected void resetProperties(Properties pr,
                                 ActionForm form) throws Throwable {
    form.setPropertyCollections(null); // reinit

    ConfigCollection modules = new Modules();
    form.addPropertyCollection(modules);
    form.addPropertyCollection(new Globals());
    form.addPropertyCollection(new Webconfig());
    form.addPropertyCollection(new Webadmin((BooleanProperty)modules.findProperty("adminwebclient")));
    form.addPropertyCollection(new Webpublic((BooleanProperty)modules.findProperty("publicwebclient")));
    form.addPropertyCollection(new Webpersonal((BooleanProperty)modules.findProperty("personalwebclient")));
    form.addPropertyCollection(new Caldavpublic((BooleanProperty)modules.findProperty("publiccaldav")));
    form.addPropertyCollection(new Caldavpersonal((BooleanProperty)modules.findProperty("personalcaldav")));

    if (pr != null) {
      Collection cs = form.getPropertyCollections();

      Iterator it = cs.iterator();

      while (it.hasNext()) {
        ConfigCollection c = (ConfigCollection)it.next();

        c.initialise(pr, form.getErr());
      }
    }
  }

  protected boolean saveProperties(Properties pr,
                                   ActionForm form) throws Throwable {
    Collection c = form.getPropertyCollections();

    Iterator it = c.iterator();
    boolean ok = true;

    while (it.hasNext()) {
      ConfigCollection coll = (ConfigCollection)it.next();

      if (!coll.save(pr, form.getErr())) {
        ok = false;
      }
    }

    return ok;
  }

  /** The incoming request has a lot of parameters of the form
   *  <br/>a.b=val<br/>
   *  a is the property collection name and b is the property suffix in
   *  that collection.
   *
   * @param request
   * @param form
   * @return String forward
   * @throws Throwable
   */
  protected String update(HttpServletRequest request,
                          ActionForm form) throws Throwable {
    /* use the following if checkboxes are employed */
    /*
    Collection colls = form.getPropertyCollections();

    Iterator it = colls.iterator();

    while (it.hasNext()) {
      ConfigCollection coll = (ConfigCollection)it.next();

      coll.resetFlagged();
    } */

    Enumeration names = request.getParameterNames();

    while (names.hasMoreElements()) {
      String name = (String)names.nextElement();

      int dpos = name.indexOf(".");

      if ((dpos > 0) && (dpos < name.length())) {
        String cname = name.substring(0, dpos);
        String pname = name.substring(dpos + 1);

        ConfigCollection c = form.findPropertyCollection(cname);

        if (c != null) {
          ConfigProperty p = c.findProperty(pname);

          if (p != null) {
            String val = Util.checkNull(request.getParameter(name));

            if (p.getType() == typeBoolean) {
              if (val == null) {
                val = "false";
              }
            }
            p.setValue(val);
            p.validate(form.getErr());
          }
        }
      }
    }

    return "success";
  }

  /** get an env object initialised appropriately for our usage.
   *
   * @param frm
   * @return CalEnv object - also implanted in form.
   * @throws Throwable
   */
  public CalEnv getEnv(ActionForm frm) throws Throwable {
    CalEnv env = frm.getEnv();
    if (env != null) {
      return env;
    }

    String envPrefix = JspUtil.getReqProperty(frm.getMres(),
                                              "org.bedework.envprefix");

    env = new CalEnv(envPrefix, debug);
    frm.assignEnv(env);
    return env;
  }

  /** Validate the current data.
   *
   * @param form
   * @throws Throwable
   */
  protected void validate(ActionForm form) throws Throwable {
    Collection c = form.getPropertyCollections();

    Iterator it = c.iterator();

    while (it.hasNext()) {
      ConfigCollection coll = (ConfigCollection)it.next();

      coll.validate(form.getErr());
    }
  }
}
