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

package org.bedework.calfacade.ifs;

import org.apache.log4j.Logger;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeBadDateException;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calfacade.CalFacadeUtil;

import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.util.TimeZones;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;

/** Handle caching, retrieval and registration of timezones.
 *
 * @author Mike Douglass
 *
 */
public abstract class CalTimezones implements Serializable {
  private transient Logger log;
  
  protected boolean debug;

  protected String defaultTimeZoneId;
  protected transient TimeZone defaultTimeZone;

  protected static class TimezoneInfo implements Serializable {
    TimeZone tz;

    boolean publick;
    
    /**
     * @param tz
     */
    public TimezoneInfo(TimeZone tz) {
      init(tz);
    }
    
    /** Constructor
     * 
     * @param tz
     * @param publick
     */
    public TimezoneInfo(TimeZone tz, boolean publick) {
      init(tz);
      this.publick = publick;
    }
    
    /** (Re)init the object
     * 
     * @param tz
     * @param vtz
     */
    public void init(TimeZone tz) {
      this.tz = tz;
    }
    
    public TimeZone getTz() {
      return tz;
    }
    
    /**
     * @return true for public timezone
     */
    public boolean getPublick() {
      return publick;
    }
  }

  /* Map of user TimezoneInfo */
  protected HashMap timezones = new HashMap();
  
  /* Cache date only UTC values - we do a lot of those but the number of
   * different dates should be limited.
   * 
   * We have one cache per timezone
   */
  private HashMap dateCaches = new HashMap();

  private HashMap defaultDateCache = new HashMap();
  
  private long datesCached;
  private long dateCacheHits;
  private long dateCacheMisses;

  protected CalTimezones(boolean debug) {
    this.debug = debug;
  }
  
  /** Save a timezone definition in the database. The timezone is in the
   * form of a complete calendar definition containing a single VTimeZone
   * object.
   *
   * <p>The calendar must be on a path from a timezone root
   *
   * @param tzid
   * @param vtz
   * @throws CalFacadeException
   */
  public abstract void saveTimeZone(String tzid, VTimeZone vtz)
          throws CalFacadeException;

  /** Register a timezone object in the current session.
  *
  * @param id
  * @param timezone
  * @throws CalFacadeException
  */
  public void registerTimeZone(String id, TimeZone timezone)
          throws CalFacadeException {
    if (debug) {
      trace("register timezone with id " + id);
    }
    
    TimezoneInfo tzinfo = (TimezoneInfo)timezones.get(id);
    
    if (tzinfo == null) {
      tzinfo = new TimezoneInfo(timezone);
      timezones.put(id, tzinfo);
    } else {
      tzinfo.tz = timezone;
    }
  }

 /** Get a timezone object given the id. This will return transient objects
  * registered in the timezone directory
  *
  * @param id
  * @return TimeZone with id or null
  * @throws CalFacadeException
  */
  public abstract TimeZone getTimeZone(final String id) throws CalFacadeException;
  
  /** Get the default timezone for this system.
   *
   * @return default TimeZone or null for none set.
   * @throws CalFacadeException
   */
  public TimeZone getDefaultTimeZone() throws CalFacadeException {
    if ((defaultTimeZone == null) && (defaultTimeZoneId != null)) {
      defaultTimeZone = getTimeZone(defaultTimeZoneId);
    }

    return defaultTimeZone;
  }
  
  /** Set the default timezone id for this system.
   *
   * @param id
   * @throws CalFacadeException
   */
  public void setDefaultTimeZoneId(String id) throws CalFacadeException {
    defaultTimeZone = null;
    defaultTimeZoneId = id;
  }
  
  /** Get the default timezone id for this system.
   *
   * @return String id
   * @throws CalFacadeException
   */
  public String getDefaultTimeZoneId() throws CalFacadeException {
    return defaultTimeZoneId;
  }
  
  /** Find a timezone object in the database given the id.
   *
   * @param id
   * @param owner     event owner or null for current user
   * @return VTimeZone with id or null
   * @throws CalFacadeException
   */
  public abstract VTimeZone findTimeZone(final String id, BwUser owner) throws CalFacadeException;
  
  /** Clear all public timezone objects. Implementing classes should call this.
   *
   * <p>Will remove all public timezones in preparation for a replacement
   * (presumably)
   *
   * @throws CalFacadeException
   */
  public void clearPublicTimezones() throws CalFacadeException {
    dateCaches.clear();
    defaultDateCache.clear();
  }
  
  /** Refresh the public timezone table - presumably after a call to clearPublicTimezones.
   * and many calls to saveTimeZone.
   *
   * @throws CalFacadeException
   */
  public abstract void refreshTimezones() throws CalFacadeException;
  
  private static DateFormat formatTd  = new SimpleDateFormat("yyyyMMdd'T'HHmmss");
  private static Calendar cal = Calendar.getInstance();
  private static java.util.TimeZone utctz;
  private static java.util.TimeZone lasttz;
  private static String lasttzid;
  static {
    try {
      utctz = TimeZone.getTimeZone(TimeZones.UTC_ID);
    } catch (Throwable t) {
      throw new RuntimeException("Unable to initialise UTC timezone");
    }
    cal.setTimeZone(utctz);
  }
  
