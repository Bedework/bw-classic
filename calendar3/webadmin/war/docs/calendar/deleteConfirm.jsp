<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<jsp:include page="/docs/header.jsp">
  <jsp:param name="title" value="org.bedework.title.delete.calendar.confirm"/>
</jsp:include>

<h2><bean:message key="org.bedework.text.delete.calendar.ok" /></h2>

<genurl:form action="calendar/delete.do" >
  <html:submit property="cancelled" value="Cancel"/>&nbsp;&nbsp;&nbsp;
  <html:submit property="deleteCalendarOK" value="Delete"/>&nbsp;&nbsp;&nbsp;


  <jsp:include page="displayCalendarCommon.jsp" />


  <html:submit property="cancelled" value="Cancel"/>&nbsp;&nbsp;&nbsp;
  <html:submit property="deleteCalendarOK" value="Delete"/>&nbsp;&nbsp;&nbsp;
</genurl:form>

<%@include file="/docs/footer.jsp"%>

