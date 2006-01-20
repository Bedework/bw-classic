<bean:define id="id" name="sponsor" property="id"/>
<% rpitemp="/sponsor/fetchForUpdate.do?spid=" + id; %>
<sponsor>
  <name>
    <genurl:link page="<%=rpitemp%>">
      <bean:write name="sponsor" property="name" />
    </genurl:link>
  </name>
  <phone><bean:write name="sponsor" property="phone" /></phone>
  <logic:present name="sponsor" property="email">
    <email><bean:write name="sponsor" property="email"/></email>
  </logic:present>
  <logic:present name="sponsor" property="link">
    <link><bean:write name="sponsor" property="link" /></link>
  </logic:present>
</sponsor>
