<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

<bean:define id="curcal" name="calForm" property="calendar"/>
<currentCalendar>
  <id><bean:write name="calendar" property="id" /></id>
  <bw:emitText name="calendar" property="name" />
  <bw:emitText name="calendar" property="path" />
  <bw:emitText name="calendar" property="description" tagName="desc" />
  <calendarCollection><bean:write name="calendar" property="calendarCollection" /></calendarCollection>
  <bw:emitText name="calendar" property="mailListId" />
  <bw:emitCurrentPrivs name="calendar" property="currentAccess" />
  <bw:emitAcl name="calendar" property="currentAccess" />
</currentCalendar>
