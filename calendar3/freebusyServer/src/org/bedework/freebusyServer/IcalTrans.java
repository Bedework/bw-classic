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
package org.bedework.freebusyServer;

import org.bedework.calfacade.CalFacadeException;
import org.bedework.calsvc.CalSvc;
import org.bedework.calsvci.CalSvcI;
import org.bedework.calsvci.CalSvcIPars;
import org.bedework.icalendar.IcalTranslator;

import java.io.InputStreamReader;
import java.util.Collection;

/** Translate to/from ical. This requires the ability to get timezone info so
 * we use the bedework svci and ical translator.
 *
 * @author Mike Douglass
 */
public class IcalTrans {
  private boolean debug;

  private CalSvcI svci;
  private IcalTranslator trans;

  /** Constructor
   *
   * @param debug
   * @throws Throwable
   */
  public IcalTrans(boolean debug) throws Throwable {
    this.debug = debug;

    getSvci(); //
  }

  /**
   *
   * @throws CalFacadeException
   */
  private void getSvci() throws CalFacadeException {
    boolean publicMode = true;

    if (svci != null) {
      if (!svci.isOpen()) {
        svci.open();
        svci.beginTransaction();
      }

      return;
    }

    svci = new CalSvc();
    /* account is what we authenticated with.
     * user, if non-null, is the user calendar we want to access.
     */
    CalSvcIPars pars = new CalSvcIPars(null, // account,
                                       null, // account,
                                       null, // calSuite,
                                       "org.bedework.app.freebusy.",
                                       publicMode,
                                       true,    // caldav
                                       null, // synchId
                                       debug);
    svci.init(pars);

    svci.open();
    svci.beginTransaction();

    trans = new IcalTranslator(svci.getIcalCallback(), debug);
  }

  /**
   * @param in
   * @return Collection
   * @throws Throwable
   */
  public Collection getFreeBusy(InputStreamReader in) throws Throwable {
    return trans.fromIcal(null, in);
  }

  /**
   * @throws CalFacadeException
   */
  public void close() throws CalFacadeException {
    if ((svci == null) || !svci.isOpen()) {
      return;
    }

    try {
      svci.endTransaction();
    } catch (CalFacadeException cfe) {
      try {
        svci.close();
      } catch (Throwable t1) {
      }
      svci = null;
      throw cfe;
    }

    try {
      svci.close();
    } catch (CalFacadeException cfe) {
      svci = null;
      throw cfe;
    }
  }
}
