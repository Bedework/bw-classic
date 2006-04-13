<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<%@ taglib uri='bedework' prefix='bw' %>

<%@ include file="/docs/header.jsp" %>

<%
try {
%>

<page>freeBusy</page>

<bean:define id="freeBusyObj"
             name="calForm"
             property="freeBusy"
             toScope="request"/>

<freebusy>
  <bw:emitText name="freeBusyObj" property="who.account" tagName="who" />
  <bw:emitText name="freeBusyObj" property="start.dtval" tagName="start" />
  <bw:emitText name="freeBusyObj" property="end.dtval" tagName="end" />
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

<%@ include file="/docs/footer.jsp" %>

