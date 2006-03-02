<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<%@include file="/docs/header.jsp"%>

<page>modEvent</page>
<creating><bean:write name="peForm" property="addingEvent"/></creating>

<!-- Mod pages contain only formElements for now; we do this to
     take advantage of Struts' form processing features -->
<formElements>
  <genurl:form action="event/update" >
    <title><html:text property="event.summary" size="40" styleId="iTitle" styleClass="edit"/></title>
    <calendar>
      <logic:present name="peForm" property="preferredCalendars">
        <preferred>
          <html:select property="prefCalendarId">
              <html:optionsCollection property="preferredCalendars"
                                        label="name"
                                        value="id"/>
          </html:select>
        </preferred>
      </logic:present>
      <all>
        <html:select property="calendarId">
          <html:optionsCollection property="addContentCalendarCollections"
                                      label="name"
                                      value="id"/>
        </html:select>
      </all>
    </calendar>
    <allDay><html:checkbox property="eventStartDate.dateOnly"/></allDay>
    <start>
      <month>
        <html:select property="eventStartDate.month">
          <html:options labelProperty="eventStartDate.monthLabels"
                        property="eventStartDate.monthVals"/>
        </html:select>
      </month>
      <day>
        <html:select property="eventStartDate.day">
          <html:options labelProperty="eventStartDate.dayLabels"
                        property="eventStartDate.dayVals"/>
        </html:select>
      </day>
      <year>
        <html:select property="eventStartDate.year">
          <html:options property="yearVals"/>
        </html:select>
      </year>
      <yearText>
        <html:text property="eventStartDate.year" size="4"/>
      </yearText>
      <hour>
        <html:select property="eventStartDate.hour">
          <html:options labelProperty="eventStartDate.hourLabels"
                        property="eventStartDate.hourVals"/>
        </html:select>
      </hour>
      <minute>
        <html:select property="eventStartDate.minute">
          <html:options labelProperty="eventStartDate.minuteLabels"
                        property="eventStartDate.minuteVals"/>
        </html:select>
      </minute>
      <logic:notEqual name="peForm" property="hour24" value="true" >
        <ampm>
          <html:select property="eventStartDate.ampm">
            <html:options property="eventStartDate.ampmLabels"/>
          </html:select>
        </ampm>
      </logic:notEqual>
    </start>
    <end>
      <type><bean:write name="peForm" property="eventEndType"/></type>
      <dateTime>
        <month>
          <html:select property="eventEndDate.month">
              <html:options labelProperty="eventEndDate.monthLabels"
                            property="eventEndDate.monthVals"/>
          </html:select>
        </month>
        <day>
          <html:select property="eventEndDate.day">
            <html:options labelProperty="eventEndDate.dayLabels"
                          property="eventEndDate.dayVals"/>
          </html:select>
        </day>
        <year>
          <html:select property="eventEndDate.year">
            <html:options property="yearVals"/>
          </html:select>
          </year>
        <yearText>
          <html:text property="eventEndDate.year" size="4"/>
        </yearText>
        <hour>
          <html:select property="eventEndDate.hour">
            <html:options labelProperty="eventEndDate.hourLabels"
                          property="eventEndDate.hourVals"/>
          </html:select>
        </hour>
        <minute>
          <html:select property="eventEndDate.minute">
            <html:options labelProperty="eventEndDate.minuteLabels"
                          property="eventEndDate.minuteVals"/>
          </html:select>
        </minute>
        <ampm>
          <logic:notEqual name="peForm" property="hour24" value="true" >
            <html:select property="eventEndDate.ampm">
              <html:options property="eventEndDate.ampmLabels"/>
            </html:select>
          </logic:notEqual>
        </ampm>
      </dateTime>
      <duration>
        <%--
        <days><input type="text" name="eventDuration.daysStr" size="2" value="0" onChange="window.document.peForm.durationType[0].checked = true;"/></days>
        <hours><input type="text" name="eventDuration.hoursStr" size="2" value="1" onChange="window.document.peForm.durationType[0].checked = true;"/></hours>
        <minutes><input type="text" name="eventDuration.minutesStr" size="2" value="0" onChange="window.document.peForm.durationType[0].checked = true;"/></minutes>
        <weeks><input type="text" name="eventDuration.weeksStr" size="2" value="0" onChange="window.document.peForm.durationType[1].checked = true;"/></weeks>
        --%>
        <days><html:text property="eventDuration.daysStr" size="2" /></days>
        <hours><html:text property="eventDuration.hoursStr" size="2" /></hours>
        <minutes><html:text property="eventDuration.minutesStr" size="2" /></minutes>
        <weeks><html:text property="eventDuration.weeksStr" size="2" /></weeks>
      </duration>
    </end>

    <category>
      <logic:present name="peForm" property="preferredCategories">
        <preferred>
          <html:select property="prefCategoryId">
            <html:optionsCollection name="peForm" property="preferredCategories"
                                      label="word" value="id" />
          </html:select>
        </preferred>
      </logic:present>
      <all>
        <html:select property="categoryId">
          <html:optionsCollection name="peForm" property="publicCategories"
                                          label="word" value="id" />
        </html:select>
      </all>
    </category>

    <desc><html:textarea property="event.description" rows="8" cols="55" styleId="iDesc" styleClass="edit"></html:textarea></desc>
    <descLength><bean:write name="peForm" property="maxDescriptionLength" /></descLength>
    <status><bean:write name="peForm" property="event.status"/></status>
    <cost><html:text property="event.cost" size="30" styleId="iCost" styleClass="edit"/></cost>
    <link><html:text property="event.link" size="30" styleId="iLink" styleClass="edit"/></link>

    <location>
      <logic:present name="peForm" property="preferredLocations">
        <preferred>
          <html:select property="prefLocationId">
            <html:optionsCollection property="preferredLocations"
                                    label="address"
                                    value="id"/>
          </html:select>
        </preferred>
      </logic:present>
      <all>
        <html:select property="locationId">
          <html:optionsCollection property="publicLocations"
                                    label="address"
                                    value="id"/>
          </html:select>
      </all>
      <logic:equal name="peForm" property="autoCreateLocations"
                 value="true">
        <address>
          <html:text size="30" value="" property="location.address" styleId="iLocation" styleClass="edit"/>
        </address>
        <link>
          <html:text property="location.link" size="30" styleId="iLocLink" styleClass="edit"/>
        </link>
      </logic:equal>
    </location>

    <sponsor>
      <logic:present name="peForm" property="preferredSponsors">
        <preferred>
          <html:select property="prefSponsorId">
            <html:optionsCollection property="preferredSponsors"
                                    label="name"
                                    value="id"/>
          </html:select>
        </preferred>
      </logic:present>
      <all>
        <html:select property="sponsorId">
          <html:optionsCollection property="publicSponsors"
                                    label="name"
                                    value="id"/>
        </html:select>
      </all>
      <logic:equal name="peForm" property="autoCreateSponsors"
                 value="true">
        <%@include file="/docs/sponsor/modSponsorCommon.jsp"%>
      </logic:equal>
    </sponsor>

    <!-- these are the values that may be submitted to the update action -->
    <submitButtons>
      <button type="add">addEvent</button>
      <button type="update">updateEvent</button>
      <button type="cancel">cancelled</button>
      <button type="copy">copy</button>
      <button type="delete">delete</button>
    </submitButtons>
  </genurl:form>
</formElements>

<%@include file="/docs/footer.jsp"%>

