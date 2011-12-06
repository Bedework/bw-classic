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
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- Subscriptions Calendar Tree -->
  <xsl:template name="subscriptionsTree">
    <div class="secondaryColHeader">
      <h3><xsl:copy-of select="$bwStr-LCol-Calendars"/></h3>
    </div>
    <div id="subsTree">&#160;</div>
    
    <script type="text/javascript">
	    $(document).ready(function(){
	      // get the subscriptions/calendars and load them into the tree
	      loadSubscriptions("#subsTree","<xsl:value-of select="$setSelection"/>","<xsl:value-of select="/bedework/selectionState/collection/virtualpath"/>");
	    });
	  </script>
  </xsl:template>

</xsl:stylesheet>
