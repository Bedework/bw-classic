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
<eventform>
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
</eventform>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="/docs/footer.jsp" %>

