<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="/docs/header.jsp"%>

<page>modView</page>
<creating><bean:write name="peForm" property="addingView"/></creating>

<views>
  <bean:define name="peForm" property="view" id="view"/>
  <view>
    <name><bean:write name="view" property="name" /></name>
    <subscriptions>
      <logic:iterate name="view" property="subscriptions" id="subscription">
        <subscription>
          <name><bean:write name="subscription" property="name" /></name>
        </subscription>
      </logic:iterate>
    </subscriptions>
  </view>
</views>

<subscriptions>
  <logic:iterate name="peForm" property="subscriptions" id="subscription">
    <subscription>
      <name><bean:write name="subscription" property="name" /></name>
      <uri><bean:write name="subscription" property="uri" /></uri>
      <affectsFreeBusy><bean:write name="subscription" property="affectsFreeBusy" /></affectsFreeBusy>
      <display><bean:write name="subscription" property="display" /></display>
      <style><bean:write name="subscription" property="style" /></style>
      <emailNotifications><bean:write name="subscription" property="emailNotifications" /></emailNotifications>
      <calendarDeleted><bean:write name="subscription" property="calendarDeleted" /></calendarDeleted>
    </subscription>
  </logic:iterate>
</subscriptions>

<%@include file="/docs/footer.jsp"%>
