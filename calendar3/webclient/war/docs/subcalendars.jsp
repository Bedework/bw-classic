<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<bean:define id="calendar" name="curCal" />

<%-- Generate a single calendar entry in the calendar list. --%>
<calendar>
  <name><bean:write name="calendar" property="name"/></name>
  <id><bean:write name="calendar" property="id"/></id>
  <title><bean:write name="calendar" property="title"/></title>
  <description><bean:write name="calendar" property="description"/></description>
  <logic:equal name="calForm" property="guest" value="false"><%--
    Generate a checkbox indicating subscribed status if we are in the
    personal calendar. Use this in the personal calendar subscription form. --%>
    <genurl:form action="subscribe">
      <bean:define id="calId" name="calendar" property="id" />
      <% String rpitemp = "subscribed[" + calId + "]"; %>
      <checkbox><html:checkbox property="<%=rpitemp%>" /></input></checkbox>
    </genurl:form>
  </logic:equal>
  <important>true</important><%--
    Values: true,false - indicates whether a calendar will show up on the
    front page listings --%>
  <logic:present name="calendar" property="children" ><%--
    iterate recursively over any subcalendars --%>
    <logic:iterate id="subcalendar" name="calendar" property="children" >
      <bean:define id="curCal" name="subcalendar" toScope="request" />
      <jsp:include page="subcalendars.jsp" />
    </logic:iterate>
  </logic:present>
</calendar>
