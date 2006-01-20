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

import java.io.PrintStream;

import java.awt.Color;
import java.awt.Dimension;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.text.Document;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;

/** Introductory panel
 *
 *   @author Mike Douglass   douglm @ rpi.edu
 */
public class IntroPanel extends AbstractOptionsPanel {
  JTextPane info = new JTextPane();
  Document doc = info.getDocument();

  SimpleAttributeSet black = new SimpleAttributeSet();
  SimpleAttributeSet codeText = new SimpleAttributeSet();

  /** Constructor
   *
   * @param globals
   * @param index
   */
  public IntroPanel(Globals globals, int index) {
    super(globals, "intro", index);

    StyleConstants.setForeground(black, Color.black);
    StyleConstants.setFontFamily(black, "Times");
    StyleConstants.setFontSize(black, 14);
    StyleConstants.setSpaceBelow(black, 14);

    StyleConstants.setForeground(codeText, Color.black);
    StyleConstants.setFontFamily(codeText, "Courier");
    StyleConstants.setFontSize(codeText, 14);
    StyleConstants.setSpaceBelow(codeText, 14);

    info.setParagraphAttributes(black, true);
    addText("intro");

    JScrollPane scroller = new JScrollPane(info);

    info.setPreferredSize(new Dimension(400, 400));
    addWideComponent(scroller);
  }

  public void saveProperties(PrintStream str) {
    saveTitle(str, "intro");
    str.println(globals.rsrc.getTextString("intro"));
  }

  private void addText(String rname) {
    try {
      selectEnd();
      info.replaceSelection(globals.rsrc.getHelpString(rname));
//      doc.insertString(doc.getLength(), globals.rsrc.getHelpString(rname), black);
    } catch (Throwable t) {
      error(t);
    }
  }

  private void selectEnd() {
    int len = doc.getLength();

    info.setSelectionStart(len);
    info.setSelectionEnd(len);
  }
}
