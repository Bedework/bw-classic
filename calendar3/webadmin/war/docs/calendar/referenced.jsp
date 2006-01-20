<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<jsp:include page="/docs/header.jsp">
  <jsp:param name="title" value="org.bedework.title.calendar.inuse"/>
</jsp:include>

<h2><bean:message key="org.bedework.text.calendar.referenced" /></h2>

<genurl:form action="calendar/fetchForUpdate" >
  <html:submit property="listCalendars" value="OK"/>&nbsp;&nbsp;&nbsp;

  <jsp:include page="displayCalendarsCommon.jsp" />
</genurl:form>

<%@include file="/docs/footer.jsp"%>

