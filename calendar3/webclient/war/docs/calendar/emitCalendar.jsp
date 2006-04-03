<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

<calendar>
  <id><bean:write name="calendar" property="id" /></id>
  <bw:emitText name="calendar" property="name" />
  <bw:emitText name="calendar" property="path" />
  <bw:emitText name="calendar" property="description" tagName="desc" />
  <calendarCollection><bean:write name="calendar" property="calendarCollection" /></calendarCollection>
  <bw:emitText name="calendar" property="mailListId" />
  <bw:emitCurrentPrivs name="calendar" property="currentAccess" />

  <logic:iterate name="calendar" property="children" id="cal">
    <bean:define id="calendar" name="cal" toScope="session" />
    <jsp:include page="/docs/calendar/emitCalendar.jsp" />
  </logic:iterate>
</calendar>

