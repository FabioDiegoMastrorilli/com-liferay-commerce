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
CommerceOrderEditDisplayContext commerceOrderEditDisplayContext = (CommerceOrderEditDisplayContext)request.getAttribute(WebKeys.PORTLET_DISPLAY_CONTEXT);

SearchContainer<CommerceOrderItem> commerceOrderItemsSearchContainer = commerceOrderEditDisplayContext.getCommerceOrderItemsSearchContainer();
PortletURL portletURL = commerceOrderEditDisplayContext.getCommerceOrderItemsPortletURL();
%>

<liferay-portlet:renderURL var="editURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcRenderCommandName" value="editCommerceOrderShippingAddress" />
	<portlet:param name="commerceOrderId" value="<%= String.valueOf(commerceOrderEditDisplayContext.getCommerceOrderId()) %>" />
</liferay-portlet:renderURL>

<commerce-ui:modal
	closeOnSubmit="<%= true %>"
	id="billing-modal"
	showCancel="<%= true %>"
	showSubmit="<%= true %>"
	size="lg"
	title="Billing address"
	url="<%= editURL %>"
/>

<commerce-ui:modal
	closeOnSubmit="<%= true %>"
	id="shipping-modal"
	showCancel="<%= true %>"
	showSubmit="<%= true %>"
	size="lg"
	title="Shipping address"
	url="<%= editURL %>"
/>

<commerce-ui:modal
	closeOnSubmit="<%= true %>"
	id="purchase-order-number-modal"
	showCancel="<%= true %>"
	showSubmit="<%= true %>"
	size="lg"
	title="Purchase order number"
	url="<%= editURL %>"
/>

<commerce-ui:modal
	closeOnSubmit="<%= true %>"
	id="requested-delivery-modal"
	showCancel="<%= true %>"
	showSubmit="<%= true %>"
	size="lg"
	title="Requested delivery date"
	url="<%= editURL %>"
/>

<commerce-ui:modal
	closeOnSubmit="<%= true %>"
	id="order-notes-modal"
	showCancel="<%= true %>"
	showSubmit="<%= true %>"
	size="lg"
	title="Order notes"
	url="<%= editURL %>"
/>

