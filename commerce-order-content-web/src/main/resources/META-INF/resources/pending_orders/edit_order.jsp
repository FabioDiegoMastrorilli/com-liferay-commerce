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

List<CommerceOrderValidatorResult> commerceOrderValidatorResults = new ArrayList<>();
%>

<%@ include file="/management_bar.jspf" %>

<portlet:actionURL name="editCommerceOrder" var="editCommerceOrderActionURL">
	<portlet:param name="mvcRenderCommandName" value="editCommerceOrder" />
</portlet:actionURL>

<aui:form action="<%= editCommerceOrderActionURL %>" cssClass="order-details-container" method="post" name="fm">
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="redirect" type="hidden" value="<%= currentURL %>" />
	<aui:input name="commerceOrderId" type="hidden" value="<%= String.valueOf(commerceOrder.getCommerceOrderId()) %>" />

	<liferay-ui:error exception="<%= CommerceOrderValidatorException.class %>">

		<%
		CommerceOrderValidatorException cove = (CommerceOrderValidatorException)errorException;

		if (cove != null) {
			commerceOrderValidatorResults = cove.getCommerceOrderValidatorResults();
		}

		for (CommerceOrderValidatorResult commerceOrderValidatorResult : commerceOrderValidatorResults) {
		%>

			<liferay-ui:message key="<%= commerceOrderValidatorResult.getLocalizedMessage() %>" />

		<%
		}
		%>

	</liferay-ui:error>

	<liferay-portlet:renderURL var="editBillingAddressURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
		<portlet:param name="mvcRenderCommandName" value="editCommerceOrderBillingAddress" />
		<portlet:param name="commerceOrderId" value="<%= String.valueOf(commerceOrderContentDisplayContext.getCommerceOrderId()) %>" />
	</liferay-portlet:renderURL>

	<commerce-ui:modal
		closeOnSubmit="<%= true %>"
		id="billing-address-modal"
		showCancel="<%= true %>"
		showSubmit="<%= true %>"
		size="lg"
		title='<%= LanguageUtil.get(request, "billing-address") %>'
		url="<%= editBillingAddressURL %>"
	/>

	<liferay-portlet:renderURL var="editShippingAddressURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
		<portlet:param name="mvcRenderCommandName" value="editCommerceOrderShippingAddress" />
		<portlet:param name="commerceOrderId" value="<%= String.valueOf(commerceOrderContentDisplayContext.getCommerceOrderId()) %>" />
	</liferay-portlet:renderURL>

	<commerce-ui:modal
		closeOnSubmit="<%= true %>"
		id="shipping-address-modal"
		showCancel="<%= true %>"
		showSubmit="<%= true %>"
		size="lg"
		title='<%= LanguageUtil.get(request, "shipping-address") %>'
		url="<%= editShippingAddressURL %>"
	/>

	<liferay-portlet:renderURL var="editPurchaseOrderNumberURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
		<portlet:param name="mvcRenderCommandName" value="editCommerceOrderPurchaseOrderNumber" />
		<portlet:param name="commerceOrderId" value="<%= String.valueOf(commerceOrderContentDisplayContext.getCommerceOrderId()) %>" />
	</liferay-portlet:renderURL>

	<commerce-ui:modal
		closeOnSubmit="<%= true %>"
		id="purchase-order-number-modal"
		showCancel="<%= true %>"
		showSubmit="<%= true %>"
		size="lg"
		title='<%= LanguageUtil.get(request, "purchase-order-number") %>'
		url="<%= editPurchaseOrderNumberURL %>"
	/>

	<liferay-portlet:renderURL var="editRequestedDeliveryDateURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
		<portlet:param name="mvcRenderCommandName" value="editCommerceOrderRequestedDeliveryDate" />
		<portlet:param name="commerceOrderId" value="<%= String.valueOf(commerceOrderContentDisplayContext.getCommerceOrderId()) %>" />
	</liferay-portlet:renderURL>

	<commerce-ui:modal
		closeOnSubmit="<%= true %>"
		id="requested-delivery-date-modal"
		showCancel="<%= true %>"
		showSubmit="<%= true %>"
		size="lg"
		title='<%= LanguageUtil.get(request, "requested-delivery-date") %>'
		url="<%= editRequestedDeliveryDateURL %>"
	/>

	<liferay-portlet:renderURL var="editPrintedNoteURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
		<portlet:param name="mvcRenderCommandName" value="editCommerceOrderPrintedNote" />
		<portlet:param name="commerceOrderId" value="<%= String.valueOf(commerceOrderContentDisplayContext.getCommerceOrderId()) %>" />
	</liferay-portlet:renderURL>

	<commerce-ui:modal
		closeOnSubmit="<%= true %>"
		id="printed-note-modal"
		showCancel="<%= true %>"
		showSubmit="<%= true %>"
		size="lg"
		title='<%= LanguageUtil.get(request, "printed-note") %>'
		url="<%= editPrintedNoteURL %>"
	/>

	<div class="row">
		<div class="col-12">
			<commerce-ui:panel
				actionUrl="<%= editBillingAddressURL %>"
				elementClasses="flex-fill"
				title='<%= LanguageUtil.get(request, "info") %>'
			>
				<div class="row vertically-divided">
					<div class="col-md-4">

						<%
						CommerceAddress billingAddress = commerceOrder.getBillingAddress();
						%>

						<commerce-ui:info-box
							actionLabel='<%= LanguageUtil.get(request, (billingAddress == null) ? "add" : "edit") %>'
							actionTargetId="billing-address-modal"
							actionUrl="<%= editBillingAddressURL %>"
							elementClasses="py-3"
							title='<%= LanguageUtil.get(request, "billing-address") %>'
						>
							<c:choose>
								<c:when test="<%= billingAddress == null %>">
									<span class="text-muted">
										<%= LanguageUtil.get(request, "click-add-to-insert") %>
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
							actionLabel='<%= LanguageUtil.get(request, (shippingAddress == null) ? "add" : "edit") %>'
							actionTargetId="shipping-address-modal"
							actionUrl="<%= editShippingAddressURL %>"
							elementClasses="py-3"
							title='<%= LanguageUtil.get(request, "shipping-address") %>'
						>
							<c:choose>
								<c:when test="<%= shippingAddress == null %>">
									<span class="text-muted">
										<%= LanguageUtil.get(request, "click-add-to-insert") %>
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
							actionLabel='<%= LanguageUtil.get(request, Validator.isNull(purchaseOrderNumber) ? "add" : "edit") %>'
							actionTargetId="purchase-order-number-modal"
							actionUrl="<%= editPurchaseOrderNumberURL %>"
							elementClasses="py-3"
							title='<%= LanguageUtil.get(request, "purchase-order-number") %>'
						>
							<c:choose>
								<c:when test="<%= Validator.isNull(purchaseOrderNumber) %>">
									<span class="text-muted">
										<%= LanguageUtil.get(request, "click-add-to-insert") %>
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
							actionLabel='<%= LanguageUtil.get(request, (requestedDeliveryDate == null) ? "add" : "edit") %>'
							actionTargetId="requested-delivery-date-modal"
							actionUrl="<%= editRequestedDeliveryDateURL %>"
							elementClasses="py-3"
							title='<%= LanguageUtil.get(request, "requested-delivery-date") %>'
						>
							<c:choose>
								<c:when test="<%= requestedDeliveryDate == null %>">
									<span class="text-muted">
										<%= LanguageUtil.get(request, "click-add-to-insert") %>
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
							actionLabel='<%= LanguageUtil.get(request, Validator.isNull(printedNote) ? "add" : "edit") %>'
							actionTargetId="printed-note-modal"
							actionUrl="<%= editPrintedNoteURL %>"
							elementClasses="py-3"
							title='<%= LanguageUtil.get(request, "printed-note") %>'
						>
							<c:choose>
								<c:when test="<%= Validator.isNull(printedNote) %>">
									<span class="text-muted">
										<%= LanguageUtil.get(request, "click-add-to-insert") %>
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
</aui:form>

