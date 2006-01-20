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

package edu.rpi.cct.uwcal.config.optionsApp.common;

import edu.rpi.cct.uwcal.config.common.Resources;

import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Properties;
import javax.swing.JCheckBox;
import javax.swing.JComponent;

/**
 * Small utility class to simplify creation of buttons. The abstract method
 * buttonAction is called when the button is pressed.
 *
 * @author  Mike Douglass
 * @version 1.0
 */
public class CheckBox extends JCheckBox {
  protected Resources rsrc;
  protected String resourceName;

  /* If props are given we use the property to hold the value,
     otherwise we just use a flag */
  private Properties props;

  /* Use this if props == null */
  protected boolean flag;

  /**
   * Create a checkbox with a label and tooltip defined by the
   * resourceName using a property and add it to the parent.
   *
   * @param parent       JComponent to which the button will be added
   * @param resourceName  Name of resource defining label and tooltip
   * @param rsrc
   * @param props
   * @param enabled  True if the button is to be enabled
   */
  public CheckBox(JComponent parent, String resourceName,
                  Resources rsrc, Properties props,
                  boolean enabled) {
    super();
    this.rsrc = rsrc;
    this.resourceName = resourceName;
    init(parent, rsrc.getLabelString(resourceName),
         rsrc.getTooltipString(resourceName), props, enabled);
  }

  /**
   * Create a checkbox with a label and tooltip defined by the
   * resourceName using a property and add it to the parent.
   *
   * @param parent       JComponent to which the button will be added
   * @param resourceName  Name of resource defining label and tooltip
   * @param rsrc
   * @param props
   * @param enabled  True if the button is to be enabled
   * @param labelled
   */
  public CheckBox(JComponent parent, String resourceName,
                  Resources rsrc, Properties props,
                  boolean enabled, boolean labelled) {
    super();
    this.rsrc = rsrc;
    this.resourceName = resourceName;
    String label = null;
    if (labelled) {
      label = rsrc.getLabelString(resourceName);
    }
    init(parent, label,
         rsrc.getTooltipString(resourceName), props, enabled);
  }

  /**
   * Create a checkbox with a label and tooltip defined by the
   * resourceName and use a flag for the value.
   *
   * @param parent       JComponent to which the button will be added
   * @param resourceName  Name of resource defining label and tooltip
   * @param rsrc
   * @param val
   * @param enabled  True if the button is to be enabled
   * @param labelled
   */
  public CheckBox(JComponent parent, String resourceName,
                  Resources rsrc, boolean val,
                  boolean enabled, boolean labelled) {
    super();
    this.resourceName = resourceName;
    flag = val;
    String label = null;
    if (labelled) {
      label = rsrc.getLabelString(resourceName);
    }
    init(parent, label,
         rsrc.getTooltipString(resourceName), null, enabled);
  }

  /** Called when the checkbox changes state
   *
   * @param val     boolean new state ofthe checkbox
   */
  public void checkBoxAction(boolean val) {
    if (props == null) {
      flag = val;
    } else {
      props.setProperty(rsrc.getPropnameString(resourceName), String.valueOf(val));
    }
  }

  /**
   * @return name of property
   */
  public String getPropName() {
    if (props == null) {
      return null;
    }

    return rsrc.getPropnameString(resourceName);
  }

  /**
   * @return resource name
   */
  public String getResourceName() {
    return resourceName;
  }

  /**
   * @return checkbox value
   */
  public boolean getValue() {
    if (props == null) {
      return flag;
    }

    String val = (String)props.getProperty(rsrc.getPropnameString(resourceName));
    if (val == null) {
      return false;
    }

    return Boolean.valueOf(val).booleanValue();
  }

  /**
   * @param al
   * @return action listener
   */
  public ActionListener replaceActionListener(ActionListener al) {
    ActionListener oldal = this.al;
    removeActionListener(this.al);
    this.al = al;
    addActionListener(al);
    return oldal;
  }

  private ActionListener al;

  // Init with a tool tip and a label or icon
  private void init(JComponent parent, String label,
                    String toolTip, Properties props, boolean enabled) {
    this.props = props;

    if (label != null) {
      setText(label);
    }
    setSelected(getValue());
    setEnabled(enabled);

    if (parent != null) {
      al = new ActionListener() {
          public void actionPerformed(ActionEvent evt) {
            JCheckBox cb = (JCheckBox)evt.getSource();
            checkBoxAction(cb.isSelected());
          }
        };

      addActionListener(al);

      if (toolTip != null) {
        setToolTipText(toolTip);
      }

      setAlignmentY(Component.CENTER_ALIGNMENT);
      parent.add(this);
    }
  } // initButton
}


