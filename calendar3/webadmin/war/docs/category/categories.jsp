<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="header.jsp"%>

<page>categories</page>

<categories>
  <logic:iterate name="peForm" property="categories" id="keywd">
    <category><bean:write name="keywd" property="word" /></category>
    <desc>
      <logic:present name="keywd" property="description" >
        <bean:write name="keywd" property="description" />
      </logic:present>
    </desc>
  </logic:iterate>
</categories>

<%@include file="footer.jsp"%>
