<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ==================================================================== -->
  <!-- ==================================================================== -->
  <!--                    BEDEWORK CONFIGURATION WEB APP                    -->
  <!-- ==================================================================== -->
  <!-- ==================================================================== -->
  <xsl:output method="xhtml" indent="yes" media-type="text/html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" standalone="yes" omit-xml-declaration="yes"/>
  <xsl:variable name="appRoot" select="/bedeworkconfig/appRoot"/>
  <xsl:variable name="urlPrefix" select="/bedeworkconfig/urlPrefix"/>

  <xsl:variable name="firstView">welcome</xsl:variable>
  <xsl:variable name="lastView" select="/bedeworkconfig/propertyGroups/form/propertyGroup[position()=last()]/@name"/>
  <xsl:variable name="currentView">
    <xsl:choose>
      <xsl:when test="/bedeworkconfig/appvar/key='setView'"><xsl:value-of select="/bedeworkconfig/appvar[key='setView']/value"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$firstView"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="currentViewPos">
    <xsl:choose>
      <xsl:when test="$currentView = $firstView">0</xsl:when>
      <xsl:otherwise><xsl:for-each select="/bedeworkconfig/propertyGroups/form/propertyGroup[@name=$currentView]"><xsl:number/></xsl:for-each></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="prevView">
    <xsl:choose>
      <xsl:when test="$currentView = $firstView">$currentView</xsl:when>
      <xsl:otherwise><xsl:value-of select="/bedeworkconfig/propertyGroups/form/propertyGroup[position()=number($currentViewPos)-1]/@name"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="nextView">
    <xsl:choose>
      <xsl:when test="$currentView = $lastView">$currentView</xsl:when>
      <xsl:otherwise><xsl:value-of select="/bedeworkconfig/propertyGroups/form/propertyGroup[position()=number($currentViewPos)+1]/@name"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>Bedework: open-source institutional events calendar - <xsl:value-of select="$currentView"/></title>
        <link rel="stylesheet" type="text/css" media="screen,all" href="{$appRoot}/default/default/bedeworkConfig.css"/>
        <script language="JavaScript" type="text/javascript">
          <![CDATA[
            function setPrevView() {
              if (window.document.propsForm.setappvar.options.selectedIndex != 0) {
                window.document.propsForm.setappvar.options.selectedIndex -= 1;
                window.document.propsForm.submit();
              }
            }
            function setNextView() {
              if (window.document.propsForm.setappvar.options.selectedIndex != window.document.propsForm.setappvar.options.length-1) {
                window.document.propsForm.setappvar.options.selectedIndex += 1;
                window.document.propsForm.submit();
              }
            }
            function showHelp(id) {
              helpField = document.getElementById(id);
              helpField.className="helpText";
            }
            function hideHelp(id) {
              helpField = document.getElementById(id);
              helpField.className="hidden";
            }
          ]]>
        </script>
      </head>
      <body>
        <div id="bodyBlock">
          <div id="header">
            <h2 id="title">
              <a href="setup.do"><img src="{$appRoot}/images/bedework.gif" alt="Bedework Calendar" border="0"/></a>
            </h2>
            <div id="configLabel">
              BedeFig: Bedework Calendar Properties Config
            </div>
          </div>
          <xsl:if test="/bedeworkconfig/message">
            <div id="messages">
              <xsl:apply-templates select="/bedeworkconfig/message"/>
            </div>
          </xsl:if>
          <xsl:if test="/bedeworkconfig/error">
            <div id="errors">
              <xsl:apply-templates select="/bedeworkconfig/error"/>
            </div>
          </xsl:if>
          <div id="content">
            <xsl:choose>
              <xsl:when test="/bedeworkconfig/page='main'">
                <form action="save.do" method="POST" enctype="multipart/form-data" name="propsForm">
                  <div id="buttonMenuTop">
                    <xsl:choose>
                      <xsl:when test="$currentView = $firstView">
                        <div id="buttonMenuPrev">&lt; prev</div>
                      </xsl:when>
                      <xsl:otherwise>
                        <div id="buttonMenuPrev">&lt; <a href="javascript:setPrevView()">prev</a></div>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="$currentView = $lastView">
                        <div id="buttonMenuNext">next &gt;</div>
                      </xsl:when>
                      <xsl:otherwise>
                        <div id="buttonMenuNext"><a href="javascript:setNextView()">next</a> &gt;</div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>

                  <ul id="buttonMenu">
                    <li><input type="submit" name="validate" value="validate"/></li>
                    <li><input type="submit" name="save" value="save"/></li>
                  </ul>

                  <select name="setappvar" onchange="submit()">
                    <option value="setView(welcome)">welcome</option>
                    <xsl:for-each select="/bedeworkconfig/propertyGroups/form/propertyGroup">
                      <xsl:variable name="groupName" select="@name"/>
                      <xsl:choose>
                        <xsl:when test="$currentView = $groupName">
                          <option name="{$groupName}" value="setView({$groupName})" selected="selected">
                            <xsl:value-of select="$groupName"/>
                          </option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option name="{$groupName}" value="setView({$groupName})">
                            <xsl:value-of select="$groupName"/>
                          </option>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </select>

                  advanced:
                  <xsl:choose>
                    <xsl:when test="/bedeworkconfig/propertyGroups/form/propertyGroup[@name='modules']/property[@name='advanced']/fieldValue='true'">
                      <input type="radio" name="modules.advanced" value="true" checked="checked" onclick="submit()"/> yes
                      <input type="radio" name="modules.advanced" value="false" onclick="submit()"/> no
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="radio" name="modules.advanced" value="true" onclick="submit()"/> yes
                      <input type="radio" name="modules.advanced" value="false" checked="checked" onclick="submit()"/> no
                    </xsl:otherwise>
                  </xsl:choose>

    <!-- ======================================================================= -->
    <!-- ========================== GENERATE CONTENT =========================== -->
    <!-- ======================================================================= -->

                  <xsl:choose>
                    <xsl:when test="$currentView = 'welcome'">
                      <div id="welcome">
                        <h1>BedeFig: Configure Bedework Properties</h1>
                        <p>
                          Welcome to the Bedework property configuration tool.  This
                          application allows you to review, modify, validate, and
                          save the properties used for building a Bedework
                          Calendar production-ready application.
                        </p>
                        <p>
                          Options are grouped into pages.  You can select any section
                          at any time by using the pull-down menu above, or you may
                          move from page to page by clicking the "next" button to the upper right.
                        </p>
                        <p>
                          When you have finished reviewing and modifying properties,
                          press "validate" to check your settings, and "save" to download
                          a properly-configured properties file which you can use to build
                          a production-ready version of the Bedework Calendar application.
                        </p>
                      </div>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="/bedeworkconfig/propertyGroups/form/propertyGroup[@name=$currentView]"/>
                    </xsl:otherwise>
                  </xsl:choose>


    <!-- ======================================================================= -->
    <!-- ======================================================================= -->
    <!-- ======================================================================= -->
                </form>
              </xsl:when>
              <xsl:when test="/bedeworkconfig/page='save'">
                <form action="save.do" method="POST" enctype="multipart/form-data" name="downloadForm">
                  <input type="hidden" name="contentType" value="text/text"/>
                  <input type="hidden" name="contentName" value="myBedework.properties"/>
                  <input type="hidden" name="skinName" value="outputText"/>
                  <input type="hidden" name="refreshXslt" value="yes"/>
                  <ul id="buttonMenu">
                    <li><input type="submit" name="save" value="download file"/></li>
                    <li><a href="setup.do">return</a></li>
                  </ul>
                </form>
                <h1>Your Configured Properties File:</h1>
                <div id="propFile">
                  <xsl:for-each select="/bedeworkconfig/propertyGroups/propertyGroup">
                    #<br/>
                    # <xsl:value-of select="@name"/><br/>
                    #<br/>
                    <xsl:for-each select="property">
                      <xsl:value-of select="@name"/>=<xsl:value-of select="."/><br/>
                    </xsl:for-each>
                    <br/>
                  </xsl:for-each>
                </div>
              </xsl:when>
            </xsl:choose>
          </div>
          <div id="footer">
            <p>
              some footer text

            </p>
            <ul class="menu" id="footMenu">
              <li class="first">first item</li>
              <li>second</li>
              <li>third</li>
            </ul>
          </div>
          <div id="subFoot">&#160;</div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="propertyGroup">
    <xsl:variable name="groupName" select="@name"/>
    <xsl:apply-templates select="@name" mode="groupHeading"/>
    <table id="{$groupName}">
      <xsl:apply-templates select="property[fieldName!='modules.advanced']"/>
    </table>
  </xsl:template>

  <xsl:template match="property">
    <xsl:variable name="propertyName" select="@name"/>
    <xsl:variable name="fieldName" select="fieldName"/>
    <xsl:variable name="fieldValue" select="fieldValue"/>
    <tr id="{$propertyName}">
      <td><xsl:apply-templates select="fieldName" mode="label"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="@type='0'"><!-- text input (string) -->
            <input type="text" name="{$fieldName}" size="50" value="{$fieldValue}" class="string"/>
          </xsl:when>
          <xsl:when test="@type='1'"><!-- text input (int) -->
            <input type="text" name="{$fieldName}" size="40" value="{$fieldValue}" class="int"/>
          </xsl:when>
          <xsl:when test="@type='2'"><!-- intended as checkbox (boolean)
            but we're going to implement as radio buttons so we can always
            send an explicit value -->
            <xsl:choose>
              <xsl:when test="fieldValue='true'">
                <xsl:choose>
                  <xsl:when test="contains($fieldName,'modules.')">
                    <input type="radio" name="{$fieldName}" value="true" checked="checked" onclick="submit()"/> yes
                    <input type="radio" name="{$fieldName}" value="false" onclick="submit()"/> no
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="{$fieldName}" value="true" checked="checked"/> yes
                    <input type="radio" name="{$fieldName}" value="false"/> no
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="contains($fieldName,'modules.')">
                    <input type="radio" name="{$fieldName}" value="true" onclick="submit()"/> yes
                    <input type="radio" name="{$fieldName}" value="false" checked="checked" onclick="submit()"/> no
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="{$fieldName}" value="true"/> yes
                    <input type="radio" name="{$fieldName}" value="false" checked="checked"/> no
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="@type='3'"><!-- radio input (choice) -->
            not supported yet (in the xsl)
          </xsl:when>
          <xsl:when test="@type='4'"><!-- multi input (checkbox of same name or multi-select box) -->
            not supported yet (in the xsl)
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="fieldName" mode="help"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="@name" mode="groupHeading">
    <xsl:choose>
      <xsl:when test=".='modules'">
        <h1>Select Modules</h1>
        <p>Select the Bedework modules you wish to build:</p>
      </xsl:when>
      <xsl:when test=".='globals'">
        <h1>Global Settings</h1>
      </xsl:when>
      <xsl:when test=".='Webadmin'">
        <h1>Administration Web Client Settings</h1>
      </xsl:when>
      <xsl:when test=".='webpublic'">
        <h1>Public Web Client Settings</h1>
      </xsl:when>
      <xsl:when test=".='webpersonal'">
        <h1>Personal Web Client Settings</h1>
      </xsl:when>
      <xsl:when test=".='calDAV-public'">
        <h1>Public CalDAV Server Settings</h1>
      </xsl:when>
      <xsl:when test=".='calDAV-personal'">
        <h1>Personal CalDAV Server Settings</h1>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="fieldName" mode="label">
    <xsl:choose>
      <xsl:when test=".='modules.adminwebclient'">
        Public events administration web client
      </xsl:when>
      <xsl:when test=".='modules.publicwebclient'">
        Public events web client
      </xsl:when>
      <xsl:when test=".='modules.personalwebclient'">
        Personal events web client
      </xsl:when>
      <xsl:when test=".='modules.publiccaldav'">
        Public events CalDAV server
      </xsl:when>
      <xsl:when test=".='modules.personalcaldav'">
        Personal events CalDAV server
      </xsl:when>
      <xsl:when test=".='modules.advanced'">
        Use advanced interface
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="fieldName" mode="help">
    <xsl:variable name="fieldId">help<xsl:value-of select="translate(.,'.','')"/></xsl:variable>
    <span class="help">
    <xsl:choose>
      <xsl:when test=".='modules.adminwebclient'">
        <a href="" onmouseover="showHelp('{$fieldId}')" onmouseout="hideHelp('{$fieldId}')">?</a>
        <div id="{$fieldId}" class="hidden">
          help for Public events administration web client
        </div>
      </xsl:when>
      <xsl:when test=".='modules.publicwebclient'">
        <a href="" onmouseover="showHelp('{$fieldId}')" onmouseout="hideHelp('{$fieldId}')">?</a>
        <div id="{$fieldId}" class="hidden">
          help for Public events web client
        </div>
      </xsl:when>
      <xsl:when test=".='modules.personalwebclient'">
        <a href="" onmouseover="showHelp('{$fieldId}')" onmouseout="hideHelp('{$fieldId}')">?</a>
        <div id="{$fieldId}" class="hidden">
          help for Personal events web client
        </div>
      </xsl:when>
      <xsl:when test=".='modules.publiccaldav'">
        <a href="" onmouseover="showHelp('{$fieldId}')" onmouseout="hideHelp('{$fieldId}')">?</a>
        <div id="{$fieldId}" class="hidden">
          help for Public events CalDAV server
        </div>
      </xsl:when>
      <xsl:when test=".='modules.personalcaldav'">
        <a href="" onmouseover="showHelp('{$fieldId}')" onmouseout="hideHelp('{$fieldId}')">?</a>
        <div id="{$fieldId}" class="hidden">
          help for Personal events CalDAV server
        </div>
      </xsl:when>
      <xsl:when test=".='modules.advanced'">
        <a href="" onmouseover="showHelp('{$fieldId}')" onmouseout="hideHelp('{$fieldId}')">?</a>
        <div id="{$fieldId}" class="hidden">
          help for Use advanced interface
        </div>
      </xsl:when>
    </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template match="message">
    <xsl:choose>
      <xsl:when test="id = 'org.bedework.config.error.missingvalue'">
        <p>placeholder.</p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/>
        <xsl:if test="param"> =
          <xsl:for-each select="param">
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="error">
    <xsl:choose>
      <xsl:when test="id = 'org.bedework.config.error.missingvalue'">
        <p>A value is missing.  See the field
        (<xsl:for-each select="param">
            <xsl:value-of select="."/>
          </xsl:for-each>)
        highlighted below.</p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/>
        <xsl:if test="param"> =
          <xsl:for-each select="param">
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>




