<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

<%@include file="/docs/header.jsp"%>

<%
try {
%>

<page>subscriptions</page>

<subscriptions>
  <%-- this is now permanently in header.jsp so the code is being duplicated;
       we should consolidate the subscriptions code by removing it here --
       just produce the "subscribe" list below.  --%>
  <%@include file="/docs/subs/emitSubscriptions.jsp"%>

  <subscribe>
    <!-- List of calendars to subscribe to-->
    <%@include file="/docs/calendar/emitPublicCalendars.jsp"%>
  </subscribe>
</subscriptions>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>


<%@include file="/docs/footer.jsp"%>
