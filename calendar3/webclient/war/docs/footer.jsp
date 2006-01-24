<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>

<%
try {
%>
  <%-- Generates standard calendar values for use in the client for forms, etc --%>

  <bean:define id="forLabels" name="calForm" property="forLabels" />
  <bean:define id="calInfo" name="calForm" property="today.calInfo" />

   <%--
  <daylabels>
    <logic:iterate id="dayLabels" name="calForm" property="forLabels.dayLabels">
      <val><bean:write name="dayLabels"/></val>
    </logic:iterate>
  </daylabels>
  <dayvalues>
    <logic:iterate id="dayVals" name="calForm" property="forLabels.dayVals">
      <val><bean:write name="dayVals"/></val>
    </logic:iterate>
    <start><bean:write name="calForm" property="viewStartDate.day"/></start>
  </dayvalues>
  --%>
  <daylabels>
    <logic:iterate id="dayLabel" name="calInfo" property="dayLabels">
      <val><bean:write name="dayLabel"/></val>
    </logic:iterate>
  </daylabels>
  <dayvalues>
    <logic:iterate id="dayVal" name="calInfo" property="dayVals">
      <val><bean:write name="dayVal"/></val>
    </logic:iterate>
    <start><bean:write name="calForm" property="viewStartDate.day"/></start>
  </dayvalues>
  <daynames>
    <logic:iterate id="dayName" name="calInfo" property="dayNamesAdjusted">
      <val><bean:write name="dayName"/></val>
    </logic:iterate>
  </daynames>
  <shortdaynames>
    <logic:iterate id="shortDayName" name="calInfo" property="shortDayNamesAdjusted">
      <val><bean:write name="shortDayName"/></val>
    </logic:iterate>
  </shortdaynames>
  <monthlabels>
    <logic:iterate id="monthLabels" name="calForm" property="forLabels.monthLabels">
      <val><bean:write name="monthLabels"/></val>
    </logic:iterate>
  </monthlabels>
  <monthvalues>
    <logic:iterate id="monthVals" name="calForm" property="forLabels.monthVals">
      <val><bean:write name="monthVals"/></val>
    </logic:iterate>
    <start><bean:write name="calForm" property="viewStartDate.month"/></start>
  </monthvalues>
  <yearvalues>
    <logic:iterate id="yearVals" name="calForm" property="yearVals">
      <val><bean:write name="yearVals"/></val>
    </logic:iterate>
    <start><bean:write name="calForm" property="viewStartDate.year"/></start>
  </yearvalues>
  <hourlabels>
    <logic:iterate id="hourLabels" name="calForm" property="forLabels.hourLabels">
      <val><bean:write name="hourLabels"/></val>
    </logic:iterate>
  </hourlabels>
  <hourvalues>
    <logic:iterate id="hourVals" name="calForm" property="forLabels.hourVals">
      <val><bean:write name="hourVals"/></val>
    </logic:iterate>
    <start><bean:write name="calForm" property="viewStartDate.hour"/></start>
  </hourvalues>
  <minvalues>
    <logic:iterate id="minuteVals" name="calForm" property="forLabels.minuteLabels">
      <val><bean:write name="minuteVals"/></val>
    </logic:iterate>
    <start><bean:write name="calForm" property="viewStartDate.minute"/></start>
<%--    <logic:iterate id="minuteVals" name="calForm" property="forLabels.minuteLabels">
 --%>
  </minvalues>
  <ampmvalues>
    <logic:iterate id="ampmVals" name="calForm" property="forLabels.ampmLabels">
      <val><bean:write name="ampmVals"/></val>
    </logic:iterate>
    <start><bean:write name="calForm" property="viewStartDate.ampm"/></start>
  </ampmvalues>
</ucalendar>
<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%-- Required to force write in jetspeed2 portal-struts bridge
< % pageContext.getOut().flush(); % >
--%>

