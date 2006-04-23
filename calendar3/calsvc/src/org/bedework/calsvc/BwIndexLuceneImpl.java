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

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.BwLocation;
import org.bedework.calsvci.CalSvcI;

import edu.rpi.cct.misc.indexing.Index;
import edu.rpi.cct.misc.indexing.IndexException;
import edu.rpi.cct.misc.indexing.IndexLuceneImpl;

import java.util.Iterator;

import org.apache.lucene.document.Document;
import org.apache.lucene.index.Term;

/**
 * @author Mike Douglass douglm @ rpi.edu
 *
 */
public class BwIndexLuceneImpl extends IndexLuceneImpl {
  private CalSvcI svci;
  private BwIndexKey keyConverter = new BwIndexKey();

  /** Constructor
   *
   * @param svci
   * @param sysfilePath
   * @param admin
   * @param debug
   * @throws IndexException
   */
  public BwIndexLuceneImpl(CalSvcI svci,
                           String sysfilePath,
                           boolean admin,
                           boolean debug) throws IndexException {
    super(sysfilePath,
          BwIndexLuceneDefs.defaultFieldName,
          admin, debug);
    this.svci = svci;
  }

  /** Called to make or fill in a Key object.
   *
   * @param key   Possible Index.Key object for reuse
   * @param doc   The retrieved Document
   * @param score The rating for this entry
   * @return Index.Key  new or reused object
   */
  public Index.Key makeKey(Index.Key key,
                           Document doc,
                           float score) throws IndexException {
    if ((key == null) || (!(key instanceof BwIndexKey))) {
      key = new BwIndexKey(svci);
    }

    BwIndexKey bwkey = (BwIndexKey)key;

    bwkey.setScore(score);

    String itemType = doc.get(BwIndexLuceneDefs.itemTypeName);
    bwkey.setItemType(itemType);

    if (itemType == null) {
      throw new IndexException("org.bedework.index.noitemtype");
    }

    if (itemType.equals(BwIndexLuceneDefs.itemTypeCalendar)) {
      bwkey.setCalendarKey(doc.get(BwIndexLuceneDefs.keyCalendar));
    } else if (itemType.equals(BwIndexLuceneDefs.itemTypeEvent)) {
      bwkey.setEventKey(doc.get(BwIndexLuceneDefs.keyEvent));
    } else {
      throw new IndexException(IndexException.unknownRecordType,
                               itemType);
    }

    return key;
  }

  /** Called to make a key term for a record.
   *
   * @param   rec      The record
   * @return  Term     Lucene term which uniquely identifies the record
   */
  public Term makeKeyTerm(Object rec) throws IndexException {
    String name = makeKeyName(rec);
    String key = makeKeyVal(rec);

    return new Term(name, key);
  }

  /** Called to make a key value for a record.
   *
   * @param   rec      The record
   * @return  String   String which uniquely identifies the record
   * @throws IndexException
   */
  public String makeKeyVal(Object rec) throws IndexException {
    if (rec instanceof BwCalendar) {
      return ((BwCalendar)rec).getPath();
    }

    if (rec instanceof BwEvent) {
      BwEvent ev = (BwEvent)rec;

      String path = ev.getCalendar().getPath();
      String guid = ev.getGuid();
      String recurid = null;
      if (ev.getRecurrence() != null) {
        recurid = ev.getRecurrence().getRecurrenceId();
      }

      return keyConverter.makeEventKey(path, guid, recurid);
    }

    throw new IndexException(IndexException.unknownRecordType,
                             rec.getClass().getName());
  }

  /** Called to make the primary key name for a record.
   *
   * @param   rec      The record
   * @return  String   Name for the field/term
   * @throws IndexException
   */
  public String makeKeyName(Object rec) throws IndexException {
    if (rec instanceof BwCalendar) {
      return BwIndexLuceneDefs.keyCalendar;
    }

    if (rec instanceof BwEvent) {
      return BwIndexLuceneDefs.keyEvent;
    }

    throw new IndexException(IndexException.unknownRecordType,
                             rec.getClass().getName());
  }

  /** Called to fill in a Document from an object.
   *
   * @param doc   The Document
   * @param o     Object to be indexed
   */
  public void addFields(Document doc,
                        Object o) throws IndexException {
    if (o == null) {
      System.out.println("Tried to index null record");
      return;
    }

    if (o instanceof BwCalendar) {
      BwCalendar cal = (BwCalendar)o;

      addString(doc, BwIndexLuceneDefs.calendarPath, cal.getPath());
      addLongString(doc, BwIndexLuceneDefs.calendarDescription, cal.getDescription());
      addString(doc, BwIndexLuceneDefs.calendarSummary, cal.getSummary());
    } else if (o instanceof BwEvent) {
      BwEvent ev = (BwEvent)o;

      addString(doc, BwIndexLuceneDefs.keyEvent, makeKeyVal(ev));

      addLongString(doc, BwIndexLuceneDefs.eventDescription, ev.getDescription());
      addString(doc, BwIndexLuceneDefs.eventSummary, ev.getSummary());

      addUntokenized(doc, BwIndexLuceneDefs.eventStart, ev.getDtstart().getDtval());
      addUntokenized(doc, BwIndexLuceneDefs.eventStart, ev.getDtend().getDtval());

      BwLocation loc = ev.getLocation();
      if (loc != null) {
        addString(doc, BwIndexLuceneDefs.eventLocation, loc.getAddress());
        addString(doc, BwIndexLuceneDefs.eventLocation, loc.getSubaddress());
      }

      Iterator it = ev.iterateCategories();
      while (it.hasNext()) {
        BwCategory cat = (BwCategory)it.next();

        addString(doc, BwIndexLuceneDefs.eventCategory, cat.getWord());
        addString(doc, BwIndexLuceneDefs.eventCategory, cat.getDescription());
      }
    } else {
      throw new IndexException(IndexException.unknownRecordType,
                               o.getClass().getName());
    }
  }

  /** Called to return an array of valid term names.
   *
   * @return  String[]   term names
   */
  public String[] getTermNames() {
    return BwIndexLuceneDefs.getTermNames();
  }
}
