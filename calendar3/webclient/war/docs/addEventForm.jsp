<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%
try {
%>

<eventform>
  <genurl:form action="addEvent">
    <title>
      <html:text property="newEvent.summary"/></input>
    </title>
    <description>
      <html:textarea property="newEvent.description"/>
    </description>
    <link>
      <html:text property="newEvent.link"/></input>
    </link>
    <location>
      <locationmenu>
        <html:select property="locationId">
          <html:optionsCollection property="locations"
                                  label="address"
                                  value="id"/>
        </html:select>
      </locationmenu>
      <locationtext>
        <html:text property="newLocation.address" /></input>
      </locationtext>
    </location>
    <startdate>
      <html:select property="eventStartDate.month">
       <html:options labelProperty="eventStartDate.monthLabels"
                      property="eventStartDate.monthVals"/>
      </html:select>
      <html:select property="eventStartDate.day">
        <html:options labelProperty="eventStartDate.dayLabels"
                      property="eventStartDate.dayVals"/>
      </html:select>
      <html:select property="eventStartDate.year">
        <html:options property="yearVals"/>
      </html:select>
    </startdate>
    <starttime>
      <html:select property="eventStartDate.hour">
        <html:options labelProperty="eventStartDate.hourLabels"
                      property="eventStartDate.hourVals"/>
      </html:select>
      <html:select property="eventStartDate.minute">
        <html:options labelProperty="eventStartDate.minuteLabels"
                      property="eventStartDate.minuteVals"/>
      </html:select>
      <logic:notEqual name="calForm" property="hour24" value="true" >
        <html:select property="eventStartDate.ampm">
          <html:options property="eventStartDate.ampmLabels"/>
        </html:select>
      </logic:notEqual>
    </starttime>
    <enddate>
      <html:select property="eventEndDate.month">
        <html:options labelProperty="eventEndDate.monthLabels"
                      property="eventEndDate.monthVals"/>
      </html:select>
      <html:select property="eventEndDate.day">
        <html:options labelProperty="eventEndDate.dayLabels"
                      property="eventEndDate.dayVals"/>
      </html:select>
      <html:select property="eventEndDate.year">
        <html:options property="yearVals"/>
      </html:select>
    </enddate>
    <endtime>
      <html:select property="eventEndDate.hour">
        <html:options labelProperty="eventEndDate.hourLabels"
                      property="eventEndDate.hourVals"/>
      </html:select>
      <html:select property="eventEndDate.minute">
        <html:options labelProperty="eventEndDate.minuteLabels"
                      property="eventEndDate.minuteVals"/>
      </html:select>
      <logic:notEqual name="calForm" property="hour24" value="true" >
        <html:select property="eventEndDate.ampm">
          <html:options property="eventEndDate.ampmLabels"/>
        </html:select>
      </logic:notEqual>
    </endtime>
  </genurl:form>
</eventform>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>

