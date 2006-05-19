<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

<bean:define id="event" name="formattedEvent" property="event"/>
<bean:define id="calid" name="event" property="calendar.id"/>
<bean:define id="guid" name="event" property="guid"/>
<% String rpitemprecurid = ""; %>
<logic:present name="event" property="recurrence.recurrenceId" >
  <bean:define id="recurid" name="event" property="recurrence.recurrenceId" />
  <% rpitemprecurid = String.valueOf(recurid); %>
</logic:present>

<event>
  <id><bean:write name="event" property="id" /></id>
  <title><bean:write name="event" property="summary" /></title>
  <bw:emitText name="event" property="guid" />
  <bw:emitText name="event" property="recurrence.recurrenceId" tagName="recurrenceId" />
  <allday><bean:write name="peForm" property="eventStartDate.dateOnly"/></allday>
  <bw:emitText name="formattedEvent" property="start.dateString" tagName="start" />
  <bw:emitText name="formattedEvent" property="end.dateString" tagName="end" />
  <logic:present  name="event" property="calendar">
    <bean:define id="calendar" name="event" property="calendar"/>
    <calendar>
      <bw:emitText name="calendar" property="name"/><%--
        Value: string - name of the calendar --%>
      <bw:emitText name="calendar" property="path"/><%--
          Value: path to the calendar --%>
      <bw:emitText name="calendar" property="encodedPath"/><%--
          Value: encoded path to the calendar --%>
      <id><bean:write name="calendar" property="id"/></id><%--
        Value: integer - calendar id --%>
      <bw:emitText name="calendar" property="owner.account" tagName="owner" /><%--
        Value: string - calendar owner id --%>
    </calendar>
  </logic:present>
  <logic:notPresent  name="event" property="calendar">
    <calendar>
      <name></name>
      <path></path>
      <encodedPath></encodedPath>
      <id></id><%--
        Value: integer - calendar id --%>
      <owner></owner><%--
        Value: string - calendar owner id --%>
    </calendar>
  </logic:notPresent>
  <bw:emitText name="event" property="description" tagName="desc" />
  <status><bean:write name="formattedEvent" property="event.status" /></status>
  <bw:emitText name="event" property="link" />
  <bw:emitText name="event" property="cost" />

  <logic:present name="event" property="location">
    <location><bean:write name="formattedEvent" property="event.location.address" /></location>
  </logic:present>
  <logic:notPresent name="event" property="location">
    <location></location>
  </logic:notPresent>

  <logic:present name="event" property="sponsor">
    <sponsor><bean:write name="formattedEvent" property="event.sponsor.name" /></sponsor>
  </logic:present>
  <logic:notPresent name="event" property="sponsor">
    <sponsor></sponsor>
  </logic:notPresent>

  <creator><bean:write name="formattedEvent" property="event.creator.account" /></creator>
</event>

