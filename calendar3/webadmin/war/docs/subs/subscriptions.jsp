<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="/docs/header.jsp"%>

<page>subscriptions</page>

<subscriptions>
  <logic:iterate name="peForm" property="subscriptions" id="subscription">
    <subscription>
      <name><bean:write name="subscription" property="name" /></name>
      <uri><bean:write name="subscription" property="uri" /></uri>
      <affectsFreeBusy><bean:write name="subscription" property="affectsFreeBusy" /></affectsFreeBusy>
      <display><bean:write name="subscription" property="display" /></display>
      <style><bean:write name="subscription" property="style" /></style>
      <internal><bean:write name="subscription" property="internalSubscription" /></internal>
      <emailNotifications><bean:write name="subscription" property="emailNotifications" /></emailNotifications>
      <calendarDeleted><bean:write name="subscription" property="calendarDeleted" /></calendarDeleted>
    </subscription>
  </logic:iterate>

  <subscribe>
    <!-- List of calendars to subscribe to-->
    <%@include file="/docs/calendar/emitCalendars.jsp"%>
  </subscribe>
</subscriptions>


<%@include file="/docs/footer.jsp"%>
