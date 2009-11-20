<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<bedework>
  <page>categoryWidget</page>

  <logic:iterate id="msg" name="calForm" property="msg.msgList">
    <message>
      <id><bean:write name="msg" property="msgId" /></id>
      <logic:iterate id="param" name="msg" property="params" >
        <param><bean:write name="param" /></param>
      </logic:iterate>
    </message>
  </logic:iterate>

  <logic:iterate id="errBean" name="calForm" property="err.msgList">
    <error>
      <id><bean:write name="errBean" property="msgId" /></id>
      <logic:iterate id="param" name="errBean" property="params" >
        <param><bean:write name="param" /></param>
      </logic:iterate>
    </error>
  </logic:iterate>

  <approot><bean:write name="calForm" property="presentationState.appRoot"/></approot>

  <%-- List of categories  --%>
  <categories>
    <logic:iterate id="category" name="calForm" property="categories">
      <category>
        <keyword><bean:write name="category" property="word.value"/></keyword>
        <creator><bean:write name="category" property="creatorHref"/></creator>
        <id><bean:write name="category" property="id" /></id>
      </category>
    </logic:iterate>
  </categories>
</bedework>

