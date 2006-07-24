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
package org.bedework.calfacade.env;

import org.bedework.calfacade.CalEnvException;

/** Obtain a CalEnv object.
 *
 */
public class CalEnvFactory {
  private final static String envclass = "org.bedework.calenv.CalEnv";

  /** Obtain and initialise a caldav object using the given prefix.
  *
  * @param appPrefix
  * @param debug
   * @return CalEnvI
  * @throws CalEnvException
  */
  public static CalEnvI getEnv(String appPrefix, boolean debug) throws CalEnvException {
    try {
      Object o = Class.forName(envclass).newInstance();

      if (o == null) {
        throw new CalEnvException("Class " + envclass + " not found");
      }

      if (!(o instanceof CalEnvI)) {
        throw new CalEnvException("Class " + envclass +
                                  " is not a subclass of " +
                                  CalEnvI.class.getName());
      }

      CalEnvI env = (CalEnvI)o;

      env.init(appPrefix, debug);

      return env;
    } catch (CalEnvException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new CalEnvException(t);
    }
  }
}