<div class="row">
	<div class="col-12">
		<commerce-ui:table
			dataProviderKey="commercePendingOrderItems"
			itemPerPage="<%= 5 %>"
			namespace="<%= renderResponse.getNamespace() %>"
			pageNumber="1"
			portletURL="<%= commerceOrderContentDisplayContext.getPortletURL() %>"
			tableName="commercePendingOrderItems"
		/>
	</div>

	<div class="col-12">
		<c:choose>
			<c:when test="<%= PortalPermissionUtil.contains(PermissionThreadLocal.getPermissionChecker(), CommerceActionKeys.MANAGE_COMMERCE_ORDER_PRICES) %>">
				<liferay-portlet:renderURL var="editOrderSummaryURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
					<portlet:param name="mvcRenderCommandName" value="editCommerceOrderSummary" />
					<portlet:param name="commerceOrderId" value="<%= String.valueOf(commerceOrderContentDisplayContext.getCommerceOrderId()) %>" />
				</liferay-portlet:renderURL>

				<commerce-ui:modal
					closeOnSubmit="<%= true %>"
					id="order-summary-modal"
					showCancel="<%= true %>"
					showSubmit="<%= true %>"
					size="lg"
					title='<%= LanguageUtil.get(request, "order-summary") %>'
					url="<%= editOrderSummaryURL %>"
				/>

				<commerce-ui:panel
					actionLabel='<%= LanguageUtil.get(request, "edit") %>'
					actionTargetId="order-summary-modal"
					actionUrl="<%= editOrderSummaryURL %>"
					title='<%= LanguageUtil.get(request, "order-summary") %>'
				>
					<commerce-ui:summary
						items="<%= commerceOrderContentDisplayContext.getSummary() %>"
					/>
				</commerce-ui:panel>
			</c:when>
			<c:otherwise>
				<commerce-ui:panel
					title='<%= LanguageUtil.get(request, "order-summary") %>'
				>
					<commerce-ui:summary
						items="<%= commerceOrderContentDisplayContext.getSummary() %>"
					/>
				</commerce-ui:panel>
			</c:otherwise>
		</c:choose>
	</div>
