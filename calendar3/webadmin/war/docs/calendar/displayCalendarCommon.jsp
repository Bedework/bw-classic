<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>

<h2>Calendar Information</h2>

<table id="eventFormTable">
  <tr>
    <td class="fieldName">
      Calendar:
    </td>
    <td>
      <bean:write name="peForm" property="calendar.name" />
    </td>
  </tr>
  <tr>
    <td class="fieldName">
      Path:
    </td>
    <td>
      <bean:write name="peForm" property="calendar.path" />-
    </td>
  </tr>
  <tr>
    <td class="fieldName">
      Public:
    </td>
    <td>
      <bean:write name="peForm" property="calendar.publick" />-
    </td>
  </tr>
  <tr>
    <td class="fieldName">
      Access:
    </td>
    <td>
      <bean:write name="peForm" property="calendar.access" />-
    </td>
  </tr>
  <tr>
    <td class="fieldName">
      Title:
    </td>
    <td>
      <bean:write name="peForm" property="calendar.title" />-
    </td>
  </tr>
  <tr>
    <td class="fieldName">
      Description:
    </td>
    <td>
      <bean:write name="peForm" property="calendar.description" />-
    </td>
  </tr>
  <tr>
    <td class="fieldName">
      Show Children:
    </td>
    <td>
      <bean:write name="peForm" property="calendar.showChildren" />-
    </td>
  </tr>
  <tr>
    <td class="fieldName">
      Calendar Collection:
    </td>
    <td>
      <bean:write name="peForm" property="calendar.calendarCollection" />-
    </td>
  </tr>
</table>
