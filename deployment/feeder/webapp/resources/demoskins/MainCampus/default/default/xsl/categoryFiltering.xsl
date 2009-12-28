<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
</xsl:stylesheet>