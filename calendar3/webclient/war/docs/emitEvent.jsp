<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<bean:define id="eventFmt" name="eventFormatter" scope="request" />
<bean:define id="eventInfo" name="eventFmt" property="eventInfo" />
<bean:define id="event" name="eventFmt" property="event" />
<%-- Output a single event --%>
  <event>
    <subscription>
      <id><bean:write name="eventInfo" property="subscription.id"/></id>
      <affectsFreeBusy><bean:write name="eventInfo" property="subscription.affectsFreeBusy"/></affectsFreeBusy>
      <style><bean:write name="eventInfo" property="subscription.style"/></style>
    </subscription>
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
    <guid><bean:write name="event" property="guid"/></guid>
    <logic:present  name="event" property="recurrence.recurrenceId">
      <recurrenceId><bean:write name="event" property="recurrence.recurrenceId"/></recurrenceId>
    </logic:present>
    <logic:notPresent  name="event" property="recurrence.recurrenceId">
      <recurrenceId></recurrenceId>
    </logic:notPresent>
    <summary><bean:write name="event" property="summary"/></summary><%--
    <summary><bean:write name="event" property="summary"/></summary><%--
      Value: string - short description, typically used for the event title  --%>
    <link><bean:write name="event" property="link"/></link><%--
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
    <logic:present  name="event" property="location">
      <bean:define id="location" name="event" property="location"/>
      <location>
        <id><bean:write name="location" property="id"/></id><%--
            Value: integer - location id --%>
        <address><bean:write name="location" property="address"/></address><%--
          Value: string - physical address of the location --%>
        <link><bean:write name="location" property="link"/></link><%--
            Value: URI - link to a web address for the location --%>
        <logic:present name="detailView" scope="request"><%--
          Only output these attributes if we are in detailed mode... --%>
          <subaddress><bean:write name="location" property="subaddress"/></subaddress><%--
            Value: string - more address information --%>
          <creator><bean:write name="location" property="creator.account"/></creator><%--
            Value: string - location creator id --%>
        </logic:present>
      </location>
    </logic:present>
    <logic:notPresent  name="event" property="location">
      <location>
        <address></address>
        <logic:present name="detailView" scope="request"><%--
          Only output these attributes if we are in detailed mode... --%>
          <id></id><%--
            Value: integer - location id --%>
          <subaddress></subaddress><%--
            Value: string - more address information --%>
          <link></link><%--
            Value: URI - link to a web address for the location --%>
          <creator></creator><%--
            Value: string - location creator id --%>
        </logic:present>
      </location>
    </logic:notPresent>
    <categories>
      <logic:present name="event" property="categories">
        <logic:iterate id="category" name="event" property="categories">
          <category>
            <id><bean:write name="category" property="id"/></id><%--
              Value: integer - category id --%>
            <value><bean:write name="category" property="word"/></value><%--
              Value: string - the category value --%>
            <logic:present name="detailView" scope="request"><%--
              Only output these attributes if we are in detailed mode... --%>
              <description><bean:write name="category" property="description"/></description><%--
                Value: string - long description of category --%>
              <creator><bean:write name="category" property="creator.account"/></creator><%--
                Value: string - category creator id --%>
            </logic:present>
          </category>
        </logic:iterate>
      </logic:present>
    </categories>
    <logic:present name="detailView" scope="request"><%--
      Only output these attributes if we are in detailed mode... --%>
      <description><bean:write name="event" property="description"/></description><%--
          Value: string - long description of the event.  Limited to 500 characters. --%>
      <cost><bean:write name="event" property="cost"/></cost><%--
          Value: string - cost information --%>
      <sequence><bean:write name="event" property="sequence"/></sequence><%--
          RFC sequence number for the event --%>

      <logic:present name="event" property="sponsor">
        <bean:define id="sponsor" name="event" property="sponsor"/>
        <sponsor>
          <id><bean:write name="sponsor" property="id"/></id><%--
            Value: integer - sponsor id --%>
          <name><bean:write name="sponsor" property="name"/></name><%--
            Value: string - sponsor's name --%>
          <phone><bean:write name="sponsor" property="phone"/></phone><%--
            Value (example): x7777 - sponsor's phone number --%>
          <email><bean:write name="sponsor" property="email"/></email><%--
            Value (example): nobody@nowhere.edu - sponsor's email address --%>
          <link><bean:write name="sponsor" property="link"/></link><%--
            Value: URI - link to sponsor web page --%>
        </sponsor>
      </logic:present>
    </logic:present>
  </event>
