<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>
<html:xhtml/>

<name><html:text property="sponsor.name" size="30" styleId="iSponsor" styleClass="edit, highlite"/></name>
<phone><html:text property="sponsor.phone" size="30" styleId="iAddPhone" styleClass="edit"/></phone>
<link><html:text property="sponsor.link" size="30" styleId="iCLink" styleClass="edit"/></link>
<email><html:text property="sponsor.email" size="30" styleId="iEmail" styleClass="edit"/></email>
