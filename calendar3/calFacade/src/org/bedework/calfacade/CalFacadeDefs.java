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
package org.bedework.calfacade;

/** This interface defines some calfacade values.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public interface CalFacadeDefs {
  /* Integer values associated with each type of calendar entity. Used as a
     code for db entries.
   */

  /** */
  public static final int entityTypeEvent = 0;

  /** */
  public static final int entityTypeAlarm = 1;

  /** */
  public static final int entityTypeTodo = 2;

  /** */
  public static final int entityTypeJournal = 3;

  /** Any object with this key is considered unsaved
   */
  public static final int unsavedItemKey = -1;

  /** Values which define how to retrieve recurring events. We have the
   * following choices (derived from caldav)
   *
   * <p>expand - return as if all instances within the time range are
   *      individual events.
   *
   * <p>overrides - return the master event and overrides only (if any fall
   *              within a specified range
   *
   * <p>masterOnly - return the master if any instances fall in the range
   */

  /** expand */
  public final static int retrieveRecurExpanded = 0;

  /** overrides */
  public final static int retrieveRecurOverrides = 1;

  /** overrides */
  public final static int retrieveRecurMaster = 2;

  /*     Some location stuff    */

  /** */
  public final static int noLocationId = 1;

  /** */
  public final static int unknownLocationId = 2;

  /** Unique ID of a location that has been deleted (An event can
   *   use a location created by another user, and if the user
   *   deletes the location, the 'deleted' location can be used
   *   to indicate this event to this user.)
   */
  public final static int deletedLocationId = 3;

  /** Any location id up to this is reserved.
   */
  public static final int maxReservedLocationId = 3;

  /** */
  public final static int minLocationId = maxReservedLocationId + 1;

  /** */
  public final static int defaultLocationId = noLocationId;

  /*     Some sponsor stuff    */

  /** */
  public final static int noSponsorId = 1;

  /** */
  public final static int unknownSponsorId = 2;

  /** */
  public final static int deletedSponsorId = 3;

  /** */
  public final static int defaultSponsorId = noSponsorId;

  /** Any sponsor id up to this is reserved.
   */
  public static final int maxReservedSponsorId = 3;

  /** */
  public final static int minSponsorId = maxReservedSponsorId + 1;

  /*     Some other stuff    */

  /** */
  public static final String bwMimeType = "bwcal";

  /** */
  public static final String bwUriPrefix = bwMimeType + "://";
}

