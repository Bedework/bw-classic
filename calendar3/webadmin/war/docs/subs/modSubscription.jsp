<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="/docs/header.jsp"%>

<page>modSubscription</page>
<creating><bean:write name="peForm" property="addingSubscription"/></creating>

<subscriptions>
  <subscription>
    <name><bean:write name="peForm" property="subscription.name" /></name>
    <uri><bean:write name="peForm" property="subscription.uri" /></uri>
    <affectsFreeBusy><bean:write name="peForm" property="subscription.affectsFreeBusy" /></affectsFreeBusy>
    <display><bean:write name="peForm" property="subscription.display" /></display>
    <style><bean:write name="peForm" property="subscription.style" /></style>
    <internal><bean:write name="peForm" property="subscription.internalSubscription" /></internal>
    <emailNotifications><bean:write name="peForm" property="subscription.emailNotifications" /></emailNotifications>
    <calendarDeleted><bean:write name="peForm" property="subscription.calendarDeleted" /></calendarDeleted>
    <unremoveable><bean:write name="subscription" property="unremoveable" /></unremoveable>
  </subscription>

  <subscribe>
    <!-- List of calendars to subscribe to-->
    <%@include file="/docs/calendar/emitCalendars.jsp"%>
  </subscribe>
</subscriptions>

<%@include file="/docs/footer.jsp"%>

