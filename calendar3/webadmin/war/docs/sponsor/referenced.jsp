<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>sponsorReferenced</page>

<% /* used by included file */
   String rpitemp; %>
<sponsors>
  <logic:iterate id="sponsor" name="peForm" property="editableSponsors" >
    <%@include file="/docs/sponsor/emitSponsor.jsp"%>
  </logic:iterate>
</sponsors>

<%@include file="/docs/footer.jsp"%>

