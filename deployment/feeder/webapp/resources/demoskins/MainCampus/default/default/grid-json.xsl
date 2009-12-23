<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>

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

  <!-- Bring in settings and included xsl -->
  <xsl:include href="./config.xsl"/>

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

  <xsl:template name="preprocessCats">
    <xsl:param name="allCats" />
    <xsl:variable name="andCat" select="substring-before($allCats, '~')" />
    <xsl:variable name="orList" select="substring-after($allCats, '~')" />
    <xsl:call-template name="processCats">
      <xsl:with-param name="andCat" select="$andCat" />
      <xsl:with-param name="orList" select="$orList" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="processCats">
    <xsl:param name="andCat" />
    <xsl:param name="orList" />
    <xsl:choose>
	
      <xsl:when test="contains($orList, '~')">   
        <!-- There are 2 or more on the "or" list.  -->
        <xsl:variable name="orCat" select="substring-before($orList, '~')" />
        <xsl:variable name="remainingOrList" select="substring-after($orList, '~')" />
        <!-- Process the first one -->
        <xsl:call-template name="processAndOr">
	      <xsl:with-param name="andCat" select="$andCat"/>
	      <xsl:with-param name="orCat" select="$orCat"/>
	    </xsl:call-template>
        <!-- and use recursion to process the remaining categories -->
        <xsl:call-template name="processCats">
	      <xsl:with-param name="andCat" select="$andCat"/>
          <xsl:with-param name="orList" select="$remainingOrList" />
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <!-- No more tildes, so this is the last or only "or" category.  Call processAndOr to process it -->
        <xsl:call-template name="processAndOr">
	      <xsl:with-param name="andCat" select="$andCat"/>
	      <xsl:with-param name="orCat" select="$orList"/>
	    </xsl:call-template>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

  <xsl:template name="processAndOr">
	<xsl:param name="andCat"/>
    <xsl:param name="orCat" />
	<xsl:choose>
      <xsl:when test="$andCat = 'all'">
        <xsl:choose>
          <xsl:when test="$orCat = 'all'">
          <!-- all categories should be displayed -->
            <xsl:apply-templates select="event" />
          </xsl:when>
          <xsl:otherwise>
            <!-- nothing being anded; display event if it matches "or" category-->
            <xsl:apply-templates select="event[categories/category/uid = $orCat]" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$orCat = 'all'">
            <!-- no or's; display if it matches "and" category -->
            <xsl:apply-templates select="event[categories/category/uid = $andCat]" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <!-- an "and" and an "or", so display if they are both present -->
              <xsl:when test="event/category/uid = $andCat">
                <xsl:apply-templates select="event[categories/category/uid = $orCat]" />
              </xsl:when>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
   	  </xsl:otherwise>
    </xsl:choose>	
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

  <xsl:template match="event">
    <!-- first, escape apostrophes -->
    <xsl:variable name="aposStrippedSummary">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="summary"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="aposStrippedDescription">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="description"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="aposStrippedLocAddress">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="location/address"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <!-- second, strip line breaks -->
    <xsl:variable name="strippedSummary" select='translate($aposStrippedSummary,"&#xA;"," ")'/>
    <xsl:variable name="strippedDescription" select='translate($aposStrippedDescription,"&#xA;"," ")'/>
    <xsl:variable name="strippedLocAddress" select='translate($aposStrippedLocAddress,"&#xA;"," ")'/>
    <!-- finally, produce the JSON output -->
                  {
                    "summary" : "<xsl:value-of select="$strippedSummary"/>",
                    "subscriptionId" : "<xsl:value-of select="subscription/id"/>",
                    "calPath" : "<xsl:value-of select="calendar/encodedPath"/>",
                    "guid" : "<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>",
                    "recurrenceId" : "<xsl:value-of select="recurrenceId"/>",
                    "link" : "<xsl:value-of select='link'/>",
                    "eventlink" : "<xsl:value-of select="$urlprefix"/><xsl:value-of select="$eventView"/>&amp;calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/>",
                    "status" : "<xsl:value-of select='status'/>",
                    "start" : {
                      "allday" : "<xsl:value-of select='start/allday'/>",
                      "shortdate" : "<xsl:value-of select='start/shortdate'/>",
                      "longdate" : "<xsl:value-of select='start/longdate'/>",
                      "dayname" : "<xsl:value-of select='start/dayname'/>",
                      "time" : "<xsl:value-of select='start/time'/>",
                      "utcdate" : "<xsl:value-of select='start/utcdate'/>",
                      "datetime" : "<xsl:value-of select='start/unformatted'/>",
                      "timezone" : "<xsl:value-of select='start/timezone/id'/>"
                    },
                    "end" : {
                      "allday" : "<xsl:value-of select='end/allday'/>",
                      "shortdate" : "<xsl:value-of select='end/shortdate'/>",
                      "longdate" : "<xsl:value-of select='end/longdate'/>",
                      "dayname" : "<xsl:value-of select='end/dayname'/>",
                      "time" : "<xsl:value-of select='end/time'/>",
                      "utcdate" : "<xsl:value-of select='end/utcdate'/>",
                      "datetime" : "<xsl:value-of select='end/unformatted'/>",
                      "timezone" : "<xsl:value-of select='end/timezone/id'/>"
                    },
                    "location" : {
                      "address" : "<xsl:value-of select="$strippedLocAddress"/>",
                      "link" : "<xsl:value-of select='location/link'/>"
                    },
                    "calendar" : {
                      "name" : "<xsl:value-of select='calendar/name'/>",
                      "path" : "<xsl:value-of select='calendar/path'/>",
                      "encodedPath" : "<xsl:value-of select='calendar/encodedPath'/>"
                    },
                    "categories" : [
                      <xsl:for-each select='categories/category'>"<xsl:value-of select='value'/>"<xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>
                    ],
                    "description" : "<xsl:value-of select='$strippedDescription'/>",
                    "xproperties" : [
                      <xsl:for-each select="xproperties/node()[name() != '']">
                      {
                        "<xsl:value-of select='name()'/>" : {
                          "values" : {
                             <xsl:for-each select="values/node()[name() != '']">
                               "<xsl:value-of select='name()'/>" : "<xsl:call-template name="replace"><xsl:with-param name="string" select="."/><xsl:with-param name="pattern" select='"&apos;"'/><xsl:with-param name="replacement" select='"\&apos;"'/></xsl:call-template>"<xsl:if test='position() != last()'>,</xsl:if>
                             </xsl:for-each>
                          }
                        }
                      }<xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>

                    ]
                 }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
