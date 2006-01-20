<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<jsp:include page="/docs/header.jsp">
  <jsp:param name="title" value="org.bedework.title.mod.categorylist"/>
</jsp:include>

<p>
  Select the category that you would like to update:
</p>

<%
  String rpitemp;
%>

<table id="commonListTable">
  <tr>
    <th>category</th>
    <th>Description</th>
    <th>Flags</th>
  </tr>

  <logic:iterate id="category" name="peForm" property="allCategories" >
    <bean:define id="id" name="category" property="id"/>

    <% rpitemp="/category/fetchForUpdate.do?categoryId=" + id; %>
    <tr>
      <td valign="top" width="20%">
        <genurl:link page="<%=rpitemp%>">
          <bean:write name="category" property="word" />
        </genurl:link>
      </td>
      <td valign="top" width="40%">
        <bean:write name="category" property="description" />
      </td>
    </tr>
  </logic:iterate>
</table>

<%@include file="/docs/footer.jsp"%>

