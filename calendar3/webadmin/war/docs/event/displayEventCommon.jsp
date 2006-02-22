<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<event>
  <id><bean:write name="peForm" property="event.id"/></id>
  <title><bean:write name="peForm" property="event.summary"/></title>
  <calendar><bean:write name="peForm" property="calendar.name"/></calendar>
  <allDay><bean:write name="peForm" property="eventStartDate.dateOnly"/></allDay>
  <start>
    <month><bean:write name="peForm" property="eventStartDate.month"/></month>
    <day><bean:write name="peForm" property="eventStartDate.day"/></day>
    <year><bean:write name="peForm" property="eventStartDate.year"/></year>
    <hour><bean:write name="peForm" property="eventStartDate.hour"/></hour>
    <minute><bean:write name="peForm" property="eventStartDate.minute"/></minute>
    <logic:notEqual name="peForm" property="hour24" value="true" >
      <ampm><bean:write name="peForm" property="eventStartDate.ampm"/></ampm>
    </logic:notEqual>
  </start>
  <end>
    <type><bean:write name="peForm" property="eventEndType"/></type>
    <dateTime>
      <month><bean:write name="peForm" property="eventEndDate.month"/></month>
      <day><bean:write name="peForm" property="eventEndDate.day"/></day>
      <year><bean:write name="peForm" property="eventEndDate.year"/></year>
      <hour><bean:write name="peForm" property="eventEndDate.hour"/></hour>
      <minute><bean:write name="peForm" property="eventEndDate.minute"/></minute>
      <logic:notEqual name="peForm" property="hour24" value="true" >
        <html:select property="eventEndDate.ampm">
          <ampm><bean:write name="peForm" property="eventEndDate.ampmLabels"/></ampm>
        </html:select>
      </logic:notEqual>
    </dateTime>
    <duration>
      <type></type>
      <days><bean:write name="peForm" property="eventDuration.daysStr"/> </days>
      <hours><bean:write name="peForm" property="eventDuration.hoursStr"/></hours>
      <minutes><bean:write name="peForm" property="eventDuration.minutesStr"/></minutes>
      <weeks><bean:write name="peForm" property="eventDuration.weeksStr"/></weeks>
    </duration>
  </end>

  <logic:present name="peForm" property="event.category[0]" >
    <category><bean:write name="peForm" property="event.category[0].word"/></category>
  </logic:present>
  <desc><bean:write name="peForm" property="event.description"/></desc>

  <status><bean:write name="peForm" property="event.status"/></status>
  <link><bean:write name="peForm" property="event.link"/></link>
  <cost><bean:write name="peForm" property="event.cost"/></cost>

  <logic:present name="peForm" property="event.location">
    <location><bean:write name="peForm" property="event.location.address"/></location>
  </logic:present>
  <logic:present name="peForm" property="event.sponsor">
    <sponsor><bean:write name="peForm" property="event.sponsor.name"/></sponsor>
  </logic:present>
  <logic:present name="peForm" property="event.creator">
    <creator><bean:write name="peForm" property="event.creator.account"/></creator>
  </logic:present>
  <owner><bean:write name="peForm" property="event.creator.account"/></owner>
</event>

