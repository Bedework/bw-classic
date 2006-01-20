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
package org.bedework.calfacade.filter;

import org.bedework.calfacade.BwUser;

/** A filter that selects all events created by a particular user
 *
 * @author Greg Barnes
 * @author Mike Douglass
 * @version 2.0
 */
public class BwCreatorFilter extends BwEntityFilter {
  /** Set the creator to filter on
   *
   *  @param val     BwUser creator to filter on
   */
  public void setCreator(BwUser val) {
    setEntity(val);
  }

  /** Get the creator we're filtering on
   *  @return BwUser     creator we're filtering on
   */
  public BwUser getCreator() {
    return (BwUser)getEntity();
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwCreatorFilter{id=");
    sb.append(id);
    sb.append(", name=");
    sb.append(getName());
    sb.append(", creator=");
    sb.append(getCreator());
    sb.append(", single=");
    sb.append(getSingle());
    sb.append("}");

    return sb.toString();
  }
}
