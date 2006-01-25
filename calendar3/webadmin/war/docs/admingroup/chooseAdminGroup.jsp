<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="/docs/header.jsp"%>

<page>chooseGroup</page>

<%
  String rpitemp;
%>

<groups>
  <logic:iterate id="adminGroup" name="peForm" property="userAdminGroups" >
    <group>
      <name><bean:write name="adminGroup" property="account" /></name>
      <desc><bean:write name="adminGroup" property="description" /></desc>
    </group>
  </logic:iterate>
</groups>

<%@include file="/docs/footer.jsp"%>
