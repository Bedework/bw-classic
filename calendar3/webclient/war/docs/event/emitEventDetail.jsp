<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

    <%-- Output any event fields with forms specific to short format displays --%>
    <logic:present  name="event" property="location">
      <bean:define id="location" name="event" property="location"/>
      <location>
        <id><bean:write name="location" property="id"/></id><%--
            Value: integer - location id --%>
        <bw:emitText name="location" property="address" /><%--
          Value: string - physical address of the location --%>
        <bw:emitText name="location" property="link"/><%--
            Value: URI - link to a web address for the location --%>
        <bw:emitText name="location" property="subaddress"/><%--
          Value: string - more address information --%>
        <bw:emitText name="location" property="creator.account" tagName="creator" /><%--
          Value: string - location creator id --%>
      </location>
    </logic:present>
    <logic:notPresent  name="event" property="location">
      <location>
        <address></address>
        <id></id><%--
          Value: integer - location id --%>
        <subaddress></subaddress><%--
          Value: string - more address information --%>
        <link></link><%--
          Value: URI - link to a web address for the location --%>
        <creator></creator><%--
          Value: string - location creator id --%>
      </location>
    </logic:notPresent>
    <categories>
      <logic:present name="event" property="categories">
        <logic:iterate id="category" name="event" property="categories">
          <category>
            <id><bean:write name="category" property="id"/></id><%--
              Value: integer - category id --%>
            <bw:emitText name="category" property="word"/><%--
              Value: string - the category value --%>
            <bw:emitText name="category" property="description"/><%--
              Value: string - long description of category --%>
            <bw:emitText name="category" property="creator.account" tagName="creator" /><%--
              Value: string - category creator id --%>
          </category>
        </logic:iterate>
      </logic:present>
    </categories>
    <bw:emitText name="event" property="description" /><%--
        Value: string - long description of the event.  Limited to 500 characters. --%>
    <bw:emitText name="event" property="cost" /><%--
        Value: string - cost information --%>
    <sequence><bean:write name="event" property="sequence"/></sequence><%--
        RFC sequence number for the event --%>

    <logic:present name="event" property="sponsor">
      <bean:define id="sponsor" name="event" property="sponsor"/>
      <sponsor>
        <id><bean:write name="sponsor" property="id"/></id><%--
          Value: integer - sponsor id --%>
        <bw:emitText name="sponsor" property="name"/><%--
          Value: string - sponsor's name --%>
        <bw:emitText name="sponsor" property="phone"/><%--
          Value (example): x7777 - sponsor's phone number --%>
        <bw:emitText name="sponsor" property="email"/><%--
          Value (example): nobody@nowhere.edu - sponsor's email address --%>
        <bw:emitText name="sponsor" property="link"/><%--
          Value: URI - link to sponsor web page --%>
      </sponsor>
    </logic:present>
    <bw:emitCurrentPrivs name="eventInfo" property="currentAccess" />

