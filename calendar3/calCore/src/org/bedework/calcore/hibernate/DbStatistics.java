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

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwCategory;
import org.bedework.calfacade.BwEventObj;
import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.BwUser;

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
  private static final int lcolw = 50;
  
  public static void dumpStats(Statistics dbStats) {
    /* XXX this ought to be property driven to some extent. The cache stats in
     * particular.
     */
    if (dbStats == null) {
      return;
    }
    
    Logger log = Logger.getLogger(DbStatistics.class);
    
    log.debug(lpad("Number of connection requests: " , lcolw) + 
              dbStats.getConnectCount());
    log.debug(lpad("Session flushes: " , lcolw) + 
              dbStats.getFlushCount());
    log.debug(lpad("Transactions: " , lcolw) +
              dbStats.getTransactionCount());
    log.debug(lpad("Successful transactions: " , lcolw) + 
              dbStats.getSuccessfulTransactionCount());
    log.debug(lpad("Sessions opened: " , lcolw) +
              dbStats.getSessionOpenCount());
    log.debug(lpad("Sessions closed: " , lcolw) +
              dbStats.getSessionCloseCount());
    log.debug(lpad("Queries executed: " , lcolw) + 
              dbStats.getQueryExecutionCount());
    log.debug(lpad("Slowest query time: " , lcolw) + 
              dbStats.getQueryExecutionMaxTime());
    
    log.debug(" "); 
    log.debug(lpad("Collection statistics" , lcolw)); 
    log.debug(" "); 
    
    log.debug(lpad("Collections fetched: " , lcolw) +
              dbStats.getCollectionFetchCount());
    log.debug(lpad("Collections loaded: " , lcolw) +
              dbStats.getCollectionLoadCount());
    log.debug(lpad("Collections rebuilt: " , lcolw) +
              dbStats.getCollectionRecreateCount());
    log.debug(lpad("Collections batch deleted: " , lcolw) +
              dbStats.getCollectionRemoveCount());
    log.debug(lpad("Collections batch updated: " , lcolw) +
              dbStats.getCollectionUpdateCount());
    
    log.debug(" "); 
    log.debug(lpad("Object statistics" , lcolw)); 
    log.debug(" "); 
    
    log.debug(lpad("Objects fetched: " , lcolw) +
              dbStats.getEntityFetchCount());
    log.debug(lpad("Objects loaded: " , lcolw) +
              dbStats.getEntityLoadCount());
    log.debug(lpad("Objects inserted: " , lcolw) +
              dbStats.getEntityInsertCount());
    log.debug(lpad("Objects deleted: " , lcolw) +
              dbStats.getEntityDeleteCount());
    log.debug(lpad("Objects updated: " , lcolw) +
              dbStats.getEntityUpdateCount());

    log.debug(" "); 
    log.debug(lpad("Cache statistics" , lcolw)); 
    log.debug(" "); 
    
    double chit = dbStats.getQueryCacheHitCount();
    double cmiss = dbStats.getQueryCacheMissCount();
    
    log.debug(lpad("Cache hit count: " , lcolw) + chit);
    log.debug(lpad("Cache miss count: " , lcolw) + cmiss);
    log.debug(lpad("Cache hit ratio: " , lcolw) + chit / (chit + cmiss));

    entityStats(dbStats, BwCalendar.class, log);
    entityStats(dbStats, BwCategory.class, log);
    entityStats(dbStats, BwEventObj.class, log);
    entityStats(dbStats, BwLocation.class, log);
    entityStats(dbStats, BwSponsor.class, log);
    entityStats(dbStats, BwUser.class, log);

    collectionStats(dbStats, BwCalendar.class, "children", log);
    collectionStats(dbStats, BwEventObj.class, "categories", log);
    collectionStats(dbStats, BwEventObj.class, "attendees", log);
    collectionStats(dbStats, BwEventObj.class, "rrules", log);
    //collectionStats(dbStats, BwEventObj.class, "exrules", log);
    collectionStats(dbStats, BwEventObj.class, "rdates", log);
    collectionStats(dbStats, BwEventObj.class, "exdates", log);
  }
  
  private static void entityStats(Statistics dbStats, Class cl, Logger log) {
    String name = cl.getName();
    
    log.debug(" "); 
    log.debug(lpad("Statistics for " + name , lcolw)); 
    log.debug(" "); 
    
    EntityStatistics eStats = dbStats.getEntityStatistics(name);

    log.debug(lpad("Fetched: " , lcolw) + eStats.getFetchCount());
    log.debug(lpad("Loaded: " , lcolw) + eStats.getLoadCount());
    log.debug(lpad("Inserted: " , lcolw) + eStats.getInsertCount());
    log.debug(lpad("Deleted: " , lcolw) + eStats.getDeleteCount());
    log.debug(lpad("Updated: " , lcolw) + eStats.getUpdateCount());
  }
  
  private static void collectionStats(Statistics dbStats, Class cl, 
                                      String cname, Logger log) {
    String name = cl.getName() + "." + cname;
    
    log.debug(" "); 
    log.debug(lpad("Statistics for " + name , lcolw)); 
    log.debug(" "); 
    
    CollectionStatistics cStats = dbStats.getCollectionStatistics(name);

    log.debug(lpad("Fetched: " , lcolw) + cStats.getFetchCount());
    log.debug(lpad("Loaded: " , lcolw) + cStats.getLoadCount());
    log.debug(lpad("Recreated: " , lcolw) + cStats.getRecreateCount());
    log.debug(lpad("Removed: " , lcolw) + cStats.getRemoveCount());
    log.debug(lpad("Updated: " , lcolw) + cStats.getUpdateCount());
  }
  
  private static void secondLevelStats(Statistics dbStats, String name, 
                                       Logger log) {
    log.debug(" "); 
    log.debug(lpad("Second level statistics for " + name , lcolw)); 
    log.debug(" "); 
    
    SecondLevelCacheStatistics slStats = dbStats.getSecondLevelCacheStatistics(name);

    log.debug(lpad("Elements in memory: " , lcolw) + slStats.getElementCountInMemory());
    log.debug(lpad("Element on disk: " , lcolw) + slStats.getElementCountOnDisk());
    log.debug(lpad("Entries: " , lcolw) + slStats.getEntries());
    log.debug(lpad("Hit count: " , lcolw) + slStats.getHitCount());
    log.debug(lpad("Miss count: " , lcolw) + slStats.getMissCount());
    log.debug(lpad("Put count: " , lcolw) + slStats.getPutCount());
    log.debug(lpad("Memory size: " , lcolw) + slStats.getSizeInMemory());
  }

  private final static String padder = "                    " +
                                       "                    " +
                                       "                    " +
                                       "                    ";
  
  private final static int padderLen = padder.length();
  
  private static String lpad(String s, int len) {
    int l = len - s.length();
    
    if (l > padderLen) {
      return padder + s;
    }
    
    if (l < 0) {
      return s;
    }
    
    return padder.substring(0, l) + s;
  }
}
