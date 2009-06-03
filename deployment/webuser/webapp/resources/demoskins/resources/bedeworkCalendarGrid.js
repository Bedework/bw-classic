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

// jQuery stuff for the calendar grid.
// These functions support contextual menus for events and day cells in the
// week and month calendar grids

$(document).ready(function() {

  // an active day in the calendar grid
  $("td.bwActiveDay").click (
    function (event) {
      // only activate if we've clicked the table cell itself
      var $targ = $(event.target);
      if ($targ.is("td")) {
        $(this).children("div").children("div.bwActionIcons").toggle("fast");
      }
    }
  );

  // hover effects to auto-hide the action icons;
  // do this on both the actions and table cells.
  $("td.bwActiveDay").hover (
    function() {
      // do nothing on mouseover
    },
    function () {
      $("div.bwActionIcons").hide();
    }
  );
  $("div.bwActionIcons").hover (
    function() {
      // do nothing on mouseover
    },
    function () {
      $("div.bwActionIcons").hide();
    }
  );

  $("div.listAdd").hover (
    function () {
      $(this).children("div.bwActionIcons").show("fast");
    },
    function () {
      $(this).children("div.bwActionIcons").hide("fast");
    }
  );

  // EVENT MENUS and TOOLTIPS

  $("li.event").hover (
    function () {
      $(this).children("div.eventTip").show();
    },
    function () {
      $(this).children("div.eventTip").hide();
    }
  );

  $("div.eventTip").click (
    function () {
      $(this).slideUp("fast");
    }
  );


});

