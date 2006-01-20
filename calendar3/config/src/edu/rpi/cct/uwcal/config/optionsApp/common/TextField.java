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
import javax.swing.JComponent;
import javax.swing.JTextField;

/**
 * Small utility class to simplify creation of text fields.
 *
 * @author  Mike Douglass
 * @version 1.0
 */
public class TextField extends JTextField {
  protected Resources rsrc;
  protected String resourceName;

  private Properties props;

  /**
   * Create a text field with a tooltip defined by the
   * resourceName and add it to the parent.
   *
   * @param parent       JComponent to which the button will be added
   * @param resourceName  Name of resource defining label and tooltip
   * @param rsrc
   * @param props
   * @param enabled  True if the button is to be enabled
   */
  public TextField(JComponent parent, String resourceName,
                   Resources rsrc, Properties props,
                   boolean enabled) {
    super();
    this.rsrc = rsrc;
    this.resourceName = resourceName;
    init(parent, rsrc.getLabelString(resourceName),
         rsrc.getTooltipString(resourceName), props, enabled);
  }

  /** Called when the field changes state
   *
   * @param val     boolean new state ofthe checkbox
   */
  public void textFieldAction(String val) {
    props.setProperty(rsrc.getPropnameString(resourceName), val);
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
   * @return text field value
   */
  public String getValue() {
    if (props == null) {
      return null;
    }

    return (String)props.getProperty(rsrc.getPropnameString(resourceName));
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

  // Init a JButton with a tool tip and a label or icon
  private void init(JComponent parent, String label,
                    String toolTip, Properties props, boolean enabled) {
    this.props = props;

    setText(label);
    setText(getValue());
    setEnabled(enabled);

    if (parent == null) {
      return;
    }

    al = new ActionListener() {
        public void actionPerformed(ActionEvent evt) {
          JTextField tf = (JTextField)evt.getSource();
          textFieldAction(tf.getText());
        }
      };

    addActionListener(al);

    if (toolTip != null) {
      setToolTipText(toolTip);
    }

    setAlignmentY(Component.CENTER_ALIGNMENT);
    parent.add(this);
  } // initButton
}


