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
package org.bedework.calcore.hibernate;

import java.util.Collection;
import java.util.Vector;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwStats;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.BwStats.StatsEntry;

import org.apache.log4j.Logger;

import org.hibernate.stat.CollectionStatistics;
import org.hibernate.stat.EntityStatistics;
import org.hibernate.stat.SecondLevelCacheStatistics;
import org.hibernate.stat.Statistics;

/** Class to help display statistics.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class DbStatistics {
  /** Dump the statistics to the log
   *
   * @param dbStats
   */
  public static void dumpStats(Statistics dbStats) {
    if (dbStats == null) {
      return;
    }

    Logger log = Logger.getLogger(DbStatistics.class);

    log.debug(BwStats.toString(getStats(dbStats)));
  }

  /** Get the current statistics
   *
   * @param dbStats
   * @return Collection
   */
  public static Collection getStats(Statistics dbStats) {
    /* XXX this ought to be property driven to some extent. The cache stats in
     * particular.
     */
    Vector v = new Vector();

    if (dbStats == null) {
      return v;
    }

    v.add(new StatsEntry("Number of connection requests", dbStats.getConnectCount()));
    v.add(new StatsEntry("Session flushes", dbStats.getFlushCount()));
    v.add(new StatsEntry("Transactions", dbStats.getTransactionCount()));
    v.add(new StatsEntry("Successful transactions", dbStats.getSuccessfulTransactionCount()));
    v.add(new StatsEntry("Sessions opened", dbStats.getSessionOpenCount()));
    v.add(new StatsEntry("Sessions closed", dbStats.getSessionCloseCount()));
    v.add(new StatsEntry("Queries executed", dbStats.getQueryExecutionCount()));
    v.add(new StatsEntry("Slowest query time", dbStats.getQueryExecutionMaxTime()));

    v.add(new StatsEntry("Collection statistics"));

    v.add(new StatsEntry("Collections fetched", dbStats.getCollectionFetchCount()));
    v.add(new StatsEntry("Collections loaded", dbStats.getCollectionLoadCount()));
    v.add(new StatsEntry("Collections rebuilt", dbStats.getCollectionRecreateCount()));
    v.add(new StatsEntry("Collections batch deleted", dbStats.getCollectionRemoveCount()));
    v.add(new StatsEntry("Collections batch updated", dbStats.getCollectionUpdateCount()));

    v.add(new StatsEntry("Object statistics"));

    v.add(new StatsEntry("Objects fetched", dbStats.getEntityFetchCount()));
    v.add(new StatsEntry("Objects loaded", dbStats.getEntityLoadCount()));
    v.add(new StatsEntry("Objects inserted", dbStats.getEntityInsertCount()));
    v.add(new StatsEntry("Objects deleted", dbStats.getEntityDeleteCount()));
    v.add(new StatsEntry("Objects updated", dbStats.getEntityUpdateCount()));

    v.add(new StatsEntry("Cache statistics"));

    double chit = dbStats.getQueryCacheHitCount();
    double cmiss = dbStats.getQueryCacheMissCount();

    v.add(new StatsEntry("Cache hit count", chit));
    v.add(new StatsEntry("Cache miss count", cmiss));
    v.add(new StatsEntry("Cache hit ratio", chit / (chit + cmiss)));

    entityStats(v, dbStats, BwCalendar.class);
    entityStats(v, dbStats, BwCategory.class);
    entityStats(v, dbStats, BwEventObj.class);
    entityStats(v, dbStats, BwLocation.class);
    entityStats(v, dbStats, BwSponsor.class);
    entityStats(v, dbStats, BwUser.class);

    collectionStats(v, dbStats, BwCalendar.class, "children");
    collectionStats(v, dbStats, BwEventObj.class, "categories");
    collectionStats(v, dbStats, BwEventObj.class, "attendees");
    collectionStats(v, dbStats, BwEventObj.class, "rrules");
    //collectionStats(v, dbStats, BwEventObj.class, "exrules");
    collectionStats(v, dbStats, BwEventObj.class, "rdates");
    collectionStats(v, dbStats, BwEventObj.class, "exdates");

    return v;
  }

  private static void entityStats(Collection c, Statistics dbStats,
                                  Class cl) {
    String name = cl.getName();

    c.add(new StatsEntry("Statistics for " + name));

    EntityStatistics eStats = dbStats.getEntityStatistics(name);

    c.add(new StatsEntry("Fetched", eStats.getFetchCount()));
    c.add(new StatsEntry("Loaded", eStats.getLoadCount()));
    c.add(new StatsEntry("Inserted", eStats.getInsertCount()));
    c.add(new StatsEntry("Deleted", eStats.getDeleteCount()));
    c.add(new StatsEntry("Updated", eStats.getUpdateCount()));
  }

  private static void collectionStats(Collection c, Statistics dbStats, Class cl,
                                      String cname) {
    String name = cl.getName() + "." + cname;

    c.add(new StatsEntry("Statistics for " + name));

    CollectionStatistics cStats = dbStats.getCollectionStatistics(name);

    c.add(new StatsEntry("Fetched", cStats.getFetchCount()));
    c.add(new StatsEntry("Loaded", cStats.getLoadCount()));
    c.add(new StatsEntry("Recreated", cStats.getRecreateCount()));
    c.add(new StatsEntry("Removed", cStats.getRemoveCount()));
    c.add(new StatsEntry("Updated", cStats.getUpdateCount()));
  }

  private static void secondLevelStats(Collection c, Statistics dbStats,
                                       String name) {
    c.add(new StatsEntry("Second level statistics for " + name));

    SecondLevelCacheStatistics slStats = dbStats.getSecondLevelCacheStatistics(name);

    c.add(new StatsEntry("Elements in memory", slStats.getElementCountInMemory()));
    c.add(new StatsEntry("Element on disk", slStats.getElementCountOnDisk()));
    //c.add(new StatsEntry("Entries", slStats.getEntries()));
    c.add(new StatsEntry("Hit count", slStats.getHitCount()));
    c.add(new StatsEntry("Miss count", slStats.getMissCount()));
    c.add(new StatsEntry("Put count", slStats.getPutCount()));
    c.add(new StatsEntry("Memory size", slStats.getSizeInMemory()));
  }
}
