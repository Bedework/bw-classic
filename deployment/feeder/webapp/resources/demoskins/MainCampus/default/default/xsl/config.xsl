<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">


  <!-- **********************************************************************
    Copyright 2009 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
  -->

  <!-- URL of resources common to all bedework apps (javascript, images) -->
  <xsl:variable name="resourceCommons">../../../bedework-common</xsl:variable>

  <!-- URL for resources (images, css, javascript) -->
  <xsl:variable name="resourcesRoot" select="concat($appRoot,'/default/default/theme')"/>

  <!-- DEFINE INCLUDES -->
  <!-- cannot use the resourceCommons variable in xsl:include paths -->
  <xsl:include href="../../../../bedework-common/default/default/errors.xsl"/>
  <xsl:include href="../../../../bedework-common/default/default/messages.xsl"/>
  <xsl:include href="../../../../bedework-common/default/default/util.xsl"/>
  <xsl:include href="../strings.xsl"/>

  <!-- URL of the XSL template directory -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>
 
  <xsl:variable name="bwCacheHostUrl">http://localhost:3000</xsl:variable>
  <xsl:variable name="bwCalendarHostURL">http://localhost:8080</xsl:variable>

  <!-- Properly encoded prefixes to the application actions; use these to build
      urls; allows the application to be used without cookies or within a portal.
      These urls are rewritten in header.jsp and simply passed through for use
      here. Every url includes a query string (either ?b=de or a real query
      string) so that all links constructed in this stylesheet may begin the
      query string with an ampersand. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef"/>
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export"/>
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent"/>
  

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  
</xsl:stylesheet>
