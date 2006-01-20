<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>adminGroupList</page>
<%
  String rpitemp;
%>
<groups>
  <showMembers><bean:write name="peForm" property="showAgMembers"/></showMembers>
  <logic:iterate id="adminGroup" name="peForm" property="adminGroups" >
    <group>
      <bean:define id="account" name="adminGroup" property="account"/>
      <% rpitemp="/admingroup/fetchForUpdate.do?adminGroupName=" + account;  %>
      <name>
        <genurl:link page="<%=rpitemp%>">
           <bean:write name="adminGroup" property="account" />
        </genurl:link>
      </name>
      <desc>
        <bean:write name="adminGroup" property="description" />
      </desc>
      <members>
        <logic:equal name="peForm" property="showAgMembers" value="true">
          <logic:present name="adminGroup" property="groupMembers" >
            <logic:iterate name="adminGroup" property="groupMembers"
                           id="member" >
              <member><bean:write name="member" property="account" /></member>
            </logic:iterate>
          </logic:present>
        </logic:equal>
      </members>
      <% rpitemp="/admingroup/fetchForUpdateMembers.do?adminGroupName=" + account;  %>
      <updateMembersUrl>
        <genurl:link page="<%=rpitemp%>"></genurl:link>
      </updateMembersUrl>
    </group>
  </logic:iterate>
</groups>

<formElements>
  <genurl:form action="admingroup/initUpdate.do">
    <hideMembers>
      <html:radio name="peForm" property="showAgMembers" value="false"
                      onclick="document.peForm.submit();" />
    </hideMembers>
    <showMembers>
      <html:radio name="peForm" property="showAgMembers" value="true"
                      onclick="document.peForm.submit();" />
    </showMembers>
  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>
