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

package edu.rpi.cct.uwcal.resources;

import java.io.Serializable;
import java.util.ResourceBundle;
import java.util.Locale;

import org.apache.log4j.Logger;

/** Object to provide internationalized resources for the calendar suite.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class Resources implements Serializable {
  /** */
  public static final String DESCRIPTION = "description";

  /** */
  public static final String EMAIL = "email";

  /** */
  public static final String END = "end";

  /** */
  public static final String PHONENBR = "phoneNbr";

  /** */
  public static final String START = "start";

  /** */
  public static final String SUBADDRESS = "subaddress";

  /** */
  public static final String SUMMARY = "summary";

  /** */
  public static final String URL = "url";

  /* ---------------------- access control resources -------------------- */

  /** */
  private static final String bundleBase = "edu.rpi.cct.uwcal.resources.UWCalResources";

  /** Bundle for the default locale */
  private ResourceBundle bundle = ResourceBundle.getBundle(bundleBase);

  //private Locale defaultLocale = Locale.getDefault();

  /** Constructor
   *
   */
  public Resources() {}

  /**
   * @param loc
   */
  public Resources(Locale loc) {
    //defaultLocale = loc;
    bundle = ResourceBundle.getBundle(bundleBase, loc);
  }

  /**
   * @param loc
   */
  public void setDefaultLocale(Locale loc) {
    //defaultLocale = loc;
  }

  /**
   * @param key
   * @return value for key
   */
  public String getString(String key) {
    try {
      return bundle.getString(key);
    } catch (Throwable t) {
      Logger.getLogger(Resources.class).warn("Exception getting resource " + key, t);
      return null;
    }
  }

  /**
   * @param key
   * @param loc
   * @return value for key and locale
   */
  public static String getString(String key, Locale loc) {
    try {
      return ResourceBundle.getBundle(bundleBase, loc).getString(key);
    } catch (Throwable t) {
      Logger.getLogger(Resources.class).warn("Exception getting resource " + key, t);
      return null;
    }
  }
}
