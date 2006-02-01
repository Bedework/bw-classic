<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modSyspars</page>
<bean:define id="systemParams" name="peForm" property="syspars"/>
<prefs>
  <defaultUserViewName><bean:write name="systemParams" property="defaultUserViewName"/></defaultUserViewName>
  <directoryBrowsingDisallowed><bean:write name="systemParams" property="directoryBrowsingDisallowed"/></directoryBrowsingDisallowed>
  <httpConnectionsPerUser><bean:write name="systemParams" property="httpConnectionsPerUser"/></httpConnectionsPerUser>
  <httpConnectionsPerHost><bean:write name="systemParams" property="httpConnectionsPerHost"/></httpConnectionsPerHost>
  <httpConnections><bean:write name="systemParams" property="httpConnections"/></httpConnections>
  <defaultUserQuota><bean:write name="systemParams" property="defaultUserQuota"/></defaultUserQuota>
</prefs>

<%@include file="/docs/footer.jsp"%>
