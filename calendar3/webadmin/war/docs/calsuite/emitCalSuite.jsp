<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='bedework' prefix='bw' %>
<html:xhtml/>

<calSuite>
  <bw:emitText name="calSuite" property="name" />
  <bw:emitText name="calSuite" property="group.account" tagName="group" />
  <bw:emitText name="calSuite" property="rootCalendar.path" tagName="calPath" />
  <bw:emitCurrentPrivs name="calSuite" property="currentAccess"/>
  <bw:emitAcl name="calSuite" property="currentAccess" />
</calSuite>
