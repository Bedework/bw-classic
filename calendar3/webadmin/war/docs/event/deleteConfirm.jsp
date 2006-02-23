<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>deleteEventConfirm</page>

<%@include file="/docs/event/displayEventCommon.jsp"%>

<formElements>
  <genurl:form action="event/delete.do" >
    <html:submit property="cancelled" value="Cancel"/>
    <html:submit property="deleteEventOK" value="Delete"/>
  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

