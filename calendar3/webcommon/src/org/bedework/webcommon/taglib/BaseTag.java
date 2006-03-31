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
package org.bedework.webcommon.taglib;

import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.struts.util.RequestUtils;

/** Base for simple Tags which provides some commonly used methods
 *
 * @author Mike Douglass
 */
public class BaseTag extends TagSupport {
  /** Return a value from the property of the named object in the given
   * (or null for default) scope.
   *
   * @param name      String object name
   * @param scope     String scope name or null for default
   * @param property  String property name or null for whole object
   * @param required  boolean true if we should throw an exception if not
   *                  found.
   * @return Object   null if none found.
   */
  protected Object getObject(String name, String scope,
                             String property, boolean required)
      throws JspTagException {
    try {
      Object o = RequestUtils.lookup(pageContext, name, property, scope);
      if (o == null) {
        if (required) {
          throw new JspTagException("Unable to find " + name +
                                    " in " + scope + " for property " +
                                    property);
        }

        return null;
      }

      return o;
    } catch (JspTagException jte) {
      throw jte;
    } catch (Throwable t) {
      throw new JspTagException(t.getMessage());
    }
  }

  /** Return an int value from the property of the named object in the given
   * (or null for default) scope.
   *
   * @param name      String object name
   * @param scope     String scope name or null for default
   * @param property  String property name or null for whole object
   * @param required  boolean true if we should throw an exception if not
   *                  found.
   * @return int      0 if none found.
   */
  protected int getInt(String name, String scope,
                       String property, boolean required)
      throws JspTagException {
    Object o = getObject(name, scope, property, required);

    if (!(o instanceof Integer)) {
      throw new JspTagException("Object " + name +
                                " in " + scope + " for property " +
                                property +
                                " is not an Integer");
    }

    return ((Integer)o).intValue();
  }

  /** Return the int scopeindex given a scope name
   *
   * @param scopeName   String - same as struts values
   * @return int        value defined in PageContext
   */
  protected int getScope(String scopeName) throws JspTagException {
    if (scopeName == null) {
      return PageContext.PAGE_SCOPE;
    }

    if (scopeName.equals("page")) {
      return PageContext.PAGE_SCOPE;
    }

    if (scopeName.equals("request")) {
      return PageContext.REQUEST_SCOPE;
    }

    if (scopeName.equals("session")) {
      return PageContext.SESSION_SCOPE;
    }

    if (scopeName.equals("application")) {
      return PageContext.APPLICATION_SCOPE;
    }

    throw new JspTagException("Invalid scope name " + scopeName);
  }
}