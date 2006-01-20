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

import java.awt.Component;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;

/**
 *   @author Mike Douglass   douglm @ rpi.edu
 */
public class TabbedPane extends JTabbedPane {
  private boolean debug;

  private JFrame frame;

  private Resources rsrc;

  /** Constructor
   *
   * @param frame
   * @param rsrc
   * @param debug
   */
  public TabbedPane(JFrame frame, Resources rsrc, boolean debug) {
    this.debug = debug;
    this.frame = frame;
    this.rsrc = rsrc;
  }

  /** Get index of tab for given module
   *
   * @param module
   * @return int index
   */
  public int getTabIndex(AbstractOptionsPanel module) {
    /* Look for the tab */

    for (int i = 0; i < getTabCount(); i++) {
      AbstractOptionsPanel tab = panelAt(i);

      if ((tab != null) &&
          (tab.getIndex() == module.getIndex())) {
        return i;
      }
    }

    return -1;
  }

  /** Remove tab for given module
   *
   * @param module
   */
  public void removeTab(AbstractOptionsPanel module) {
    /* Look for the tab to remove */

    for (int i = 0; i < getTabCount(); i++) {
      AbstractOptionsPanel tab = panelAt(i);

      if ((tab != null) &&
          (tab.getIndex() == module.getIndex())) {
        remove(i);
        module.setEnabled(false);
        checkPrevNext();
        frame.invalidate();
        frame.repaint();
        break;
      }
    }
  }

  /** Add tab for given module
   *
   * @param module
   */
  public void addTab(AbstractOptionsPanel module) {
    /* Find where to put the tab. */
    for (int i = 0; i < getTabCount(); i++) {
      AbstractOptionsPanel tab = panelAt(i);

      if ((tab != null) &&
          (tab.getIndex() > module.getIndex())) {
        insertTab(rsrc.getTabString(module.getResourceName()), null,
                  new JScrollPane(module), null, i);
        if (debug) {
          System.out.println("Insert at " + i);
        }

        module.setEnabled(true);
        module = null;
        break;
      }
    }

    if (module != null) {
      /* Didn't insert - add */
      if (debug) {
        System.out.println("Just add");
      }

      module.setEnabled(true);
      addTab(rsrc.getTabString(module.getResourceName()),
             new JScrollPane(module));
    }

    checkPrevNext();
    frame.invalidate();
    frame.repaint();
  }

  private void checkPrevNext() {
    for (int i = 0; i < getTabCount(); i++) {
      AbstractOptionsPanel tab = panelAt(i);

      if (tab != null) {
        tab.checkPrevNext();
      }
    }
  }

  private AbstractOptionsPanel panelAt(int i) {
    Component c = getComponentAt(i);

    if (!(c instanceof JScrollPane)) {
      return null;
    }

    JScrollPane sc = (JScrollPane)c;

    c = sc.getViewport().getView();

    if (!(c instanceof AbstractOptionsPanel)) {
      return null;
    }

    return (AbstractOptionsPanel)c;
  }
}

