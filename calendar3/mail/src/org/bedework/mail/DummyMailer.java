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
package org.bedework.mail;

import org.bedework.calfacade.BwCalendar;
import org.bedework.calfacade.BwUser;
import org.bedework.calfacade.CalFacadeException;
import org.bedework.calsvci.CalSvcI;

import java.util.Collection;
import java.util.Vector;

import org.apache.log4j.Logger;

/** A dummy mailer which just writes to the log.
 *
 * @author  Mike Douglass douglm@rpi.edu
 */
public class DummyMailer implements MailerIntf {
  //private boolean debug;

  private Logger log;

  public void init(CalSvcI svci, boolean debug) throws CalFacadeException {
    //this.debug = debug;
  }

  public void addList(BwCalendar cal) throws CalFacadeException {
    debugMsg("addList called with " + cal.getName());
  }

  public void deleteList(BwCalendar cal) throws CalFacadeException {
    debugMsg("deleteList called with " + cal.getName());
  }

  public Collection listLists() throws CalFacadeException {
    debugMsg("listLists called");
    return new Vector();
  }

  public boolean checkList(BwCalendar cal) throws CalFacadeException {
    debugMsg("checkList called with " + cal.getName());
    return true;
  }

  public void postList(BwCalendar cal, Message val) throws CalFacadeException {
    debugMsg("postList called with " + cal.getName() + " and message:");
    debugMsg(val.toString());
  }

  public void addUser(BwCalendar cal, BwUser user) throws CalFacadeException {
    debugMsg("addUser called with " + cal.getName() + " and user " +
             user.getAccount());
  }

  public void removeUser(BwCalendar cal, BwUser user) throws CalFacadeException {
    debugMsg("removeUser called with " + cal.getName() + " and user " +
             user.getAccount());
  }

  public boolean checkUser(BwCalendar cal, BwUser user) throws CalFacadeException {
    debugMsg("checkUser called with " + cal.getName() + " and user " +
             user.getAccount());
    return true;
  }

  public void updateUser(BwCalendar cal, BwUser user, String newEmail)
        throws CalFacadeException {
    debugMsg("updateUser called with " + cal.getName() + " and user " +
             user.getAccount() + " and new email " + newEmail);
  }

  public Collection listUsers(BwCalendar cal) throws CalFacadeException {
    debugMsg("listUsers called with " + cal.getName());
    return new Vector();
  }

  public void post(Message val) throws CalFacadeException {
    debugMsg("Mailer called with:");
    debugMsg(val.toString());
  }

  private Logger getLog() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void debugMsg(String msg) {
    getLog().debug(msg);
  }
}
