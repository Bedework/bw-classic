<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modCalSuite</page>
<creating><bean:write name="peForm" property="addingCalSuite"/></creating>

<!-- Mod pages contain only formElements for now; we do this to
     take advantage of Struts' form processing features -->
<formElements>
  <genurl:form action="calSuite/update" >

    <name><html:text property="name" size="30" /></name>
    <group><html:text property="groupName" size="30" /></group>
    <calendar><html:text property="calPath" size="30" /></calendar>

     <!-- these are the values that may be submitted to the update action -->
    <submitButtons>
      <button type="add">addCalSuite</button>
      <button type="update">updateCalSuite</button>
      <button type="cancel">forwardto</button>
      <button type="delete">delete</button>
    </submitButtons>

  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

