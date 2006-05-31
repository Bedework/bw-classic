<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='bedework' prefix='bw' %>
<html:xhtml/>

<bean:define id="name" name="calSuite" property="name"/>
<% rpitemp="/calsuite/fetchForUpdate.do?calname=" + name; %>
<calsuite>
  <name>
    <genurl:link page="<%=rpitemp%>">
      <bean:write name="calSuite" property="name" />
    </genurl:link>
  </name>
  <bw:emitText name="calSuite" property="group.name" tagName"group" />
  <bw:emitText name="calSuite" property="calendar.path" tagName"calPath" />
</calsuite>
