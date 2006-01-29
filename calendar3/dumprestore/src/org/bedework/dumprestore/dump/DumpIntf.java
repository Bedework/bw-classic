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
package org.bedework.dumprestore.dump;

import java.util.Iterator;

/** Interface which defines the dataabse functions needed to dump the
 * calendar data. It is intended that the implementation might cache
 * objects. Calling each method in the order below should be the most
 * efficient.
 *
 * <p>These methods return dummy objects for references. For example,
 * an event location is represented by a Location object with only the
 * id filled in.
 *
 * <p>If the implementing class discovers a discrepency, e.g. a missing
 * user entry, it is up to the caller to determine that is the case.
 *
 * <p>Error messages should be emitted by the implementing classes.
 *
 * <p>Classes to dump in the order they must appear are<ul>
 * <li>BwSystem</li>
 * <li>BwUser</li>
 * <li>BwTimeZone</li>
 * <li>BwCalendar</li>
 * <li>BwLocation</li>
 * <li>BwSponsor</li>
 * <li>BwOrganizer</li>
 * <li>BwAttendee</li>
 * <li>BwAlarm</li>
 * <li>BwCategory</li>
 * <li>BwAuthUser</li>
 * <li>BwAuthUserPrefs</li>
 * <li>BwEvent</li>
 * <li>BwAdminGroup</li>
 * <li>BwPreferences + BwSubscription + BwView</li>
 *
 * <li>BwEventAnnotation</li>
 * <li>BwFilter</li>
 * <li>BwRecurrenceInstance</li>
 * <li>BwSynchData</li>
 * <li>BwSynchInfo</li>
 * <li>BwSynchState</li>
 * <li>BwTodo</li>
 * <li>BwUserInfo</li>
 * </ul>
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public interface DumpIntf {
  /** Call after any init phase
   *
   * @throws Throwable
   */
  public void open() throws Throwable;

  /** Call after dumping.
   *
   * @throws Throwable
   */
  public void close() throws Throwable;

  /** Will return an Iterator returning AdminGroup objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getAdminGroups() throws Throwable;

  /** Will return an Iterator returning Alarm objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getAlarms() throws Throwable;

  /** Will return an Iterator returning Attendee objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getAttendees() throws Throwable;

  /** Will return an Iterator returning AuthUser objects. Preferences will
   * be attached - user objects will also be attached.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getAuthUsers() throws Throwable;

  /** Will return an Iterator returning BwCalendar objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getCalendars() throws Throwable;

  /** Will return an Iterator returning Category objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getCategories() throws Throwable;

  /** Will return an Iterator returning Event objects.
   * All relevent objects, categories, locations, sponsors, creators will
   * be attached.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getEvents() throws Throwable;

  /** Will return an Iterator returning EventAnnotation objects.
   * All relevent objects, categories, locations, sponsors, creators will
   * be attached.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getEventAnnotations() throws Throwable;

  /** Will return an Iterator returning Filter objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getFilters() throws Throwable;

  /** Will return an Iterator returning Location objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getLocations() throws Throwable;

  /** Will return an Iterator returning Organizer objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getOrganizers() throws Throwable;

  /** Will return an Iterator returning BwPreferences objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getPreferences() throws Throwable;

  /** Will return an Iterator returning Sponsor objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getSponsors() throws Throwable;

  /** Will return an Iterator returning Subscription objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getSubscriptions() throws Throwable;

  /** Will return an Iterator returning system parameter objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getSyspars() throws Throwable;

  /** Will return an Iterator returning TimeZone objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getTimeZones() throws Throwable;

  /** Will return an Iterator returning User objects.
   * Subscriptions will be included
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getUsers() throws Throwable;

  /** Will return an Iterator returning view objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getViews() throws Throwable;

  /** Will return an Iterator returning BwDbLastmod objects.
   *
   * @return Iterator over entities
   * @throws Throwable
   */
  public Iterator getDbLastmods() throws Throwable;
}

