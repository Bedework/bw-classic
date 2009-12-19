<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="leftColumn">
    <div class="left_column">
      <xsl:call-template name="jsDateSelectionCal" />
      <div class="clear">&#160;</div>
      <xsl:call-template name="viewList" />
      <xsl:call-template name="displaySideBar" />
      <xsl:call-template name="groupsList" />
    </div>
  </xsl:template>

  <!-- Date Selection Calendar (javascript widget) -->
  <xsl:template name="jsDateSelectionCal">
    <div id="jsNavCal" class="calContainer">
      <xsl:call-template name="dateSelectForm" />
      <p>
        To view the interactive calendar, please enable
        Javascript on your browser.
      </p>
    </div>
  </xsl:template>

  <!--============= Display Side Bar ======-->
  <xsl:template name="displaySideBar">
    <div class="sideBarContainer">
      <h4>FILTER ON CALENDARS:</h4>
      <ul class="sideLinks">
        <li>
          <a href="{$fetchPublicCalendars}">
            View All Calendars
          </a>
        </li>
      </ul>
      <h4>EVENTS CALENDAR INFO:</h4>
      <ul class="sideLinks">
        <li>
          <a href="/caladmin">Manage Events</a>
        </li>
        <li>
          <a href="/eventsubmit?setappvar=confirmed(no)">
            Submit an Event
          </a>
        </li>
        <li>
          <a href="http://calendar.duke.edu/help">Help</a>
        </li>
      </ul>
      <ul class="sideLinksExpand">
        <li>
          <h4>OTHER UNIVERSITY CALENDARS</h4>
          <span id="additionalUnivClicker">+</span>
          <ul id="additionalUnivSub"
            style="height:0px;overflow:hidden;">
            <li>
              <a href="http://dukehealth.org/events"
                target="_blank">
                DukeHealth.org Event Calendar
              </a>
            </li>
            <li>
              <a
                href="http://calendar.activedatax.com/ncstate/EventList.aspx"
                target="_blank">
                NC State Calendar
              </a>
            </li>
            <li>
              <a
                href="http://webevent.nccu.edu/CalendarNOW.aspx"
                target="_blank">
                NCCU Calendar
              </a>
            </li>
            <li>
              <a href="http://events.unc.edu/cal/"
                target="_blank">
                UNC Calendar
              </a>
            </li>
          </ul>
        </li>
        <li>
          <h4>OTHER LINKS</h4>
          <span id="additionalOptionsClicker">+</span>
          <ul id="additionalOptionsSub"
            style="height:0px;overflow:hidden">
            <li>
              <a href="http://www.durham-nc.com"
                target="_blank">
                Durham Visitor's Bureau Calendar
              </a>
            </li>
            <li>
              <a href="http://map.duke.edu" target="_blank">
                Duke Campus Map
              </a>
            </li>
          </ul>
        </li>
      </ul>
    </div>
  </xsl:template>

</xsl:stylesheet>
