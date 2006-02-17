<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modSyspars</page>
<bean:define id="systemParams" name="peForm" property="syspars"/>
<system>
  <tzid><bean:write name="systemParams" property="tzid"/></tzid>
  <defaultUserViewName><bean:write name="systemParams" property="defaultUserViewName"/></defaultUserViewName>
  <httpConnectionsPerUser><bean:write name="systemParams" property="httpConnectionsPerUser"/></httpConnectionsPerUser>
  <httpConnectionsPerHost><bean:write name="systemParams" property="httpConnectionsPerHost"/></httpConnectionsPerHost>
  <httpConnections><bean:write name="systemParams" property="httpConnections"/></httpConnections>
  <defaultUserQuota><bean:write name="systemParams" property="defaultUserQuota"/></defaultUserQuota>
</system>

<views>
  <logic:iterate name="peForm" property="views" id="view">
    <view>
      <name><bean:write name="view" property="name" /></name>
    </view>
  </logic:iterate>
</views>

<%@include file="/docs/footer.jsp"%>
