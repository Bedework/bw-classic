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
      <html:text property="category.word" size="30" />
    </td>
  </tr>
  <tr>
    <td class="optional">
      Description:
    </td>
    <td>
      <html:textarea property="category.description"  rows="3" cols="55" />
      <span class="fieldInfo">(optional)</span>
    </td>
  </tr>
</table>
