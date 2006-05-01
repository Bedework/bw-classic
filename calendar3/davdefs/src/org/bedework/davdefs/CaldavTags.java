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

package org.bedework.davdefs;

import edu.rpi.sss.util.xml.QName;

/** Define Caldav tags for XMlEmit.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class CaldavTags implements CaldavDefs {
  /**   */
  public static final QName allcomp = new QName(caldavNamespace,
                                                "allcomp");

  /**   */
  public static final QName allprop = new QName(caldavNamespace,
                                                "allprop");

  /**   */
  public static final QName calendar = new QName(caldavNamespace,
                                                 "calendar");

  /**   */
  public static final QName calendarData = new QName(caldavNamespace,
                                                     "calendar-data");

  /**   */
  public static final QName calendarDescription = new QName(caldavNamespace,
                                                            "calendar-description");

  /**   */
  public static final QName calendarTimezone = new QName(caldavNamespace,
                                                         "calendar-timezone");

  /**   */
  public static final QName calendarMultiget = new QName(caldavNamespace,
                                                         "calendar-multiget");

  /**   */
  public static final QName calendarQuery = new QName(caldavNamespace,
                                                      "calendar-query");

  /**   */
  public static final QName comp = new QName(caldavNamespace,
                                             "comp");

  /**   */
  public static final QName compFilter = new QName(caldavNamespace,
                                                   "comp-filter");

  /**   */
  public static final QName expand = new QName(caldavNamespace,
                                               "expand");

  /**   */
  public static final QName filter = new QName(caldavNamespace,
                                               "filter");

  /**   */
  public static final QName freeBusyQuery = new QName(caldavNamespace,
                                                      "free-busy-query");

  /**   */
  public static final QName isNotDefined = new QName(caldavNamespace,
                                                     "is-not-defined");

  /**   */
  public static final QName limitFreebusySet = new QName(caldavNamespace,
                                                         "limit-freebusy-set");

  /**   */
  public static final QName limitRecurrenceSet = new QName(caldavNamespace,
                                                           "limit-recurrence-set");

  /**   */
  public static final QName mkcalendar = new QName(caldavNamespace,
                                                   "mkcalendar");

  /**   */
  public static final QName maxAttendeesPerInstance = new QName(caldavNamespace,
                                                    "max-attendees-per-instance");

  /**   */
  public static final QName maxDateTime = new QName(caldavNamespace,
                                                    "max-date-time");

  /**   */
  public static final QName maxInstances = new QName(caldavNamespace,
                                                     "max-instances");

  /**   */
  public static final QName maxResourceSize = new QName(caldavNamespace,
                                                        "max-resource-size");

  /**   */
  public static final QName minDateTime = new QName(caldavNamespace,
                                                    "min-date-time");

  /**   */
  public static final QName paramFilter = new QName(caldavNamespace,
                                                    "param-filter");

  /**   */
  public static final QName prop = new QName(caldavNamespace,
                                             "prop");

  /**   */
  public static final QName propFilter = new QName(caldavNamespace,
                                                   "prop-filter");

  /**   */
  public static final QName readFreeBusy = new QName(caldavNamespace,
                                                     "read-free-busy");

  /**   */
  public static final QName returnContentType = new QName(caldavNamespace,
                                                          "return-content-type");

  /**   */
  public static final QName supportedCalendarComponentSet = new QName(caldavNamespace,
                                            "supported-calendar-component-set");

  /**   */
  public static final QName supportedCalendarData = new QName(caldavNamespace,
                                                      "supported-calendar-data");

  /**   */
  public static final QName textMatch = new QName(caldavNamespace,
                                                  "text-match");

  /**   */
  public static final QName timeRange = new QName(caldavNamespace,
                                                  "time-range");
}

