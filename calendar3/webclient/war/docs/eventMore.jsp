<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@ include file="header.jsp" %>
<%
try {
%>
  <page>event</page>
  <%-- Wrapper for a single event (emitEvent.jsp) --%>
    <bean:define id="detailView" value="true" toScope="request"/>
    <bean:define id="eventFormatter"
                 name="calForm"
                 property="curEventFmt"
                 toScope="request"/>

    <jsp:include page="emitEvent.jsp"/>
<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="footer.jsp" %>
