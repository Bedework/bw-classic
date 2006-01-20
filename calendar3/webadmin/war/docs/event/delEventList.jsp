<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<page>deleteEventList</page>

<%--
  This is wrong
<events>
  <logic:iterate id="fevent" name="peForm" property="formattedEvents" >
    <%@include file="/docs/event/emitEvent.jsp"%>
  </logic:iterate>
</events>
--%>

<formElements>
  <genurl:form action="delEvent" >
     <html:submit property="delEvents" value="Delete"/>
     <html:submit property="forwardto" value="Cancel"/>
   </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

