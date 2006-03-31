<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
    <%-- Output any additional event fields for full format displays --%>
    <logic:present  name="event" property="organizer">
      <bean:define id="organizer" name="event" property="organizer"/>
      <organizer>
        <id><bean:write name="organizer" property="id"/></id><%--
            Value: integer - organizer id --%>
        <bw:emitText name="organizer" property="cn"/><%--
          Value: string - cn of the organizer --%>
        <bw:emitText name="organizer" property="dir"/><%--
              Value: URI - link to a directory for lookup --%>
        <bw:emitText name="organizer" property="language"/><%--
            Value: string - language code --%>
        <bw:emitText name="organizer" property="sentBy"/><%--
          Value: string - usually mailto url --%>
        <bw:emitText name="organizer" property="organizerUri"/><%--
          Value: string - u --%>
      </organizer>
    </logic:present>
    <logic:iterate id="attendee" name="event" property="attendees">
      <attendee>
        <id><bean:write name="attendee" property="id"/></id><%--
            Value: integer - attendee id --%>
        <bw:emitText name="attendee" property="cn"/><%--
          Value: string - cn of the attendee --%>
        <bw:emitText name="attendee" property="cuType"/><%--
          Value: string - type of calendar user --%>
        <bw:emitText name="attendee" property="delegatedFrom"/><%--
               mailto url --%>
        <bw:emitText name="attendee" property="delegatedTo"/><%--
               mailto url --%>
      </organizer>
    </logic:iterate>

