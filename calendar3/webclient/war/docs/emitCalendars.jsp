<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@ include file="/docs/header.jsp" %>
  <page>calendars</page>

  <%-- List of all calendars and subcalendars. --%>
  <calendars>
    <bean:define id="calendar" name="calForm" property="calendars"
             toScope="session" />
    <%@include file="/docs/emitCalendar.jsp"%>
  </calendars>

<%@ include file="/docs/footer.jsp" %>
