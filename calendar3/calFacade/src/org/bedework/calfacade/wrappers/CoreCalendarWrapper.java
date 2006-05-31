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
package org.bedework.calfacade.wrappers;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwUser;

import edu.rpi.cct.uwcal.access.Acl.CurrentAccess;

import java.util.Collection;

/** An object to wrap a calendar entity in Bedework. This allows us to limit
 * access to methods and attach thread or session information to the entity.
 *
 *   @author Mike Douglass douglm @ rpi.edu
 *  @version 1.0
 */
public class CoreCalendarWrapper extends BwCalendar {
  private BwCalendar entity;

  /* Current access for the user.
   */
  private CurrentAccess currentAccess;

  /** Constructor
   *
   * @param entity
   */
  public CoreCalendarWrapper(BwCalendar entity) {
    this.entity = entity;
  }

  /* ====================================================================
   *                   BwDbentity methods
   * ==================================================================== */

  public void setId(int val) {
    entity.setId(val);
  }

  public int getId() {
    return entity.getId();
  }

  public void setSeq(int val) {
    entity.setSeq(val);
  }

  public int getSeq() {
    return entity.getSeq();
  }

  /* ====================================================================
   *                   BwOwnedDbentity methods
   * ==================================================================== */

  /** Set the owner
   *
   * @param val     UserVO owner of the entity
   */
  public void setOwner(BwUser val) {
    entity.setOwner(val);
  }

  /**
   *
   * @return UserVO    owner of the entity
   */
  public BwUser getOwner() {
    return entity.getOwner();
  }

  /**
   * @param val
   */
  public void setPublick(boolean val) {
    entity.setPublick(val);
  }

  /**
   * @return boolean true for public
   */
  public boolean getPublick() {
    return entity.getPublick();
  }

  /* ====================================================================
   *                   BwShareableDbentity methods
   * ==================================================================== */

  public void setCreator(BwUser val) {
    entity.setCreator(val);
  }

  public BwUser getCreator() {
    return entity.getCreator();
  }

  public void setAccess(String val) {
    entity.setAccess(val);
  }

  public String getAccess() {
    return entity.getAccess();
  }

  /* ====================================================================
   *                   BwShareableContainedDbentity methods
   * ==================================================================== */

  public void setCalendar(BwCalendar val) {
    entity.setCalendar(val);
  }

  public BwCalendar getCalendar() {
    return entity.getCalendar();
  }

  /* ====================================================================
   *                   Bean methods
   * ==================================================================== */

  public void setName(String val) {
    entity.setName(val);
  }

  public String getName() {
    return entity.getName();
  }

  public void setPath(String val) {
    entity.setPath(val);
  }

  public String getPath() {
    return getPath();
  }

  /** Set the summary
   *
   * @param val    String summary
   */
  public void setSummary(String val) {
    entity.setSummary(val);
  }

  /** Get the summary
   *
   * @return String   summary
   */
  public String getSummary() {
    return entity.getSummary();
  }

  /** Set the description
   *
   * @param val    description
   */
  public void setDescription(String val) {
    entity.setDescription(val);
  }

  /** Get the description
   *
   *  @return String   description
   */
  public String getDescription() {
    return entity.getDescription();
  }

  /** Set the mail list id
   *
   * @param val    String mail list id
   */
  public void setMailListId(String val) {
    entity.setMailListId(val);
  }

  /** Get the mail list id
   *
   *  @return String   mail list id
   */
  public String getMailListId() {
    return entity.getMailListId();
  }

  /** true if this is to 'hold' calendar objects
   *
   * @param val   boolean true if this is to 'hold' calendar objects
   */
  public void setCalendarCollection(boolean val) {
    entity.setCalendarCollection(val);
  }

  /** true if this is to 'hold' calendar objects
   *
   * @return boolean  true if this is to 'hold' calendar objects
   */
  public boolean getCalendarCollection() {
    return getCalendarCollection();
  }

  /**  Set the set of children
   *
   * @param   val   SortedSet children for this calendar
   */
  public void setChildren(Collection val) {
    entity.setChildren(val);
  }

  /**  Get the set of children
   *
   * @return Collection   Calendar children for this calendar
   */
  public Collection getChildren() {
    return entity.getChildren();
  }

  /** Set the type
   *
   * @param val    type
   */
  public void setCalType(int val) {
    entity.setCalType(val);
  }

  /** Get the description
   *
   *  @return String   description
   */
  public int getCalType() {
    return entity.getCalType();
  }

  /* ====================================================================
   *                   Wrapper object methods
   * ==================================================================== */

  /**
   *
   * @param val CurrentAccess
   */
  public void setCurrentAccess(CurrentAccess val) {
    currentAccess = val;
  }

  /**
   * @return CurrentAccess
   */
  public CurrentAccess getCurrentAccess() {
    return currentAccess;
  }
}
