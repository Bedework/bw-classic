<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>
<%@ taglib uri='struts-html' prefix='html' %>
<%@ taglib uri='struts-genurl' prefix='genurl' %>

<%@ include file="header.jsp" %>

<page>main</page>

<propertyGroups>
  <html:form action="save.do" method="POST" enctype="multipart/form-data">
    <logic:iterate id="pgroup" name="configForm" property="propertyCollections">
      <logic:equal name="pgroup" property="show" value="true" >
        <bean:define id="bwpgname" name="pgroup" property="name" />
        <propertyGroup name="<%=bwpgname%>">
          <logic:iterate id="prop" name="pgroup" property="properties" >
            <logic:equal name="prop" property="type" value="5" >
              <comment><bean:write name="prop" property="value"/></comment>
            </logic:equal>
            <logic:notEqual name="prop" property="type" value="5" >
              <logic:equal name="prop" property="show" value="true" >
                <bean:define id="ptype" name="prop" property="type" />
                <bean:define id="bwpname" name="prop" property="name" />
                <property name="<%=bwpname%>" type="<%=ptype%>">
                  <required><bean:write name="prop" property="required"/></required>
                  <ok><bean:write name="prop" property="goodValue"/></ok>
                  <fieldName><bean:write name="pgroup" property="name" />.<bean:write name="prop" property="name" /></fieldName>
                  <fieldValue><bean:write name="prop" property="value" /></fieldValue>
                  <logic:equal name="prop" property="type" value="2" >
                    <checked><bean:write name="prop" property="booleanValAndFlag"/></checked>
                  </logic:equal>

                  <%-- /*
                   ORIGINAL JSP:
                  <% String nm = String.valueOf(bwpgname) + "." + String.valueOf(bwpname); %>
                  <logic:equal name="prop" property="type" value="2" >
                    <% String checked = ""; %>
                    <logic:equal name="prop" property="booleanValAndFlag" value="true" >
                      <% checked = "CHECKED"; %>
                    </logic:equal>
                    <field><input type="checkbox" name="<%=nm%>" <%=checked%> value="true" /></field>
                  </logic:equal>
                  <logic:notEqual name="prop" property="type" value="2" >
                    <logic:present name="prop" property="value" >
                      <bean:define id="bwpval" name="prop" property="value" />
                      <% String val = String.valueOf(bwpval); %>
                      <input type="text" name="<%=nm%>" value="<%=val%>" />
                    </logic:present>
                    <logic:notPresent name="prop" property="value" >
                      <input type="text" name="<%=nm%>" />
                    </logic:notPresent>
                  </logic:notEqual> */ --%>
                </property>
              </logic:equal>
            </logic:notEqual>
          </logic:iterate>
        </propertyGroup>
      </logic:equal>
    </logic:iterate>
    <submitButtons>
      <save><html:submit property="save" value="Save"/></save>
      <refresh><html:submit property="refresh" value="Refresh"/></refresh>
    </submitButtons>
  </html:form>
</propertyGroups>

<%@ include file="footer.jsp" %>

