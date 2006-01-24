<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="error">
    <xsl:choose>
      <xsl:when test="id='org.bedework.client.error.exc'">
        <xsl:value-of select="param"/>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.noaccess'">
        Error: no access
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingsubscriptionid'">
        You must supply a subscription name
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
        Not found: there is no calendar identified by the id <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.calendar.referenced'">
        Cannot delete: the calendar is referenced by events
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.unimplemented'">
        Unimplemented: the feature you are trying to use has not been implemented yet
      </xsl:when>
      <!-- ??????????????? -->
      <!-- some help to clarify the following would be good -->
      <xsl:when test="id='org.bedework.client.error.badhow'">
        Error: bad how
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.badwhotype'">
        Error: bad who type
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
      <!-- end ??????????????? -->
      <xsl:when test="id='org.bedework.client.error.choosegroupsuppressed'">
        Error: choose group is suppressed.  You cannot perform that action at this time.
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.toolong.description'">
        Your description is too long.  Please limit your entry to
        <xsl:value-of select="param"/> characters.  You may also wish to
        point the event entry at a supplimental web page by entering a URL.
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.notitle'">
        You must supply a title
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nodescription'">
        You must supply a description
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.event.startafterend'">
        The end date for this event occurs before the start date
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.invalid.endtype'">
        The end date type is invalid for the type of event you are creating
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nosponsorname'">
        You must select a contact.  If there is no contact, select "none".
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.nolocationaddress'">
        You must select a location.  For general use, use "on-campus" or "off-campus".
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingfield'">
        Your information is incomplete: please supply a <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.missingfield'">
        Your information is incomplete: please supply a <em><xsl:value-of select="param"/></em>
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
      <xsl:when test="id='org.bedework.client.error.nosuchsponsor'">
        Not found: there is no contact <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.sponsor.referenced'">
        Cannot delete: the sponsor is referenced by events
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.sponsor.alreadyexists'">
        Cannot add: the sponsor already exists
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
      <xsl:when test="id='org.bedework.client.error.nosuchuserid'">
        Not found: there is no user identified by the id <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.usernotfound'">
        Not found: the user <em><xsl:value-of select="param"/></em> was not found
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/> = <xsl:value-of select="param"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

