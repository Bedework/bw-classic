<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

<bean:define id="eventFmt" name="eventFormatter" scope="request" />
<bean:define id="eventInfo" name="eventFmt" property="eventInfo" />
<bean:define id="event" name="eventFmt" property="event" />
<%-- Output a single event. This page handles fields common to all views --%>
  <event>
    <logic:present  name="eventInfo" property="subscription">
      <subscription>
        <id><bean:write name="eventInfo" property="subscription.id"/></id>
        <affectsFreeBusy><bean:write name="eventInfo" property="subscription.affectsFreeBusy"/></affectsFreeBusy>
        <style><bean:write name="eventInfo" property="subscription.style"/></style>
      </subscription>
    </logic:present>
    <logic:notPresent  name="eventInfo" property="subscription">
      <subscription>
        <id>-1</id>
        <affectsFreeBusy>false</affectsFreeBusy>
        <style></style>
      </subscription>
    </logic:notPresent>
    <start><%-- start date and time --%>
      <bean:define id="date" name="eventFmt"
                   property="start"
                   toScope="request" />
      <%@ include file="emitDate.jsp" %>
    </start>
    <end><%-- end date and time --%>
      <bean:define id="date" name="eventFmt"
                   property="end"
                   toScope="request" />
      <%@ include file="emitDate.jsp" %>
    </end>
    <id><bean:write name="event" property="id"/></id><%--
      Value: integer - event id --%>
    <bw:emitText name="event" property="guid" />
    <bw:emitText name="event" property="recurrence.recurrenceId" tagName="recurrenceId" />
    <bw:emitText name="event" property="summary" /><%--
      Value: string - short description, typically used for the event title  --%>
    <bw:emitText name="event" property="link"/><%--
      Value: URI - link associated with the event --%>
    <public><bean:write name="event" property="publick"/></public>
    <editable><bean:write name="eventInfo" property="editable"/></editable><%--
      Value: true,false - true if user can edit (and delete) event, false otherwise --%>
    <kind><bean:write name="eventInfo" property="kind"/></kind><%--
      Value: 0 - actual event entry
             1 - 'added event' from a reference
             2 - from a subscription --%>
    <recurring><bean:write name="event" property="recurring"/></recurring><%--
      Value: true,false - true if the event is recurring --%>
    <logic:present  name="event" property="calendar">
      <bean:define id="calendar" name="event" property="calendar"/>
      <calendar>
        <name><bean:write name="calendar" property="name"/></name><%--
          Value: string - name of the calendar --%>
        <path><bean:write name="calendar" property="path"/></path><%--
            Value: path to the calendar --%>
        <id><bean:write name="calendar" property="id"/></id><%--
          Value: integer - calendar id --%>
        <owner><bean:write name="calendar" property="owner.account"/></owner><%--
          Value: string - calendar owner id --%>
      </calendar>
    </logic:present>
    <logic:notPresent  name="event" property="calendar">
      <calendar>
        <name></name>
        <path></path>
        <id></id><%--
          Value: integer - calendar id --%>
        <owner></owner><%--
          Value: string - calendar owner id --%>
      </calendar>
    </logic:notPresent>
    <bw:emitText name="event" property="status" /><%-- Status
          Value: string, only one of CONFIRMED, TENTATIVE, or CANCELLED --%>
    <logic:notPresent name="detailView" scope="request"><%-- look for short form --%>
      <logic:notPresent name="allView" scope="request">
        <jsp:include page="event/emitEventShort.jsp"/>
      </logic:notPresent>
    </logic:notPresent>

    <logic:present name="detailView" scope="request">
      <jsp:include page="event/emitEventDetail.jsp"/>
    </logic:present>

    <logic:present name="allView" scope="request">
      <jsp:include page="event/emitEventDetail.jsp"/>
      <jsp:include page="event/emitEventAll.jsp"/>
    </logic:present>
  </event>
