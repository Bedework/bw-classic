<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>eventList</page>

<%--  Generate events --%>
<events>
  <logic:iterate id="formattedEvent" name="peForm" property="formattedEvents" >
    <%@include file="/docs/event/emitEvent.jsp"%>
  </logic:iterate>
</events>

<%--  Generate form elements to be exposed --%>
<formElements>
  <genurl:form action="event/fetchForDisplay.do">
    <listAllSwitchFalse>
      <html:radio name="peForm" property="listAllEvents"
                    value="false"
                    onclick="document.peForm.submit();" />
    </listAllSwitchFalse>
    <listAllSwitchTrue>
      <html:radio name="peForm" property="listAllEvents"
                    value="true"
                    onclick="document.peForm.submit();" />
    </listAllSwitchTrue>
  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

