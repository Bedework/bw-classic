<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>

  <!-- **********************************************************************
    Copyright 2010 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed "AS IS" without any express or
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
  <xsl:include href="./xsl/categoryFiltering.xsl"/>

  <!--  global variables --> 
  <xsl:variable name="urlprefix" select="/bedework/urlprefix"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>

  <xsl:template match='/'>
    <xsl:choose>
      <xsl:when test="/bedework/appvar/key = 'objName'">
        var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {'bwEventCalendar': {
      </xsl:when>
      <xsl:otherwise>
      {"bwEventCalendar": {
      </xsl:otherwise>
    </xsl:choose>
        "year": {
          "value": "<xsl:value-of select='/bedework/eventscalendar/year/value'/>",
         <xsl:apply-templates select="/bedework/eventscalendar/year/month" />
      }
      }}
  </xsl:template>

  

  <xsl:template match="month">
      "month": {
        "value" : "<xsl:value-of select='value'/>",
        "longname" : "<xsl:value-of select='longname'/>",
        "shortname" : "<xsl:value-of select='shortname'/>",
        "weeks" : [
          <xsl:apply-templates select="week" />
          ]
        }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>

  <xsl:template match="week">
        {
          "value" : "<xsl:value-of select='value'/>",
          "days" : [
             <xsl:apply-templates select="day" />
          ]
        }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>

  <xsl:template match="day">
          {
            <xsl:choose>
            <xsl:when test="filler = 'true'">
            "filler" : "<xsl:value-of select='filler'/>"
            </xsl:when>
            <xsl:otherwise>
            "filler" : "<xsl:value-of select='filler'/>",
            "value" : "<xsl:value-of select='value'/>",
            "name" : "<xsl:value-of select='name'/>",
            "date" : "<xsl:value-of select='date'/>",
            "longdate" : "<xsl:value-of select='longdate'/>",
            "shortdate" : "<xsl:value-of select='shortdate'/>",
            "events" : [
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
              ]
            </xsl:otherwise>
          </xsl:choose>
        }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
