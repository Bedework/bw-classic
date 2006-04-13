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

package org.bedework.calsvc;

/** Haven't yet figured out how we'll internationalize queries. I think internal
 * lucene field names will have to be fixed and defined below and front end
 * implementors will need to provide a mapping.
 *
 * <p>We can possibly provide a subsclass of the parser to take a mapping table
 * of allowable external names to internal names.
 *
 * <p>In any case, this class defines the names of all the fields we index.
 *
 * @author Mike Douglass douglm @ rpi.edu
 *
 */
public class BwIndexLuceneDefs {
  private BwIndexLuceneDefs() {
    // There'll be no instantiation here
  }

  /* ---------------------------- Calendar fields ------------------------- */

  /** */
  public static final String calendarDescription = "calendarDescription";

  /** Key field for a calendar */
  public static final String calendarPath = "calendarPath";

  /** */
  public static final String calendarSummary = "calendarSummary";

  /* ---------------------------- Event fields ------------------------- */

  /** */
  public static final String eventCategory = "eventCategory";

  /** */
  public static final String eventDescription = "eventDescription";

  /** */
  public static final String eventEnd = "eventEnd";

  /** */
  public static final String eventLocation = "eventLocation";

  /** */
  public static final String eventStart = "eventStart";

  /** */
  public static final String eventSummary = "eventSummary";

  /** */
  public static final String defaultFieldName = "default";

  /* Field names for fields which contain item type and key information.
   */

  /** Field name defining type of item */
  public static final String itemTypeName = "itemType";

  /** */
  public static final String[] termNames = {
    itemTypeName,

    // ----------------- Calendar
    calendarDescription,
    calendarSummary,

    // ----------------- Event
    eventCategory,
    eventDescription,
    eventLocation,
    eventSummary,
  };

  /**
   * @return String[]
   */
  public static String[] getTermNames() {
    return termNames;
  }

  /* Item types. We index various item types and these strings define each
   * type.
   */

  /** */
  public static final String itemTypeCalendar = "calendar";

  /** */
  public static final String itemTypeEvent = "event";

  /** Key field for calendar */
  public static final String keyCalendar = "calendarPath";

  /** Key for an event */
  public static final String keyEvent = "eventKey";

}
