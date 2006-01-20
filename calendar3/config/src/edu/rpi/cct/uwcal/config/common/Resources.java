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

package edu.rpi.cct.uwcal.config.common;

import java.io.Serializable;
import java.util.ResourceBundle;
import java.util.Locale;

/** Object to provide internationalized resources for the calendar suite
 * config module.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class Resources implements Serializable {
  private static final String bundleBase =
        "edu.rpi.cct.uwcal.config.common.ConfigResources";

  /* These constants prefix each resource type */
  private final static String labelPrefix = "org.bedework.label.";
  private final static String tooltipPrefix = "org.bedework.tooltip.";
  private final static String helpPrefix = "org.bedework.help.";
  private final static String textPrefix = "org.bedework.text.";
  private final static String tabPrefix = "org.bedework.tab.";
  private final static String valuePrefix = "org.bedework.value.";
  private final static String propnamePrefix = "org.bedework.propname.";
  private final static String titlePrefix = "org.bedework.title.";
  private final static String buttonPrefix = "org.bedework.button.";
  private final static String menuPrefix = "org.bedework.menu.";
  private final static String menuMnemonicPrefix = "org.bedework.menu.mnemonic.";

  /** Bundle for the default locale */
  private ResourceBundle bundle = ResourceBundle.getBundle(bundleBase);

  //private Locale defaultLocale = Locale.getDefault();

  /** Constructor
   *
   */
  public Resources() {}

  /** Constructor
   *
   * @param loc
   */
  public Resources(Locale loc) {
    //defaultLocale = loc;
    bundle = ResourceBundle.getBundle(bundleBase, loc);
  }

  /** XXX Has no effect at the moment
   * @param loc
   */
  public void setDefaultLocale(Locale loc) {
    //defaultLocale = loc;
  }

  /**
   * @param key
   * @return string for key
   */
  public String getLabelString(String key) {
    return getString(labelPrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getLabelString(String key, Locale loc) {
    return getString(labelPrefix, key, loc);
  }

  /**
   * @param key
   * @return string for key
   */
  public String getTooltipString(String key) {
    return getString(tooltipPrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getTooltipString(String key, Locale loc) {
    return getString(tooltipPrefix, key, loc);
  }

  /**
   * @param key
   * @return string for key
   */
  public String getHelpString(String key) {
    return getString(helpPrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getHelpString(String key, Locale loc) {
    return getString(helpPrefix, key, loc);
  }

  /**
   * @param key
   * @return string for key
   */
  public String getTextString(String key) {
    return getString(textPrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getTextString(String key, Locale loc) {
    return getString(textPrefix, key, loc);
  }

  /**
   * @param key
   * @return string for key
   */
  public String getTabString(String key) {
    return getString(tabPrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getTabString(String key, Locale loc) {
    return getString(tabPrefix, key, loc);
  }

  /**
   * @param key
   * @return string for key
   */
  public String getValueString(String key) {
    return getString(valuePrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getValueString(String key, Locale loc) {
    return getString(valuePrefix, key, loc);
  }

  /**
   * @param key
   * @return string for key
   */
  public String getPropnameString(String key) {
    return getString(propnamePrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getPropnameString(String key, Locale loc) {
    return getString(propnamePrefix, key, loc);
  }

  /**
   * @param key
   * @return string for key
   */
  public String getTitleString(String key) {
    return getString(titlePrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getTitleString(String key, Locale loc) {
    return getString(titlePrefix, key, loc);
  }

  /**
   * @param key
   * @return string for key
   */
  public String getButtonString(String key) {
    return getString(buttonPrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return string for key and locale
   */
  public String getButtonString(String key, Locale loc) {
    return getString(buttonPrefix, key, loc);
  }

  /**
   * @param key
   * @return menu string for key
   */
  public String getMenuString(String key) {
    return getString(menuPrefix, key);
  }

  /**
   * @param key
   * @param loc
   * @return menu string for key and locale
   */
  public String getMenuString(String key, Locale loc) {
    return getString(menuPrefix, key, loc);
  }

  /**
   * @param key
   * @return Mnemonic char for key
   */
  public char getMenuMnemonicChar(String key) {
    String s = getString(menuMnemonicPrefix, key);
    if ((s == null) || (s.length() != 1)) {
      return ' ';
    }

    return s.charAt(0);
  }

  /**
   * @param key
   * @param loc
   * @return Mnemonic char for key and locale
   */
  public char getMenuMnemonicChar(String key, Locale loc) {
    String s = getString(menuMnemonicPrefix, key, loc);
    if ((s == null) || (s.length() != 1)) {
      return ' ';
    }

    return s.charAt(0);
  }
/*
  public String getPropval(String key) {
    return getString(propnamePrefix, key);
  }

  public String getPropval(String key, Locale loc) {
    return getString(propnamePrefix, key, loc);
  }
*/
  /**
   * @param prefix
   * @param key
   * @return value for prefix + key
   */
  public String getString(String prefix, String key) {
    try {
      return bundle.getString(prefix + key);
    } catch (Throwable t) {
      error(t, "Exception getting resource " + prefix + key);
      return null;
    }
  }

  /**
   * @param prefix
   * @param key
   * @param loc
   * @return value for prefix + key in locale
   */
  public String getString(String prefix, String key, Locale loc) {
    try {
      return ResourceBundle.getBundle(bundleBase, loc).getString(prefix + key);
    } catch (Throwable t) {
      error(t, "Exception getting resource " + prefix + key);
      return null;
    }
  }

  private void error(Throwable t, String msg) {
    System.out.println(msg);
    t.printStackTrace();
  }
}
