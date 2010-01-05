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
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.Writer;
import java.util.Enumeration;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.TreeSet;

/** Ant task to build the xsl parameters used by the stylesheets for language
 * specific replacement of strings. We assume the directory contains a number of
 * resource bundle property files.
 *
 * <p>Task attributes are <ul>
 * <li>dir              Directory path to the language property files</li>
 * <li>prefix           Filename prefix</li>
 * <li>resdir           Directory where we copy the resource files</li>
 * <li>xsldir           Directory where we generate the xsl</li>
 * <li>name             Name of new property to hold list of available locales</li>
 * <li>defaultLocale    Default locale for this build</li>
 * <li>check            Optional true/false to check resources for missing properties</li>
 * </ul>
 *
 * @author douglm @ rpi.edu
 */
public class MakeLangXsl extends Task {
  protected File dir;
  protected File resdir;
  protected File xsldir;
  protected String prefix;
  protected String name;

  protected boolean check;

  private String adjustedPrefix;

  private final String suffix = ".properties";

  private Writer wtr;

  /** Set the directory containing property files
   *
   * @param val   File
   */
  public void setDir(final File val) {
    dir = val;
  }

  /** Set the directory for the resource files
   *
   * @param val   File
   */
  public void setResdir(final File val) {
    resdir = val;
  }

  /** Set the directory for the generated xsl
   *
   * @param val   File
   */
  public void setXsldir(final File val) {
    xsldir = val;
  }

  /** Set the prefix for file names
   *
   * @param val   String
   */
  public void setPrefix(final String val) {
    prefix = val;
    adjustedPrefix = prefix + "_";
  }

  /**
   * The name of the property to set.
   * @param val property name
   */
  public void setName(final String val) {
      name = val;
  }

  /**
   * @return String
   */
  public String getName() {
      return name;
  }

  /**
   * @param val   true for checking
   */
  public void setCheck(final boolean val) {
      check = val;
  }

  /** Execute the task
   */
  @Override
  public void execute() throws BuildException {
    try {
      if (getProject() == null) {
        throw new IllegalStateException("project has not been set");
      }

      if (dir == null) {
        throw new BuildException("You must specify the dir attribute");
      }

      if (!dir.isAbsolute()) {
        throw new BuildException("The dir attribute value must be an absolute path.");
      }

      if (resdir == null) {
        throw new BuildException("You must specify the resdir attribute");
      }

      if (!resdir.isAbsolute()) {
        throw new BuildException("The resdir attribute value must be an absolute path.");
      }

      if (xsldir == null) {
        throw new BuildException("You must specify the xsldir attribute");
      }

      if (!xsldir.isAbsolute()) {
        throw new BuildException("The xsldir attribute value must be an absolute path.");
      }

      if (prefix == null) {
        throw new BuildException("You must specify the prefix attribute");
      }

      if (name == null) {
        throw new BuildException("You must specify the name attribute");
      }

      PropertyHelper props = PropertyHelper.getPropertyHelper(getProject());

      List<String> propFileNames = getPropertyFileNames();

      List<String> locales = new LinkedList<String>();

      for (String fname: propFileNames) {
        locales.add(makeLocale(fname));
      }

      props.setProperty(null, name, locales.toString(), false);
    } catch (BuildException be) {
      throw be;
    } catch (Throwable t) {
      t.printStackTrace();
      throw new BuildException(t);
    }
  }

  private List<String> getPropertyFileNames() throws BuildException {
    List<String> fnames = new LinkedList<String>();

    FilenameFilter fltr = new FilenameFilter() {
      public boolean accept(final File dir, final String name) {
        return name.startsWith(adjustedPrefix) &&
               name.endsWith(suffix);
      }
    };

    String[] names = dir.list(fltr);
    if (names == null) {
      throw new BuildException("No property files located on path " + dir);
    }

    for (String name: names) {
      fnames.add(name);

      makeXsl(name);
    }

    if (check && (fnames.size() > 1)) {
      checkResources(fnames);
    }

    return fnames;
  }

