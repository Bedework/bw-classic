<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modCalSuite</page>
<creating><bean:write name="peForm" property="addingCalSuite"/></creating>

<%/* <bean:define id="calSuite" name="peForm" property="calSuite"/> */%>
<calSuite>
  <%/*<bw:emitText name="calSuite" property="name" />
  <bw:emitText name="calSuite" property="group.name" tagName="group" />
  <bw:emitText name="calSuite" property="calendar.path" tagName="calPath" />*/%>
</calSuite>

<%@include file="/docs/footer.jsp"%>

