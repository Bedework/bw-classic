<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- View List -->
  <xsl:template name="viewList">
    <div class="secondaryColHeader">
      <h3>Calendar Views</h3>
    </div>
    <ul class="viewList">
      <xsl:for-each select="/bedework/views/view">
        <xsl:variable name="viewName" select="name/text()"/>
        <li>
          <a href="{$setSelection}&amp;viewName={$viewName}">
            <xsl:if test="$viewName = (/bedework/selectionState/view/name)">
              <xsl:attribute name="class">current</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$viewName"/>
          </a>
        </li>
      </xsl:for-each>
      <!--
      <li>
        <a
          href="/cal/?setappvar=category(all)&amp;setappvar=categoryclass(all)">
          <xsl:if
            test="((/bedework/appvar[key = 'categoryclass']/value = 'all') or not(/bedework/appvar[key = 'categoryclass']/value))">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          All
        </a>
      </li>
      <li>
        <a
          href="http://www.registrar.duke.edu/registrar/studentpages/student/academicalendars.html">
          Official Academic Calendar
        </a>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Concert/Music~ Dance Performance~ Exhibit~ Masterclass~ Movie/Film~ Reading~ Theater)&amp;setappvar=categoryclass(Arts)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Arts'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Arts
        </a>
        <span id="artsClicker">+</span>
        <ul id="artsSub" style="height:0px"
          class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'Arts'">
              <xsl:attribute name="style">height:170px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/?setappvar=category(Concert/Music)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Concert/Music'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Concert/Music
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Dance Performance)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Dance Performance'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Dance Performance
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Exhibit)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Exhibit'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Exhibit
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Masterclass)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Masterclass'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Masterclass
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Movie/Film)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Movie/Film'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Movie/Film
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Reading)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Reading'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Reading
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Theater)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Theater'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Theater
            </a>
          </li>
        </ul>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Athletics/Intramurals/Recreation~ Athletics/Varsity Sports/Men~ Athletics/Varsity Sports/Women)&amp;setappvar=categoryclass(Athletics/Recreation)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Athletics/Recreation'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Athletics/Recreation
        </a>
        <span id="athleticsClicker">+</span>
        <ul id="athleticsSub" class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'Athletics/Recreation'">
              <xsl:attribute name="style">height:75px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/?setappvar=category(Athletics/Varsity Sports/Men)&amp;setappvar=categoryclass(Athletics/Recreation)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Athletics/Varsity Sports/Men'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Athletics/Varsity Sports/Men
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Athletics/Varsity Sports/Women)&amp;setappvar=categoryclass(Athletics/Recreation)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Athletics/Varsity Sports/Women'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Athletics/Varsity Sports/Women
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Athletics/Intramurals/Recreation)&amp;setappvar=categoryclass(Athletics/Recreation)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Athletics/Intramurals/Recreation'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Athletics/Intramurals/Recreation
            </a>
          </li>
        </ul>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Conference/Symposium~ Lecture/Talk~ Panel/Seminar/Colloquium)&amp;setappvar=categoryclass(Lectures/Conferences)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Lectures/Conferences'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Lectures/Conferences
        </a>
        <span id="lecturesClicker">+</span>
        <ul id="lecturesSub" class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'Lectures/Conferences'">
              <xsl:attribute name="style">height:75px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/?setappvar=category(Conference/Symposium)&amp;setappvar=categoryclass(Lectures/Conferences)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Conference/Symposium'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Conference/Symposium
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Lecture/Talk)&amp;setappvar=categoryclass(Lectures/Conferences)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Lecture/Talk'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Lecture/Talk
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Panel/Seminar/Colloquium)&amp;setappvar=categoryclass(Lectures/Conferences)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Panel/Seminar/Colloquium'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Panel/Seminar/Colloquium
            </a>
          </li>
        </ul>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Religious/Spiritual)&amp;setappvar=categoryclass(Religious/Spiritual)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Religious/Spiritual'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Religious/Spiritual
        </a>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Commencement~ Founders' Day~ Holiday~ MLK~ Parents' and Family Weekend)&amp;setappvar=categoryclass(University Events)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'University Events'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          University Events
        </a>
        <span id="lifeClicker">+</span>
        <ul id="lifeSub" class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'University Events'">
              <xsl:attribute name="style">height:135px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/main/setViewPeriod.do?setappvar=category(Commencement)&amp;setappvar=categoryclass(University Events)&amp;date=20100501&amp;viewType=monthView">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Commencement'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Commencement
            </a>
          </li>
          <li>
            <a
              href="/cal/main/setViewPeriod.do?setappvar=category(Founders' Day)&amp;setappvar=categoryclass(University Events)&amp;date=20091001&amp;viewType=monthView">
              <xsl:if
                test="/bedework/appvar[key = &quot;category&quot;]/value = &quot;Founders' Day&quot;">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Founders' Day
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Holiday)&amp;setappvar=categoryclass(University Events)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Holiday'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Holiday
            </a>
          </li>
          <li>
            <a
              href="/cal/main/setViewPeriod.do?setappvar=category(MLK)&amp;setappvar=categoryclass(University Events)&amp;date=20100101&amp;viewType=monthView">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'MLK'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              MLK
            </a>
          </li>
          <li>
            <a
              href="/cal/main/setViewPeriod.do?setappvar=category(Parents' and Family Weekend)&amp;setappvar=categoryclass(University Events)&amp;date=20091023&amp;viewType=monthView">
              <xsl:if
                test="/bedework/appvar[key = &quot;category&quot;]/value = &quot;Parents' and Family Weekend&quot;">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Parents' and Family Weekend
            </a>
          </li>
        </ul>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Workshop/Short Course)&amp;setappvar=categoryclass(Workshop/Short Course)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Workshop/Short Course'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Workshop/Short Course
        </a>
      </li>
      <li>
        <div
          style="font: bold 1.2em/2 Arial, sans-serif; display:inline;">
          Other
        </div>
        <span id="otherClicker">+</span>
        <ul id="otherSub" class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'Other'">
              <xsl:attribute name="style">height:330px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/?setappvar=category(Alumni/Reunion)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Alumni/Reunion'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Alumni/Reunion
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Brown Bag)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Brown Bag'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Brown Bag
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Ceremony)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Ceremony'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Ceremony
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Health/Wellness)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Health/Wellness'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Health/Wellness
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Meeting)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Meeting'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Meeting
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Orientation)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Orientation'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Orientation
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Reception)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Reception'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Reception
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Research)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Research'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Research
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Social)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Social'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Social
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Technology)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Technology'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Technology
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Tour)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Tour'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Tour
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Training)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Training'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Training
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Volunteer/Community Service)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Volunteer/Community Service'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Volunteer/Community Service
            </a>
          </li>
        </ul>
      </li>
      -->
    </ul>
  </xsl:template>

</xsl:stylesheet>
