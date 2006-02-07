<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@ include file="header.jsp" %>
  <page>calendars</page>

  <%-- List of all calendars and subcalendars. --%>
  <calendars>
    <bean:define id="calendar" name="calForm" property="publicCalendars"
             toScope="session" />
    <%@include file="/docs/emitCalendar.jsp"%>

    <%-- old 2.3 code: keep for a short while
    <logic:present name="calForm" property="publicCalendars" >
      <bean:define id="calendars" name="calForm" property="publicCalendars" />
      <logic:iterate id="calendar" name="calendars" >
        <bean:define id="curCal" name="calendar" toScope="request" />
        <jsp:include page="subcalendars.jsp" />
      </logic:iterate>
    </logic:present>
    --%>
  </calendars>

<%@ include file="footer.jsp" %>
