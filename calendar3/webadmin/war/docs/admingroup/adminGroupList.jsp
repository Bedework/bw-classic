<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="/docs/header.jsp"%>

<page>adminGroupList</page>
<%
  String rpitemp;
%>
<groups>
  <showMembers><bean:write name="peForm" property="showAgMembers"/></showMembers>
  <logic:iterate id="adminGroup" name="peForm" property="adminGroups" >
    <group>
      <name><bean:write name="adminGroup" property="account" /></name>
      <desc><bean:write name="adminGroup" property="description" /></desc>
      <members>
        <logic:equal name="peForm" property="showAgMembers" value="true">
          <logic:present name="adminGroup" property="groupMembers" >
            <logic:iterate name="adminGroup" property="groupMembers"
                           id="member" >
              <member>
                <account><bean:write name="member" property="account" /></account>
                <kind><bean:write name="member" property="kind" /></kind>
              </member>
            </logic:iterate>
          </logic:present>
        </logic:equal>
      </members>
    </group>
  </logic:iterate>
</groups>

<%@include file="/docs/footer.jsp"%>
