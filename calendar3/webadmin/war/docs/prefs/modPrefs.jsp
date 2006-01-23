<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modPrefs</page>
<bean:define id="user" name="peForm" property="userPreferences"/>
<prefs>
  <user></user>
  <view><bean:write name="user" property="view"/></view>
  <viewPeriod><bean:write name="user" property="viewPeriod"/></viewPeriod>
  <skin><bean:write name="user" property="skin"/></skin>
  <skinStyle><bean:write name="user" property="skinStyle"/></skinStyle>
</prefs>

<%@include file="/docs/footer.jsp"%>

