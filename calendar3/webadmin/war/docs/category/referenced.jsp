<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<jsp:include page="/docs/header.jsp">
  <jsp:param name="title" value="org.bedework.title.category.inuse"/>
</jsp:include>

<h2><bean:message key="org.bedework.text.category.referenced" /></h2>

<genurl:form action="category/fetchForUpdate" >
  <html:submit property="listCategories" value="OK"/>&nbsp;&nbsp;&nbsp;

  <table id="eventFormTable">
    <tr>
      <td class="fieldName">
        Category:
      </td>
      <td>
        <bean:write name="peForm" property="category.word" />
      </td>
    </tr>

    <tr>
      <td class="optional">
        Description:
      </td>
      <td>
        <bean:write name="peForm" property="category.description" />
      </td>
    </tr>
  </table>
</genurl:form>

<%@include file="/docs/footer.jsp"%>

