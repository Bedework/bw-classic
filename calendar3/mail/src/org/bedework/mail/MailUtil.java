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
package org.bedework.mail;

import org.bedework.calfacade.BwDateTime;
import org.bedework.calfacade.BwEvent;
import org.bedework.calfacade.CalFacadeUtil;

import edu.rpi.cct.uwcal.resources.Resources;

import java.text.DateFormat;

/** Some useful methods used when mailing calendar objects..
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class MailUtil {
  /** make event printable
   *
   * @param event
   * @return printable event
   */
  public static StringBuffer displayableEvent(BwEvent event) {
    return displayableEvent(event, new Resources());
  }

  /** make event printable using resources
   *
   * @param event
   * @param rsrc
   * @return printable event
   */
  public static StringBuffer displayableEvent(BwEvent event,
                                              Resources rsrc) {
    StringBuffer sb = new StringBuffer();

    sb.append(event.getSummary());
    sb.append("\n");
    sb.append(rsrc.getString(Resources.START));
    sb.append(": ");
    sb.append(formatDate(event.getDtstart()));
    sb.append("\n");
    sb.append(rsrc.getString(Resources.END));
    sb.append(": ");
    sb.append(formatDate(event.getDtend()));
    sb.append("\n");
    sb.append(rsrc.getString(Resources.DESCRIPTION));
    sb.append(": \n");
    sb.append(event.getDescription());
    sb.append("\n");

    return sb;
  }

  /**
   * @param dt
   * @return formatted date
   */
  public static String formatDate(BwDateTime dt) {
    DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT);
    try {
      return df.format(CalFacadeUtil.getDate(dt));
    } catch (Throwable t) {
      return t.getMessage();
    }
  }

  /** Mail a message to somebody.
   *
   * <p>All required message fields are set. The message will be mailed via
   * the supplied mailer. If the Object is non-null it will be
   * converted to the appropriate external form and sent as an attachment.
   *
   * @param mailer
   * @param val      Message to mail
   * @param att      String val to attach - e.g event, todo
   * @param name     name for attachment
   * @param type     mimetype for attachment
   * @param sysid    used for from address
   * @throws Throwable
   */
  public static void mailMessage(MailerIntf mailer,
                                 Message val,
                                 String att,
                                 String name,
                                 String type,
                                 String sysid) throws Throwable {
    ObjectAttachment oa = new ObjectAttachment();

    oa.setOriginalName(name);
    oa.setVal(att);
    oa.setMimeType(type);

    val.addAttachment(oa);

    if (val.getFrom() == null) {
      // This should be a property
      val.setFrom("donotreply-" + sysid);
    }

    mailer.post(val);
  }
}

