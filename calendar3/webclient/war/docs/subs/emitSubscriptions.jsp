<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

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

    <calendars>
      <logic:present name="subscription" property="calendar">
        <bean:define id="calendar" name="subscription" property="calendar"
             toScope="session" />
        <jsp:include page="/docs/calendar/emitCalendar.jsp"/>
      </logic:present>
    </calendars>
  </subscription>
</logic:iterate>
