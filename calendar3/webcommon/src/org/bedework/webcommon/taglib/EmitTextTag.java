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

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.JspTagException;

import org.apache.struts.taglib.TagUtils;

/** A simple Tag to emit a tagged text object. This tag has the
 * attributes, <ul>
 * <li><b>name<b> (Required) defines the name of object embedded somewhere
 *               in the page context containing the path object.</li>
 * <li><b>tagName<b> (Optional)defines the name of the tag. </li>
 * <li><b>indent<b> (Optional) string indent value</li>
 * </ul>
 *
 * We retrieve the value and emit xml.
 *
 * @author Mike Douglass
 */
public class EmitTextTag extends NameScopePropertyTag {
  /** Optional attribute: name of outer tag */
  private String tagName;

  /** Optional attribute: for those who like tidy xml
   * If specified we add teh value after a new line. */
  private String indent = null;

  private boolean filter = true;

  /**
   * Constructor
   */
  public EmitTextTag() {
  }

  /** Called at end of Tag
   *
   * @return int      either EVAL_PAGE or SKIP_PAGE
   */
  public int doEndTag() throws JspTagException {
    try {
      /* Try to retrieve the value */
      String val = getString(false);

      JspWriter out = pageContext.getOut();

      if (tagName == null) {
        tagName = property;
      }

      // Assume we're indented for the first tag
      out.print('<');
      out.print(tagName);

      if (indent != null) {
        out.println('>');
        if (val != null) {
          out.print(indent);
          out.print("  ");
          out.println(formatted(val));
        }
        out.print(indent);
        out.println("</");
      } else {
        out.print('>');
        if (val != null) {
          out.print(formatted(val));
        }
        out.print("</");
      }

      out.print(tagName);
      out.println('>');
    } catch(Throwable t) {
      throw new JspTagException("Error: " + t.getMessage());
    } finally {
      tagName = null; // reset for next time.
      filter = true; // reset for next time.
    }

    return EVAL_PAGE;
  }

  /**
   * @param val String name
   */
  public void setTagName(String val) {
    tagName = val;
  }

  /**
   * @return String name
   */
  public String getTagName() {
    return tagName;
  }

  /**
   * @param val String indent
   */
  public void setIndent(String val) {
    indent = val;
  }

  /**
   * @return  String indent
   */
  public String getIndent() {
    return indent;
  }

  /** Should we filter output for html?
   *
   * @param val boolean
   */
  public void setFilter(boolean val) {
    filter = val;
  }

  /** Should we filter output for html?
   *
   * @return boolean
   */
  public boolean getFilter() {
    return filter;
  }

  private String formatted(String val) {
    if (filter) {
      return TagUtils.getInstance().filter(val);
    }

    return val;
  }
}
