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
package org.bedework.tools.dumprestore;

/** Some definitions for dumped data.
 *
 * <p>The data is dumped in one section per object class. Dumped objects
 * refer to other objects by their key (usually an integer).
 *
 * <p>Restoring the data will take a couple of passes over some of it. For
 * example, the user entries ref to subscriptions which refer to filters
 * which refer to locations and sponsors and categories.
 *
 * <p>Restore the users, save the subscriptions and then do them at the end.
 *
 * @author Mike Douglass   douglm@rpi.edu
 * @version 1.0
 */
public interface Defs {
  /** */
  public static final int dbTypeDb2 = 0;
  /** */
  public static final int dbTypeHsql = 1;
  /** */
  public static final int dbTypeMysql = 2;
  /** */
  public static final int dbTypeOracle = 3;
  /** */
  public static final int dbTypePostgres = 4;
  /** */
  public static final int dbTypeSqlServer = 5;

  /* ====================================================================
   *                      Tag name for entire dump
   * ==================================================================== */

  /** */
  public static final String dumpTag = "caldata";

  /* ====================================================================
   *                      Tag names for each section
   * ==================================================================== */

  /** */
  public static final String sectionFilters = "filters";
  /** */
  public static final String sectionUsers = "users";
  /** */
  public static final String sectionUserInfo = "user-info";
  /** */
  public static final String sectionCalendars = "calendars";
  /** */
  public static final String sectionLocations = "locations";
  /** */
  public static final String sectionSponsors = "sponsors";
  /** */
  public static final String sectionOrganizers = "organizers";
  /** */
  public static final String sectionAttendees = "attendees";
  /** */
  public static final String sectionAlarms = "alarms";
  /** */
  public static final String sectionKeywords = "keywords"; // v2.3.2
  /** */
  public static final String sectionCategories = "categories";
  /** */
  public static final String sectionAuthUsers = "authusers";
  /** */
  public static final String sectionEvents = "events";
  /** */
  public static final String sectionAdminGroups = "adminGroups";
  /** */
  public static final String sectionUserPrefs = "user-preferences";
  /** */
  public static final String sectionDbLastmods = "dblastmods";

  /* ====================================================================
   *                      Tag names for each object
   * ==================================================================== */

  /** */
  public static final String objectAndFilter = "andFilter";
  /** */
  public static final String objectKeywordFilter = "keyFilter"; // v2.3.2
  /** */
  public static final String objectCategoryFilter = "catFilter";
  /** */
  public static final String objectCreatorFilter = "creatorFilter";
  /** */
  public static final String objectLocationFilter = "locationFilter";
  /** */
  public static final String objectNotFilter = "notFilter";
  /** */
  public static final String objectOrFilter = "orFilter";
  /** */
  public static final String objectSponsorFilter = "sponsorFilter";

  /** */
  public static final String objectUser = "user";
  /** */
  public static final String objectUserInfo = "user-info";
  /** */
  public static final String objectCalendar = "calendar";
  /** */
  public static final String objectLocation = "location";
  /** */
  public static final String objectSponsor = "sponsor";
  /** */
  public static final String objectOrganizer = "organizer";
  /** */
  public static final String objectAttendee = "attendee";
  /** */
  public static final String objectAlarm = "alarm";
  /** */
  public static final String objectKeyword = "keyword"; // v2.3.2
  /** */
  public static final String objectCategory = "category";
  /** */
  public static final String objectAuthUser = "authuser";
  /** */
  public static final String objectEvent = "event";
  /** */
  public static final String objectAdminGroup = "adminGroup";
  /** */
  public static final String objectUserPrefs = "user-prefs";
  /** */
  public static final String objectDbLastmod = "dblastmod";
}