<div class="container">
	<div class="col-12 mb-4">
		<commerce-ui:step-tracker
			steps="<%= commerceOrderEditDisplayContext.getOrderSteps() %>"
		/>
	</div>

	<div class="col-12">
		<commerce-ui:panel
			elementClasses="flex-fill"
			headerActionUrl="<%= editURL %>"
			title="info"
		>
			<div class="row vertically-divided">
				<div class="col-md-4">
					<commerce-ui:info-box
						actionLabel="edit"
						actionTargetId="billing-modal"
						elementClasses="py-3"
						title="Billing address"
					>
						PO Box 467 New York NY 10002
					</commerce-ui:info-box>

					<commerce-ui:info-box
						actionLabel="edit"
						actionTargetId="shipping-modal"
						elementClasses="py-3"
						title="Shipping address"
					>
						PO Box 467 New York NY 10002
					</commerce-ui:info-box>
				</div>

				<div class="col-md-4">
					<commerce-ui:info-box
						actionLabel="edit"
						actionTargetId="purchase-order-number-modal"
						elementClasses="py-3"
						title="Purchase Order Number"
					>
						#56731451
					</commerce-ui:info-box>

					<commerce-ui:info-box
						actionLabel="edit"
						actionTargetId="purchase-order-number-modal"
						elementClasses="py-3"
						title="Requested delivery date"
					>
						Aug 24, 2019
					</commerce-ui:info-box>
				</div>

				<div class="col-md-4">
					<commerce-ui:info-box
						actionLabel="edit"
						actionTargetId="order-notes-modal"
						elementClasses="py-3"
						title="Order notes"
					>
						Cras ultricies ligula sed magna dictum porta. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a.
					</commerce-ui:info-box>
				</div>
			</div>
		</commerce-ui:panel>
	</div>

	<div class="col-12">
		<commerce-ui:panel
			title="items"
		>
			<liferay-frontend:management-bar
				includeCheckBox="<%= true %>"
				searchContainerId="commerceOrderItems"
			>
				<liferay-frontend:management-bar-filters>
					<liferay-frontend:management-bar-sort
						orderByCol="<%= commerceOrderItemsSearchContainer.getOrderByCol() %>"
						orderByType="<%= commerceOrderItemsSearchContainer.getOrderByType() %>"
						orderColumns="<%= commerceOrderItemsSearchContainer.getOrderableHeaders() %>"
						portletURL="<%= portletURL %>"
					/>

					<li>
						<aui:form action="<%= portletURL %>" method="get" name="fm">
							<liferay-portlet:renderURLParams portletURL="<%= portletURL %>" />

							<liferay-ui:search-form
								page="/order/item_search.jsp"
								servletContext="<%= application %>"
							/>
						</aui:form>
					</li>
				</liferay-frontend:management-bar-filters>

				<liferay-frontend:management-bar-buttons>
					<portlet:actionURL name="editCommerceOrderItem" var="addCommerceOrderItemURL" />

					<aui:form action="<%= addCommerceOrderItemURL %>" cssClass="hide" name="addCommerceOrderItemFm">
						<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.ADD %>" />
						<aui:input name="redirect" type="hidden" value="<%= currentURL %>" />
						<aui:input name="commerceOrderId" type="hidden" value="<%= commerceOrderEditDisplayContext.getCommerceOrderId() %>" />
						<aui:input name="cpInstanceIds" type="hidden" value="" />
					</aui:form>

					<liferay-frontend:add-menu
						inline="<%= true %>"
					>
						<liferay-frontend:add-menu-item
							id="addCommerceOrderItem"
							title='<%= LanguageUtil.get(request, "add-item") %>'
							url="javascript:;"
						/>
					</liferay-frontend:add-menu>
				</liferay-frontend:management-bar-buttons>

				<liferay-frontend:management-bar-action-buttons>
					<liferay-frontend:management-bar-button
						href='<%= "javascript:" + renderResponse.getNamespace() + "deleteCommerceOrderItems();" %>'
						icon="times"
						label="delete"
					/>
				</liferay-frontend:management-bar-action-buttons>
			</liferay-frontend:management-bar>

			<div class="container-fluid-1280">
				<liferay-ui:search-container
					id="commerceOrderItems"
					searchContainer="<%= commerceOrderItemsSearchContainer %>"
				>
					<liferay-ui:search-container-row
						className="com.liferay.commerce.model.CommerceOrderItem"
						escapedModel="<%= true %>"
						keyProperty="commerceOrderItemId"
						modelVar="commerceOrderItem"
					>

						<%
						PortletURL rowURL = renderResponse.createRenderURL();

						rowURL.setParameter("mvcRenderCommandName", "editCommerceOrderItem");
						rowURL.setParameter("redirect", currentURL);
						rowURL.setParameter("commerceOrderId", String.valueOf(commerceOrderItem.getCommerceOrderId()));
						rowURL.setParameter("commerceOrderItemId", String.valueOf(commerceOrderItem.getCommerceOrderItemId()));

						CommerceOrder commerceOrder = commerceOrderItem.getCommerceOrder();
						%>

						<liferay-ui:search-container-column-text
							cssClass="important table-cell-content"
							href="<%= rowURL %>"
							property="sku"
						/>

						<liferay-ui:search-container-column-text
							cssClass="table-cell-content"
							name="name"
							value="<%= commerceOrderItem.getName(locale) %>"
						/>

						<%
						CommerceProductPrice commerceProductPrice = commerceOrderEditDisplayContext.getCommerceProductPrice(commerceOrderItem);
						%>

						<liferay-ui:search-container-column-text
							cssClass="table-cell-content"
							name="price"
						>
							<c:if test="<%= commerceProductPrice != null %>">

								<%
								CommerceMoney unitPrice = commerceProductPrice.getUnitPrice();
								%>

								<div class="value-section">
									<span class="commerce-value">
										<%= HtmlUtil.escape(unitPrice.format(locale)) %>
									</span>
									<span class="commerce-subscription-info">
										<liferay-commerce:subscription-info
											commerceOrderItemId="<%= commerceOrder.isOpen() ? 0 : commerceOrderItem.getCommerceOrderItemId() %>"
											CPInstanceId="<%= commerceOrderItem.getCPInstanceId() %>"
											showDuration="<%= false %>"
										/>
									</span>
								</div>
							</c:if>
						</liferay-ui:search-container-column-text>

						<liferay-ui:search-container-column-text
							name="discount"
						>
							<c:if test="<%= commerceProductPrice != null %>">

								<%
								CommerceDiscountValue commerceDiscountValue = commerceProductPrice.getDiscountValue();
								%>

								<c:if test="<%= commerceDiscountValue != null %>">

									<%
									CommerceMoney discountAmount = commerceDiscountValue.getDiscountAmount();
									%>

									<div class="value-section">
										<span class="commerce-value">
											<%= HtmlUtil.escape(discountAmount.format(locale)) %>
										</span>
									</div>
								</c:if>
							</c:if>
						</liferay-ui:search-container-column-text>

						<liferay-ui:search-container-column-text
							property="quantity"
						/>

						<liferay-ui:search-container-column-text
							name="total"
						>
							<c:if test="<%= commerceProductPrice != null %>">

								<%
								CommerceMoney finalPrice = commerceProductPrice.getFinalPrice();
								%>

								<div class="value-section">
									<span class="commerce-value">
										<%= HtmlUtil.escape(finalPrice.format(locale)) %>
									</span>
								</div>
							</c:if>
						</liferay-ui:search-container-column-text>

						<liferay-ui:search-container-column-jsp
							cssClass="entry-action-column"
							path="/order/item_action.jsp"
						/>
					</liferay-ui:search-container-row>

					<liferay-ui:search-iterator
						markupView="lexicon"
					/>
				</liferay-ui:search-container>
			</div>
		</commerce-ui:panel>
	</div>

	<div class="col-12">
		<commerce-ui:panel
			headerActionLabel="edit"
			title="order-summary"
		>
			<div id="order-timeline-root"></div>
		</commerce-ui:panel>
	</div>
