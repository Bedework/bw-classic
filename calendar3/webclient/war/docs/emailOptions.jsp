<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@ include file="header.jsp" %>

<%
try {
%>

<page>emailOptions</page>

<emailoptionsform>
  <genurl:form action="mailEvent">
    <email><html:text name="calForm" property="lastEmail"/></input></email>
    <subject><html:text name="calForm" property="lastSubject" /></input></subject>
  </genurl:form>
</emailoptionsform>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="footer.jsp" %>

