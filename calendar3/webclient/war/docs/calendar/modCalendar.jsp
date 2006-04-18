<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="/docs/header.jsp"%>

<page>modCalendar</page>
<creating><bean:write name="calForm" property="addingCalendar"/></creating>

<%@include file="/docs/calendar/displayCalendarCommon.jsp"%>

<%@include file="/docs/calendar/emitCalendars.jsp"%>

<%@include file="/docs/footer.jsp"%>