</div>

<div id="order-details-side-panel"></div>

<liferay-portlet:renderURL var="viewOrderNotesURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcRenderCommandName" value="viewCommerceOrderNotes" />
	<portlet:param name="commerceOrderId" value="<%= String.valueOf(commerceOrderContentDisplayContext.getCommerceOrderId()) %>" />
</liferay-portlet:renderURL>

<portlet:actionURL name="editCommerceOrder" var="editCommerceOrderURL" />

<aui:script require="commerce-frontend-js/components/side_panel/entry.es as sidePanel">
	sidePanel.default(
		"orderDetailsSidePanel",
		"order-details-side-panel",
		{
		    container: '#main-content',
			id: 'sidePanelTestId',
			items: [
				{
					slug: 'comments',
					href: '<%= viewOrderNotesURL %>',
					icon: 'comments'
				},
				{
					slug: 'edit',
					href: '<%= editCommerceOrderURL %>',
					icon: 'pencil'
				}
			],
			size: 'sm',
			spritemap: '/o/admin-theme/images/lexicon/icons.svg',
			topAnchor: '.commerce-topbar',
		}
	);
</aui:script>

<%@ include file="/pending_orders/transition.jspf" %>

<aui:script use="aui-base">
var orderTransition = A.one('#<portlet:namespace />orderTransition');

if (orderTransition) {
	orderTransition.delegate(
		'click',
		function(event) {
			<portlet:namespace />transition(event);
		},
		'.transition-link'
	);
}
</aui:script>