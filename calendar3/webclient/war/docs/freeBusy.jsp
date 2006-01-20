<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%@ include file="header.jsp" %>

<%
try {
%>

<page>freeBusy</page>

<bean:define id="freeBusyObj"
             name="calForm"
             property="freeBusy"
             toScope="request"/>

<freebusy>
  <who><bean:write name="freeBusyObj" property="who.account" /></who>
  <start><bean:write name="freeBusyObj" property="start" /></start>
  <end><bean:write name="freeBusyObj" property="end" /></end>
  <logic:iterate id="freeBusyComponent"  name="freeBusyObj" property="times" >
    <freeBusyComponent>
      <fbtype><bean:write name="freeBusyComponent" property="type" /></fbtype>
      <logic:iterate id="period"  name="freeBusyComponent" property="periods" >
        <period>
          <start><bean:write name="period" property="start" /></start>
          <end><bean:write name="period" property="end" /></end>
        </period>
      </logic:iterate>
    </freeBusyComponent>
  </logic:iterate>
</freebusy>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="footer.jsp" %>