</div>

<aui:script>
	function <portlet:namespace />deleteCommerceOrderItems() {
		if (confirm('<liferay-ui:message key="are-you-sure-you-want-to-delete-the-selected-order-items" />')) {
			var form = AUI.$(document.<portlet:namespace />fm);

			form.attr('method', 'post');
			form.fm('<%= Constants.CMD %>').val('<%= Constants.DELETE %>');
			form.fm('deleteCommerceOrderItemIds').val(Liferay.Util.listCheckedExcept(form, '<portlet:namespace />allRowIds'));

			submitForm(form, '<portlet:actionURL name="editCommerceOrderItem" />');
		}
	}
</aui:script>

<aui:script use="liferay-item-selector-dialog">
	$('#<portlet:namespace />addCommerceOrderItem').on(
		'click',
		function(event) {
			event.preventDefault();

			var itemSelectorDialog = new A.LiferayItemSelectorDialog(
				{
					eventName: 'productInstancesSelectItem',
					on: {
						selectedItemChange: function(event) {
							var selectedItems = event.newVal;

							if (selectedItems) {
								$('#<portlet:namespace />cpInstanceIds').val(selectedItems);

								var addCommerceOrderItemFm = $('#<portlet:namespace />addCommerceOrderItemFm');

								submitForm(addCommerceOrderItemFm);
							}
						}
					},
					title: '<liferay-ui:message arguments="<%= commerceOrderEditDisplayContext.getCommerceOrderId() %>" key="add-new-product-to-order-x" />',
					url: '<%= commerceOrderEditDisplayContext.getItemSelectorUrl() %>'
				}
			);

			itemSelectorDialog.open();
		}
	);
</aui:script>