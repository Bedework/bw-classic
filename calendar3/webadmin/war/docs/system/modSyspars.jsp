<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<%@ taglib uri='bedework' prefix='bw' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modSyspars</page>
<bean:define id="systemParams" name="peForm" property="syspars"/>
<system>
  <bw:emitText name="systemParams" property="tzid"/>
  <bw:emitText name="systemParams" property="defaultUserViewName"/>
  <bw:emitText name="systemParams" property="httpConnectionsPerUser"/>
  <bw:emitText name="systemParams" property="httpConnectionsPerHost"/>
  <bw:emitText name="systemParams" property="httpConnections"/>
  <bw:emitText name="systemParams" property="maxPublicDescriptionLength"/>
  <bw:emitText name="systemParams" property="maxUserDescriptionLength"/>
  <bw:emitText name="systemParams" property="maxUserEntitySize"/>
  <bw:emitText name="systemParams" property="defaultUserQuota"/>
</system>

<views>
  <logic:iterate name="peForm" property="views" id="view">
    <view>
      <name><bean:write name="view" property="name" /></name>
    </view>
  </logic:iterate>
</views>

<%@include file="/docs/footer.jsp"%>
