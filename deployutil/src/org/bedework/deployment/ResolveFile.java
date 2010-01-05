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
import org.apache.tools.ant.Task;
import org.apache.tools.ant.util.FileUtils;

import java.io.File;

/** Ant task to resolve a file name. This is just a wrapper to the ant FileUtils
 * which calls resolveFile. Surely this can be done another way?
 *
 * <p>Task attributes are <ul>
 * <li>base             base to resolve against - must be an absolute path</li>
 * <li>file             Filename which may or may not be absolute</li>
 * <li>name             Name of new property</li>
 * </ul>
 *
 * @author douglm @ rpi.edu
 */
public class ResolveFile extends Task {
  protected String name;
  protected File base;
  protected File file;

  /**
   * helper for path -> URI and URI -> path conversions.
   */
  private static FileUtils fu = FileUtils.getFileUtils();

  /**
   * The name of the property to set.
   * @param name property name
   */
  public void setName(final String name) {
      this.name = name;
  }

  /**
   * @return String
   */
  public String getName() {
      return name;
  }

  /**
   * Base to resolve against.
   *
   * @param val filename
   */
  public void setBase(final File val) {
      base = val;
  }

  /**
   * @return File
   */
  public File getBase() {
      return base;
  }

  /**
   * Filename of file to resolve
   * @param val filename
   *
   * @ant.attribute group="noname"
   */
  public void setFile(final String val) {
      file = new File(val);
  }

  /** Execute the task
   */
  @Override
  public void execute() throws BuildException {
    try {
      if (getProject() == null) {
        throw new IllegalStateException("project has not been set");
      }

      if (name == null) {
        throw new BuildException("You must specify the name attribute");
      }

      if (base == null) {
        throw new BuildException("You must specify the base attribute");
      }

      if (!base.isAbsolute()) {
        throw new BuildException("The base attribute value must be an absolute path.");
      }

      if (file == null) {
        throw new BuildException("You must specify the file attribute");
      }

      if (!file.isAbsolute()) {
        file = fu.resolveFile(base, file.getPath());
      }

      PropertyHelper props = PropertyHelper.getPropertyHelper(getProject());

      props.setProperty(null, name, file.getAbsolutePath(), false);
    } catch (BuildException be) {
      throw be;
    } catch (Throwable t) {
      t.printStackTrace();
      throw new BuildException(t);
    }
  }
}
