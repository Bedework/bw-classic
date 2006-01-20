<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<jsp:include page="/docs/header.jsp">
  <jsp:param name="title" value="org.bedework.title.delete.category.confirm"/>
</jsp:include>

<h2><bean:message key="org.bedework.text.delete.category.ok" /></h2>

<genurl:form action="category/delete.do" >
  <html:submit property="cancelled" value="Cancel"/>&nbsp;&nbsp;&nbsp;
  <html:submit property="deleteCategoryOK" value="Delete"/>&nbsp;&nbsp;&nbsp;


  <jsp:include page="displayCategoryCommon.jsp" />


  <html:submit property="cancelled" value="Cancel"/>&nbsp;&nbsp;&nbsp;
  <html:submit property="deleteCategoryOK" value="Delete"/>&nbsp;&nbsp;&nbsp;
</genurl:form>

<%@include file="/docs/footer.jsp"%>

