<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>
  <!-- JSON feed of Bedework events,
       Bedework v3.6, Arlen Johnson

       Purpose: produces an array of javascript objects representing events.

  -->

  <!-- **********************************************************************
    Copyright 2010 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
  
  <!-- Bring in settings and included xsl -->
  <xsl:include href="./xsl/config.xsl"/>
  <!-- Provides event template -->
  <xsl:include href="./xsl/jsonEvent.xsl"/>
  <!-- Provides category filter templates -->
  <xsl:include href="./xsl/jsonCategoryFiltering.xsl"/>

  <!--  global variables -->
  <xsl:variable name="urlprefix" select="/bedework/urlprefix"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>

  <xsl:template match='/'>
    <xsl:choose>
      <xsl:when test="/bedework/appvar/key = 'objName'">
        var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {'bwEventList': {
      </xsl:when>
      <xsl:otherwise>
        {'bwEventList': {
      </xsl:otherwise>
    </xsl:choose>
        'events': [
           <xsl:apply-templates select="/bedework/events" />
        ]
    }}
  </xsl:template>

  <xsl:template match="events">
	<xsl:choose>
	  <xsl:when test="/bedework/appvar/key = 'filter'">
		<xsl:variable name="filterName" select="substring-before(/bedework/appvar[key='filter']/value,':')"/>
		<xsl:variable name="filterVal" select="substring-after(/bedework/appvar[key='filter']/value,':')"/>
		<!-- Define filters here: -->
		<xsl:choose>
	      <xsl:when test="$filterName = 'grpAndCats'">
			<xsl:call-template name="preprocessCats">
			  <xsl:with-param name="allCats" select="$filterVal"/>
			</xsl:call-template>
	      </xsl:when>
		  <xsl:otherwise>
			<!-- Filter name not defined? Turn off filtering. -->
			<xsl:apply-templates select="event"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:apply-templates select="event"/>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>
</xsl:stylesheet>


