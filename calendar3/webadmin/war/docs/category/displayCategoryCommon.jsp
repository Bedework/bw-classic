<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>

<h2>Category Information</h2>

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
  <tr>
    <td class="optional">
      &nbsp;
    </td>
  </tr>
</table>
