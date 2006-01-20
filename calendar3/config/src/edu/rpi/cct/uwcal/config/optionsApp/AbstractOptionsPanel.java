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

import edu.rpi.cct.uwcal.config.optionsApp.common.Button;
import edu.rpi.cct.uwcal.config.optionsApp.common.CheckBox;
import edu.rpi.cct.uwcal.config.optionsApp.common.TextField;

import java.awt.Component;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.io.PrintStream;
import javax.swing.border.EtchedBorder;
import javax.swing.border.TitledBorder;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSeparator;
import javax.swing.SwingConstants;

/**
 * @author Mike Douglass   douglm @ ri.edu
 */
public abstract class AbstractOptionsPanel extends JPanel {
  private GridBagLayout gridbag;
  protected GridBagConstraints constraints;

  protected Globals globals;

  private int index;
  private String resourceName;

  /** Current row in the layout */
  protected int row;

  private boolean enabled;

  // private int maxUnitIncrement = 1;

  private Button prev;
  private Button next;

  /** The index is used to order the tabs
   *
   * @param globals
   * @param resourceName   String prefix for resources
   * @param index          used to order tabs
   */
  public AbstractOptionsPanel(Globals globals, String resourceName, int index) {
    this.globals = globals;
    this.index = index;
    this.resourceName = resourceName;

    String title = globals.rsrc.getTitleString(resourceName);

    setBorder(new TitledBorder(new EtchedBorder(), title));
    setName(title);

    gridbag = new GridBagLayout();
    constraints = new GridBagConstraints();

    setFont(new Font("Helvetica", Font.PLAIN, 14));
    setLayout(gridbag);
    constraints.insets = new Insets(2, 2, 2, 0);

    row = 0;

    addPrevNext();
    addSeparator();
  }

  /** ???
   *
   */
  public void checkPrevNext() {
    if (!enabled) {
      return;
    }

    prev.setEnabled(index > 0);

    next.setEnabled(!globals.isLastTab(this));
  }

  /**
   * @return index of this tab
   */
  public int getIndex() {
    return index;
  }

  public void setEnabled(boolean val) {
    enabled = val;
  }

  /**
   * @return true for enabled
   */
  public boolean getEnabled() {
    return enabled;
  }

  protected void error(Throwable t) {
    // Should pop up a pane
    t.printStackTrace();
  }

  /* ********************************************************************
                    Methods for adding display components
     ******************************************************************** */

  protected void addComponent(Component val, int row, int col, int anchor) {
    constraints.gridx = col;
    constraints.gridy = row;
    constraints.anchor = anchor;
    add(val, constraints);
  }

  protected void addComponent(Component val, int row, int col) {
    constraints.gridx = col;
    constraints.gridy = row;
    constraints.anchor = GridBagConstraints.CENTER;
    add(val, constraints);
  }

  protected void addComponentRight(Component val, int row, int col) {
    constraints.gridx = col;
    constraints.gridy = row;
    constraints.anchor = GridBagConstraints.EAST;

    add(val, constraints);
  }

  /** Add some help text and increment the row.
   */
  protected void showHelpText(String resourceName) {
    JLabel lbl = new JLabel(globals.rsrc.getHelpString(resourceName));

    constraints.gridwidth = 3;
    addComponent(lbl, row, 0, GridBagConstraints.WEST);
    constraints.gridwidth = 1;
    row++;
  }

  protected void addWideComponent(Component val) {
    constraints.gridx = 0;
    constraints.gridwidth = 3;
    constraints.gridy = row;
    constraints.anchor = GridBagConstraints.CENTER;
    add(val, constraints);
    constraints.gridwidth = 1;
    row++;
  }

  /** Add some text and increment the row.
   */
  protected void showTitleText(String resourceName) {
    JLabel lbl = new JLabel(globals.rsrc.getTitleString(resourceName));

    constraints.gridwidth = 3;
    addComponent(lbl, row, 0);
    constraints.gridwidth = 1;
    row++;
  }

  /** Add a separator and increment the row.
   */
  protected void addSeparator() {
    JSeparator sep = new JSeparator();
    constraints.gridwidth = 3;
    addComponent(sep, row, 0);
    constraints.gridwidth = 1;
    row++;
  }

  /** Add a label and separator and increment the row.
   */
  protected void addSeparator(String titleName) {
    Insets saveInsets = constraints.insets;
    constraints.insets = new Insets(6, 0, 6, 0);
    JSeparator sep = new JSeparator();
    constraints.weightx = 0.0;
    addComponent(sep, row, 0);

    JLabel lbl = new JLabel(globals.rsrc.getTitleString(titleName));
    addComponent(lbl, row, 1);

    sep = new JSeparator();
    addComponent(sep, row, 2);
    constraints.insets = saveInsets;
    row++;
  }

  protected JLabel label(String resourceName) {
    return label(resourceName, 0);
  }

  protected JLabel label(String resourceName, int col) {
    JLabel lbl = new JLabel(globals.rsrc.getLabelString(resourceName));
    lbl.setHorizontalAlignment(SwingConstants.TRAILING);

    constraints.fill = GridBagConstraints.NONE;
    constraints.weightx = 0.0;
    addComponentRight(lbl, row, col);

    return lbl;
  }

