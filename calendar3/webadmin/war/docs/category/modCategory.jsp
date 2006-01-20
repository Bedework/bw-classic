<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<logic:equal name="peForm" property="addingCategory" value="true" >
  <jsp:include page="/docs/header.jsp">
    <jsp:param name="title" value="org.bedework.title.add.category"/>
  </jsp:include>
</logic:equal>

<logic:notEqual name="peForm" property="addingCategory" value="true" >
  <jsp:include page="/docs/header.jsp">
    <jsp:param name="title" value="org.bedework.title.mod.category"/>
  </jsp:include>
</logic:notEqual>

<genurl:form action="category/update" >
  <jsp:include page="modCategoryCommon.jsp" />

  <table border="0" width="100%">
    <tr>
      <logic:equal name="peForm" property="addingCategory" value="true" >
        <td>
          <html:submit property="addCategory"
                       value="Submit Category"/>&nbsp;&nbsp;&nbsp;

          <html:submit property="forwardto" value="Cancel"/>
          <html:reset value="Clear"/>
        </td>
      </logic:equal>

      <logic:notEqual name="peForm" property="addingCategory" value="true" >
        <td>
          <html:submit property="updateCategory"
                       value="Submit Category"/>&nbsp;&nbsp;&nbsp;
          <html:submit property="forwardto" value="Cancel"/>
          <input type="reset" value="Clear"/>
        </td>
        <td align="right">
          <html:submit property="delete" value="Delete Category"/>
        </td>
      </logic:notEqual>
    </tr>
  </table>
</genurl:form>

<%@include file="/docs/footer.jsp"%>

