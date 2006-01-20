package edu.rpi.cct.uwcal.config.optionsApp.common;

import edu.rpi.cct.uwcal.config.common.Resources;

import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Properties;
import javax.swing.JButton;
import javax.swing.JComponent;

/**
 * Small utility class to simplify creation of buttons. The abstract method
 * buttonAction is called when the button is pressed.
 *
 * @author  Mike Douglass
 * @version 1.0
 */
public abstract class Button extends JButton {
  protected Resources rsrc;
  protected String resourceName;

  /* If props are given we use the property to hold the value,
     otherwise we just use a flag */
  protected Properties props;

  /**
   * Create an optionally enabled button with a label and of a given size and
   * add it to the parent.
   *
   * @param parent       JComponent to which the button will be added
   * @param resourceName
   * @param rsrc
   * @param props
   * @param enabled      true if the button is to be enabled
   */
  public Button(JComponent parent, String resourceName,
                  Resources rsrc, Properties props,
                  boolean enabled) {
    super();
    this.rsrc = rsrc;
    this.resourceName = resourceName;
    init(parent, rsrc.getButtonString(resourceName),
         rsrc.getTooltipString(resourceName), props, enabled);
  }

  /**
   * Create an optionally enabled button with a label and tooltip and of a
   * given size and add it to the parent.
   *
   * @param parent   JComponent to which the button will be added
   * @param resourceName
   * @param rsrc
   * @param props
   * @param enabled  True if the button is to be enabled
   * @param labelled
   */
  public Button(JComponent parent, String resourceName,
                  Resources rsrc, Properties props,
                  boolean enabled, boolean labelled) {
    super();
    this.rsrc = rsrc;
    this.resourceName = resourceName;
    String label = null;
    if (labelled) {
      label = rsrc.getButtonString(resourceName);
    }
    init(parent, label,
         rsrc.getTooltipString(resourceName), props, enabled);
  }

  /**
   * Create an optionally enabled button with an icon and of a
   * given size and add it to the parent.
   *
   * @param parent   JComponent to which the button will be added
   * @param resourceName
   * @param rsrc
   * @param enabled  True if the button is to be enabled
   * @param labelled
   */
  public Button(JComponent parent, String resourceName,
                  Resources rsrc,
                  boolean enabled, boolean labelled) {
    super();
    this.resourceName = resourceName;
    String label = null;
    if (labelled) {
      label = rsrc.getButtonString(resourceName);
    }
    init(parent, label,
         rsrc.getTooltipString(resourceName), null, enabled);
  }

  /** Called when the button is pressed
   */
  public abstract void buttonAction();

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

    if (label != null) {
      setText(label);
    }

    setEnabled(enabled);

    if (parent != null) {
      al = new ActionListener() {
          public void actionPerformed(ActionEvent evt) {
            buttonAction();
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


