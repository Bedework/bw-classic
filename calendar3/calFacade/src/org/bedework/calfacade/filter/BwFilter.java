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
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calfacade.CalFacadeUtil;

import java.io.Serializable;
import java.util.Collection;
import java.util.Comparator;
import java.util.TreeSet;

/**
 * A filter selects events (and possibly other entities) that fulfill
 * certain criteria.  For example, "All events that have the category
 * 'Lecture'".
 *
 * <p>All filters must be expressibel as a db search expresssion. Entity
 * filters select events that own a given entity or own an entity within a
 * set. This translates to <br/>
 *    event.location = given-location or <br/>
 *    event.location in given-location-set <br/>
 *
 * <p>The test may be negated to give != and not in.
 *
 * <p>Some filters can have any number of children such as an OrFilter.
 *
 * @author Greg Barnes
 * @author Mike Douglass
 * @version 1.1
 */
public class BwFilter implements Comparable, Comparator, Serializable {
  protected int id = CalFacadeDefs.unsavedItemKey;

  /** The internal name of the filter
   */
  protected String name;

  /** Some sort of description - may be null
   */
  protected String description;

  /** not equals or not in
   */
  protected boolean not;

  protected BwUser owner;

  protected boolean publick;

  protected BwFilter parent;

  /** The children of the filter */
  protected Collection children;

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

  /**
   * @param val
   */
  public void setId(int val) {
    id = val;
  }

  /**
   * @return int db id
   */
  public int getId() {
    return id;
  }

  /** Set the name
   *
   * @param val    String name
   */
  public void setName(String val) {
    name = val;
  }

  /** Get the name
   *
   * @return String   name
   */
  public String getName() {
    return name;
  }

  /** Set the description
   *
   * @param val    description
   */
  public void setDescription(String val) {
    description = val;
  }

  /** Get the description
   *
   *  @return String   description
   */
  public String getDescription() {
    return description;
  }

  /** Set the not
   *
   * @param val    boolean not
   */
  public void setNot(boolean val) {
    not = val;
  }

  /** Get the not
   *
   * @return boolean   not
   */
  public boolean getNot() {
    return not;
  }

  /** Set the owner
   *
   * @param val      UserVO owner of the calendar
   */
  public void setOwner(BwUser val) {
    owner = val;
  }

  /** Return the owner of the calendar
   *
   * @return UserVO       Calendar owner
   */
  public BwUser getOwner() {
    return owner;
  }

  /** Set the public flag
   *
   *  @param val    true if the calendar is public
   */
  public void setPublick(boolean val) {
    publick = val;
  }

  /** Is the calendar public?
   *
   *  @return boolean    true if the calendar is public
   */
  public boolean getPublick() {
    return publick;
  }

  /** Set the parent for this calendar
   *
   * @param val   FilterVO parent object
   */
  public void setParent(BwFilter val) {
    parent = val;
  }

  /** Get the parent
   *
   * @return FilterVO    the parent
   */
  public BwFilter getParent() {
    return parent;
  }

  /**  Set the set of children
   *
   * @param   val   Collection of children for this filter
   */
  public void setChildren(Collection val) {
    children = val;
  }

  /**  Get the set of children
   *
   * @return Collection   FilterVO children for this filter
   */
  public Collection getChildren() {
    if (children == null) {
      children = new TreeSet();
    }

    return children;
  }

  /* ====================================================================
   *                   Convenience methods
   * ==================================================================== */

  /**  Add a child to the set of children
   *
   * @param val     FilterVO child
   */
  public void addChild(BwFilter val) {
    getChildren().add(val);
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  public int compare(Object o1, Object o2) {
    if (!(o1 instanceof BwFilter)) {
      return -1;
    }

    BwFilter f1 = (BwFilter)o1;

    return f1.compareTo(o2);
  }

  /** Compare this filter and an object
   *
   * @param  o    object to compare.
   * @return int -1, 0, 1
   */
  public int compareTo(Object o) {
    if (!getClass().equals(o.getClass())) {
      return -1;
    }

    BwFilter that = (BwFilter)o;

    int cmp = CalFacadeUtil.cmpObjval(getOwner(), that.getOwner());
    if (cmp != 0) {
      return cmp;
    }

    return CalFacadeUtil.cmpObjval(getName(), that.getName());
  }

  public int hashCode() {
    int hc = getClass().hashCode();

    if (getName() != null) {
      hc *= getName().hashCode();
    }

    return hc;
  }

  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }

    if (!getClass().equals(obj.getClass())) {
      return false;
    }

    BwFilter that = (BwFilter)obj;

    return !CalFacadeUtil.eqObjval(getName(), that.getName());
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("BwFilter{name=");
    sb.append(String.valueOf(name));
    sb.append(", description=");
    sb.append(String.valueOf(description));
    sb.append(", parent=");
    if (parent == null) {
      sb.append("null");
    } else {
      sb.append(parent.getId());
    }
    sb.append("}");

    return sb.toString();
  }
}
