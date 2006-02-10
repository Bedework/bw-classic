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

import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

/** A filter that selects events which have the single entity or own an entity
 * in the supplied set of entities.
 *
 * @author Mike Douglass
 * @version 1.0
 */
public class BwEntityFilter extends BwFilter {
  protected Collection entities;

  /** True if this is a single entity. Allows query generators to distinguish
   * between "=" and "IN"
   *
   * @return boolean  true for a single entity
   */
  public boolean getSingle() {
    return getEntities().size() == 1;
  }

  /** Set the only entity
   *
   *  @param val     Entity to filter on
   */
  void setEntity(Object val) {
    getEntities().add(val);
  }

  /** Get the entity we're filtering on
   *
   *  @return Object     entity we're filtering on
   */
  Object getEntity() {
    if (!getSingle()) {
      throw new RuntimeException("Not single valued");
    }

    return iterateEntities().next();
  }

  /** Set the entities we're filtering on
   *
   *  @param val     Collection of entities
   */
  public void setEntities(Collection val) {
    entities = val;
  }

  /** Get the entities we're filtering on
   *
   *  @return Collection of entities - never null
   */
  public Collection getEntities() {
    if (entities == null) {
      entities = new TreeSet();
    }

    return entities;
  }

  /** Iterate over the entities we're filtering on
   *
   *  @return Iterator over entities
   */
  public Iterator iterateEntities() {
    if (getSingle() && (getEntities().size() > 1)) {
      throw new RuntimeException("Single valued with multiple values");
    }
    return getEntities().iterator();
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwEntityFilter{id=");
    sb.append(id);
    sb.append(", name=");
    sb.append(getName());
    sb.append("}");

    return sb.toString();
  }
}
