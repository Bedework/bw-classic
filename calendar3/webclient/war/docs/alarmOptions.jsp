<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%@ include file="header.jsp" %>

<%
try {
%>

<page>alarmOptions</page>

<alarmoptionsform>
  <genurl:form action="setAlarm">
    <alarmdate>
      <html:select property="triggerDateTime.month">
       <html:options labelProperty="triggerDateTime.monthLabels"
                      property="triggerDateTime.monthVals"/>
      </html:select>
      <html:select property="triggerDateTime.day">
        <html:options labelProperty="triggerDateTime.dayLabels"
                      property="triggerDateTime.dayVals"/>
      </html:select>
      <html:select property="triggerDateTime.year">
        <html:options property="yearVals"/>
      </html:select>
    </alarmdate>
    <alarmtime>
      <html:select property="triggerDateTime.hour">
        <html:options labelProperty="triggerDateTime.hourLabels"
                      property="triggerDateTime.hourVals"/>
      </html:select>
      <html:select property="triggerDateTime.minute">
        <html:options labelProperty="triggerDateTime.minuteLabels"
                      property="triggerDateTime.minuteVals"/>
      </html:select>
      <logic:notEqual name="calForm" property="hour24" value="true" >
        <html:select property="triggerDateTime.ampm">
          <html:options property="triggerDateTime.ampmLabels"/>
        </html:select>
      </logic:notEqual>
    </alarmtime>
    <alarmTriggerSelectorDate>
      <html:radio name="calForm" property="alarmTriggerByDate"
                   value="true" /></input>
    </alarmTriggerSelectorDate>
    <alarmTriggerSelectorDuration>
      <html:radio name="calForm" property="alarmTriggerByDate"
                      value="false" /></input>
    </alarmTriggerSelectorDuration>
    <alarmduration>
      <days><html:text size="5" maxlength="5" name="calForm" property="triggerDuration.daysStr"/></input></days>
      <hours><html:text size="3" maxlength="3" name="calForm" property="triggerDuration.hoursStr"/></input></hours>
      <minutes><html:text size="3" maxlength="3" name="calForm" property="triggerDuration.minutesStr"/></input></minutes>
      <seconds><html:text size="3" maxlength="3" name="calForm" property="triggerDuration.secondsStr"/></input></seconds>
      <weeks><html:text size="3" maxlength="3" name="calForm" property="triggerDuration.weeksStr"/></input></weeks>
    </alarmduration>
    <alarmDurationBefore>
      <html:radio name="calForm" property="triggerDuration.negative"
                      value="true" /></input>
    </alarmDurationBefore>
    <alarmDurationAfter>
      <html:radio name="calForm" property="triggerDuration.negative"
                      value="false" /></input>
    </alarmDurationAfter>
    <alarmDurationRelStart>
      <html:radio name="calForm" property="alarmRelStart"
                      value="true" /></input>
    </alarmDurationRelStart>
    <alarmDurationRelEnd>
      <html:radio name="calForm" property="alarmRelStart"
                      value="false" /></input>
    </alarmDurationRelEnd>
    <email><html:text name="calForm" property="lastEmail"/></input></email>
    <subject><html:text name="calForm" property="lastSubject" /></input></subject>
  </genurl:form>
</alarmoptionsform>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

<%@ include file="footer.jsp" %>

