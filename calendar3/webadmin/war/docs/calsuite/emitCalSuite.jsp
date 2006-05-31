<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='bedework' prefix='bw' %>
<html:xhtml/>

<calsuite>
  <bw:emitText name="calSuite" property="name" />
  <bw:emitText name="calSuite" property="group.name" tagName="group" />
  <bw:emitText name="calSuite" property="calendar.path" tagName="calPath" />
</calsuite>
