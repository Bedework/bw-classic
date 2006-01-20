<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modAdminGroupMembers</page>

<adminGroup>
  <name><bean:write name="peForm" property="updAdminGroup.account" /></name>
  <members>
    <logic:present name="peForm" property="updAdminGroup.groupMembers" >
      <logic:iterate name="peForm" property="updAdminGroup.groupMembers"
                     id="member" >
        <member><bean:write name="member" property="account" /></member>
      </logic:iterate>
    </logic:present>
  </members>
</adminGroup>

<formElements>
  <genurl:form action="admingroup/updateMembers" >
    <member><html:text property="updGroupMember" size="15" /></member>

    <!-- these are the values that may be submitted to the update action -->
    <submitButtons>
      <button type="add">addGroupMember</button>
      <button type="remove">removeGroupMember</button>
    </submitButtons>

  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

