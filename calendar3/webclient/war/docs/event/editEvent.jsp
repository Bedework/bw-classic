<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@ include file="/docs/header.jsp" %>

<%
try {
%>

<page>editEvent</page>
<formElements>
  <subscriptionId></subscriptionId>
  <calendarId><bean:write name="calForm" property="editEvent.calendar.id"/></calendarId>
  <guid><bean:write name="calForm" property="editEvent.guid"/></guid>
  <recurrenceId><bean:write name="calForm" property="editEvent.recurrence.recurrenceId"/></recurrenceId>

  <genurl:form action="editEvent">
    <title>
      <html:text property="editEvent.summary"/>
    </title>
    <calendar>
      <name><bean:write name="calForm" property="editEvent.calendar.name"/></name>
      <path><bean:write name="calForm" property="editEvent.calendar.path"/></path>
      <encodedPath><bean:write name="calForm" property="editEvent.calendar.encodedPath" /></encodedPath>
    </calendar>
    <allDay><html:checkbox property="eventStartDate.dateOnly"/></allDay>
    <start>
      <month>
        <html:select property="eventStartDate.month">
          <html:options labelProperty="eventStartDate.monthLabels"
                        property="eventStartDate.monthVals"/>
        </html:select>
      </month>
      <day>
        <html:select property="eventStartDate.day">
          <html:options labelProperty="eventStartDate.dayLabels"
                        property="eventStartDate.dayVals"/>
        </html:select>
      </day>
      <year>
        <html:select property="eventStartDate.year">
          <html:options property="yearVals"/>
        </html:select>
      </year>
      <yearText>
        <html:text property="eventStartDate.year" size="4"/>
      </yearText>
      <hour>
        <html:select property="eventStartDate.hour">
          <html:options labelProperty="eventStartDate.hourLabels"
                        property="eventStartDate.hourVals"/>
        </html:select>
      </hour>
      <minute>
        <html:select property="eventStartDate.minute">
          <html:options labelProperty="eventStartDate.minuteLabels"
                        property="eventStartDate.minuteVals"/>
        </html:select>
      </minute>
      <logic:notEqual name="calForm" property="hour24" value="true" >
        <ampm>
          <html:select property="eventStartDate.ampm">
            <html:options property="eventStartDate.ampmLabels"/>
          </html:select>
        </ampm>
      </logic:notEqual>
    </start>
    <end>
      <type><bean:write name="calForm" property="eventEndType"/></type>
      <dateTime>
        <month>
          <html:select property="eventEndDate.month">
              <html:options labelProperty="eventEndDate.monthLabels"
                            property="eventEndDate.monthVals"/>
          </html:select>
        </month>
        <day>
          <html:select property="eventEndDate.day">
            <html:options labelProperty="eventEndDate.dayLabels"
                          property="eventEndDate.dayVals"/>
          </html:select>
        </day>
        <year>
          <html:select property="eventEndDate.year">
            <html:options property="yearVals"/>
          </html:select>
          </year>
        <yearText>
          <html:text property="eventEndDate.year" size="4"/>
        </yearText>
        <hour>
          <html:select property="eventEndDate.hour">
            <html:options labelProperty="eventEndDate.hourLabels"
                          property="eventEndDate.hourVals"/>
          </html:select>
        </hour>
        <minute>
          <html:select property="eventEndDate.minute">
            <html:options labelProperty="eventEndDate.minuteLabels"
                          property="eventEndDate.minuteVals"/>
          </html:select>
        </minute>
        <ampm>
          <logic:notEqual name="calForm" property="hour24" value="true" >
            <html:select property="eventEndDate.ampm">
              <html:options property="eventEndDate.ampmLabels"/>
            </html:select>
          </logic:notEqual>
        </ampm>
      </dateTime>
      <duration>
        <days><html:text property="eventDuration.daysStr" size="2" /></days>
        <hours><html:text property="eventDuration.hoursStr" size="2" /></hours>
        <minutes><html:text property="eventDuration.minutesStr" size="2" /></minutes>
        <weeks><html:text property="eventDuration.weeksStr" size="2" /></weeks>
      </duration>
    </end>
    <desc><html:textarea property="editEvent.description"></html:textarea></desc>
    <status><bean:write name="calForm" property="editEvent.status"/></status>
    <link><html:text property="editEvent.link"/></link>
    <location>
      <locationmenu>
        <html:select property="eventLocationId">
          <html:optionsCollection property="locations"
                                  label="address"
                                  value="id"/>
        </html:select>
      </locationmenu>
      <locationtext><html:text property="laddress" /></locationtext>
    </location>
  </genurl:form>
</formElements>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="/docs/footer.jsp" %>

