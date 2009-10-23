<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>
  <!-- JSON representation of Bedework categories (only)
       Bedework v3.6.x, Barry Leibson

       Purpose: produces an array of javascript objects representing categories.

       Usage: provide a list of categories for form building, particualary for
       the URL Builder.

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
    to the maximum extent the law permits. -->

  <!-- DEFINE INCLUDES -->
  <!-- util.xsl belongs in bedework-common on your application server for use
       by all stylesheets: -->
  <xsl:include href="../../../bedework-common/default/default/util.xsl"/>
  
  <xsl:template match='/'>
    {"bwGroups": {
        "groups": [
            <xsl:apply-templates select="/bedework/groups/group"/>
        ]
    }}
  </xsl:template>

  <xsl:template match="group">
    <!-- escape apostrophes from group name -->
    <xsl:variable name="aposStrippedName">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="name"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <!-- first, escape apostrophes from group description -->
    <xsl:variable name="aposStrippedDescription">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="description"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <!-- second, escape quotes -->
    <xsl:variable name="aposAndQuotesStrippedDescription">
      <xsl:variable name="quote">&quot;</xsl:variable>
      <xsl:variable name="escQuote"><xsl:text>\</xsl:text>&quot;</xsl:variable>  
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="$aposStrippedDescription"/>
        <xsl:with-param name="pattern" select="$quote"/>
        <xsl:with-param name="replacement" select="$escQuote"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- third, strip line breaks -->
    <xsl:variable name="strippedDescription" select='translate($aposAndQuotesStrippedDescription,"&#xA;"," ")'/>
    <!-- finally, produce the JSON output -->
    {
      "eventOwner" : "<xsl:value-of select="eventOwner"/>",
       "name" : "<xsl:value-of select="$aposStrippedName"/>",
       "description" : "<xsl:value-of select="$strippedDescription"/>",
       "memberOf" : [
                      {
                      <xsl:apply-templates select="memberof"/>
                      }
                    ]
     }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
   
  <xsl:template match="memberof">
    <!-- escape apostrophes from name -->
    <xsl:variable name="aposStrippedMemberOfName">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="name"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
                         "name" : "<xsl:value-of select="$aposStrippedMemberOfName"/>"<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
