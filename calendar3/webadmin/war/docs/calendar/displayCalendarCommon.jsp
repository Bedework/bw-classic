<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='bedework' prefix='bw' %>

<bean:define id="curcal" name="peForm" property="calendar"/>
<currentCalendar>
  <id><bean:write name="curcal" property="id" /></id>
  <bw:emitText name="curcal" property="name" />
  <bw:emitText name="curcal" property="path" />
  <bw:emitText name="curcal" property="encodedPath" />
  <bw:emitText name="curcal" property="description" tagName="desc" />
  <calendarCollection><bean:write name="curcal" property="calendarCollection" /></calendarCollection>
  <bw:emitText name="curcal" property="mailListId" />
  <bw:emitCurrentPrivs name="curcal" property="currentAccess" />
  <bw:emitAcl name="curcal" property="currentAccess" />
</currentCalendar>
