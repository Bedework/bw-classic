<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@ include file="/docs/header.jsp" %>

<%
try {
%>

<page>editLocation</page>
<formElements>
  <genurl:form action="editLoc">
    <address><html:text property="editLocation.address"/></address>
    <subaddress><html:textarea property="editLocation.subaddress" rows="8" cols="55"/></subaddress>
    <link><html:text property="editLocation.link" /></link>
    <id><bean:write name="calForm" property="editLocation.id"/></id>
  </genurl:form>
</formElements>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="/docs/footer.jsp" %>

