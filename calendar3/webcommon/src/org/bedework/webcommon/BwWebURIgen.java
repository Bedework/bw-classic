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

package org.bedework.webcommon;

import org.bedework.calfacade.BwLocation;
import org.bedework.calfacade.BwSponsor;
import org.bedework.calfacade.CalFacadeException;

import edu.rpi.cct.uwcal.common.URIgen;

import java.net.URI;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** This class defines methods used to return uris which will provide access
 * to entities located somewhere in the implementing calendar system.
 *
 * <p>For example, a call to getLocationURI(loc) might return something like<br/>
 *     "http://cal.myplace.edu/ucal/locations.do?id=1234"
 *
 * <p>Implementing classes will be used by services like the synch process
 * which needs to embed usable urls in the generated Icalendar objects.
 *
 * The generated
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class BwWebURIgen implements URIgen {
  private String urlPrefix;

  private Pattern locidPattern = Pattern.compile("(.*locationId=)(\\d*)");
  private Pattern spidPattern = Pattern.compile("(.*sponsorId=)(\\d*)");

  /** Constructor - the prefix must point to a server application which
   * implements the requests built below. This application should run
   * unauthenticated or authenticated but in unauthenticated mode it will
   * only return public entities.
   *
   * @param urlPrefix   String value which will prefix all the urls.
   *                    Does NOT have trailing "/"
   */
  public BwWebURIgen(String urlPrefix) {
    this.urlPrefix = urlPrefix;
  }

  public URI getLocationURI(BwLocation val) throws CalFacadeException {
    try {
      return new URI(urlPrefix + "/location.do?locationId=" + val.getId());
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  /* (non-Javadoc)
   * @see edu.rpi.cct.uwcal.common.URIgen#getLocation(java.net.URI)
   */
  public BwLocation getLocation(URI val) throws CalFacadeException {
    try {
      String query = val.getQuery();

      if (query == null) {
        throw new CalFacadeException("Not a location URI");
      }

      Matcher m = locidPattern.matcher(query);

      if (!m.matches()) {
        throw new CalFacadeException("Not a location URI");
      }

      Integer id = Integer.valueOf(m.group(2));

      BwLocation loc = new BwLocation();

      loc.setId(id.intValue());

      return loc;
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  public URI getSponsorURI(BwSponsor val) throws CalFacadeException {
    try {
      return new URI(urlPrefix + "/contact.do?sponsorId=" + val.getId());
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }

  public BwSponsor getSponsor(URI val) throws CalFacadeException {
    try {
      String query = val.getQuery();

      if (query == null) {
        throw new CalFacadeException("Not a sponsor URI");
      }

      Matcher m = spidPattern.matcher(query);

      if (!m.matches()) {
        throw new CalFacadeException("Not a sponsor URI");
      }

      Integer id = Integer.valueOf(m.group(2));

      BwSponsor sp = new BwSponsor();

      sp.setId(id.intValue());

      return sp;
    } catch (CalFacadeException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new CalFacadeException(t);
    }
  }
}

