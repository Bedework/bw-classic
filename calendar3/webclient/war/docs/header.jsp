<!DOCTYPE ucalendar
[
  <!ENTITY nbsp "&#160;">
]>
<%@ page contentType="text/xml;charset=UTF-8" language="java" %>
<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<%
try {
%>

<bedework>
  <now><%-- The actual date right "now" - this may not be the same as currentdate --%>
    <date><bean:write name="calForm" property="today.dateDigits"/></date><%--
      Value: YYYYMMDD --%>
    <longdate><bean:write name="calForm" property="today.longDateString"/></longdate><%--
      Value (example): February 8, 2004 - long representation of the date --%>
    <shortdate><bean:write name="calForm" property="today.dateString"/></shortdate><%--
      Value (example): 2/8/04 - short representation of the date --%>
    <time><bean:write name="calForm" property="today.timeString"/></time><%--
      Value (example): 10:15 PM --%>
  </now>
  <bean:define id="ctView" name="calForm" property="curTimeView"/>
  <currentdate><%-- The current user-selected date --%>
    <date><bean:write name="ctView" property="curDay.dateDigits"/></date><%--
      Value: yyyymmdd - date value --%>
    <longdate><bean:write name="ctView"
                          property="curDay.fullDateString"/></longdate><%--
      Value (example): Wednesday, February 11, 2004 --%>
    <shortdate><bean:write name="ctView" property="curDay.dateString"/></shortdate><%--
      Value (example): 2/8/04 - short representation of the date --%>
    <monthname><bean:write name="ctView" property="curDay.monthName"/></monthname><%--
      Value (example): January - full month name --%>
  </currentdate>
  <firstday><%-- The first date appearing in the currently selected time period --%>
    <date><bean:write name="ctView" property="firstDay.dateDigits"/></date><%--
      Value: yyyymmdd - date value --%>
    <longdate><bean:write name="ctView"
                          property="firstDay.fullDateString"/></longdate><%--
      Value (example): Wednesday, February 11, 2004 --%>
    <shortdate><bean:write name="ctView" property="firstDay.dateString"/></shortdate><%--
      Value (example): 2/8/04 - short representation of the date --%>
    <monthname><bean:write name="ctView" property="firstDay.monthName"/></monthname><%--
      Value (example): January - full month name --%>
  </firstday>
  <lastday><%-- The last date appearing in the currently selected time period --%>
    <date><bean:write name="ctView" property="lastDay.dateDigits"/></date><%--
      Value: yyyymmdd - date value --%>
    <longdate><bean:write name="ctView"
                          property="lastDay.fullDateString"/></longdate><%--
      Value (example): Wednesday, February 11, 2004 --%>
    <shortdate><bean:write name="ctView" property="lastDay.dateString"/></shortdate><%--
      Value (example): 2/8/04 - short representation of the date --%>
    <monthname><bean:write name="ctView" property="lastDay.monthName"/></monthname><%--
      Value (example): January - full month name --%>
  </lastday>
  <previousdate><bean:write name="ctView" property="prevDate"/></previousdate><%--
    Value: YYYYMMDD - The previous "firstdate" in the selected time period  --%>
  <nextdate><bean:write name="ctView" property="nextDate"/></nextdate><%--
    Value: YYYYMMDD - The next "firstdate" in the selected time period --%>
  <periodname><bean:write name="ctView" property="periodName"/></periodname><%--
    Values: Day, Week, Month, Year - The current time period name.   --%>
  <multiday><bean:write name="ctView" property="multiDay"/></multiday><%--
    Values: true, false - Flag if we are viewing multiple days --%>
  <hour24><bean:write name="calForm" property="hour24" /></hour24><%--
    Values: true, false - Flag if we are using 24 hour time --%>

  <logic:present name="calForm" property="currentView" >
    <name><bean:write name="calForm" property="currentView.name"/></name><%--
      Value: string - Name of selected view for display --%>
    <viewid><bean:write name="calForm" property="currentView.id"/></viewid><%--
      Value: string - String ID of selected view for display --%>
  </logic:present>
  <logic:notPresent name="calForm" property="currentView" >
    <name>All</name>
    <viewid>-1</viewid>
  </logic:notPresent>
  <search><bean:write name="calForm" property="search"/></search><%--
    Value: string - Current search string for display --%>

  <publicview><bean:write name="calForm" property="publicView" /></publicview><%--
    Values: true, false - Flag if we are in the guest (public) view  --%>
  <guest><bean:write name="calForm" property="guest" /></guest><%--
    Value: true, false - Flag if we are a guest --%>
  <logic:equal name="calForm" property="guest" value="false">
    <userid><bean:write name="calForm" property="currentUser" /></userid><%--
      Value: string - Userid of non-guest user --%>
  </logic:equal>

  <logic:iterate id="msg" name="calForm" property="msg.msgList">
    <message>
      <id><bean:write name="msg" property="msgId" /></id>
      <logic:iterate id="param" name="msg" property="params" >
        <param><bean:write name="param" /></param>
      </logic:iterate>
    </message>
  </logic:iterate>

  <logic:iterate id="errBean" name="calForm" property="err.msgList">
    <error>
      <id><bean:write name="errBean" property="msgId" /></id>
      <logic:iterate id="param" name="errBean" property="params" >
        <param><bean:write name="param" /></param>
      </logic:iterate>
    </error>
  </logic:iterate>

  <approot><bean:write name="calForm" property="presentationState.appRoot"/></approot><%--
        Value: URI - the location of web resources used by the code to find the
        XSLT files.  This element is defined prior to build in
        ../../../../clones/democal.properties
        as pubevents.app.root and personal.app.root. Note that references to
        html web resources such as images are set in the xsl stylesheets. --%>
  <urlprefix><bean:write name="calForm" property="urlPrefix"/></urlprefix><%--
        Value: URI - this is prefix of the calendar application.
        e.g. http://localhost:8080/cal
        Use this value to prefix calls to the application actions in your XSLT.
        e.g. <a href="{$urlPrefix}/eventView.do?eventId=8">View Event</a> --%>
  <urlpattern><genurl:rewrite action="DUMMYACTION.DO" /></urlpattern>

  <selectionType><bean:write name="calForm" property="selectionType"/></selectionType><%--
        Value: view,search,calendar,subscription,filter
        Used to branch into different presentation depending on the type of
        output we expect --%>

  <personaluri><bean:message key="org.bedework.personal.calendar.uri"/></personaluri>
  <publicuri><bean:message key="org.bedework.public.calendar.uri"/></publicuri>
  <adminuri><bean:message key="org.bedework.public.admin.uri"/></adminuri>
  <bean:define id="personalUri"><bean:message key="org.bedework.personal.calendar.uri"/></bean:define>
  <urlPrefixes>
    <%-- render urls --%>
    <initialise><genurl:rewrite forward="initialise"/></initialise>
    <eventMore><genurl:rewrite forward="eventMore"/></eventMore>
    <initUpload><genurl:rewrite forward="initUpload"/></initUpload>

    <%-- action urls --%>
    <setup><genurl:rewrite action="setup.do"/></setup>
    <setSelection><genurl:rewrite action="setSelection.do"/></setSelection>
    <setViewPeriod><genurl:rewrite action="setViewPeriod.do"/></setViewPeriod>
    <eventView><genurl:rewrite action="eventView.do"/></eventView>
    <initEvent><genurl:rewrite action="initEvent.do"/></initEvent>
    <fetchPublicCalendars><genurl:rewrite action="fetchPublicCalendars"/></fetchPublicCalendars>
    <fetchCalendars><genurl:rewrite action="fetchCalendars"/></fetchCalendars>
    <addEvent><genurl:rewrite action="addEvent.do"/></addEvent>
    <addEventUsingPage><genurl:rewrite action="addEventUsingPage.do"/></addEventUsingPage>
    <editEvent><genurl:rewrite action="editEvent.do"/></editEvent>
    <delEvent><genurl:rewrite action="delEvent.do"/></delEvent>
    <mailEvent><genurl:rewrite action="mailEvent.do"/></mailEvent>
    <showPage><genurl:rewrite action="showPage.do"/></showPage>
    <manageLocations><genurl:rewrite action="manageLocations.do"/></manageLocations>
    <addLocation><genurl:rewrite action="addLocation.do"/></addLocation>
    <editLocation><genurl:rewrite action="editLoc.do"/></editLocation>
    <delLocation><genurl:rewrite action="delLocation.do"/></delLocation>
    <subscribe><genurl:rewrite action="subscribe.do"/></subscribe>
    <export><genurl:rewrite action="export.do"/></export>

    <initEventAlarm><genurl:rewrite action="initEventAlarm.do"/></initEventAlarm>
    <setAlarm><genurl:rewrite action="setAlarm.do"/></setAlarm>
    <addEventRef><genurl:rewrite action="addEventRef.do"/></addEventRef>
    <upload><genurl:rewrite action="upload.do"/></upload>
  </urlPrefixes><%--
        actionUrlPrefixes are used to generate appropriately encoded urls for
        calls into the application; these are required for use within portals --%>
  <confirmationid><bean:write name="calForm" property="confirmationId"/></confirmationid><%--
        Value: String - a 16 character random string used to allow users to confirm
        additions to thier private calendar --%>
  <logic:iterate id="appvar" name="calForm" property="appVars">
    <appvar><%--
        Application variables can be set arbitrarily by the stylesheet designer.
        Use an "appvar" by adding setappvar=key(value) to the query string of
        a URL.  This feature is useful for setting up state during a user's session.
        e.g. <a href="{$urlPrefix}/eventView.do?eventId=8&setappvar=currentTab(event)">View Event</a>
        To change the value of an appvar, call the same key with a different value.
        e.g. <a href="{$urlPrefix}/setup.do?setappvar=currentTab(home)">Return Home</a>
        If appvars exist, they will be output in the following form:  --%>
      <key><bean:write name="appvar" property="key" /></key>
      <value><bean:write name="appvar" property="value" /></value>

      <logic:equal name="appvar" property="key" value="summaryMode"><%--
        This is a special use of the appvar feature.  Normally, we don't return
        all details about events except when we display a single event (to keep the
        XML lighter).  To return all event details in an events listing, append a
        query string with setappvar=summaryMode(details).  Turn the detailed view
        off with setappvar=summaryMode(summary).--%>
        <logic:equal name="appvar" property="value" value="details">
          <bean:define id="detailView" value="true" toScope="request"/><%--
            Send this bean to the request scope so we can test for it on the page
            that builds the calendar tree (main.jsp) --%>
        </logic:equal>
      </logic:equal>
    </appvar>
  </logic:iterate>
<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

