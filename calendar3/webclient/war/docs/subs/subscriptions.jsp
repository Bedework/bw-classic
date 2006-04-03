<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

<%@include file="/docs/header.jsp"%>

<%
try {
%>

<page>subscriptions</page>

<subscriptions>
  <logic:iterate name="calForm" property="subscriptions" id="subscription">
    <subscription>
      <bw:emitText name="subscription" property="name" />
      <bw:emitText name="subscription" property="uri" />
      <affectsFreeBusy><bean:write name="subscription" property="affectsFreeBusy" /></affectsFreeBusy>
      <display><bean:write name="subscription" property="display" /></display>
      <bw:emitText name="subscription" property="style" />
      <internal><bean:write name="subscription" property="internalSubscription" /></internal>
      <emailNotifications><bean:write name="subscription" property="emailNotifications" /></emailNotifications>
      <calendarDeleted><bean:write name="subscription" property="calendarDeleted" /></calendarDeleted>
      <unremoveable><bean:write name="subscription" property="unremoveable" /></unremoveable>
    </subscription>
  </logic:iterate>

  <subscribe>
    <!-- List of calendars to subscribe to-->
    <%@include file="/docs/calendar/emitPublicCalendars.jsp"%>
  </subscribe>
</subscriptions>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>


<%@include file="/docs/footer.jsp"%>
