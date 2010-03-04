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
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" indent="no" media-type="text/html"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    standalone="yes" omit-xml-declaration="yes" />

  <!-- =========================================================

    DEMONSTRATION CALENDAR STYLESHEET

    PDA Skin

    This stylesheet is devoid of school branding.  It is a good
    starting point for development of a customized theme.

    It is based on work by Duke University and Yale University with
    credit also to the University of Chicago.

    For detailed instructions on how to work with the XSLT
    stylesheets included with this distribution, please see the
    Bedework Design Guide at
    http://www.bedework.org/bedework/update.do?artcenterkey=24

    ===============================================================  -->
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
    to the maximum extent the law permits. -->

  <!-- DEFINE INCLUDES -->
  <xsl:include href="./globals.xsl" />
  <xsl:include href="../strings.xsl" />

  <!-- DEFAULT THEME NAME -->
  <!-- to change the default theme, change this include -->
  <xsl:include href="../../themes/iphoneTheme/iphone.xsl" />

</xsl:stylesheet>
