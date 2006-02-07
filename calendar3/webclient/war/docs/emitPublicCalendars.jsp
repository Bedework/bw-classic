<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@ include file="header.jsp" %>
  <page>calendars</page>

  <%-- List of all calendars and subcalendars. --%>
  <calendars>
    <bean:define id="calendar" name="calForm" property="publicCalendars"
             toScope="session" />
    <%@include file="/docs/emitCalendar.jsp"%>
  </calendars>

<%@ include file="footer.jsp" %>
