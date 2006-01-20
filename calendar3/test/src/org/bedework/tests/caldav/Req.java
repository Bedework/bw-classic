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

package org.bedework.tests.caldav;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.LineNumberReader;
import java.util.Vector;

import org.apache.commons.httpclient.Header;

class Req {
  String user;
  String pw;
  String description;
  Header[] hdrs;
  String contentType;
  String[] content;
  boolean auth;
  boolean fromFile;
  String contentFileName;
  byte[] contentBytes;

  private int expectedResp = -1;

  String method;
  String url;

  static final String descHdr = "DESCRIPTION: ";
  static final String exprespHdr = "EXPECT-RESPONSE: ";
  static final String methHdr = "METHOD: ";
  static final String authHdr = "AUTH: ";
  static final String urlHdr = "URL: ";
  static final String hdrHdr = "HEADER: ";
  static final String ctypeHdr = "CONTENTTYPE: ";
  static final String contHdr = "CONTENT:";
  static final String contFileHdr = "CONTENTFILE: ";

  Req(String user, String pw, String testFileName) throws Throwable {
    this.user = user;
    this.pw = pw;

    FileReader frdr = null;

    try {
      File testFile = new File(testFileName);
      frdr = new FileReader(testFile);
      LineNumberReader lnr = new LineNumberReader(frdr);

      Vector headers = null;
      Vector cont = null;

      do {
        String ln = lnr.readLine();

        if (ln == null) {
          break;
        }

        if (ln.trim().length() == 0) {
          continue;
        }

        if (cont != null) {
          /*
              swallow remaining as content
           */
          cont.add(ln);
        } else if ((description == null) && (ln.startsWith(descHdr))) {
          /*
                DESCRIPTION
           */
          description = ln.substring(descHdr.length());
        } else if (ln.startsWith(exprespHdr)) {
          /*
                EXPECT-RESPONSE
           */
          expectedResp = Integer.parseInt(ln.substring(exprespHdr.length()));
        } else if ((method == null) && (ln.startsWith(methHdr))) {
          /*
                METHOD
           */
          method = ln.substring(methHdr.length());
        } else if (ln.startsWith(authHdr)) {
          /*
                AUTH
           */
          auth = "true".equals(ln.substring(authHdr.length()));
        } else if ((url == null) && (ln.startsWith(urlHdr))) {
          /*
                URL
           */
          url = ln.substring(urlHdr.length());
        } else if (ln.startsWith(hdrHdr)) {
          /*
                HEADER
           */
          if (headers == null) {
            headers = new Vector();
          }

          String hdr = ln.substring(hdrHdr.length());
          int colonPos = hdr.indexOf(": ");
          if (colonPos < 0) {
            throw new Exception("Bad header in test data file " + testFileName);
          }

          headers.add(new Header(hdr.substring(0, colonPos),
                                 hdr.substring(colonPos + 2)));
        } else if ((contentType == null) && (ln.startsWith(ctypeHdr))) {
          /*
                CONTENTTYPE
           */
          contentType = ln.substring(ctypeHdr.length());
        } else if (ln.startsWith(contFileHdr)) {
          /*
                CONTENTFILE
           */
          fromFile = true;
          contentFileName = ln.substring(contFileHdr.length());
          File contentFile = new File(contentFileName);

          if (!contentFile.isAbsolute()) {
            contentFileName = testFile.getParentFile().getAbsolutePath() + "/" + contentFileName;
          }

          System.out.println("Load content from file " + contentFileName);
        } else if (!fromFile && ln.startsWith(contHdr)) {
          /*
                CONTENT
           */
          if (cont == null) {
            cont = new Vector();
          }
        } else {
          throw new Exception("Bad test data file " + testFileName);
        }
      } while (true);

      if (headers != null) {
        hdrs = (Header[])headers.toArray(new Header[headers.size()]);
      }

      if (cont != null) {
        content = (String[])cont.toArray(new String[cont.size()]);
      }
    } finally {
      if (frdr != null) {
        try {
          frdr.close();
        } catch (Throwable t) {}
      }
    }
  }

  /**
   * @return boolean
   */
  public boolean getAuth() {
    return auth;
  }

  /**
   * @return String
   */
  public String getMethod() {
    return method;
  }

  /**
   * @return String url prefixed with caldav path
   */
  public String getPrefixedUrl() {
    String urlprefix;
    if (auth) {
      urlprefix = "/ucaldav/user/" + user;
    } else {
      urlprefix = "/pubcaldav/public";
    }

    urlprefix += "/";

    if (url == null) {
      return urlprefix;
    }

    return urlprefix += url;
  }

  /**
   * @return int
   */
  public int getExpectedResponse() {
    return expectedResp;
  }

  /**
   * @return Header[]
   */
  public Header[] getHdrs() {
    return hdrs;
  }

  /**
   * @return String
   */
  public String getContentType() {
    return contentType;
  }

  /**
   * @return int content length
   * @throws Throwable
   */
  public int getContentLength() throws Throwable {
    if (fromFile) {
      return getFileBytes().length;
    }

    if (content == null) {
      return 0;
    }

    int len  = 0;
    for (int i = 0; i < content.length; i++) {
      len += content[i].length() + 1;
    }

    return len;
  }

  /**
   * @return byte[]  content bytes
   * @throws Throwable
   */
  public byte[] getContentBytes() throws Throwable {
    if (fromFile) {
      return getFileBytes();
    }

    if (content == null) {
      return null;
    }

    return getBytes();
  }

  private byte[] getBytes() {
    if (contentBytes != null) {
      return contentBytes;
    }

    StringBuffer sb = new StringBuffer();

    for (int i = 0; i < content.length; i++) {
      sb.append(content[i]);
      sb.append("\n");
    }
    contentBytes = sb.toString().getBytes();
    return contentBytes;
  }

  private byte[] getFileBytes() throws Throwable {
    if (contentBytes != null) {
      return contentBytes;
    }

    ByteArrayOutputStream baos = new ByteArrayOutputStream();

    FileInputStream in = new FileInputStream(contentFileName);

    do {
      int x = in.read();
      if (x < 0) {
        break;
      }
      baos.write(x);
    } while (true);

    contentBytes = baos.toByteArray();

    return contentBytes;
  }
}

