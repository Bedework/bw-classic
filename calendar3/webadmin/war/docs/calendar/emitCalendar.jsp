<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<calendar>
  <id><bean:write name="calendar" property="id" /></id>
  <name><bean:write name="calendar" property="name" /></name>
  <path><bean:write name="calendar" property="path" /></path>
  <calendarCollection><bean:write name="calendar" property="calendarCollection" /></calendarCollection>

  <logic:iterate name="calendar" property="children" id="cal">
    <bean:define id="calendar" name="cal" toScope="session" />
    <jsp:include page="/docs/calendar/emitCalendar.jsp" />
  </logic:iterate>
</calendar>

