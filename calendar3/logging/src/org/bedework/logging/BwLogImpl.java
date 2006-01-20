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
package org.bedework.logging;

import org.bedework.calfacade.BwUser;

import org.apache.log4j.Logger;

/** This package is intended for logging of activity in the bedework calendar
    allowing tracking of changes.

    The default logger just emits system log records which can be filtered by
    the server into separate files.

    @author Mike Douglass
 */
public class BwLogImpl implements BwLog {
  private transient Logger log;

  /* (non-Javadoc)
   * @see org.bedework.logging.BwLog#log(int, org.bedework.calfacade.BwUser, java.lang.Object)
   */
  public void log(int type, BwUser who, Object what) {
    String tstr;
    try {
      tstr = logTypeStr[type];
    } catch (Throwable t) {
      tstr = "Bad type code " + type;
    }

    StringBuffer sb = new StringBuffer(tstr);
    sb.append(": ");
    sb.append(who.getAccount());
    sb.append(": ");
    sb.append(what.getClass().getName());

    info(sb.toString());
  }

  private Logger getLog() {
    if (log != null) {
      return log;
    }

    log = Logger.getLogger(this.getClass());
    return log;
  }

  private void info(String msg) {
    getLog().info(msg);
  }
}
