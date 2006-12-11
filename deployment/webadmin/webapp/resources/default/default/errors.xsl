<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="error">
    <xsl:choose>
      <xsl:when test="id='org.bedework.client.error.exc'"><!-- trap exceptions first -->
        <p>
          <xsl:choose>
            <xsl:when test="param='org.bedework.exception.alreadyonadmingrouppath'">
              Error: a group may not be added to itself.<br/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="param"/>
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.noaccess'">
        <p>Error: no access.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingsubscriptionid'">
        <p>You must supply a subscription <em>name</em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchsubscription'">
        <p>Not found: there is no user identified by the name <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.viewnotfound'">
        <p>Not found: there is no view identified by the name <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.viewnotadded'">
        <p>Error: the view was not added.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchevent'">
        <p>Not found: there is no event with guid <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingcalendarpath'">
        <p>Error: missing calendar path.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.eventnotfound'">
        <p>Not found: the event was not found.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badentityid'">
        <p>Error: bad entity id.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.noentityid'">
        <p>Error: no entity id.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchcalendar'">
        <p>Not found: there is no calendar identified by the path <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.calendar.referenced'">
        <p>Cannot delete: the calendar is not empty.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.unimplemented'">
        <p>Unimplemented: the feature you are trying to use has not been implemented yet.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badhow'">
        <p>Error: bad ACL request (bad how setting).</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badwhotype'">
        <p>Error: bad who type (user or group).</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badinterval'">
        <p>Error: bad interval.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badintervalunit'">
        <p>Error: bad interval unit.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.mail.norecipient'">
        <p>Error: the email has no recipient.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.choosegroupsuppressed'">
        <p>Error: choose group is suppressed.  You cannot perform that action at this time.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.toolong.description'">
        <p>Your description is too long.  Please limit your entry to
        <em><xsl:value-of select="param"/></em> characters.  You may also wish to
        point the event entry at a supplimental web page by entering a <em>URL</em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.notitle'">
        <p>You must supply a <em>title</em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nocalendar'">
        <p>You must supply the <em>calendar</em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nodescription'">
        <p>You must supply a <em>description</em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.event.startafterend'">
        <p>The <em>end date</em> for this event occurs before the <em>start date</em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.invalid.endtype'">
        <p>The <em>end date type</em> is invalid for the type of event you are creating.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.invalid.duration'">
        <p><em>Invalid duration</em> - you may not have a zero-length duration
        for an all day event.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nocontactname'">
        <p>You must enter a contact <em>name</em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nolocationaddress'">
        <p>You must enter a location <em>address</em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingfield'">
        <p>Your information is incomplete: please supply a <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.missingfield'">
        <p>Your information is incomplete: please supply a <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.forbidden.calmode'">
        <p>Access forbidden: you are not allowed to perform that action on calendar <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingcategory'">
        <p>Error: the category identified by <em><xsl:value-of select="param"/></em> is missing.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchcategorynosuchcategory'">
        <p>Not found: there is no category identified by the key <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.category.referenced'">
        <p>Cannot delete: the category is referenced by events.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.pubevents.error.badfield'">
        <p>Please correct your data input for <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchcontact'">
        <p>Not found: there is no contact <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.contact.referenced'">
        <p>Cannot delete: the contact is referenced by events.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.contact.alreadyexists'">
        <p>Cannot add: the contact already exists.</p>
      <xsl:when test="id='org.bedework.client.error.duplicate.contact'">
        <p>Cannot add: the contact already exists.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchlocation'">
        <p>Not found: there is no location identified by the id <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.location.alreadyexists'">
        <p>Cannot add: the location already exists.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.location.referenced'">
        <p>Cannot delete: the location is referenced by events.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.subscription.reffed'">
        <p>Cannot delete: the subscription is included in view <em><xsl:value-of select="param"/></em>.<br/>
        You must remove the subscription from this view before deleting.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.calsuitenotadded'">
        <p>Error: calendar suite not added.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.error.timezones.readerror'">
        <p>Timzone error: could not read file.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchuserid'">
        <p>Not found: there is no user identified by the id <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.usernotfound'">
        <p>Not found: the user <em><xsl:value-of select="param"/></em> was not found.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.error.duplicate.admingroup'">
        <p>Error: duplicate admin group.  <em><xsl:value-of select="param"/></em> already exists.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchadmingroup'">
        <p>Error: no such admin group "<em><xsl:value-of select="param"/></em>".</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.error.unknowgroup'">
        <p>Error: unknown admin group:  <em><xsl:value-of select="param"/></em>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.exception.alreadyonadmingrouppath'">
        <p>Error: group may not be added to itself.</p>
      </xsl:when>
      <xsl:when test="id='edu.rpi.sss.util.error.exc'">
        <p>Utility package error: <em><xsl:value-of select="param"/></em></p>
      </xsl:when>
      <xsl:otherwise>
        <p><xsl:value-of select="id"/> = <xsl:value-of select="param"/></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

