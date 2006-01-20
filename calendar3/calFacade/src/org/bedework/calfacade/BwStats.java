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

/** Some statistics for the Bedework calendar. These are not necessarily
 * absolutely correct. We don't lock, just increment and decrement but
 * they work well enough to get an idea of how we're performing.
 *
 * @author Mike Douglass       douglm@rpi.edu
 */
public class BwStats implements Serializable {
  protected int tzFetches;

  protected int systemTzFetches;

  protected int tzStores;

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

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("Bedework svc layer statistics.\n");
    format(sb, "tzFetches: ", getTzFetches());
    format(sb, "systemTzFetches: ", getSystemTzFetches());
    format(sb, "tzStores: ", getTzStores());

    return sb.toString();
  }

  private static final String padding = "                      ";
  private static final int maxvalpad = 10;
  private static final int maxnamepad = padding.length();

  private void pad(StringBuffer sb, String val, int padlen) {
    int len = val.length();

    if (len <= padlen) {
      sb.append(padding.substring(len));
    }

    sb.append(val);
  }

  private void format(StringBuffer sb, String name, int val) {
    pad(sb, name, maxnamepad);
    sb.append(": ");
    pad(sb, String.valueOf(val), maxvalpad);
    sb.append("\n");
  }
}
