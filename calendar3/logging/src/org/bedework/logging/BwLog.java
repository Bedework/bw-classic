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

/** This package is intended for logging of activity in the bedework calendar
    allowing tracking of changes.

    The default logger just emits system log records which can be filtered by
    the server into separate files.

    @author Mike Douglass
 */
public interface BwLog {
  /** */
  public static final int logon = 0;
  /** */
  public static final int logoff = 1;

  /** */
  public static final int addEvent = 2;
  /** */
  public static final int deleteEvent = 3;
  /** */
  public static final int modEvent = 4;

  /** */
  public static final String[] logTypeStr = {
    "Logon",
    "Logoff",

    "AddEvent",
    "DeleteEvent",
    "ModEvent",
  };

  /** Log an entity change
   *
   * @param type
   * @param who
   * @param what
   */
  public void log(int type, BwUser who, Object what);
}
