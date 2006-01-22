<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>authUserList</page>
<%
  String rpitemp;
%>

<authUsers>
  <logic:iterate id="authUser" name="peForm" property="authUsers" >
    <authUser>
      <account><bean:write name="authUser" property="user.account" /></account>
      <superUser><bean:write name="authUser" property="superUser"/></superUser>
      <alertUser><bean:write name="authUser" property="alertUser"/></alertUser>
      <publicEventUser><bean:write name="authUser" property="publicEventUser"/></publicEventUser>
    </authUser>
  </logic:iterate>
</authUsers>

<%@include file="/docs/footer.jsp"%>

