<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%@include file="/docs/header.jsp"%>

<page>displayEvent</page>

<%@include file="/docs/event/displayEventCommon.jsp"%>

<bean:define id="loggedInId" name="peForm" property="adminUserId" />
<logic:equal name="peForm" property="event.creator.account" value="<%=(String)loggedInId%>">
  <canEdit>true</canEdit>
</logic:equal>
<logic:notEqual name="peForm" property="event.creator.account" value="<%=(String)loggedInId%>">
  <canEdit>false</canEdit>
</logic:notEqual>

<%@include file="/docs/footer.jsp"%>
