<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%@ include file="header.jsp" %>

<%
try {
%>

<page>editLocation</page>
<locationform>
  <genurl:form action="editLoc">
    <address><html:text property="editLocation.address"/></input></address>
    <subaddress><html:textarea property="editLocation.subaddress" rows="8" cols="55"/></subaddress>
    <link><html:text property="editLocation.link" /></input></link>
    <id><bean:write name="calForm" property="editLocation.id"/></id>
  </genurl:form>
</locationform>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="footer.jsp" %>

