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

package edu.rpi.cct.uwcal.config.optionsApp;

import edu.rpi.cct.uwcal.config.common.Resources;
import edu.rpi.cct.uwcal.config.optionsApp.common.CheckBox;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Properties;
import java.util.Vector;
import javax.swing.JFrame;

/** Hold objects and state needed by all classes
 */
public abstract class Globals {
  Resources rsrc;
  Properties props;
  JFrame frame;

  TabbedPane tabbed;

  /* The components we can build */
  private HashMap modulePanels;
  private Vector orderedModulePanels;

  CheckBox advanced;

  /**
   */
  public abstract void redraw();

  /** Move to prev tab
   */
  public void prevTab() {
    int cur = tabbed.getSelectedIndex();

    if (cur == 0) {
      return;
    }

    tabbed.setSelectedIndex(cur - 1);
  }

  /** Move to next tab
   */
  public void nextTab() {
    int tabn = tabbed.getTabCount();
    int cur = tabbed.getSelectedIndex();

    if ((cur + 1) == tabn) {
      return;
    }

    tabbed.setSelectedIndex(cur + 1);
  }

  /**
   * @param module
   * @return true if module is last tab
   */
  public boolean isLastTab(AbstractOptionsPanel module) {
    int tabn = tabbed.getTabCount();

    return (tabbed.getTabIndex(module) + 1) >= tabn;
  }

  /**
   * @param moduleName
   * @return module matching given name
   */
  public AbstractOptionsPanel getModule(String moduleName) {
    return (AbstractOptionsPanel)modulePanels.get(moduleName);
  }

  /**
   * @param name
   * @param module
   */
  public void addModule(String name, AbstractOptionsPanel module) {
    modulePanels.put(name, module);
    orderedModulePanels.add(module);
  }

  /**
   * @return Iterator over modules
   */
  public Iterator iterateModules() {
    return orderedModulePanels.iterator();
  }

  /**
   *
   */
  public void clearModules() {
    modulePanels = new HashMap();
    orderedModulePanels = new Vector();
  }

}

