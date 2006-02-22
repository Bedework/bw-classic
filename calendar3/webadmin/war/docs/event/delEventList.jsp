<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<page>deleteEventList</page>

<formElements>
  <genurl:form action="delEvent" >
     <html:submit property="delEvents" value="Delete"/>
     <html:submit property="forwardto" value="Cancel"/>
   </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

