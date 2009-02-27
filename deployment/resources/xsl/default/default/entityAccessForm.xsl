<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="entityAccessForm">
    <xsl:param name="type"/><!-- optional: currently used for inbox and outbox to conditionally display scheduling access -->
    <xsl:param name="acl"/><!-- required: nodeset of entity acls used to initialize javascript object. -->
    <xsl:param name="outputId"/><!-- required: id of the current access block display to update -->

    <table cellpadding="0" id="accessFormTable" class="common">
      <tr>
        <th colspan="2" class="commonHeader">Add:</th>
      </tr>
      <tr>
        <td>
          <h5>Who:</h5>
          <div class="whoTypes">
            <input type="text" name="who" size="20"/><br/>
            <input type="radio" value="user" name="whoType" checked="checked"/> user
            <input type="radio" value="group" name="whoType"/> group
            <p>OR</p>
            <p>
              <input type="radio" value="owner" name="whoType"/> owner<br/>
              <input type="radio" value="auth" name="whoType"/> authenticated<br/>
              <input type="radio" value="unauth" name="whoType"/> unauthenticated<br/>
              <input type="radio" value="all" name="whoType"/> all users
            </p>
            <input type="button" name="updateACLs" value="add entry" onclick="bwAcl.update(this.form,'{$outputId}')"/>
          </div>
        </td>
        <td>
          <h5>
            <span id="accessRightsToggle">
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
                  <input type="radio" name="setappvar" value="accessRightsToggle(basic)" onclick="changeClass('howList','visible');changeClass('howTable','invisible');"/>basic
                  <input type="radio" name="setappvar" value="accessRightsToggle(advanced)" checked="checked" onclick="changeClass('howList','invisible');changeClass('howTable','visible');"/>advanced
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="setappvar" value="accessRightsToggle(basic)" checked="checked" onclick="changeClass('howList','visible');changeClass('howTable','invisible');"/>basic
                  <input type="radio" name="setappvar" value="accessRightsToggle(advanced)" onclick="changeClass('howList','invisible');changeClass('howTable','visible');"/>advanced
                </xsl:otherwise>
              </xsl:choose>
            </span>
            Rights:
          </h5>
          <input type="hidden" name="how" value="" id="bwCurrentHow"/>
          <!-- field 'acl' will receive xml for method 2 -->
          <input type="hidden" name="acl" value="" id="bwCurrentAcl" />
          <!-- Advanced Access Rights: -->
          <!-- the "how" field is set by iterating over the howItems below -->
          <table id="howTable" class="invisible" cellspacing="0">
            <xsl:if test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
              <xsl:attribute name="class">visible</xsl:attribute>
            </xsl:if>
            <tr>
              <th>access type</th>
              <th>allow</th>
              <th>deny</th>
            </tr>
            <tr>
              <td class="level1">
                <input type="checkbox" value="A" id="accessAll" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/>All
              </td>
              <td>
                <input type="radio" value="A" name="accessAll" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-A" name="accessAll" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level2">
                <input type="checkbox" value="R" id="accessRead" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)" checked="checked"/> Read
              </td>
              <td>
                <input type="radio" value="R" name="accessRead" checked="checked"/>
              </td>
              <td>
                <input type="radio" value="-R" name="accessRead"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="r" id="r" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/> read ACL
              </td>
              <td>
                <input type="radio" value="r" name="r" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-r" name="r" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="P" id="accessPriv" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/> read current user privilege set
              </td>
              <td>
                <input type="radio" value="P" name="accessPriv" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-P" name="accessPriv" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="F" id="F" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/> read freebusy
              </td>
              <td>
                <input type="radio" value="F" name="F" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-F" name="F" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level2">
                <input type="checkbox" value="W" id="W" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/> Write
              </td>
              <td>
                <input type="radio" value="W" name="W" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-W" name="W" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="a" id="a" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> write ACL
              </td>
              <td>
                <input type="radio" value="a" name="a" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-a" name="a" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="p" id="p" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> write properties
              </td>
              <td>
                <input type="radio" value="p" name="p" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-p" name="p" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="c" id="c" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> write content
              </td>
              <td>
                <input type="radio" value="c" name="c" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-c" name="c" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="b" id="b" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/> create (bind)
              </td>
              <td>
                <input type="radio" value="b" name="b" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-b" name="b" disabled="disabled"/>
              </td>
            </tr>
            <xsl:if test="$type = 'inbox' or $type = 'outbox'">
              <tr>
                <td class="level4">
                  <input type="checkbox" value="S" id="accessSchedule" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/> schedule
                </td>
              <td>
                <input type="radio" value="S" name="accessSchedule" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-S" name="accessSchedule" disabled="disabled"/>
              </td>
              </tr>
              <tr>
                <td class="level5">
                  <input type="checkbox" value="t" id="t" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> schedule request
                </td>
              <td>
                <input type="radio" value="t" name="t" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-t" name="t" disabled="disabled"/>
              </td>
              </tr>
              <tr>
                <td class="level5">
                  <input type="checkbox" value="y" id="y" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> schedule reply
                </td>
              <td>
                <input type="radio" value="y" name="y" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-y" name="y" disabled="disabled"/>
              </td>
              </tr>
              <tr>
                <td class="level5">
                  <input type="checkbox" value="s" id="s" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> schedule free-busy
                </td>
              <td>
                <input type="radio" value="s" name="s" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-s" name="s" disabled="disabled"/>
              </td>
              </tr>
            </xsl:if>
            <tr>
              <td class="level3">
                 <input type="checkbox" value="u" id="u" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> delete (unbind)
              </td>
              <td>
                <input type="radio" value="u" name="u" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-u" name="u" disabled="disabled"/>
              </td>
            </tr>
            <!--<tr>
              <td class="level1">
                <input type="checkbox" value="N" name="howItem" onclick="setupAccessForm(this, this.form)"/> None
              </td>
              <td>
              </td>
              <td>
              </td>
            </tr>-->
          </table>
          <!-- Simple Access Rights: -->
          <!-- the "how" field is set by getting the selected basicHowItem -->
          <ul id="howList">
            <xsl:if test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
              <xsl:attribute name="class">invisible</xsl:attribute>
            </xsl:if>
            <li>
              <input type="radio" value="A" name="basicHowItem"/>All
            </li>
            <li>
              <input type="radio" value="R" name="basicHowItem" checked="checked"/>Read only
            </li>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
