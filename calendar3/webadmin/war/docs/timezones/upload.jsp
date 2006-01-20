<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>uploadTimezones</page>

<formElements>
  <genurl:form action="timezones/upload" enctype="multipart/form-data">
    <html:file size="60" property="uploadFile" />
    <html:submit property="doUpload" value="Upload Timezones"/>
    <html:submit property="forwardto" value="Cancel"/>
  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

