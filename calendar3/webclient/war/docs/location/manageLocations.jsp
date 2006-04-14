<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@ include file="/docs/header.jsp" %>

<%
try {
%>

<page>manageLocations</page>
<formElements>
  <genurl:form action="addLocation">
    <location>
      <locationmenu>
        <html:select property="locationId">
          <html:optionsCollection property="locations"
                                  label="address"
                                  value="id"/>
        </html:select>
      </locationmenu>
    </location>
  </genurl:form>
</formElements>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="/docs/footer.jsp" %>

