<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%@ include file="header.jsp" %>

<page>save</page>

<%-- This page could change the content type and produce a properties file --%>

<propertyGroups>
  <logic:iterate id="pgroup" name="configForm" property="propertyCollections">
    <bean:define id="bwpgname" name="pgroup" property="name" />
    <bean:define id="bwpgprefix" name="pgroup" property="prefix" />
    <propertyGroup name="<%=bwpgname%>">
      <logic:iterate id="prop" name="pgroup" property="properties" >
        <bean:define id="bwpsuffix" name="prop" property="suffix" />
        <% String nm = "org.bedework." + String.valueOf(bwpgprefix) + "." + String.valueOf(bwpsuffix); %>
        <property name="<%=nm%>"><logic:present name="prop" property="value" ><bean:write name="prop" property="value" /></logic:present></property>
      </logic:iterate>
    </propertyGroup>
  </logic:iterate>
</propertyGroups>

<%@ include file="footer.jsp" %>

