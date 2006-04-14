<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<%@ taglib uri='bedework' prefix='bw' %>

<%@ include file="/docs/header.jsp" %>

<%
try {
%>

<page>freeBusy</page>

<freebusy>
<logic:iterate id="freeBusyObj" name="calForm" property="freeBusy" >
  <day>
    <bw:emitText name="freeBusyObj" property="who.account" tagName="who" />
    <bw:emitText name="freeBusyObj" property="start.dtval" tagName="start" />
    <bw:emitText name="freeBusyObj" property="end.dtval" tagName="end" />
    <logic:iterate id="fbperiod"  name="freeBusyObj" property="times" >
    <period>
      <fbtype><bean:write name="fbperiod" property="type" /></fbtype>
      <start><bean:write name="fbperiod" property="startTime" /></start>
      <length><bean:write name="fbperiod" property="minutesLength" /></length>
    </period>
    </logic:iterate>
  </day>
</logic:iterate>
</freebusy>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="/docs/footer.jsp" %>

