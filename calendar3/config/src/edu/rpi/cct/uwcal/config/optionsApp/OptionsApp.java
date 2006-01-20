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

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.Point;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Iterator;
import java.util.Properties;
import javax.swing.JFrame;

/** An application to provide a gui to set properties for bedework
 *
 *   @author Mike Douglass   douglm @ rpi.edu
 */
public class OptionsApp {
  private boolean debug;

  private Globals globals = new Globals() {
    public void redraw() {
      layout();
      // Make globalsPanel selected - that's how we got called
      tabbed.setSelectedIndex(tabbed.getTabIndex(globalsPanel));
    }
  };

  private JFrame frame;

  private TabbedPane tabbed;

  private IntroPanel introPanel;

  private GlobalOptionsPanel globalsPanel;

  /**
   * @param debug
   */
  public void init(boolean debug) {
    this.debug = debug;

    frame = new JFrame("Calendar Config");

    frame.addWindowListener(new WindowAdapter() {
        public void windowClosing(WindowEvent e) {System.exit(0);}
      });

    globals.rsrc = new Resources();
    globals.props = new Properties();
    globals.frame = frame;

    tabbed = new TabbedPane(frame, globals.rsrc, debug);
    globals.tabbed = tabbed;

    frame.setJMenuBar(getMenuBar(frame));
    frame.setSize(540, 450);

    frame.setContentPane(tabbed);

    layout();
  }

  /**
   *
   */
  public void layout() {
    globals.clearModules();
    Point p = frame.getLocation(null);
    frame.setVisible(false);

    tabbed.removeAll();

    int index = 0;

    introPanel = new IntroPanel(globals, index);
    introPanel.setEnabled(true);
//    tabbed.addTab(globals.rsrc.getTabString("intro"),
//                  new JScrollPane(introPanel));
    tabbed.addTab(introPanel);
    index++;

    globalsPanel = new GlobalOptionsPanel(globals, index) {
      public void stateChanged(String propName, boolean val) {
        AbstractOptionsPanel module = globals.getModule(propName);

        if (module == null) {
          if (debug) {
            trace("Module " + propName + " changed to " + val + " NOT IN TABLE");
          }
        } else {
          if (debug) {
            trace("Module " + propName + " with index " + module.getIndex() +
                  " changed to " + val);
          }

          if (!val) {
            tabbed.removeTab(module);
          } else {
            tabbed.addTab(module);
          }
        }
      }
    };

    globalsPanel.setEnabled(true);
//    tabbed.addTab(globals.rsrc.getTabString("global"),
//                  new JScrollPane(globalsPanel));
    tabbed.addTab(globalsPanel);
    index++;

    addModule(new AdminWebPanel(globals, index), index);
    index++;

    addModule(new PublicWebPanel(globals, index), index);
    index++;

    addModule(new PersonalWebPanel(globals, index), index);
    index++;

    addModule(new PublicCaldavPanel(globals, index), index);
    index++;

    addModule(new PersonalCaldavPanel(globals, index), index);
    index++;

    frame.invalidate();
    frame.repaint();
    frame.setLocation(p);
    frame.setVisible(true);
  }

  private void addModule(AbstractOptionsPanel module, int tabi) {
    globals.addModule(module.getResourceName(), module);
    module.setEnabled(globalsPanel.getModuleEnabled(module.getResourceName()));

    if (module.getEnabled()) {
//      JScrollPane scroller = new JScrollPane(module);

//      tabbed.addTab(globals.rsrc.getTabString(module.getResourceName()),
//                    scroller);
      tabbed.addTab(module);
    }
  }

  /** Debug
   * @param msg
   */
  public void trace(String msg) {
    System.out.println(msg);
  }

  /**
   * @param t
   */
  public void error(Throwable t) {
    t.printStackTrace();
  }

  private MenuBar getMenuBar(JFrame f) {
    return new MenuBar(f, globals.rsrc) {
      public boolean loadProperties(File f) {
        try {
          globals.props.load(new FileInputStream(f));
          globals.redraw();
          return true;
        } catch (Throwable t) {
          error(t);
          return false;
        }
      }

      public void newProperties() {
        globals.props = new Properties();
        OptionsApp.this.layout();
      }

      public boolean saveProperties(File f) {
        try {
          PrintStream str = new PrintStream(new FileOutputStream(f));

          introPanel.saveProperties(str);
          globalsPanel.saveProperties(str);

          Iterator it = globals.iterateModules();
          while (it.hasNext()) {
            AbstractOptionsPanel p = (AbstractOptionsPanel)it.next();

            p.saveProperties(str);
          }

          return true;
        } catch (Throwable t) {
          error(t);
          return false;
        }
      }

      public boolean saveAsProperties(File f) {
        return saveProperties(f);
      }
    };
  }

  /** Run this
   * @param args
   */
  public static void main(String[] args) {
    OptionsApp app = new OptionsApp();
    boolean debug = true;

    for (int i = 0; i < args.length; i++) {
      if (args[i].equals("-debug")) {
        debug = true;
      } else if (args[i].equals("-ndebug")) {
        debug = false;
      }
    }

    app.init(debug);

    /* I think it should do something like:

        //Schedule a job for the event-dispatching thread:
        //creating and showing this application's GUI.
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                createAndShowGUI();
            }
        });
        */
  }
}

