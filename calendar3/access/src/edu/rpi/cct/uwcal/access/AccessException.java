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
package edu.rpi.cct.uwcal.access;

/** Various exceptions that can arise during access checks
 *
 * @author Mike Douglass douglm @ rpi.edu
 *
 */
public class AccessException extends Exception {
  private static final String badACEMsg = "org.bedework.access.badace";

  private static final String badACLMsg = "org.bedework.access.badacl";

  private static final String badACLLengthMsg = "org.bedework.access.badacllength";

  private static final String badACLRewindMsg = "org.bedework.access.badaclrewinf";

  /**
   *
   * @param s String exception message
   */
  public AccessException(String s) {
    super(s);
  }

  /**
   *
   * @param s String exception message
   * @param extra String exception message parameter
   */
  public AccessException(String s, String extra) {
    super(s + " " + extra);
  }

  /**
   *
   * @param t Throwable to wrap
   */
  public AccessException(Throwable t) {
    super(t);
  }

  /** We got a bad ACE
   *
   * @param extra String explanation
   * @return AccessException
   */
  public static AccessException badACE(String extra) {
    return new AccessException(badACEMsg, extra);
  }

  /** We got a bad acl
   *
   * @param extra
   * @return AccessException
   */
  public static AccessException badACL(String extra) {
    return new AccessException(badACLMsg, extra);
  }

  /** Error rewinging an ACL
   *
   * @return AccessException
   */
  public static AccessException badACLRewind() {
    return new AccessException(badACLRewindMsg);
  }

  /** ACL length is wrong
   *
   * @return AccessException
   */
  public static AccessException badACLLength() {
    return new AccessException(badACLLengthMsg);
  }
}

