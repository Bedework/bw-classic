<bean:define id="eventId" name="formattedEvent" property="event.id"/>
<% String rpitemp="/event/fetchForUpdate.do?eventId=" + eventId; %>

<event>
  <id><bean:write name="formattedEvent" property="event.id" /></id>
  <title>
    <genurl:link page="<%=rpitemp%>">
      <bean:write name="formattedEvent" property="event.summary" />
    </genurl:link>
  </title>
  <allday><bean:write name="peForm" property="eventStartDate.dateOnly"/></allday>
  <start><bean:write name="formattedEvent" property="start.dateString" /></start>
  <end><bean:write name="formattedEvent" property="end.dateString" /></end>
  <calendar>
    <logic:present name="formattedEvent" property="event.category[0]" >
      <bean:write name="formattedEvent" property="event.category[0].word" />
    </logic:present>
  </calendar>
  <desc><bean:write name="formattedEvent" property="event.description" /></desc>
  <link><bean:write name="formattedEvent" property="event.link" /></link>
  <cost><bean:write name="formattedEvent" property="event.cost" /></cost>
  <location><bean:write name="formattedEvent" property="event.location.address" /></location>
  <sponsor><bean:write name="formattedEvent" property="event.sponsor.name" /></sponsor>
  <creator><bean:write name="formattedEvent" property="event.creator.account" /></creator>
</event>