  protected OptionsCheckBox checkBox(OptionsCheckBox cb) {
    return checkBox(cb, false);
  }

  protected CheckBox checkBox(String resourceName) {
    return checkBox(resourceName, false);
  }

  /** If this is not an advanced field or we are in advanced mode, then we
   * create and display a label and checkbox.
   *
   * <p>Otherwise we just create a checkbox to hold the property value.
   */
  protected OptionsCheckBox checkBox(String resourceName, boolean advancedField) {
    boolean display = !advancedField || globals.advanced.getValue();
    JComponent parent = null;
    JLabel lbl = null;

    if (display) {
      parent = this;
      lbl = label(resourceName);
    }

    OptionsCheckBox cb = new OptionsCheckBox(parent, globals, resourceName, display);

    if (display) {
      cb.setLabel(lbl);
      addCheckBox(cb);
      row++;
    }

    return cb;
  }

  protected OptionsCheckBox checkBox(OptionsCheckBox cb, boolean advancedField) {
    boolean enabled = !advancedField || globals.advanced.getValue();

    cb.setEnabled(enabled);

    if (enabled) {
      cb.setLabel(label(cb.getResourceName()));
      addCheckBox(cb);
      row++;
    }

    return cb;
  }

  protected void addCheckBox(OptionsCheckBox cb) {
    constraints.fill = GridBagConstraints.HORIZONTAL;
    constraints.weightx = 1.0;
    addComponent(cb, row, 1);
  }

  protected OptionsTextField textField(String resourceName) {
    return textField(resourceName, false);
  }

  /** If this is not an advanced field or we are in advanced mode, then we
   * create and display a label and textfield.
   *
   * <p>Otherwise we just create a checkbox to hold the property value.
   */
  protected OptionsTextField textField(String resourceName, boolean advancedField) {
    boolean display = !advancedField || globals.advanced.getValue();
    JComponent parent = null;
    JLabel lbl = null;

    if (display) {
      parent = this;
      lbl =label(resourceName);
    }

    OptionsTextField tf = new OptionsTextField(parent, globals, resourceName,
                                               display);

    if (display) {
      tf.setLabel(lbl);
      constraints.fill = GridBagConstraints.HORIZONTAL;
      constraints.weightx = 1.0;
      addComponent(tf, row, 1);

      row++;
    }

    return tf;
  }

  protected void addPrevNext() {
    prev = new Button(this, "prev", globals.rsrc, globals.props,
                             false) {
      public  void buttonAction() {
        AbstractOptionsPanel.this.globals.prevTab();
      }
    };

    next = new Button(this, "next", globals.rsrc, globals.props,
                             false) {
      public  void buttonAction() {
        AbstractOptionsPanel.this.globals.nextTab();
      }
    };

    JPanel npbuttons = new JPanel();
    npbuttons.add(prev);
    npbuttons.add(next);
    constraints.weighty = 1.0;

    addComponent(npbuttons, 0, 0, GridBagConstraints.NORTHWEST);

    constraints.weighty = 0.0;
    constraints.anchor = GridBagConstraints.CENTER;
    row++;
  }

  protected class OptionsTextField extends TextField {
    protected Globals globals;
    protected JLabel label;

    protected OptionsTextField(JComponent parent, Globals globals,
                              String resourceName, boolean enabled) {
      super(parent, resourceName,
            globals.rsrc, globals.props, enabled);

      this.globals = globals;
    }

    /** Set the label for this text option
     *
     * @param val
     */
    public void setLabel(JLabel val) {
      label = val;
    }

    public void setEnabled(boolean val) {
      super.setEnabled(val);
      if (label != null) {
        label.setEnabled(val);
      }
    }
  }

  protected class OptionsCheckBox extends CheckBox {
    protected Globals globals;
    protected JLabel label;

    protected OptionsCheckBox(JComponent parent, Globals globals,
                              String resourceName, boolean enabled) {
      super(parent, resourceName,
            globals.rsrc, globals.props, enabled, false);

      this.globals = globals;
    }

    /** Set the label for this checkbox
     *
     * @param val
     */
    public void setLabel(JLabel val) {
      label = val;
    }

    public void setEnabled(boolean val) {
      super.setEnabled(val);
      if (label != null) {
        label.setEnabled(val);
      }
    }
  }

  /* ********************************************************************
                    Methods for saving properties
     ******************************************************************** */

  /** Save the properties represented by this tab
   *
   * @param str
   */
  public abstract void saveProperties(PrintStream str);

  /**
   * @return resource name for this tab
   */
  public String getResourceName() {
    return resourceName;
  }

  protected void saveTitle(PrintStream str, String moduleName) {
    str.println("#");
    str.println("# --------------------------------------------------------------------");
    str.println("#");
    str.println("# " + globals.rsrc.getTitleString(moduleName));
    str.println("#");
  }

  protected void saveProperty(PrintStream str, String propName, String val) {
    str.println(propName + "=" + val);
  }

  protected void saveProp(PrintStream str, CheckBox cb) {
    saveProperty(str, cb.getPropName(), String.valueOf(cb.getValue()));
  }

  protected void saveProp(PrintStream str, TextField tf) {
    saveProperty(str, tf.getPropName(), tf.getValue());
  }

  protected void saveSpace(PrintStream str) {
    str.println("");
  }
}

