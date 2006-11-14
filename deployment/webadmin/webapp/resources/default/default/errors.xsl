<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="error">
    <xsl:choose>
      <xsl:when test="id='org.bedework.client.error.exc'"><!-- trap exceptions first -->
        <xsl:choose>
          <xsl:when test="param='org.bedework.exception.alreadyonadmingrouppath'">
            Error: a group may not be added to itself.<br/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.noaccess'">
        Error: no access
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingsubscriptionid'">
        You must supply a subscription <em>name</em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchsubscription'">
        Not found: there is no user identified by the name <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.viewnotfound'">
        Not found: there is no view identified by the name <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.viewnotadded'">
        Error: the view was not added
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchevent'">
        Not found: there is no event with guid <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.eventnotfound'">
        Not found: the event was not found
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badentityid'">
        Error: bad entity id
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.noentityid'">
        Error: no entity id
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchcalendar'">
        Not found: there is no calendar identified by the path <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.calendar.referenced'">
        Cannot delete: the calendar is not empty
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.folder.updated'">
        Folder updated.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.unimplemented'">
        Unimplemented: the feature you are trying to use has not been implemented yet
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badhow'">
        Error: bad ACL request (bad how setting)
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badwhotype'">
        Error: bad who type (user or group)
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badinterval'">
        Error: bad interval
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badintervalunit'">
        Error: bad interval unit
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.mail.norecipient'">
        Error: the email has no recipient
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.choosegroupsuppressed'">
        Error: choose group is suppressed.  You cannot perform that action at this time.
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.toolong.description'">
        Your description is too long.  Please limit your entry to
        <em><xsl:value-of select="param"/></em> characters.  You may also wish to
        point the event entry at a supplimental web page by entering a <em>URL</em>.
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.notitle'">
        You must supply a <em>title</em><br/>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nocalendar'">
        You must supply the <em>calendar</em><br/>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nodescription'">
        You must supply a <em>description</em><br/>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.event.startafterend'">
        The <em>end date</em> for this event occurs before the <em>start date</em>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.invalid.endtype'">
        The <em>end date type</em> is invalid for the type of event you are creating
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.invalid.duration'">
        <em>Invalid duration</em> - you may not have a zero-length duration
        for an all day event.
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nocontactname'">
        You must enter a contact <em>name</em>.
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nolocationaddress'">
        You must enter a location <em>address</em>.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingfield'">
        Your information is incomplete: please supply a <em><xsl:value-of select="param"/></em><br/>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.missingfield'">
        Your information is incomplete: please supply a <em><xsl:value-of select="param"/></em><br/>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.forbidden.calmode'">
        Access forbidden: you are not allowed to perform that action on calendar <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingcategory'">
        Error: the category identified by <em><xsl:value-of select="param"/></em> is missing
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchcategorynosuchcategory'">
        Not found: there is no category identified by the key <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.category.referenced'">
        Cannot delete: the category is referenced by events
      </xsl:when>
      <xsl:when test="id='org.bedework.pubevents.error.badfield'">
        Please correct your data input for <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchcontact'">
        Not found: there is no contact <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.contact.referenced'">
        Cannot delete: the contact is referenced by events
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.contact.alreadyexists'">
        Cannot add: the contact already exists
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchlocation'">
        Not found: there is no location identified by the id <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.location.alreadyexists'">
        Cannot add: the location already exists
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.location.referenced'">
        Cannot delete: the location is referenced by events
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.subscription.reffed'">
        <p>Cannot delete: the subscription is included in view <em><xsl:value-of select="param"/></em>.<br/>
        You must remove the subscription from this view before deleting.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.calsuitenotadded'">
        <p>Error: calendar suite not added.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.error.timezones.readerror'">
        <p>Timzone error: could not read file</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchuserid'">
        <p>Not found: there is no user identified by the id <em><xsl:value-of select="param"/></em></p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.usernotfound'">
        Not found: the user <em><xsl:value-of select="param"/></em> was not found
      </xsl:when>
      <xsl:when test="id='org.bedework.error.duplicate.admingroup'">
        Error: duplicate admin group.  <em><xsl:value-of select="param"/></em> already exists.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchadmingroup'">
        Error: no such admin group "<em><xsl:value-of select="param"/></em>"
      </xsl:when>
      <xsl:when test="id='org.bedework.error.unknowgroup'">
        Error: unknown admin group:  <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.exception.alreadyonadmingrouppath'">
        Error: group may not be added to itself
      </xsl:when>
      <xsl:when test="id='edu.rpi.sss.util.error.exc'">
        Utility package error: <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/> = <xsl:value-of select="param"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

