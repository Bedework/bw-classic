<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%@ include file="header.jsp" %>

<%
try {
%>

<page>exportData</page>

<logic:present name="calForm" property="vcal" >
<vcalendar><![CDATA[<bean:write name="calForm" property="vcal" />
]]>
</vcalendar>
</logic:present>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="footer.jsp" %>

