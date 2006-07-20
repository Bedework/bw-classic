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
package org.bedework.deployment;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.StringTokenizer;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.PropertyHelper;
import org.apache.tools.ant.taskdefs.Sequential;

/** Ant task to build the applications based on a list of names
 *
 * <p>Task attributes are <ul>
 * <li>names            Comma separated list of application names</li>
 * <li>prefix           Property name prefix for generated properties</li>
 * <li>appPrefix        Property name prefix for applications</li>
 * <li>projectPrefix    Property name prefix for project locations</li>
 * </ul>
 *
 * <p>Prefixes will be automatically appended with "." if needed.
 *
 * <p>Generated properties are all prefixed by the prefix attribute and are:<ul>
 * <li>project.base     Path to project</li>
 * <li>type             type of application</li>
 * <li>type.dir         location of application type deployment directory</li>
 * <li>name             name of the application</li>
 * </ul>
 *
 * <p>Body is ant
 *
 * @author douglm @ rpi.edu
 */
public class ForEachAppTask extends Sequential {
  private String names;

  private String prefix;

  private String appPrefix;

  private String projectPrefix;

  /** Set the names
   *
   * @param val   String
   */
  public void setNames(String val) {
    names = val;
  }

  /** Set the generated property prefix
   *
   * @param val   String
   */
  public void setPrefix(String val) {
    prefix = val;
  }

  /** Set the applications property prefix
   *
   * @param val   String
   */
  public void setAppPrefix(String val) {
    appPrefix = val;
  }

  /** Set the project locations property prefix
   *
   * @param val   String
   */
  public void setProjectPrefix(String val) {
    projectPrefix = val;
  }

  /** Execute the task
   */
  public void execute() throws BuildException {
    try {
      List nameList = getList(names);

      if (nameList.size() == 0) {
        throw new BuildException("Must supply deployment names.");
      }

      if (prefix == null) {
        throw new BuildException("Must supply property name prefix.");
      }

      if (!prefix.endsWith(".")) {
        prefix += ".";
      }

      if (!appPrefix.endsWith(".")) {
        appPrefix += ".";
      }

      if (!projectPrefix.endsWith(".")) {
        projectPrefix += ".";
      }

      PropertyHelper props = PropertyHelper.getPropertyHelper(getProject());

      Iterator nit = nameList.iterator();

      while (nit.hasNext()) {
        String name = (String)nit.next();

        String appTypeProperty = appPrefix + name + ".type";
        String type = (String)props.getProperty(null, appTypeProperty);

        if (type == null) {
          throw new BuildException("Must supply property " + appTypeProperty);
        }

        String appProjectProperty = appPrefix + name + ".project";
        String project = (String)props.getProperty(null, appProjectProperty);

        if (project == null) {
          throw new BuildException("Property " + appProjectProperty +
                                   " is undefined");
        }

        /* Build full project property from project name and get value */

        String projectProperty = projectPrefix + project;
        String projectPath = (String)props.getProperty(null, projectProperty);

        if (projectPath == null) {
          throw new BuildException("Property " + projectProperty +
                                   " is undefined");
        }

        props.setProperty(null, prefix + "name", name, false);
        props.setProperty(null, prefix + "projectName", project, false);
        props.setProperty(null, prefix + "project", projectPath, false);
        props.setProperty(null, prefix + "type", type, false);
        props.setProperty(null, prefix + "type.dir",
                          projectPath + "/deployment/" + type,
                          false);

        super.execute();
      }
    } catch (BuildException be) {
      throw be;
    } catch (Throwable t) {
      t.printStackTrace();
      throw new BuildException(t);
    }
  }

  /* Turn a comma separated list into a List
   */
  private List getList(String val) throws BuildException {
    List l = new LinkedList();

    if ((val == null) || (val.length() == 0)) {
      return l;
    }

    StringTokenizer st = new StringTokenizer(val, ",", true);
    while (st.hasMoreTokens()) {
      String token = st.nextToken().trim();

      // No empty strings

      if (token.equals("") || token.equals(",")) {
        throw new BuildException("List has an empty element.");
      }

      l.add(token);

      // List must not end with ,
      if (st.hasMoreTokens()) {
        token = st.nextToken();
        if (!st.hasMoreTokens() || !token.equals(",")) {
          throw new BuildException("List ends with ','");
        }
      }
    }

    return l;
  }
}
