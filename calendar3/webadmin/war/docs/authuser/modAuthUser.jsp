<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modAuthUser</page>

<!-- Mod pages contain only formElements for now; we do this to
     take advantage of Struts' form processing features -->
<formElements>
  <genurl:form action="authuser/update" >
    <account><bean:write name="peForm" property="editAuthUser.user.account" /></account>
    <alerts><html:checkbox property="editAuthUserAlerts" /></alerts>
    <publicEvents><html:checkbox property="editAuthUserPublicEvents" /></publicEvents>
    <superUser><html:checkbox property="editAuthUserSuperUser" /></superUser>
    <email><html:text property="editAuthUser.email" size="30" /></email>
    <phone><html:text property="editAuthUser.phone" size="30" /></phone>
    <dept><html:text property="editAuthUser.dept" size="30" /></dept>
    <lastname><html:text property="editAuthUser.lastname" size="30" /></lastname>
    <firstname><html:text property="editAuthUser.firstname" size="30" /></firstname>

    <submitButtons>
      <button type="update">modAuthUser</button>
    </submitButtons>

  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

