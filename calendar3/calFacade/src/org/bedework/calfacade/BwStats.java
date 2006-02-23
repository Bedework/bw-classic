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

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

/** Some statistics for the Bedework calendar. These are not necessarily
 * absolutely correct. We don't lock, just increment and decrement but
 * they work well enough to get an idea of how we're performing.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class BwStats implements Serializable {
  /** Class to hold a statistics. We build a collection of these.
   * We use Strings for values as these are going to be dumped as xml.
   */
  public static class StatsEntry {
    public final static int statKindHeader = 0;
    public final static int statKindStat = 1;

    private int statKind;

    private String statLabel;

    public final static int statTypeString = 0;
    public final static int statTypeInt = 1;
    public final static int statTypeLong = 2;
    public final static int statTypeDouble = 3;
    private int statType;

    private String statVal;

    public StatsEntry(String label, int val) {
      statKind = statKindStat;
      statLabel = label;
      statType = statTypeInt;
      statVal = String.valueOf(val);
    }

    public StatsEntry(String label, long val) {
      statKind = statKindStat;
      statLabel = label;
      statType = statTypeLong;
      statVal = String.valueOf(val);
    }

    public StatsEntry(String label, double val) {
      statKind = statKindStat;
      statLabel = label;
      statType = statTypeDouble;
      statVal = String.valueOf(val);
    }

    public StatsEntry(String label, String val) {
      statKind = statKindStat;
      statLabel = label;
      statType = statTypeString;
      statVal = val;
    }

    public StatsEntry(String header) {
      statKind = statKindHeader;
      statLabel = header;
    }

    public int getStatKind() {
      return statKind;
    }

    public String getStatLabel() {
      return statLabel;
    }

    public int getStatType() {
      return statType;
    }

    public String getStatVal() {
      return statVal;
    }
  }

  protected int tzFetches;

  protected int systemTzFetches;

  protected int tzStores;

  protected double eventFetchTime;

  protected long eventFetches;

  /* Timezone cache stats */
  protected long datesCached;
  protected long dateCacheHits;
  protected long dateCacheMisses;

  /**
   * @return int   total num timezone fetches.
   */
  public int getTzFetches() {
    return tzFetches;
  }

  /**
   * @return int   num system timezone fetches.
   */
  public int getSystemTzFetches() {
    return systemTzFetches;
  }

  /**
   * @return int   num timezone stores.
   */
  public int getTzStores() {
    return tzStores;
  }

  /**
   * @return double   event fetch millis.
   */
  public double getEventFetchTime() {
    return eventFetchTime;
  }

  /**
   * @return long   event fetches.
   */
  public long getEventFetches() {
    return eventFetches;
  }

  /**
   * @return Number of utc values cached
   */
  public long getDatesCached() {
    return datesCached;
  }

  /**
   * @return date cache hits
   */
  public long getDateCacheHits() {
    return dateCacheHits;
  }

  /**
   * @return data cache misses.
   */
  public long getDateCacheMisses() {
    return dateCacheMisses;
  }

  public Collection getStats() {
    Vector v = new Vector();

    v.add(new StatsEntry("Bedework statistics."));
    v.add(new StatsEntry("tzFetches", getTzFetches()));
    v.add(new StatsEntry("systemTzFetches", getSystemTzFetches()));
    v.add(new StatsEntry("tzStores", getTzStores()));

    v.add(new StatsEntry("event fetch time", getEventFetchTime()));
    v.add(new StatsEntry("event fetches", getEventFetches()));

    v.add(new StatsEntry("UTC dates cached", getDatesCached()));
    v.add(new StatsEntry("UTC date cache hits", getDateCacheHits()));
    v.add(new StatsEntry("UTC date cache misses", getDateCacheMisses()));

    return v;
  }

  /** Turn the Collection of StatsEntry into a String for dumps.
   */
  public static String toString(Collection c) {
    StringBuffer sb = new StringBuffer();

    Iterator it = c.iterator();

    while (it.hasNext()) {
      StatsEntry se = (StatsEntry)it.next();
      int k = se.getStatKind();

      if (k == StatsEntry.statKindHeader) {
        header(sb, se.getStatLabel());
      } else {
        format(sb, se.getStatLabel(), se.getStatVal());
      }
    }

    return sb.toString();
  }

  public String toString() {
    return toString(getStats());
  }

  private final static String padder = "                    " +
                                       "                    " +
                                       "                    " +
                                       "                    ";

  private final static int padderLen = padder.length();

  private static final int maxvalpad = 10;

  private static void pad(StringBuffer sb, String val, int padlen) {
    int len = padlen - val.length();

    if (len > 0) {
      sb.append(padder.substring(0, len));
    }

    sb.append(val);
  }

  private static void header(StringBuffer sb, String h) {
    sb.append("\n");
    pad(sb, h, padderLen);
    sb.append("\n");
  }

  private static void format(StringBuffer sb, String name, String val) {
    pad(sb, name, padderLen);
    sb.append(": ");
    pad(sb, val, maxvalpad);
    sb.append("\n");
  }
}
