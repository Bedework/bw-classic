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
    <email></email><!-- should come from a directory, not internal -->
    <phone></phone><!-- should come from a directory, not internal -->
    <dept></dept><!-- should come from a directory, not internal -->
    <lastname></lastname><!-- should come from a directory, not internal -->
    <firstname></firstname><!-- should come from a directory, not internal -->

    <submitButtons>
      <button type="update">modAuthUser</button>
    </submitButtons>

  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

