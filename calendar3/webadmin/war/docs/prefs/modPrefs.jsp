<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modPrefs</page>

<prefs>
  <user></user>
  <view><bean:write name="peForm" property="preferences.view"/></view>
  <viewPeriod><bean:write name="peForm" property="preferences.viewPeriod"/></viewPeriod>
  <skin><bean:write name="peForm" property="preferences.skin"/></skin>
  <skinStyle><bean:write name="peForm" property="preferences.skinStyle"/></skinStyle>
</prefs>

<%@include file="/docs/footer.jsp"%>

