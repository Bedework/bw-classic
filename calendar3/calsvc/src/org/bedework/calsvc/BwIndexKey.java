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
package org.bedework.calsvc;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.CalFacadeDefs;
import org.bedework.calsvci.CalSvcI;

import edu.rpi.cct.misc.indexing.Index;
import edu.rpi.cct.misc.indexing.IndexException;

import java.io.CharArrayWriter;
import java.util.Collection;

/**
 * @author Mike Douglass douglm @ rpi.edu
 *
 */
public class BwIndexKey extends Index.Key {
  private CalSvcI svci;

  private String key1; // calendar:path
  private String key2; // event:guid
  private String key3; // event:recurrenceid

  /** An event key is stored as a concatenated set of Strings,
   * calendar:path + guid + (recurrenceid | null).
   *
   * <p>We set it here and use the decode methods to split it up.
   */
  private char[] encoded;

  private String itemType;

  public BwIndexKey() {
  }

  public BwIndexKey(CalSvcI svci) {
    this.svci = svci;
  }

  public BwIndexKey(CalSvcI svci, float score) {
    this.score = score;
    this.svci = svci;
  }

  public void setItemType(String val) {
    itemType = val;
  }

  public void setScore(float val) {
    score = val;
  }

  public void setCalendarKey(String key1) {
    this.key1 = key1;
  }

  public void setEventKey(String key) throws IndexException {
    encoded = key.toCharArray();
    pos = 0;

    this.key1 = getKeyString();
    this.key2 = getKeyString();
    this.key3 = getKeyString();
  }

  public String makeEventKey(String key1, String key2,
                             String key3) throws IndexException {
    startEncoding();
    encodeString(key1);
    encodeString(key2);
    encodeString(key3);

    return getEncodedKey();
  }

  public Object getRecord() throws IndexException {
    try {
      if (itemType == null) {
        throw new IndexException("org.bedework.index.nullkeyitemtype");
      }

      if (itemType.equals(BwIndexLuceneDefs.itemTypeCalendar)) {
        return svci.getCalendar(key1);
      }

      if (itemType.equals(BwIndexLuceneDefs.itemTypeEvent)) {
        BwCalendar cal = svci.getCalendar(key1);
        if (cal == null) {
          return null;
        }
        Collection eis = svci.getEvent(null, cal, key2, key3,
                                       CalFacadeDefs.retrieveRecurExpanded);
        if ((eis == null) || (eis.size() == 0)) {
          return null;
        }

        return eis.iterator().next();
      }

      throw new IndexException(IndexException.unknownRecordType,
                               itemType);
    } catch (IndexException ie) {
      throw ie;
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /* ====================================================================
   *                 Key decoding methods
   * ==================================================================== */

  /** Current position in the key */
  private int pos;

  /** When encoding a key we build it here.
   */
  private CharArrayWriter caw;

  /** Get next char from encoded value. Return < 0 for no more
   *
   * @return char value
   */
  public char getChar() {
    if ((encoded == null) || (pos == encoded.length)) {
      return (char)-1;
    }

    char c = encoded[pos];
    pos++;

    return c;
  }

  /** Back off one char
   *
   * @throws AccessException
   */
  public void back() throws IndexException {
    back(1);
  }

  /** Back off n chars
   *
   * @param n   int number of chars
   * @throws AccessException
   */
  public void back(int n) throws IndexException {
    if (pos - n < 0) {
      throw new IndexException("org.bedework.index.badKeyRewind");
    }

    pos -= n;
  }

  /** Get current position
   *
   * @return int position
   */
  public int getPos() {
    return pos;
  }

  /** Set current position
   *
   * @param val  int position
   */
  public void setPos(int val) {
    pos = val;
  }

  /** Get number of chars remaining
   *
   * @return int number of chars remaining
   */
  public int remaining() {
    if (encoded == null) {
      return 0;
    }
    return encoded.length - pos;
  }

  /** Test for more
   *
   * @return boolean true for more
   */
  public boolean hasMore() {
    return remaining() > 0;
  }

  /** Test for no more
   *
   * @return boolean true for no more
   */
  public boolean empty() {
    return (encoded == null) || (encoded.length == 0);
  }

  /** Rewind to the start
   */
  public void rewind() {
    pos = 0;
  }

  /** Return the value of a blank terminated length. On success current pos
   * has been incremented.
   *
   * @return int length
   * @throws AccessException
   */
  public int getLength() throws IndexException {
    int res = 0;

    for (;;) {
      char c = getChar();
      if (c == ' ') {
        break;
      }

      if (c < 0) {
        throw new IndexException("org.bedework.index.badKeyLength");
      }

      if ((c < '0') || (c > '9')) {
        throw new IndexException("org.bedework.index.badkeychar");
      }

      res = res * 10 + Character.digit(c, 10);
    }

    return res;
  }

  /** Get a String from the encoded acl at the current position.
   *
   * @return String decoded String value
   * @throws AccessException
   */
  public String getKeyString() throws IndexException {
    if (getChar() == 'N') {
      return null;
    }
    back();
    int len = getLength();

    if ((encoded.length - pos) < len) {
      throw new IndexException("org.bedework.index.badKeyLength");
    }

    String s = new String(encoded, pos, len);
    pos += len;

    return s;
  }

  /** Skip a String from the encoded acl at the current position.
   *
   * @throws AccessException
   */
  public void skipString() throws IndexException {
    if (getChar() == 'N') {
      return;
    }

    back();
    int len = getLength();
    pos += len;
  }

  /* ====================================================================
   *                 Encoding methods
   * ==================================================================== */

  /** Get ready to encode
   *
   */
  public void startEncoding() {
    caw = new CharArrayWriter();
  }

  /** Encode a blank terminated 0 prefixed length.
   *
   * @param len
   * @throws AccessException
   */
  public void encodeLength(int len) throws IndexException {
    try {
      String slen = String.valueOf(len);
      caw.write('0');
      caw.write(slen, 0, slen.length());
      caw.write(' ');
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /** Encode a String with length prefix. String is encoded as <ul>
   * <li>One byte 'N' for null string or</li>
   * <li>length {@link #encodeLength(int)} followed by</li>
   * <li>String value.</li>
   * </ul>
   *
   * @param val
   * @throws AccessException
   */
  public void encodeString(String val) throws IndexException {
    try {
      if (val == null) {
        caw.write('N'); // flag null
      } else {
        encodeLength(val.length());
        caw.write(val, 0, val.length());
      }
    } catch (IndexException ie) {
      throw ie;
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /** Add a character
   *
   * @param c char
   * @throws AccessException
   */
  public void addChar(char c) throws IndexException {
    try {
      caw.write(c);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /** Get the current encoed value
   *
   * @return char[] encoded value
   */
  public String getEncodedKey() {
    return new String(caw.toCharArray());
  }
}
