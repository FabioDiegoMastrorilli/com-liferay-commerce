<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<%
CommerceOrderContentDisplayContext commerceOrderContentDisplayContext = (CommerceOrderContentDisplayContext)request.getAttribute(WebKeys.PORTLET_DISPLAY_CONTEXT);

CommerceOrder commerceOrder = commerceOrderContentDisplayContext.getCommerceOrder();
%>

<portlet:actionURL name="editCommerceOrder" var="editCommerceOrderSummaryActionURL" />

<aui:form action="<%= editCommerceOrderSummaryActionURL %>" cssClass="container-fluid-1280 p-0" method="post" name="fm">
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="orderSummary" />
	<aui:input name="redirect" type="hidden" value="<%= currentURL %>" />
	<aui:input name="commerceOrderId" type="hidden" value="<%= commerceOrder.getCommerceOrderId() %>" />

	<aui:model-context bean="<%= commerceOrder %>" model="<%= CommerceOrder.class %>" />

	<div class="border-0 sheet">
		<aui:input label="items-subtotal-discount" name="subtotalDiscountAmount" type="text" wrapperCssClass="form-group-item">
			<aui:validator name="number" />
		</aui:input>

		<aui:input label="order-discount" name="totalDiscountAmount" type="text" wrapperCssClass="form-group-item">
			<aui:validator name="number" />
		</aui:input>

		<aui:input label="shipping-and-handing-discount" name="shippingDiscountAmount" type="text" wrapperCssClass="form-group-item">
			<aui:validator name="number" />
		</aui:input>
	</div>

	<aui:button type="submit" />
</aui:form>