  /** Given a String time value and a possibly null tzid and/or timezone
   *  will return a UTC formatted value. The supplied time should be of the
   *  form yyyyMMdd or yyyyMMddThhmmss or yyyyMMddThhmmssZ
   *
   *  <p>The last form will be returned untouched, it's already UTC.
   *  
   *  <p>the first will have T000000 appended to the parameter value then the
   *  first and second will be converted to the equivalent UTC time.
   *
   *  <p>The returned value is used internally as a value for indexes and
   *  recurrence ids.
   *
   *  <p>Both tzid and tz null mean this is local or floating time
   *
   * @param time  String time to convert.
   * @param tzid  String tzid.
   * @param tz    If set used in preference to tzid.
   * @return String always of form yyyyMMddThhmmssZ
   * @throws CalFacadeException for bad parameters or timezone
   */
  public synchronized String getUtc(String time, String tzid, TimeZone tz) 
          throws CalFacadeException {
    /* XXX We probably need the ownerid to determine exactly which timezone
     */
    //if (debug) {
    //  trace("Get utc for " + time + " tzid=" + tzid + " tz =" + tz);
    //}
    if (CalFacadeUtil.isISODateTimeUTC(time)) {
      // Already UTC
      return time;
    }

    String dateKey = null;
    HashMap cache = null;
    
    if (CalFacadeUtil.isISODate(time)) {
      /* See if we have it cached */
      
      if (tzid == null) {
        cache = defaultDateCache;
      } else if (tzid.equals(getDefaultTimeZoneId())) {
        cache = defaultDateCache;
      } else {
        cache = (HashMap)dateCaches.get(tzid);
        if (cache == null) {
          cache = new HashMap();
          dateCaches.put(tzid, cache);
        }
      }
      
      String utc = (String)cache.get(time);
      
      if (utc != null) {
        dateCacheHits++;
        return utc;
      }

      /* Not in the cache - calculate it */
      
      dateCacheMisses++;
      dateKey = time;
      time += "T000000";
    } else if (!CalFacadeUtil.isISODateTime(time)) {
      throw new CalFacadeBadDateException();
    }
    
    try {
      boolean tzchanged = false;
      
      /* If we get a null timezone and id we are being asked for the default.
       * If we get a null tz and the tzid is the default id same again.
       * 
       * Otherwise we are asked for something other than the default.
       * 
       * So lasttzid is either 
       *    1. null - never been called
       *    2. the default tzid
       *    3. Some other tzid.
       */
      
      if (tz == null) {
        if (tzid == null) {
          tzid = getDefaultTimeZoneId();
        }
        
        if ((lasttzid == null) || (!lasttzid.equals(tzid))) {
          if (tzid.equals(getDefaultTimeZoneId())) {
            lasttz = getDefaultTimeZone();
          } else {
            lasttz = getTimeZone(tzid);
          }
          
          if (lasttz == null) {
            lasttzid = null;
            throw new CalFacadeBadDateException();
          }
          tzchanged = true;
          lasttzid = tzid;
        }
      } else {
        // tz supplied
        if (tz != lasttz) {
          /* Yes, that's a !=. I'm looking for it being the same object.
           * If I were sure that equals were correct and fast I'd use
           * that.
           */
          tzchanged = true;
          tzid = tz.getID();
          lasttz = tz;
        }
      }
      
      
      if (tzchanged) {
        if (debug) {
          trace("**********tzchanged for tzid " + tzid);
        }
        formatTd.setTimeZone(lasttz);
        lasttzid = tzid;
      }
      
      cal.setTime(formatTd.parse(time));
      
      StringBuffer sb = new StringBuffer();
      digit4(sb, cal.get(Calendar.YEAR));
      digit2(sb, cal.get(Calendar.MONTH) + 1); // Month starts at 0
      digit2(sb, cal.get(Calendar.DAY_OF_MONTH));
      sb.append('T');
      digit2(sb, cal.get(Calendar.HOUR_OF_DAY));
      digit2(sb, cal.get(Calendar.MINUTE));
      digit2(sb, cal.get(Calendar.SECOND));
      sb.append('Z');
      
      String utc = sb.toString();
      
      if (dateKey != null) {
        cache.put(dateKey, utc);
        datesCached++;
      }
      
      return utc;
    } catch (Throwable t) {
      t.printStackTrace();
      throw new CalFacadeBadDateException();
    }
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
    
  /* ====================================================================
   *                   protected methods
   * ==================================================================== */
  
  protected void digit2(StringBuffer sb, int val) throws CalFacadeException {
    if (val > 99) {
      throw new CalFacadeBadDateException();
    }
    if (val < 10) {
      sb.append("0");
    }
    sb.append(val);
  }
  
  protected void digit4(StringBuffer sb, int val) throws CalFacadeException {
    if (val > 9999) {
      throw new CalFacadeBadDateException();
    }
    if (val < 10) {
      sb.append("000");
    } else if (val < 100) {
      sb.append("00");
    } else if (val < 1000) {
      sb.append("0");
    }
    sb.append(val);
  }
  

  /* Get a logger for messages
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void trace(String msg) {
    getLogger().debug("trace: " + msg);
  }
}
