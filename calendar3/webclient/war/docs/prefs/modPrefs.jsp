<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modPrefs</page>
<bean:define id="userPrefs" name="calForm" property="userPreferences"/>
<prefs>
  <user><bean:write name="userPrefs" property="owner.account"/></user>
  <email><bean:write name="userPrefs" property="email"/></email>
  <!-- default calendar into which events will be placed -->
  <defaultCalendar>
    <path><bean:write name="userPrefs" property="defaultCalendar.path"/></path>
    <subName></subName>
  </defaultCalendar>
  <!-- name of default view (collection of subscriptions) that will appear upon login -->
  <preferredView><bean:write name="userPrefs" property="preferredView"/></preferredView>
  <!-- default period that will appear upon login (day, week, month, year, today) -->
  <preferredViewPeriod><bean:write name="userPrefs" property="preferredViewPeriod"/></preferredViewPeriod>
  <!-- skinName is XSL skin name; skinStyle is intended for CSS stylesheet name -->
  <skinName><bean:write name="userPrefs" property="skinName"/></skinName>
  <skinStyle><bean:write name="userPrefs" property="skinStyle"/></skinStyle>
  <!-- string of chars representing the days -->
  <workDays><bean:write name="userPrefs" property="workDays"/></workDays>
  <!-- start and end in minutes: e.g. 14:30 is 870 and 17:30 is 1050 -->
  <workDayStart><bean:write name="userPrefs" property="workdayStart"/></workDayStart>
  <workDayEnd><bean:write name="userPrefs" property="workdayEnd"/></workDayEnd>
  <!-- pref end type = date or duration -->
  <preferredEndType><bean:write name="userPrefs" property="preferredEndType"/></preferredEndType>
  <!-- user mode: 0 = basicMode, 1 = simpleMode, 2 = advancedMode -->
  <userMode><bean:write name="userPrefs" property="userMode"/></userMode>
</prefs>

<%@include file="/docs/footer.jsp"%>

