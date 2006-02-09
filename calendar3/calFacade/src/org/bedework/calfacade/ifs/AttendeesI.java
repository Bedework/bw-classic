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
package org.bedework.calfacade.ifs;

import org.bedework.calfacade.BwAttendee;

import java.util.Collection;
import java.util.Iterator;

/** An interface defining the operations we can carry out on attendees and
 * collections of attendees
 *
 *  @version 1.0
 *  @author Mike Douglass   douglm@rpi.edu
 */
public interface AttendeesI {
  /** Get an <code>Iterator</code> over the attendees
   *
   * @return Iterator  over the alarm's attendees
   */
  public Iterator iterateAttendees();

  /** clear the attendees
   */
  public void clearAttendees();

  /** Add an attendee
   *
   * @param val    BwAttendee
   */
  public void addAttendee(BwAttendee val);

  /** Add an attendee represented by an email address
   *
   * @param val   STring email
   */
  public void addAttendeeEmail(String val);

  /** Get the attendees' email address list
   *
   *  @return String[]   attendees list
   */
  public String[] getAttendeeEmailList();

  /** Return a copy of the collection
   *
   * @return Collection of BwAttendee
   */
  public Collection copyAttendees();

  /** Return a clone of the collection
   *
   * @return Collection of BwAttendee
   */
  public Collection cloneAttendees();
}

