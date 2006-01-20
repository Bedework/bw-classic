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

package org.bedework.httpunit.admin;

import org.bedework.httpunit.utils.TestUtils;

import com.meterware.httpunit.SubmitButton;
import com.meterware.httpunit.TableCell;
import com.meterware.httpunit.WebConversation;
import com.meterware.httpunit.WebForm;
import com.meterware.httpunit.WebLink;
import com.meterware.httpunit.WebRequest;
import com.meterware.httpunit.WebTable;

import java.util.ArrayList;

/** Class to provide basic httpunit interactions with the admin client.
 *
 */
public class TestAdminUtils extends TestUtils {
  /** Link to log out
   */
  WebLink logoutLink;

  /** Link to get the add event form
   */
  WebLink addEventFormLink;

  /** Link to get the edit events page
   */
  WebLink editEventsLink;

  /** Link to get the add location form
   */
  WebLink addLocationFormLink;

  /** Link to get the edit locations page
   */
  WebLink editLocationsLink;

  /** Link to get the add sponsor form
   */
  WebLink addSponsorFormLink;

  /** Link to get the edit sponsors page
   */
  WebLink editSponsorsLink;

  /**
   * @param urlBase
   * @param contextRoot
   * @param wc
   */
  public TestAdminUtils(String urlBase,
                        String contextRoot,
                        WebConversation wc) {
    super(urlBase, contextRoot, wc);
  }

  /**
   * @return true for ok
   */
  public boolean logout() {
    try {
     resp = wc.getResponse(logoutLink.getRequest());
     return true;
    } catch (Throwable t) {
      fail(t);
      return false;
    }
  }

  /** Ensure that the current response is the main menu page.
   * Extract a number of links from the page.
   *
   * @return true for ok
   */
  public boolean verifyMainPage() {
    dumpResponse(resp);

    logoutLink = expectLinkWithText("Log Out", "logout link");

    WebTable tbl = expectTableWithID("mainMenuTable", "main menu table");

    if (tbl == null) {
      return false;
    }

    int rows = tbl.getRowCount();

    if (rows < 3) {
      fail("Expect at least 3 main menu table rows");
    }

    addEventFormLink = expectLinkWithText(tbl, 0, 1,
                                          "Add", "add event form link");
    if (addEventFormLink == null) {
      return false;
    }

    editEventsLink = expectLinkWithText(tbl, rows - 2, 2,
                                       "Edit", "edit event link");
    if (editEventsLink == null) {
      return false;
    }

    addSponsorFormLink = expectLinkWithText(tbl, rows - 2, 1,
                                            "Add", "add sponsor form link");
    if (addSponsorFormLink == null) {
      return false;
    }

    editSponsorsLink = expectLinkWithText(tbl, rows - 2, 2,
                                          "Edit", "edit sponsors link");
    if (editSponsorsLink == null) {
      return false;
    }

    addLocationFormLink = expectLinkWithText(tbl, rows - 1, 1,
                                             "Add", "add location form link");
    if (addLocationFormLink == null) {
      return false;
    }

    editLocationsLink = expectLinkWithText(tbl, rows - 1, 2,
                                           "Edit", "edit locations link");
    if (editLocationsLink == null) {
      return false;
    }

    return true;
  }

  /** Get the location form then send a new location request.
   *
   * <p>We really want to save the entire request so we can resubmit it at
   * some inappropriate place.
   *
   * <p>We could extend this to check for failures on resubmission of a
   * duplicate.
   *
   * @param address
   * @param subAddress
   * @param locLink
   * @return link which goes to the edit location page.
   * @throws Throwable
   */
  public WebLink addLocation(String address,
                             String subAddress,
                             String locLink) throws Throwable {
    resp = wc.getResponse(addLocationFormLink.getRequest());
    WebForm form = resp.getForms()[0];

    form.setParameter("location.address", address);

    if (subAddress != null) {
      form.setParameter("location.subaddress", subAddress);
    }

    if (locLink != null) {
      form.setParameter("location.link", locLink);
    }

    /* Get the addLocation submit button */
    SubmitButton button = form.getSubmitButton("addLocation");

    WebRequest req = form.getRequest(button);

    info("About to submit request: " + req);

    setLastResponse(form.submit(button));

    WebLink link = findLocationEditLink(address);
    if (link == null) {
      return null;
    }

    String[] ids = link.getParameterValues("location.id");
    if (ids == null)  {
      fail("Missing location request parameter location.id");
      return null;
    }

    if (ids.length != 1)  {
      fail("Bad location request parameter location.id");
      return null;
    }

    info("Location " + address + " added with id " + ids[0]);

    return link;
  }

  /** The current response contains the list of locations..
   *
   * @param address
   * @return link to edit the location.
   */
  public WebLink findLocationEditLink(String address) {
    try {
      WebTable tbl = expectTableWithID("commonListTable", "location list table");

      if (tbl == null) {
        return null;
      }

      int rows = tbl.getRowCount();

      /* first row is the heading */
      for (int i = 1; i < rows; i++) {
        TableCell cell = tbl.getTableCell(i, 0);

        WebLink link = cell.getLinkWith(address);

        if (link != null) {
          return link;
        }
      }

      fail("Couldn't find location " + address);

      return null;
    } catch (Throwable t) {
      fail(t);
      return null;
    }
  }

