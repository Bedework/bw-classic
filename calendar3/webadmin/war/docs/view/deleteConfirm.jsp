<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-logic' prefix='logic' %>

<%@include file="/docs/header.jsp"%>

<page>deleteViewConfirm</page>

<views>
  <bean:define name="peForm" property="view" id="view"/>
  <view>
    <name><bean:write name="view" property="name" /></name>
    <subscriptions>
      <logic:iterate name="view" property="subscriptions" id="subscription">
        <subscription>
          <name><bean:write name="subscription" property="name" /></name>
        </subscription>
      </logic:iterate>
    </subscriptions>
  </view>
</views>

<%@include file="/docs/footer.jsp"%>
