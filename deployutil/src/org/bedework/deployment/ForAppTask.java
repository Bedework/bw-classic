/* **********************************************************************
    Copyright 2010 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.PropertyHelper;
import org.apache.tools.ant.taskdefs.Sequential;

/** Ant task to build a named application
 *
 * <p>Task attributes are <ul>
 * <li>name             The application names</li>
 * <li>prefix           Property name prefix for generated properties</li>
 * <li>appPrefix        Property name prefix for applications</li>
 * <li>projectPrefix    Property name prefix for project properties</li>
 * </ul>
 *
 * <p>Prefixes will be automatically appended with "." if needed.
 *
 * <p>Generated properties are all prefixed by the prefix attribute and are:<ul>
 * <li>name             name of the application</li>
 * <li>projectName      Name of the project - from the "X.project" property</li>
 * <li>project.path     Path to project - value of the property projectPrefix + projectName</li>
 * <li>app.sou          Path to source for application - from the "X.sou.dir" property</li>
 * </ul>
 *
 * <p>
 *   if appPrefix="org.bedework.app" and project name is myproject we expect a
 *   bunch of properties of the form "org.bedework.app.myapp.xxx".
 * </p>
 *
 * <p>
 *   If projectPrefix="org.bedework.project" and org.bedework.app.myapp.project=myproject
 *   we expect a property with the name "org.bedework.project.myproject" which
 *   provides the location of the project. This allows us to locate internal
 *   project resources.
 * </p>
 *
 * <p>Body is ant
 *
 * @author douglm @ rpi.edu
 */
public class ForAppTask extends Sequential {
  private static final String bedeworkHomeProperty = "org.bedework.project.bedework";

  private String name;

  private String prefix;

  private String appPrefix;

  private String projectPrefix;

  /** Set the names
   *
   * @param val   String
   */
  public void setName(final String val) {
    name = val;
  }

  /** Set the generated property prefix
   *
   * @param val   String
   */
  public void setPrefix(final String val) {
    prefix = val;
  }

  /** Set the applications property prefix
   *
   * @param val   String
   */
  public void setAppPrefix(final String val) {
    appPrefix = val;
  }

  /** Set the project locations property prefix
   *
   * @param val   String
   */
  public void setProjectPrefix(final String val) {
    projectPrefix = val;
  }

  /** Execute the task
   */
  @Override
  public void execute() throws BuildException {
    try {
      if (name == null) {
        throw new BuildException("Must supply application name.");
      }

      doProps(name);
    } catch (BuildException be) {
      throw be;
    } catch (Throwable t) {
      t.printStackTrace();
      throw new BuildException(t);
    }
  }

  protected void doProps(final String name) throws BuildException {
    try {
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

      String bedeworkHome = (String)props.getProperty(null, bedeworkHomeProperty);

      if (bedeworkHome == null) {
        throw new BuildException("Must supply property " + bedeworkHomeProperty);
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

      String appSouProperty = appPrefix + name + ".sou.dir";
      String appSou = (String)props.getProperty(null, appSouProperty);

      if (appSou == null) {
        throw new BuildException("Property " + appSouProperty +
        " is undefined");
      }

      if (appSou.length() == 0) {
        appSou = projectPath;
      } else {
        appSou = projectPath + "/" + appSou;
      }

      props.setProperty(null, prefix + "name", name, false);
      props.setProperty(null, prefix + "projectName", project, false);
      props.setProperty(null, prefix + "project.path", projectPath, false);
      props.setProperty(null, prefix + "app.sou", appSou, false);

      super.execute();
    } catch (BuildException be) {
      throw be;
    } catch (Throwable t) {
      t.printStackTrace();
      throw new BuildException(t);
    }
  }
}
