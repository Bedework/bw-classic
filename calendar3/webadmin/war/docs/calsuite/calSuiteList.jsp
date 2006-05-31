<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>calSuiteList</page>

<% /* used by included file */
   String rpitemp; %>
<calsuites>
  <logic:iterate id="calSuite" name="peForm" property="accessibleCalSuites" >
    <%@include file="/docs/calsuite/emitCalSuite.jsp"%>
  </logic:iterate>
</calsuites>

<%@include file="/docs/footer.jsp"%>

