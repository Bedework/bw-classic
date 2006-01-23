<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modPrefs</page>
<bean:define id="userPrefs" name="peForm" property="userPreferences"/>
<prefs>
  <user><bean:write name="userPrefs" property="owner.account"/></user>
  <preferredView><bean:write name="userPrefs" property="preferredView"/></preferredView>
  <preferredViewPeriod><bean:write name="userPrefs" property="preferredViewPeriod"/></preferredViewPeriod>
  <skinName><bean:write name="userPrefs" property="skinName"/></skinName>
  <skinStyle><bean:write name="userPrefs" property="skinStyle"/></skinStyle>
</prefs>

<%@include file="/docs/footer.jsp"%>

