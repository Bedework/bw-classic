<?xml version="1.0" encoding="UTF-8"?>
<!--
    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--==== BANNER and MENU TABS  ====-->

  <xsl:template name="tabs">
    <ul id="bwAdminMenu">
      <li>
        <xsl:if test="/bedework/tab = 'main'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="{$setup}&amp;listAllEvents=false">
          <xsl:copy-of select="$bwStr-Head-MainMenu"/>
        </a>
      </li>
      <li>
        <xsl:if test="/bedework/tab = 'pending'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="{$initPendingTab}&amp;calPath={$submissionsRootEncoded}&amp;listAllEvents=true&amp;useDbSearch=true">
          <xsl:copy-of select="$bwStr-Head-PendingEvents"/>
        </a>
      </li>
      <xsl:if test="/bedework/currentCalSuite/group = /bedework/userInfo/group">
        <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser = 'true'">
          <li>
            <xsl:if test="/bedework/tab = 'calsuite'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$showCalsuiteTab}">
              <xsl:copy-of select="$bwStr-Head-CalendarSuite"/>
            </a>
          </li>
        </xsl:if>
      </xsl:if>
      <xsl:if test="/bedework/userInfo/superUser='true'">
        <li>
          <xsl:if test="/bedework/tab = 'users'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showUsersTab}">
            <xsl:copy-of select="$bwStr-Head-Users"/>
          </a>
        </li>
        <li>
          <xsl:if test="/bedework/tab = 'system'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showSystemTab}">
            <xsl:copy-of select="$bwStr-Head-System"/>
          </a>
        </li>
      </xsl:if>
    </ul>
  </xsl:template>

</xsl:stylesheet>