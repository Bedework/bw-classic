<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>deleteSponsorConfirm</page>

<sponsor>
  <name>
    <bean:write name="peForm" property="sponsor.name" />
  </name>
  <phone><bean:write name="peForm" property="sponsor.phone" /></phone>
  <logic:present name="peForm" property="sponsor.email">
    <email><bean:write name="peForm" property="sponsor.email"/></email>
  </logic:present>
  <logic:present name="peForm" property="sponsor.link">
    <link><bean:write name="peForm" property="sponsor.link" /></link>
  </logic:present>
</sponsor>

<formElements>
  <genurl:form action="sponsor/delete.do" >
    <html:submit property="cancelled" value="Cancel"/>
    <html:submit property="deleteSponsorOK" value="Delete"/>
  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

