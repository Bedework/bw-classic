<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<html:xhtml/>

<group>
  <name><bean:write name="peForm" property="updAdminGroup.account" /></name>
  <desc><bean:write name="peForm" property="updAdminGroup.description" /></desc>
  <groupOwner><bean:write name="peForm" property="adminGroupGroupOwner" /></groupOwner>
  <eventsOwner><bean:write name="peForm" property="adminGroupEventOwner" /></eventsOwner>
  <members>
    <logic:present name="peForm" property="updAdminGroup.groupMembers" >
      <logic:iterate name="peForm" property="updAdminGroup.groupMembers"
                     id="member" >
        <member><bean:write name="member" property="account" /></member>
      </logic:iterate>
    </logic:present>
  </members>
</group>
