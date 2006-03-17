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

/** Ant task to build the applications based on two lists given as attributes.
 *
 * <p>Task attributes are <ul>
 * <li>names     Comma separated list of application names</li>
 * <li>types     Comma separated list of application types, e.g. webadmin</li>
 * <li>prefix    Property name prefix for generated proerties</li>
 * </ul>
 *
 * <p>Body is ant
 *
 * @author douglm @ rpi.edu
 */
public class ForEachAppTask extends Sequential {
  private String names;

  private String types;

  private String prefix;

  /** Set the names
   *
   * @param val   String
   */
  public void setNames(String val) {
    names = val;
  }

  /** Set the types
   *
   * @param val   File
   */
  public void setTypes(String val) {
    types = val;
  }

  /** Set the proeprty prefix
   *
   * @param val   String
   */
  public void setPrefix(String val) {
    prefix = val;
  }

  /** Execute the task
   */
  public void execute() throws BuildException {
    List nameList = getList(names);
    List typeList = getList(types);

    if ((nameList.size() == 0) || (typeList.size() == 0)) {
      throw new BuildException("Must supply names and types.");
    }

    if (nameList.size() != typeList.size()) {
      throw new BuildException("names and types must have same number of entries.");
    }

    if (prefix == null) {
      throw new BuildException("Must supply property name prefix.");
    }

    if (!prefix.endsWith(".")) {
      prefix += ".";
    }

    PropertyHelper props = PropertyHelper.getPropertyHelper(getProject());

    Iterator nit = nameList.iterator();
    Iterator kit = typeList.iterator();

    while (nit.hasNext()) {
      String name = (String)nit.next();
      String type = (String)kit.next();

      props.setProperty(null, prefix + "name", name, false);
      props.setProperty(null, prefix + "type", type, false);

      super.execute();
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
