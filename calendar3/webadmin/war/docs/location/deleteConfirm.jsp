<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>deleteLocationConfirm</page>

<location>
  <address>
    <bean:write name="peForm" property="location.address" />
  </address>
  <subaddress>
    <bean:write name="peForm" property="location.subaddress" />
  </subaddress>
  <logic:present name="peForm" property="location.link">
    <link><bean:write name="peForm" property="location.link" /></link>
  </logic:present>
</location>

<formElements>
  <genurl:form action="location/delete.do" >
    <html:submit property="cancelled" value="Cancel"/>
    <html:submit property="deleteLocationOK" value="Delete"/>
  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

