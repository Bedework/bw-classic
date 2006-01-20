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

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

/** Bean to represent a mail message. A serializable simplification and
 * restatement of the javax.mail.Message class. Serializability is
 * important if we want to queue the message..
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class Message implements Serializable {
  /** Who is it from
   */
  private String from;

  /** Who we send to
   */
  private String[] mailTo;

  /** Who we cc to
   */
  private String[] ccTo;

  /** Who we bcc to
   */
  private String[] bccTo;

  /** Subject
   */
  private String subject;

  /** When the message was queued
   */
  private long genDate;

  /** Content
   */
  private String content;

  private Collection attachments;

  /**
   * @param val
   */
  public void setFrom(String val) {
    from = val;
  }

  /**
   * @return value
   */
  public String getFrom() {
    return from;
  }

  /**
   * @param val
   */
  public void setMailTo(String[] val) {
    mailTo = val;
  }

  /**
   * @return value
   */
  public String[] getMailTo() {
    return mailTo;
  }

  /**
   * @param val
   */
  public void setCcTo(String[] val) {
    ccTo = val;
  }

  /**
   * @return value
   */
  public String[] getCcTo() {
    return ccTo;
  }

  /**
   * @param val
   */
  public void setBccTo(String[] val) {
    bccTo = val;
  }

  /**
   * @return value
   */
  public String[] getBccTo() {
    return bccTo;
  }

  /**
   * @param val
   */
  public void setSubject(String val) {
    subject = val;
  }

  /**
   * @return value
   */
  public String getSubject() {
    return subject;
  }

  /**
   * @param val
   */
  public void setGenDate(long val) {
    genDate = val;
  }

  /**
   * @return value
   */
  public long getGenDate() {
    return genDate;
  }

  /**
   * @param val
   */
  public void setContent(String val) {
    content = val;
  }

  /**
   * @return value
   */
  public String getContent() {
    return content;
  }

  /**
   * @param val
   */
  public void setAttachments(Collection val) {
    attachments = val;
  }

  /**
   * @return value
   */
  public Collection getAttachments() {
    if (attachments == null) {
      attachments = new Vector();
    }

    return attachments;
  }

  /**
   * @param val
   */
  public void addAttachment(Attachment val) {
    getAttachments().add(val);
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    sb.append("Message[\n");

    appStr(sb, "from", getFrom());

    appStrs(sb, "to", getMailTo());
    appStrs(sb, "cc", getCcTo());
    appStrs(sb, "bcc", getBccTo());

    appStr(sb, "subject", getSubject());
    appStr(sb, "content", getContent());

    Iterator it = getAttachments().iterator();
    while (it.hasNext()) {
      Attachment att = (Attachment)it.next();

      sb.append(att.toString());
      sb.append("\n");
    }

    sb.append("]endMessage\n");


    return sb.toString();
  }

  private void appStr(StringBuffer sb, String nm, String val) {
    sb.append(nm);
    sb.append(": ");
    sb.append(val);
    sb.append("\n");
  }

  private void appStrs(StringBuffer sb, String nm, String[] vals) {
    sb.append(nm);
    sb.append(": ");

    if (vals != null) {
      for (int i = 0; i < vals.length; i++) {
        if (i != 0) {
          sb.append(", ");
        }
        sb.append(vals[i]);
      }
    }
    sb.append("\n");
  }
}
