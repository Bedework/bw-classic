<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="/docs/header.jsp"%>

<page>addSubByUri</page>

<subscriptions>
  <subscribe>
    <!-- List of calendars to subscribe to-->
    <%@include file="/docs/calendar/emitPublicCalendars.jsp"%>
  </subscribe>
</subscriptions>

<%@include file="/docs/footer.jsp"%>

