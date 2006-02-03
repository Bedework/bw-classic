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
package org.bedework.dumprestore.restore.rules;

import org.bedework.calfacade.base.BwShareableDbentity;
import org.bedework.dumprestore.restore.RestoreGlobals;

import org.xml.sax.Attributes;

/**
 * @author Mike Douglass   douglm @ rpi.edu
 * @version 1.0
 */
public class EntityRule extends RestoreRule {
  EntityRule(RestoreGlobals globals) {
    super(globals);
  }

  public void begin(String ns, String name, Attributes att) {
    if (globals.debugEntity) {
      trace("About to push entity for " + name);
    }

    String className = (String)RestoreGlobals.classes.get(name);

    if (className == null) {
      throw new RuntimeException("Unable to get class name for " + name);
    }

    Object o = null;

    try {
      Class c = Class.forName(className);

      if (c == null) {
        throw new RuntimeException("Unable to get class for " + name +
                                   " and class " + className);
      }

      o = c.newInstance();
    } catch (ClassNotFoundException e) {
      throw new RuntimeException("Class " + className + " not found");
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }

    push(o);
  }

  /** Set the owner and creator on a shareable entity.
   *
   * @param entity
   * @param name
   * @throws Exception
   */
  public void fixSharableEntity(BwShareableDbentity entity,
                                String name) throws Exception {
    try {
      if (entity.getCreator() == null) {
        warn(name + " " + entity.getId() + " has no creator, set to " +
            globals.getPublicUser().getAccount());

        entity.setCreator(globals.getPublicUser());
      }

      if (entity.getOwner() == null) {
        warn(name + " " + entity.getId() + " has no owner, set to " +
            globals.getPublicUser().getAccount());

        entity.setOwner(globals.getPublicUser());

        if (!entity.getPublick()) {
          warn(name + " " + entity.getId() + " is NOT public");
        }
      }
    } catch (Throwable t) {
      throw new Exception(t);
    }
  }
}

