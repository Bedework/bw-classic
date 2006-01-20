<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>chooseGroup</page>

<%
  String rpitemp;
%>

<groups>
  <logic:iterate id="adminGroup" name="peForm"
                 property="userAdminGroups" >
    <bean:define id="account" name="adminGroup" property="account"/>
    <% rpitemp="/setup.do?adminGroupName=" + account;  %>
    <group>
      <name>
        <genurl:link page="<%=rpitemp%>">
          <bean:write name="adminGroup" property="account" />
        </genurl:link>
      </name>
      <desc>
        <bean:write name="adminGroup" property="description" />
      </desc>
    </group>
  </logic:iterate>
</groups>

<%@include file="/docs/footer.jsp"%>
