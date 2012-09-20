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
<xsl:output
     method="html"
     indent="no"
     media-type="text/html"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     standalone="yes"
     omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>

  <!--+++++++++++++++ Resources ++++++++++++++++++++-->
  <!-- templates: 
         - listResources
  -->

  <!-- List all resources -->
  <xsl:template name="listResources">
    <h2><xsl:copy-of select="$bwStr-Resource-ManageResources"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-Resource-ResourcesAre"/>
    </p>

    <h4><xsl:copy-of select="$bwStr-Resource-AddNewResource"/></h4>
    <div class="addResourceForm" style="border: 1px solid grey; padding: 10px; display: table;">
	    <form name="addResource" action="{$calsuite-resources-add}" method="post">
        <span class="resFormLabel">
          <xsl:value-of select="$bwStr-Resource-NameLabel" />
          <xsl:text>: </xsl:text>
        </span>
	      <input type="text" name="name" size="60"/>
	      <br/>
	      
        <span class="resFormLabel">
          <xsl:value-of select="$bwStr-Resource-ContentTypeLabel" />
          <xsl:text>: </xsl:text>
        </span>
	      <select name="ct">
	      	<option value="text/plain" selected="true">
	      	  <xsl:value-of select="$bwStr-Resource-Text" />
          </option>
	      	<option value="application/xml">XML</option>
	      	<option value="text/css">CSS</option>
	      	<option value="image/png">PNG (Image)</option>
	      	<option value="image/jpeg">JPEG (Image)</option>
	      	<option value="image/gif">GIF (Image)</option>
	      </select>
	      <br/>
	      
        <span class="resFormLabel">
          <xsl:value-of select="$bwStr-Resource-ResourceTypeLabel" />
          <xsl:text>: </xsl:text>
        </span>
	      <input type="text" name="type" size="40" />
	      <br/>
	      
	      <xsl:choose>
	       <xsl:when test="/bedework/userInfo/superUser = 'true'">
	        <span class="resFormLabel">
	          <xsl:value-of select="$bwStr-Resource-ClassLabel" />
	          <xsl:text>: </xsl:text>
	        </span>
	         <select name="class">
	           <option value="calsuite" selected="true">
	             <xsl:value-of select="$bwStr-Resource-CalendarSuite" />
	           </option>
	           <option value="admin">
               <xsl:value-of select="$bwStr-Resource-Admin" />
             </option>
	         </select>
           <br/>
	       </xsl:when>
	       <xsl:otherwise>
          <input type="hidden" name="class" value="calsuite" />
	       </xsl:otherwise>
	      </xsl:choose>
	      <input type="submit" value="{$bwStr-Resource-AddNewResource}" name="addresource"/>
	    </form>
	  </div>

    <!-- The table of resources -->
    <h4><xsl:copy-of select="$bwStr-Resource-Resources"/></h4>
    <table id="commonListTable" class="resourcesTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-Resource-NameCol"/></th>
        <th><xsl:copy-of select="$bwStr-Resource-ContentTypeCol"/></th>
        <th><xsl:copy-of select="$bwStr-Resource-ResourceTypeCol"/></th>
        <xsl:if test="/bedework/userInfo/superUser = 'true'">
          <th><xsl:copy-of select="$bwStr-Resource-ResourceClassCol"/></th>
        </xsl:if>
        <th> </th>
      </tr>
      <xsl:for-each select="/bedework/resources/resource">
        <xsl:sort select="name" order="ascending" case-order="upper-first"/>
        <xsl:variable name="resName" select="name"/>
        <xsl:variable name="resContentType" select="content-type"/>
        <xsl:variable name="resType" select="type"/>
        <xsl:variable name="resClass" select="class"/>
        <xsl:variable name="downloadLink" select="concat('/pubcaldav', path)" />
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <a href="{$calsuite-resources-edit}&amp;name={$resName}&amp;class={$resClass}">
              <xsl:value-of select="$resName"/>
            </a>
          </td>
          <td>
          	<xsl:value-of select="$resContentType" />
          </td>
          <td>
          	<xsl:value-of select="$resType" />
          </td>
	        <xsl:if test="/bedework/userInfo/superUser = 'true'">
	          <td>
	            <xsl:value-of select="$resClass" />
	          </td>
	        </xsl:if>
          <td>
            <a href="{$downloadLink}">
              <xsl:copy-of select="$bwStr-Resource-ResourceURL"/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>


  <!-- Add or Edit a resource -->
  <xsl:template name="modResource">
    <xsl:variable name="isCreating" select="/bedework/creating" />
    <xsl:variable name="resource" select="/bedework/currentResource" />
    <xsl:variable name="isText">
      <xsl:choose>
        <xsl:when test="$resource/content-type = 'text/plain'">true</xsl:when>
        <xsl:when test="$resource/content-type = 'text/css'">true</xsl:when>
        <xsl:when test="$resource/content-type = 'application/xml'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="downloadLink" select="concat('/pubcaldav', $resource/path)" />

    <xsl:choose>
      <xsl:when test="$isCreating = 'true'">
        <h2>
          <xsl:value-of select="concat($bwStr-ModRes-AddResource, ' - ', $resource/name)" />
        </h2>
      </xsl:when>
      <xsl:otherwise>
        <h2>
          <xsl:value-of select="concat($bwStr-ModRes-EditResource, ' - ', $resource/name)" />
        </h2>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    
    <xsl:if test="$isCreating = 'false'">
      <a href="{$downloadLink}">
        <xsl:value-of select="$bwStr-ModRes-ClickToDownload" />
      </a>
      <br/>
      <br/>
    </xsl:if>

    <div class="modResourceForm">
      <form name="modResource" action="{$calsuite-resources-update}" method="post" enctype="multipart/form-data">
        <span class="resFormLabel">
          <xsl:value-of select="$bwStr-ModRes-NameLabel" />
          <xsl:text>: </xsl:text>
        </span>
        <input type="hidden" name="name" value="{$resource/name}"/>
        <span class="resFormField">
          <xsl:value-of select="$resource/name" />
        </span>
        <br/>
        
        <span class="resFormLabel">
          <xsl:value-of select="$bwStr-ModRes-ContentTypeLabel" />
          <xsl:text>: </xsl:text>
        </span>
        <input type="hidden" name="ct" value="{$resource/content-type}"/>
        <span class="resFormField">
          <xsl:value-of select="$resource/content-type" />
        </span>
        <br/>
        
        <span class="resFormLabel">
          <xsl:value-of select="$bwStr-ModRes-ResourceTypeLabel" />
          <xsl:text>: </xsl:text>
        </span>
        <input type="hidden" name="type" value="{$resource/type}"/>
        <span class="resFormField">
          <xsl:value-of select="$resource/type" />
        </span>
        <br/>

        <xsl:if test="/bedework/userInfo/superUser = 'true'">
        <span class="resFormLabel">
          <xsl:value-of select="$bwStr-ModRes-ClassLabel" />
          <xsl:text>: </xsl:text>
        </span>
	        <span class="resFormField">
	          <xsl:value-of select="$resource/class" />
	        </span>
	        <br/>
        </xsl:if>
        <input type="hidden" name="class" value="{$resource/class}" />
        
        <xsl:if test="$isText = 'true'">
	        <span class="resFormLabel">
	          <xsl:value-of select="$bwStr-ModRes-ResourceContentLabel" />
	        </span>
          <br/>
          <textarea name="content" rows="20" cols="80" id="resourceContent" style="display:block;">
          </textarea>
          <xsl:if test="$isCreating = 'false'">
            <script type="text/javascript">
              <xsl:text>
                $(document).ready(function() {
              </xsl:text>
              <xsl:text>$.ajax({url: "</xsl:text>
              <xsl:value-of select="$downloadLink" />
              <xsl:text>", 
                  error: function() { $("#resourceContent").val("-- Failed to retrieve resource content! --"); },
                  dataFilter: function(data, type) { return data; },
                  success: function(data) { $("#resourceContent").val(data); }, 
                  cache: false,
                  dataType: "text"});</xsl:text>
              <xsl:text>
                });
              </xsl:text>
            </script>
          </xsl:if>
        </xsl:if>
        <xsl:if test="$isText = 'false'">
	        <span class="resFormLabel">
	          <xsl:value-of select="$bwStr-ModRes-UploadLabel" />
	          <xsl:text>: </xsl:text>
	        </span>
          <input type="file" name="uploadFile" size="60" />
          <br/>
        </xsl:if>
        
        <br/>
        <input type="submit" name="update">
          <xsl:attribute name="value">
				    <xsl:choose>
				      <xsl:when test="$isCreating = 'true'">
  		          <xsl:value-of select="$bwStr-ModRes-AddResource" />
				      </xsl:when>
				      <xsl:otherwise>
                <xsl:value-of select="$bwStr-ModRes-UpdateResource" />
				      </xsl:otherwise>
				    </xsl:choose>
          </xsl:attribute>
        </input>
        <input type="submit" name="remove" value="{$bwStr-ModRes-RemoveResource}" />
        <span> - OR -</span>
        <input type="submit" name="cancel" value="{$bwStr-ModRes-BackToList}" />
      </form>
    </div>
  </xsl:template>


  <!-- Confirmation of resource deletion -->
  <xsl:template name="deleteResourceConfirm">
    <h2><xsl:copy-of select="$bwStr-DelRes-RemoveResource"/></h2>

    <p>
      <xsl:copy-of select="$bwStr-DelRes-TheResource"/>
      <xsl:text> </xsl:text>
      <strong><xsl:value-of select="/bedework/currentResource/name"/></strong>
      <xsl:text> </xsl:text>
      <xsl:copy-of select="$bwStr-DelRes-WillBeRemoved"/>
    </p>
    <p class="note">
      <xsl:copy-of select="$bwStr-DelRes-BeForewarned"/>
    </p>

    <p><xsl:copy-of select="$bwStr-DelRes-Continue"/></p>

    <form name="removeResource" action="{$calsuite-resources-remove}" method="post">
      <input type="hidden" name="name" value="{/bedework/currentResource/name}" />
      <input type="hidden" name="class" value="{/bedework/currentResource/class}" />
      <input type="submit" name="delete" value="{$bwStr-DelRes-YesRemoveView}"/>
      <input type="submit" name="cancelled" value="{$bwStr-DelRes-Cancel}"/>
    </form>
  </xsl:template>  
</xsl:stylesheet>