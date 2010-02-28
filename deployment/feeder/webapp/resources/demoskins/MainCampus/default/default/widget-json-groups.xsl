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
	<xsl:choose>
      <xsl:when test="/bedework/appvar/key = 'objName'">
    var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {"bwGroups": {
      </xsl:when>
      <xsl:otherwise>
    {"bwGroups": {
      </xsl:otherwise>
    </xsl:choose>
        "groups": [
            <xsl:apply-templates select="/bedework/groups/group"/>
        ]
    }}
  </xsl:template>

  <xsl:template match="group">
    {
      "eventOwner" : "<xsl:value-of select="eventOwner"/>",
       "name" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="name"/></xsl:call-template>",
       "description" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="description"/></xsl:call-template>",
       "memberOf" : [
                      {
                      <xsl:apply-templates select="memberof"/>
                      }
                    ]
     }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
   
  <xsl:template match="memberof">
                         "name" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="name"/></xsl:call-template>"<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
