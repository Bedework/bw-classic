<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

<%@include file="/docs/header.jsp"%>

<page>modSubscription</page>
<creating><bean:write name="calForm" property="addingSubscription"/></creating>

<subscriptions>
  <subscription>
    <name><bean:write name="calForm" property="subscription.name" /></name>
    <uri><bean:write name="calForm" property="subscription.uri" /></uri>
    <affectsFreeBusy><bean:write name="calForm" property="subscription.affectsFreeBusy" /></affectsFreeBusy>
    <display><bean:write name="calForm" property="subscription.display" /></display>
    <bw:emitText name="calForm" property="subscription.style" />
    <internal><bean:write name="calForm" property="subscription.internalSubscription" /></internal>
    <emailNotifications><bean:write name="calForm" property="subscription.emailNotifications" /></emailNotifications>
    <calendarDeleted><bean:write name="calForm" property="subscription.calendarDeleted" /></calendarDeleted>
    <unremoveable><bean:write name="calForm" property="subscription.unremoveable" /></unremoveable>
  </subscription>

  <subscribe>
    <!-- List of calendars to subscribe to-->
    <%@include file="/docs/calendar/emitPublicCalendars.jsp"%>
  </subscribe>
</subscriptions>

<%@include file="/docs/footer.jsp"%>

