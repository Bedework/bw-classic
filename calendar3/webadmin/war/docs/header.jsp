<%@ page contentType="text/xml;charset=UTF-8" language="java" %>
<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<%@ taglib uri='bedework' prefix='bw' %>
<html:xhtml/>
<%
try {
%>

<bedeworkadmin>
  <!-- messages -->
  <logic:iterate id="msg" name="peForm" property="msg.msgList">
    <message>
      <id><bean:write name="msg" property="msgId" /></id>
      <logic:iterate id="param" name="msg" property="params" >
        <param><bean:write name="param" /></param>
      </logic:iterate>
    </message>
  </logic:iterate>

  <!-- errors -->
  <logic:iterate id="errBean" name="peForm" property="err.msgList">
    <error>
      <id><bean:write name="errBean" property="msgId" /></id>
      <logic:iterate id="param" name="errBean" property="params" >
        <param><bean:write name="param" /></param>
      </logic:iterate>
    </error>
  </logic:iterate>

  <!-- global variables -->
  <approot><bean:write name="peForm" property="presentationState.appRoot"/></approot><%--
        Value: URI - the location of web resources used by the code to find the
        XSLT files.  This element is defined prior to build in
        ../../../../clones/democal.properties
        as pubevents.app.root and personal.app.root. Note that references to
        html web resources such as images are set in the xsl stylesheets. --%>
  <urlprefix><bean:write name="peForm" property="urlPrefix"/></urlprefix><%--
        Value: URI - this is prefix of the calendar application.
        e.g. http://localhost:8080/cal
        Use this value to prefix calls to the application actions in your XSLT.
        e.g. <a href="{$urlPrefix}/eventView.do?eventId=8">View Event</a> --%>
  <urlpattern><genurl:rewrite action="DUMMYACTION.DO" /></urlpattern>

  <personaluri><bean:message key="org.bedework.personal.calendar.uri"/></personaluri>
  <publicuri><bean:message key="org.bedework.public.calendar.uri"/></publicuri>
  <adminuri><bean:message key="org.bedework.public.admin.uri"/></adminuri>

  <!-- Use URL prefixes when writing hyperlinks; these use the "genurl"
       struts tag to correctly build up application links within the
       container. "b=de" in the query string of each prefix has no meaning to
       the application and is not processed: it ensures that if we need to
       append the query string, we can always begin with an ampersand. -->
  <urlPrefixes>
    <setup><genurl:link page="/setup.do?b=de"/></setup>
    <logout><genurl:link page="/setup.do?logout=true"/></logout>
    <event>
      <showEvent><genurl:link page="/event/showEvent.rdo?b=de"/></showEvent>
      <showModForm><genurl:link page="/event/showModForm.rdo?b=de"/></showModForm>
      <showUpdateList><genurl:link page="/event/showUpdateList.rdo?b=de"/></showUpdateList>
      <showDeleteConfirm><genurl:link page="/event/showDeleteConfirm.rdo?b=de"/></showDeleteConfirm>
      <initAddEvent><genurl:link page="/event/initAddEvent.do?b=de"/></initAddEvent>
      <initUpdateEvent><genurl:link page="/event/initUpdateEvent.do?b=de"/></initUpdateEvent>
      <delete><genurl:link page="/event/delete.do?b=de"/></delete>
      <fetchForDisplay><genurl:link page="/event/fetchForDisplay.do?b=de"/></fetchForDisplay>
      <fetchForUpdate><genurl:link page="/event/fetchForUpdate.do?b=de"/></fetchForUpdate>
      <fetchUpdateList><genurl:link page="/event/fetchUpdateList.do?b=de"/></fetchUpdateList>
      <update><genurl:link page="/event/update.do?b=de"/></update>
    </event>
    <sponsor>
      <showSponsor><genurl:link page="/sponsor/showSponsor.do?b=de"/></showSponsor>
      <showReferenced><genurl:link page="/sponsor/showReferenced.do?b=de"/></showReferenced>
      <showModForm><genurl:link page="/sponsor/showModForm.do?b=de"/></showModForm>
      <showUpdateList><genurl:link page="/sponsor/showUpdateList.do?b=de"/></showUpdateList>
      <showDeleteConfirm><genurl:link page="/sponsor/showDeleteConfirm.do?b=de"/></showDeleteConfirm>
      <initAdd><genurl:link page="/sponsor/initAdd.do?b=de"/></initAdd>
      <initUpdate><genurl:link page="/sponsor/initUpdate.do?b=de"/></initUpdate>
      <delete><genurl:link page="/sponsor/delete.do?b=de"/></delete>
      <fetchForDisplay><genurl:link page="/sponsor/fetchForDisplay.do?b=de"/></fetchForDisplay>
      <fetchForUpdate><genurl:link page="/sponsor/fetchForUpdate.do?b=de"/></fetchForUpdate>
      <fetchUpdateList><genurl:link page="/sponsor/fetchUpdateList.do?b=de"/></fetchUpdateList>
      <update><genurl:link page="/sponsor/update.do?b=de"/></update>
    </sponsor>
    <location>
      <showLocation><genurl:link page="/location/showLocation.do?b=de"/></showLocation>
      <showReferenced><genurl:link page="/location/showReferenced.do?b=de"/></showReferenced>
      <showModForm><genurl:link page="/location/showModForm.do?b=de"/></showModForm>
      <showUpdateList><genurl:link page="/location/showUpdateList.do?b=de"/></showUpdateList>
      <showDeleteConfirm><genurl:link page="/location/showDeleteConfirm.do?b=de"/></showDeleteConfirm>
      <initAdd><genurl:link page="/location/initAdd.do?b=de"/></initAdd>
      <initUpdate><genurl:link page="/location/initUpdate.do?b=de"/></initUpdate>
      <delete><genurl:link page="/location/delete.do?b=de"/></delete>
      <fetchForDisplay><genurl:link page="/location/fetchForDisplay.do?b=de"/></fetchForDisplay>
      <fetchForUpdate><genurl:link page="/location/fetchForUpdate.do?b=de"/></fetchForUpdate>
      <fetchUpdateList><genurl:link page="/location/fetchUpdateList.do?b=de"/></fetchUpdateList>
      <update><genurl:link page="/location/update.do?b=de"/></update>
    </location>
    <calendar>
      <fetch><genurl:link page="/calendar/showUpdateList.rdo?b=de"/></fetch><!-- keep -->
      <fetchDescriptions><genurl:link page="/calendar/showDescriptionList.rdo?b=de"/></fetchDescriptions><!-- keep -->
      <initAdd><genurl:link page="/calendar/initAdd.do?b=de"/></initAdd><!-- keep -->
      <delete><genurl:link page="/calendar/delete.do?b=de"/></delete>
      <fetchForDisplay><genurl:link page="/calendar/fetchForDisplay.do?b=de"/></fetchForDisplay>
      <fetchForUpdate><genurl:link page="/calendar/fetchForUpdate.do?b=de"/></fetchForUpdate><!-- keep -->
      <update><genurl:link page="/calendar/update.do?b=de"/></update><!-- keep -->
    </calendar>
    <subscriptions> <!-- only those listed are used here (no need to clean up) -->
      <fetch><genurl:link page="/subs/fetch.do?b=de"/></fetch>
      <fetchForUpdate><genurl:link page="/subs/fetchForUpdate.do?b=de"/></fetchForUpdate>
      <initAdd><genurl:link page="/subs/initAdd.do?b=de"/></initAdd>
      <subscribe><genurl:link page="/subs/subscribe.do?b=de"/></subscribe>
    </subscriptions>
    <view> <!-- only those listed are used here (no need to clean up) -->
      <fetch><genurl:link page="/view/showViews.rdo?b=de"/></fetch>
      <fetchForUpdate><genurl:link page="/view/fetchForUpdate.do?b=de"/></fetchForUpdate>
      <addView><genurl:link page="/view/addView.do?b=de"/></addView>
      <update><genurl:link page="/view/update.do?b=de"/></update>
      <remove><genurl:link page="/view/removeView.do?b=de"/></remove>
    </view>
    <system> <!-- only those listed are used here (no need to clean up) -->
      <fetch><genurl:link page="/syspars/fetch.do?b=de"/></fetch>
      <update><genurl:link page="/syspars/update.do?b=de"/></update>
    </system>
    <stats>
      <update><genurl:link page="/stats/update.do?b=de"/></update>
    </stats>
    <timezones>
      <showUpload><genurl:link page="/timezones/showUpload.rdo?b=de"/></showUpload>
      <initUpload><genurl:link page="/timezones/initUpload.do?b=de"/></initUpload>
      <upload><genurl:link page="/timezones/upload.do?b=de"/></upload>
    </timezones>
    <authuser>
      <showModForm><genurl:link page="/authuser/showModForm.do?b=de"/></showModForm>
      <showUpdateList><genurl:link page="/authuser/showUpdateList.do?b=de"/></showUpdateList>
      <getAuthUsers><genurl:link page="/authuser/getAuthUsers.do?b=de"/></getAuthUsers>
      <initUpdate><genurl:link page="/authuser/initUpdate.do?b=de"/></initUpdate>
      <fetchForUpdate><genurl:link page="/authuser/fetchForUpdate.do?b=de"/></fetchForUpdate>
      <update><genurl:link page="/authuser/update.do?b=de"/></update>
    </authuser>
    <prefs><!-- only those listed are used here (no need to clean up) -->
      <fetchForUpdate><genurl:link page="/prefs/fetchForUpdate.do?b=de"/></fetchForUpdate>
      <update><genurl:link page="/prefs/update.do?b=de"/></update>
    </prefs>
    <admingroup>
      <showModForm><genurl:link page="/admingroup/showModForm.rdo?b=de"/></showModForm>
      <showModMembersForm><genurl:link page="/admingroup/showModMembersForm.rdo?b=de"/></showModMembersForm>
      <showUpdateList><genurl:link page="/admingroup/showUpdateList.rdo?b=de"/></showUpdateList>
      <showChooseGroup><genurl:link page="/admingroup/showChooseGroup.rdo?b=de"/></showChooseGroup>
      <showDeleteConfirm><genurl:link page="/admingroup/showDeleteConfirm.rdo?b=de"/></showDeleteConfirm>
      <initAdd><genurl:link page="/admingroup/initAdd.do?b=de"/></initAdd>
      <initUpdate><genurl:link page="/admingroup/initUpdate.do?b=de"/></initUpdate><!-- keep -->
      <delete><genurl:link page="/admingroup/delete.do?b=de"/></delete>
      <fetchForUpdate><genurl:link page="/admingroup/fetchForUpdate.do?b=de"/></fetchForUpdate><!-- keep -->
      <fetchForUpdateMembers><genurl:link page="/admingroup/fetchForUpdateMembers.do?b=de"/></fetchForUpdateMembers>
      <fetchUpdateList><genurl:link page="/admingroup/fetchUpdateList.do?b=de"/></fetchUpdateList><!-- keep -->
      <update><genurl:link page="/admingroup/update.do?b=de"/></update>
      <updateMembers><genurl:link page="/admingroup/updateMembers.do?b=de"/></updateMembers>
      <switch><genurl:link page="/admingroup/switch.do?b=de"/></switch>
    </admingroup>
  </urlPrefixes>

  <userInfo>
    <!-- user type -->
    <logic:equal name="peForm" property="userAuth.contentAdminUser" value="true" >
      <contentAdminUser>true</contentAdminUser>
    </logic:equal>
    <logic:notEqual name="peForm" property="userAuth.contentAdminUser" value="true" >
      <contentAdminUser>false</contentAdminUser>
    </logic:notEqual>

    <logic:equal name="peForm" property="userAuth.superUser" value="true">
      <superUser>true</superUser>
    </logic:equal>
    <logic:notEqual name="peForm" property="userAuth.superUser" value="true">
      <superUser>false</superUser>
    </logic:notEqual>

    <logic:equal name="peForm" property="userMaintOK" value="true" >
      <userMaintOK>true</userMaintOK>
    </logic:equal>
    <logic:notEqual name="peForm" property="userMaintOK" value="true" >
      <userMaintOK>false</userMaintOK>
    </logic:notEqual>

    <logic:equal name="peForm" property="adminGroupMaintOK" value="true">
      <adminGroupMaintOk>true</adminGroupMaintOk>
    </logic:equal>
    <logic:notEqual name="peForm" property="adminGroupMaintOK" value="true">
      <adminGroupMaintOk>false</adminGroupMaintOk>
    </logic:notEqual>

    <!-- user and group -->
    <bw:emitText name="peForm" property="adminUserId" tagName="user"/>
    <bw:emitText name="peForm" property="adminGroup.account" tagName="group"/>
  </userInfo>

  <logic:iterate id="appvar" name="peForm" property="appVars">
    <appvar><%--
        Application variables can be set arbitrarily by the stylesheet designer.
        Use an "appvar" by adding setappvar=key(value) to the query string of
        a URL.  This feature is useful for setting up state during a user's session.
        e.g. <a href="{$urlPrefix}/eventView.do?eventId=8&setappvar=currentTab(event)">View Event</a>
        To change the value of an appvar, call the same key with a different value.
        e.g. <a href="{$urlPrefix}/setup.do?setappvar=currentTab(home)">Return Home</a>
        If appvars exist, they will be output in the following form:  --%>
      <key><bean:write name="appvar" property="key" /></key>
      <value><bean:write name="appvar" property="value" /></value>
    </appvar>
  </logic:iterate>

<%
} catch (Throwable t) {
  t.printStackTrace();
}
%>
