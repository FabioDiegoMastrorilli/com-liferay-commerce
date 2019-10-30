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

<liferay-ui:error exception="<%= CommerceOrderValidatorException.class %>">

	<%
	CommerceOrderValidatorException cove = (CommerceOrderValidatorException)errorException;

	if (cove != null) {
		for (CommerceOrderValidatorResult commerceOrderValidatorResult : cove.getCommerceOrderValidatorResults()) {
	%>

			<liferay-ui:message key="<%= commerceOrderValidatorResult.getLocalizedMessage() %>" />

	<%
		}
	}
	%>

</liferay-ui:error>

<div class="row">
	<div class="col-12">
		<commerce-ui:panel
			elementClasses="flex-fill"
			title='<%= LanguageUtil.get(request, "info") %>'
		>
			<div class="row vertically-divided">
				<div class="col-md-4">

					<%
					CommerceAddress billingAddress = commerceOrder.getBillingAddress();
					%>

					<commerce-ui:info-box
						elementClasses="py-3"
						title='<%= LanguageUtil.get(request, "billing-address") %>'
					>
						<c:choose>
							<c:when test="<%= billingAddress == null %>">
								<span class="text-muted">
									<%= LanguageUtil.get(request, "none") %>
								</span>
							</c:when>
							<c:otherwise>
								<%= HtmlUtil.escape(commerceOrderContentDisplayContext.getDescriptiveCommerceAddress(billingAddress)) %>
							</c:otherwise>
						</c:choose>
					</commerce-ui:info-box>

					<%
					CommerceAddress shippingAddress = commerceOrder.getShippingAddress();
					%>

					<commerce-ui:info-box
						elementClasses="py-3"
						title='<%= LanguageUtil.get(request, "shipping-address") %>'
					>
						<c:choose>
							<c:when test="<%= shippingAddress == null %>">
								<span class="text-muted">
									<%= LanguageUtil.get(request, "none") %>
								</span>
							</c:when>
							<c:otherwise>
								<%= HtmlUtil.escape(commerceOrderContentDisplayContext.getDescriptiveCommerceAddress(shippingAddress)) %>
							</c:otherwise>
						</c:choose>
					</commerce-ui:info-box>
				</div>

				<div class="col-md-4">

					<%
					String purchaseOrderNumber = commerceOrder.getPurchaseOrderNumber();
					%>

					<commerce-ui:info-box
						elementClasses="py-3"
						title='<%= LanguageUtil.get(request, "purchase-order-number") %>'
					>
						<c:choose>
							<c:when test="<%= Validator.isNull(purchaseOrderNumber) %>">
								<span class="text-muted">
									<%= LanguageUtil.get(request, "none") %>
								</span>
							</c:when>
							<c:otherwise>
								<%= HtmlUtil.escape(purchaseOrderNumber) %>
							</c:otherwise>
						</c:choose>
					</commerce-ui:info-box>

					<%
					Date requestedDeliveryDate = commerceOrder.getRequestedDeliveryDate();
					%>

					<commerce-ui:info-box
						elementClasses="py-3"
						title='<%= LanguageUtil.get(request, "requested-delivery-date") %>'
					>
						<c:choose>
							<c:when test="<%= requestedDeliveryDate == null %>">
								<span class="text-muted">
									<%= LanguageUtil.get(request, "none") %>
								</span>
							</c:when>
							<c:otherwise>
								<%= commerceOrderContentDisplayContext.getCommerceOrderDateTime(requestedDeliveryDate) %>
							</c:otherwise>
						</c:choose>
					</commerce-ui:info-box>
				</div>

				<%
				String printedNote = commerceOrder.getPrintedNote();

				String commerceOrderDateTime = commerceOrderContentDisplayContext.getCommerceOrderDateTime(commerceOrder.getCreateDate());
				%>

				<div class="col-md-4">
					<commerce-ui:info-box
						elementClasses="py-3"
						title='<%= LanguageUtil.get(request, "printed-note") %>'
					>
						<c:choose>
							<c:when test="<%= Validator.isNull(printedNote) %>">
								<span class="text-muted">
									<%= LanguageUtil.get(request, "none") %>
								</span>
							</c:when>
							<c:otherwise>
								<%= HtmlUtil.escape(printedNote) %>
							</c:otherwise>
						</c:choose>
					</commerce-ui:info-box>

					<commerce-ui:info-box
						elementClasses="py-3"
						title='<%= LanguageUtil.get(request, "order-date") %>'
					>
						<%= HtmlUtil.escape(commerceOrderDateTime) %>
					</commerce-ui:info-box>
				</div>
			</div>
		</commerce-ui:panel>
	</div>
</div>

<div class="commerce-cta is-visible">
	<portlet:actionURL name="editCommerceOrder" var="editCommerceOrderActionURL">
		<portlet:param name="mvcRenderCommandName" value="viewCommerceOrderDetails" />
	</portlet:actionURL>

	<aui:form action="<%= editCommerceOrderActionURL %>" method="post" name="fm">
		<aui:input name="<%= Constants.CMD %>" type="hidden" />
		<aui:input name="commerceOrderId" type="hidden" value="<%= String.valueOf(commerceOrder.getCommerceOrderId()) %>" />
	</aui:form>

	<aui:button cssClass="btn btn-lg btn-secondary" onClick='<%= renderResponse.getNamespace() + "reorderCommerceOrder();" %>' value="reorder" />
</div>

<div class="row">
	<div class="col-md-12">
		<commerce-ui:table
			dataProviderKey="commercePlacedOrderItems"
			itemPerPage="<%= 5 %>"
			namespace="<%= renderResponse.getNamespace() %>"
			pageNumber="1"
			portletURL="<%= commerceOrderContentDisplayContext.getPortletURL() %>"
			tableName="commercePlacedOrderItems"
		/>
	</div>

	<div class="col-12">
		<commerce-ui:panel
			title='<%= LanguageUtil.get(request, "order-summary") %>'
		>
			<commerce-ui:summary
				items="<%= commerceOrderContentDisplayContext.getSummary() %>"
			/>
		</commerce-ui:panel>
	</div>
</div>

<aui:script>
	function <portlet:namespace/>viewCommerceOrderShipments(uri) {
		Liferay.Util.openWindow(
			{
				dialog: {
					centered: true,
					destroyOnClose: true,
					modal: true
				},
				dialogIframe: {
					bodyCssClass: 'dialog'
				},
				id: 'viewCommerceOrderShipmentsDialog',
				title: '',
				uri: uri
			}
		);
	}

	function <portlet:namespace />reorderCommerceOrder() {
		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = 'reorder';

		submitForm(document.<portlet:namespace />fm);
	}
</aui:script>