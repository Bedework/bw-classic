/* **********************************************************************
    Copyright 2008 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
    to the maximum extent the law permits. */

/* NOTE: this file is different between Bedework web applications and is
   therefore not currently interchangable between apps.  This will be normalized
   in the coming versions, but for now don't try to exchange them. */

// jQuery stuff for the detailed event view.
// These functions support edit and download menuing for recurring events.
// All recurring events have two actions: one that can be performed on the
// master event and one that can be performed on the instance.

$(document).ready(function() {

  // edit button
  $("#bwEditRecurButton").hover(
    function () {
      $("#bwEditRecurWidget").show();
    },
    function () {
      $("#bwEditRecurWidget").hide();
    }
  );

  // download button
  $("#bwDownloadButton").hover(
    function () {
      $("#bwDownloadWidget").show();
    },
    function () {
      $("#bwDownloadWidget").hide();
    }
  );

  // copy button
  $("#bwCopyRecurButton").hover(
    function () {
      $("#bwCopyRecurWidget").show();
    },
    function () {
      $("#bwCopyRecurWidget").hide();
    }
  );

  // delete button
  $("#bwDeleteRecurButton").hover(
    function () {
      $("#bwDeleteRecurWidget").show();
    },
    function () {
      $("#bwDeleteRecurWidget").hide();
    }
  );

  // link button
  $("#bwLinkRecurButton").hover(
    function () {
      $("#bwLinkRecurWidget").show();
    },
    function () {
      $("#bwLinkRecurWidget").hide();
    }
  );

});
