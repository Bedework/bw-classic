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

package edu.rpi.sss.util.fmt;

import java.io.Serializable;
import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/** Class to help in formatting of time and date strings. Allows callers to set
 *  the current date/time format.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */

public class TimeDateFormatter implements Serializable {
  private SimpleDateFormat formatter;
  private Locale curLocale;
  private int curStyle;
  private boolean usingStyle;

  /** */
  public final static int time = 0;
  /** */
  public final static int date = 1;
  /** */
  public final static int timeDate = 2;
  /** */
  public final static int dateTime = 3;
  /** */
  public final static int timeShort = 4;
  /** */
  public final static int dateShort = 5;
  /** */
  public final static int timeDateShort = 6;
  /** */
  public final static int dateTimeShort = 7;

  /** */
  public final static int dflt = dateTime;

  private String timePattern = "h:mm a";
  private String datePattern = "MMM d, yyyy";
  private String timeDatePattern = timePattern + " " + datePattern;
  private String dateTimePattern = datePattern + " " + timePattern;
  private String timeShortPattern = "h:mm a";
  private String dateShortPattern = "M/d/yyyy";
  private String timeDateShortPattern = timeShortPattern + " " + dateShortPattern;
  private String dateTimeShortPattern = dateShortPattern + " " + timeShortPattern;

  private String defaultPattern = dateTimePattern;

  /**
   *
   */
  public TimeDateFormatter() {
    this(dflt);
  }

  /**
   * @param style
   */
  public TimeDateFormatter(int style) {
    this(style, Locale.getDefault());
  }

  /**
   * @param style
   * @param l
   */
  public TimeDateFormatter(int style, Locale l) {
    getFormatter(style, l);
  }

  /**
   * @param pattern
   */
  public TimeDateFormatter(String pattern) {
    this(pattern, Locale.getDefault());
  }

  /**
   * @param pattern
   * @param l
   */
  public TimeDateFormatter(String pattern, Locale l) {
    getFormatter(pattern, l);
  }

  /** Return a text representation of the Date object
   *
   * @param val Date
   * @return text representation of the Date object
   */
  public String format(Date val) {
    return formatter.format(val);
  }

  /**
   * @param val
   * @return parsed parameter
   * @throws Exception
   */
  public Date parse(String val) throws Exception {
    if (val == null) return null;

    return formatter.parse(val);
  }

  /**
   * @param style
   */
  public void setStyle(int style) {
    getFormatter(style, curLocale);
  }

  /**
   * @param style
   * @param pattern
   */
  public void setStylePattern(int style, String pattern) {
    if (style == time) {
      timePattern = pattern;
    } else if (style == date) {
      datePattern = pattern;
    } else if (style == timeDate) {
      timeDatePattern = pattern;
    } else if (style == timeDate) {
      dateTimePattern = pattern;
    } else if (style == timeShort) {
      timeShortPattern = pattern;
    } else if (style == dateShort) {
      dateShortPattern = pattern;
    } else if (style == timeDateShort) {
      timeDateShortPattern = pattern;
    } else if (style == timeDateShort) {
      dateTimeShortPattern = pattern;
    }

    if (usingStyle) {
      getFormatter(curStyle, curLocale);
    }
  }

  /**
   * @param pattern
   */
  public void setPattern(String pattern) {
    getFormatter(pattern, curLocale);
  }

  private void getFormatter(int style, Locale l) {
    String pattern = defaultPattern;
    curLocale = l;
    curStyle = style;
    usingStyle = true;

    if (style == time) {
      pattern = timePattern;
    } else if (style == date) {
      pattern = datePattern;
    } else if (style == timeDate) {
      pattern = timeDatePattern;
    } else if (style == timeDate) {
      pattern = dateTimePattern;
    } else if (style == timeShort) {
      pattern = timeShortPattern;
    } else if (style == dateShort) {
      pattern = dateShortPattern;
    } else if (style == timeDateShort) {
      pattern = timeDateShortPattern;
    } else if (style == timeDateShort) {
      pattern = dateTimeShortPattern;
    }

    formatter = new SimpleDateFormat(pattern, new DateFormatSymbols(l));
  }

  private void getFormatter(String pattern, Locale l) {
    curLocale = l;
    usingStyle = false;
    formatter = new SimpleDateFormat(pattern, new DateFormatSymbols(l));
  }

}
