<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>deleteAdminGroupConfirm</page>

<groups>
  <jsp:include page="displayAdminGroupCommon.jsp" />
</groups>

<formElements>
  <genurl:form action="admingroup/delete.do" >
    <html:submit property="cancelled" value="Cancel"/>
    <html:submit property="removeAdminGroupOK" value="Delete"/>
  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

