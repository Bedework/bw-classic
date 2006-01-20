<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%@include file="/docs/header.jsp"%>

<page>modCalendar</page>
<creating><bean:write name="peForm" property="addingCalendar"/></creating>

<bean:define id="curcal" name="peForm" property="calendar"/>
<currentCalendar>
  <id><bean:write name="curcal" property="id" /></id>
  <name><bean:write name="curcal" property="name" /></name>
  <summary><bean:write name="curcal" property="summary" /></summary>
  <desc><bean:write name="curcal" property="description" /></desc>
  <path><bean:write name="curcal" property="path" /></path>
  <calendarCollection><bean:write name="curcal" property="calendarCollection" /></calendarCollection>
</currentCalendar>

<%@include file="/docs/calendar/emitCalendars.jsp"%>

<%@include file="/docs/footer.jsp"%>