  /**
   * @return list of edit location links
   */
  public ArrayList getLocationEditLinks() {
    try {
      resp = wc.getResponse(editLocationsLink.getRequest());

      WebTable tbl = expectTableWithID("commonListTable", "location list table");

      if (tbl == null) {
        return null;
      }

      int rows = tbl.getRowCount();
      ArrayList links = new ArrayList();

      /* first row is the heading */
      for (int i = 1; i < rows; i++) {
        TableCell cell = tbl.getTableCell(i, 0);

        WebLink[] ls = cell.getLinks();

        if ((ls == null) || (ls.length != 1)) {
          fail("Expected exactly 1 link in sponsors commonListTable cell.");
          return null;
        }

        links.add(ls[0]);
      }

      return links;
    } catch (Throwable t) {
      fail(t);
      return null;
    }
  }

  /** Get the sponsor form then send a new sponsor request.
   *
   * <p>We really want to save the entire request so we can resubmit it at
   * some inappropriate place.
   *
   * <p>We could extend this to check for failures on resubmission of a
   * duplicate.
   *
   * @param name
   * @param phoneAreaCode
   * @param phoneBegin
   * @param phoneEnd
   * @param spLink
   * @param email
   * @param phoneExtra
   * @return link which goes to the edit sponsor page.
   * @throws Throwable
   */
  public WebLink addSponsor(String name,
                             String phoneAreaCode,
                             String phoneBegin,
                             String phoneEnd,
                             String spLink,
                             String email,
                             String phoneExtra) throws Throwable {
    resp = wc.getResponse(addSponsorFormLink.getRequest());
    WebForm form = resp.getForms()[0];

    form.setParameter("sponsor.name", name);
    /* required but allow null parameter to check response
     */
    if (phoneAreaCode != null) {
      form.setParameter("phoneAreaCode", phoneAreaCode);
    }

    /* required but allow null parameter to check response
     */
    if (phoneBegin != null) {
      form.setParameter("phoneBegin", phoneBegin);
    }

    /* required but allow null parameter to check response
     */
    if (phoneEnd != null) {
      form.setParameter("phoneEnd", phoneEnd);
    }

    if (spLink != null) {
      form.setParameter("sponsor.link", spLink);
    }

    if (email != null) {
      form.setParameter("sponsor.email", email);
    }

    if (phoneExtra != null) {
      form.setParameter("phoneExtra", phoneExtra);
    }

    /* Get the addSponsor submit button */
    SubmitButton button = form.getSubmitButton("addSponsor");

    WebRequest req = form.getRequest(button);

    info("About to submit request: " + req);

    setLastResponse(form.submit(button));

    WebLink link = findSponsorEditLink(name);
    if (link == null) {
      return null;
    }

    String[] ids = link.getParameterValues("sponsor.id");
    if (ids == null)  {
      fail("Missing location request parameter sponsor.id");
      return null;
    }

    if (ids.length != 1)  {
      fail("Bad sponsor request parameter sponsor.id");
      return null;
    }

    info("Sponsor " + name + " added with id " + ids[0]);

    return link;
  }

  /** The current response contains the list of sponsors..
   *
   * @param name
   * @return link to edit the sponsor.
   */
  public WebLink findSponsorEditLink(String name) {
    try {
      WebTable tbl = expectTableWithID("commonListTable", "sponsor list table");

      if (tbl == null) {
        return null;
      }

      int rows = tbl.getRowCount();

      /* first row is the heading */
      for (int i = 1; i < rows; i++) {
        TableCell cell = tbl.getTableCell(i, 0);

        WebLink link = cell.getLinkWith(name);

        if (link != null) {
          return link;
        }
      }

      fail("Couldn't find sponsor " + name);

      return null;
    } catch (Throwable t) {
      fail(t);
      return null;
    }
  }

  /**
   * @return edit sponsor links
   */
  public ArrayList getSponsorEditLinks() {
    try {
      resp = wc.getResponse(editSponsorsLink.getRequest());

      WebTable tbl = expectTableWithID("commonListTable", "sponsor list table");

      if (tbl == null) {
        return null;
      }

      int rows = tbl.getRowCount();
      ArrayList links = new ArrayList();

      /* first row is the heading */
      for (int i = 1; i < rows; i++) {
        TableCell cell = tbl.getTableCell(i, 0);

        WebLink[] ls = cell.getLinks();

        if ((ls == null) || (ls.length != 1)) {
          fail("Expected exactly 1 link in sponsors commonListTable cell.");
          return null;
        }

        links.add(ls[0]);
      }

      return links;
    } catch (Throwable t) {
      fail(t);
      return null;
    }
  }
}

