<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<html:xhtml/>

<bean:define id="id" name="location" property="id"/>
<% rpitemp="/location/fetchForUpdate.do?locid=" + id; %>
<location>
  <address>
    <genurl:link page="<%=rpitemp%>">
      <bean:write name="location" property="address" />
    </genurl:link>
  </address>
  <subaddress>
    <bean:write name="location" property="subaddress" />
  </subaddress>
  <logic:present name="location" property="link">
    <link><bean:write name="location" property="link" /></link>
  </logic:present>
</location>
