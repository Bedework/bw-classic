<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>
  <!-- JSON representation of Bedework categories (only)
       Bedework v3.6.x, Arlen Johnson

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
    var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {"bwCategories": {
      </xsl:when>
      <xsl:otherwise>
    {"bwCategories": {
      </xsl:otherwise>
    </xsl:choose>
        "categories": [
            <xsl:apply-templates select="/bedework/categories/category"/>
        ]
    }}
  </xsl:template>

  <xsl:template match="category">
    <!-- first, escape apostrophes -->
    <xsl:variable name="aposStrippedKeyword">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="value"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <!-- second, strip line breaks -->
    <xsl:variable name="strippedKeyword" select='translate($aposStrippedKeyword,"&#xA;"," ")'/>
    <!-- finally, produce the JSON output -->
            {
                "value" : "<xsl:value-of select="$strippedKeyword"/>",
                "id" : "<xsl:value-of select="id"/>",
                "uid" : "<xsl:value-of select="uid"/>",
                "creator" : "<xsl:value-of select="creator"/>"
            }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