  private void makeXsl(final String fname) throws BuildException {
    try {
      String locale = makeLocale(fname);

      File outFile = new File(xsldir + "/" +
                              "lang" + locale + ".xsl");
      FileUtils.getFileUtils().createNewFile(outFile, true);

      wtr = new FileWriter(outFile);

      /* Header */

      xslLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
      xslLine("<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">");

      /* Body */

      Properties props = getProps(fname);
      for(Enumeration allKeys = props.keys(); allKeys.hasMoreElements(); ) {
        xslLine(formatLine((String)allKeys.nextElement()));
      }

      /* footer */
      xslLine("</xsl:stylesheet>");

      wtr.close();
    } catch (Throwable t) {
      throw new BuildException(t);
    }
  }

  private String formatLine(final String key) {
    return String.format("  <xsl:param name=\"%s\" />", key);
  }

  private void xslLine(final String ln) throws Throwable {
    wtr.write(ln);
    wtr.write("\n");
  }

  private String makeLocale(final String fname) {
    String s = fname.substring(adjustedPrefix.length());

    return s.substring(0, s.length() - suffix.length());
  }

  /** Used when mapping appearance of a property name in the resource files.
   *
   */
  private static class FnameMapEntry {
    String pname;
    int ct; // Number of files with property
    boolean[] flags;

    int first(final boolean val) {
      for (int i = 0; i < flags.length; i++) {
        if (flags[i] == val) {
          return i;
        }
      }

      return -1;
    }
  }

  private Properties getProps(final String fname) throws BuildException {
    try {
      FileInputStream propFile = new FileInputStream(dir.getAbsolutePath() +
                                                     "/" + fname);
      Properties props = new Properties();
      props.load(propFile);

      return props;
    } catch (Throwable t) {
      throw new BuildException(t);
    }
  }

  private void checkResources(final List<String> fnames) throws BuildException {
    List<TreeSet<String>> propNamesList = new LinkedList<TreeSet<String>>();
    int fnamesSz = fnames.size();

    /* For each property file create a list of names */
    try {
      for (String fname: fnames) {
        propNamesList.add(new TreeSet(getProps(fname).keySet()));
      }

      boolean eq = true;
      TreeSet<String> ts0 = propNamesList.get(0);

      /* See if the are all equal */
      for (int i = 1; i < fnamesSz; i++) {
        if (!ts0.equals(propNamesList.get(i))) {
          eq = false;
          break;
        }
      }

      if (eq) {
        return;
      }

      /* remove all the common elements */

      TreeSet<String> rep = new TreeSet<String>();

      for (String name: propNamesList.get(0)) {
        if (inAllOthers(0, name, propNamesList)) {
          continue;
        }

        rep.add(name);
      }

      /* put back what's left */
      propNamesList.set(0, rep);

      /* Now iterate over each flagging those which don't appear in all */

      SortedMap<String, FnameMapEntry> nameMap =
        new TreeMap<String, FnameMapEntry>();

      for (int i = 0; i < fnamesSz; i++) {
        mapPropNames(i, fnames, propNamesList.get(i), nameMap);
      }

      for (FnameMapEntry fme: nameMap.values()) {
        if (fme.ct == 1) {
          log("Resource property " + fme.pname +
              " only appears in " + fnames.get(fme.first(true)));
        } else if (fme.ct == fnamesSz - 1) {
          log("Resource property " + fme.pname +
              " appears in all except " + fnames.get(fme.first(false)));
        } else {
          log("Resource property " + fme.pname +
              " does not appear in all resource files");
        }
      }
    } catch (Throwable t) {
      throw new BuildException(t);
    }
  }

  private void mapPropNames(final int i,
                            final List<String> fnames,
                            final TreeSet<String> propNames,
                            final SortedMap<String, FnameMapEntry> nameMap) throws BuildException {
    for (String name: propNames) {
      FnameMapEntry fme = nameMap.get(name);
      if (fme == null) {
        fme = new FnameMapEntry();
        fme.pname = name;
        fme.flags = new boolean[fnames.size()];
        nameMap.put(name, fme);
      }

      fme.flags[i] = true;
      fme.ct++;
    }
  }

  private boolean inAllOthers(final int i, final String name,
                              final List<TreeSet<String>> propNamesList) {
    for (int j = 0; j < propNamesList.size(); j++) {
      if (j == i) {
        continue;
      }

      if (!propNamesList.get(j).contains(name)) {
        return false;
      }
    }

    /* Remove it */

    for (int j = 0; j < propNamesList.size(); j++) {
      if (j == i) {
        continue;
      }

      propNamesList.get(j).remove(name);
    }

    return true;
  }
}
