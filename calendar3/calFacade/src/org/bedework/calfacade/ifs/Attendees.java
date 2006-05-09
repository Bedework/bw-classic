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
package org.bedework.calfacade.ifs;

import org.bedework.calfacade.BwAttendee;
import org.bedework.calfacade.BwUser;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.TreeSet;

/** A class defining the operations we can carry out on attendees and
 * collections of attendees
 *
 *  @version 1.0
 *  @author Mike Douglass   douglm @ rpi.edu
 */
public class Attendees implements Serializable {
  private BwUser owner;
  private boolean publick;
  private Collection attendees;

  /** Constructor
   *
   * @param owner
   * @param publick
   */
  public Attendees(BwUser owner, boolean publick) {
    this.owner = owner;
    this.publick = publick;
  }

  /** Constructor
   *
   * @param owner
   * @param publick
   * @param attendees
   */
  public Attendees(BwUser owner, boolean publick, Collection attendees) {
    this(owner, publick);
    this.attendees = attendees;
  }

  /** Set the owner for this object and any contained objects.
   *
   * @param val
   */
  public void setOwner(BwUser val) {
    owner = val;

    if (attendees != null) {
      Iterator it = iterateAttendees();
      while (it.hasNext()) {
        BwAttendee att = (BwAttendee)it.next();
        att.setOwner(owner);
      }
    }
  }

  /** Set the public flag for this object and any contained objects.
   *
   * @param val
   */
  public void setPublick(boolean val) {
    publick = val;

    if (attendees != null) {
      Iterator it = iterateAttendees();
      while (it.hasNext()) {
        BwAttendee att = (BwAttendee)it.next();
        att.setPublick(publick);
      }
    }
  }

  /** Set the attendees
   *
   * @param val    Collection of attendees
   */
  public void setAttendees(Collection val) {
    attendees = val;
  }

  /** Get the attendees
   *
   *  @return Collection     attendees list
   */
  public Collection getAttendees() {
    if (attendees == null) {
      attendees = new TreeSet();
    }

    return attendees;
  }

  /** Get an <code>Iterator</code> over the attendees
   *
   * @return Iterator  over the alarm's attendees
   */
  public Iterator iterateAttendees() {
    return getAttendees().iterator();
  }

  /** clear the attendees
   */
  public void clearAttendees() {
    getAttendees().clear();
  }

  /** Add an attendee
   *
   * @param val   BwAttendee
   */
  public void addAttendee(BwAttendee val) {
    Collection as = getAttendees();

    if (!as.contains(val)) {
      val.setOwner(owner);
      val.setPublick(publick);
      as.add(val);
    }
  }

  /** Add an attendee represented by an email address
   *
   * @param val  String email
   */
  public void addAttendeeEmail(String val) {
    Collection as = getAttendees();
    BwAttendee att = new BwAttendee();

    att.setOwner(owner);
    att.setPublick(publick);
    att.setAttendeeUri(val);

    if (!as.contains(att)) {
      as.add(att);
    }
  }

  /** Get the attendees' email address list
   *
   *  @return String[]   attendees list
   */
  public String[] getAttendeeEmailList() {
    ArrayList al = new ArrayList();
    Iterator it = iterateAttendees();
    while (it.hasNext()) {
      BwAttendee att = (BwAttendee)it.next();

      String uri = att.getAttendeeUri();

      if (uri == null) {
        // ???
      } else if (!uri.toUpperCase().startsWith("MAILTO:")) {
        // Assume an email without MAILTO: prefix.
        al.add(uri);
      } else {
        al.add(uri.substring(7));
      }
    }
    return (String[])al.toArray(new String[al.size()]);
  }

  /** Return a copy of the collection
   *
   * @return Collection of BwAttendee
   */
  public Collection copyAttendees() {
    TreeSet ts = new TreeSet();

    Iterator it = iterateAttendees();
    while (it.hasNext()) {
      BwAttendee att = (BwAttendee)it.next();

      ts.add(att);
    }

    return ts;
  }

  /** Return a clone of the collection
   *
   * @return Collection of BwAttendee
   */
  public Collection cloneAttendees() {
    TreeSet ts = new TreeSet();

    Iterator it = iterateAttendees();
    while (it.hasNext()) {
      BwAttendee att = (BwAttendee)it.next();

      ts.add(att.clone());
    }

    return ts;
  }
}

