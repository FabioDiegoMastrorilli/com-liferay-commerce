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

package com.liferay.commerce.order.content.web.internal.display.context;

import com.liferay.commerce.account.constants.CommerceAccountConstants;
import com.liferay.commerce.account.model.CommerceAccount;
import com.liferay.commerce.configuration.CommerceOrderFieldsConfiguration;
import com.liferay.commerce.constants.CommerceConstants;
import com.liferay.commerce.constants.CommerceOrderActionKeys;
import com.liferay.commerce.constants.CommercePortletKeys;
import com.liferay.commerce.constants.CommerceShipmentConstants;
import com.liferay.commerce.constants.CommerceWebKeys;
import com.liferay.commerce.context.CommerceContext;
import com.liferay.commerce.currency.model.CommerceMoney;
import com.liferay.commerce.discount.CommerceDiscountValue;
import com.liferay.commerce.frontend.model.HeaderActionModel;
import com.liferay.commerce.frontend.model.SummaryItem;
import com.liferay.commerce.model.CommerceAddress;
import com.liferay.commerce.model.CommerceOrder;
import com.liferay.commerce.model.CommerceOrderNote;
import com.liferay.commerce.model.CommerceRegion;
import com.liferay.commerce.model.CommerceShipmentItem;
import com.liferay.commerce.order.CommerceOrderHelper;
import com.liferay.commerce.order.content.web.internal.frontend.OrderFilterImpl;
import com.liferay.commerce.order.content.web.internal.portlet.configuration.CommerceOrderContentPortletInstanceConfiguration;
import com.liferay.commerce.price.CommerceOrderPrice;
import com.liferay.commerce.price.CommerceOrderPriceCalculation;
import com.liferay.commerce.product.display.context.util.CPRequestHelper;
import com.liferay.commerce.product.model.CommerceChannel;
import com.liferay.commerce.product.service.CommerceChannelLocalService;
import com.liferay.commerce.service.CommerceAddressService;
import com.liferay.commerce.service.CommerceOrderItemService;
import com.liferay.commerce.service.CommerceOrderNoteService;
import com.liferay.commerce.service.CommerceOrderService;
import com.liferay.commerce.service.CommerceShipmentItemService;
import com.liferay.frontend.taglib.clay.servlet.taglib.util.DropdownItem;
import com.liferay.petra.string.StringBundler;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.module.configuration.ConfigurationProviderUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.PortletProvider;
import com.liferay.portal.kernel.portlet.PortletProviderUtil;
import com.liferay.portal.kernel.portlet.PortletQName;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermission;
import com.liferay.portal.kernel.security.permission.resource.PortletResourcePermission;
import com.liferay.portal.kernel.settings.GroupServiceSettingsLocator;
import com.liferay.portal.kernel.theme.PortletDisplay;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.FastDateFormatFactoryUtil;
import com.liferay.portal.kernel.util.ObjectValuePair;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.webserver.WebServerServletTokenUtil;

import java.text.DateFormat;
import java.text.Format;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.portlet.PortletURL;

import javax.servlet.http.HttpServletRequest;

/**
 * @author Alessio Antonio Rendina
 */
public class CommerceOrderContentDisplayContext {

	public CommerceOrderContentDisplayContext(
			CommerceAddressService commerceAddressService,
			CommerceChannelLocalService commerceChannelLocalService,
			CommerceOrderHelper commerceOrderHelper,
			CommerceOrderItemService commerceOrderItemService,
			CommerceOrderNoteService commerceOrderNoteService,
			CommerceOrderPriceCalculation commerceOrderPriceCalculation,
			CommerceOrderService commerceOrderService,
			CommerceShipmentItemService commerceShipmentItemService,
			HttpServletRequest httpServletRequest,
			ModelResourcePermission<CommerceOrder> modelResourcePermission,
			PortletResourcePermission portletResourcePermission)
		throws PortalException {

		_commerceAddressService = commerceAddressService;
		_commerceChannelLocalService = commerceChannelLocalService;
		_commerceOrderHelper = commerceOrderHelper;
		_commerceOrderItemService = commerceOrderItemService;
		_commerceOrderNoteService = commerceOrderNoteService;
		_commerceOrderPriceCalculation = commerceOrderPriceCalculation;
		_commerceOrderService = commerceOrderService;
		_commerceShipmentItemService = commerceShipmentItemService;
		_httpServletRequest = httpServletRequest;
		_modelResourcePermission = modelResourcePermission;
		_portletResourcePermission = portletResourcePermission;

		_cpRequestHelper = new CPRequestHelper(httpServletRequest);

		PortletDisplay portletDisplay = _cpRequestHelper.getPortletDisplay();

		_commerceOrderContentPortletInstanceConfiguration =
			portletDisplay.getPortletInstanceConfiguration(
				CommerceOrderContentPortletInstanceConfiguration.class);

		ThemeDisplay themeDisplay = _cpRequestHelper.getThemeDisplay();

		_commerceOrderDateFormatDateTime =
			FastDateFormatFactoryUtil.getDateTime(
				DateFormat.SHORT, DateFormat.SHORT, themeDisplay.getLocale(),
				themeDisplay.getTimeZone());

		_commerceContext = (CommerceContext)_httpServletRequest.getAttribute(
			CommerceWebKeys.COMMERCE_CONTEXT);

		_commerceAccount = _commerceContext.getCommerceAccount();

		_commerceOrderNoteId = ParamUtil.getLong(
			_httpServletRequest, "commerceOrderNoteId");
	}

	public CommerceChannel fetchCommerceChannel() {
		return _commerceChannelLocalService.fetchCommerceChannelBySiteGroupId(
			_cpRequestHelper.getScopeGroupId());
	}

	public List<CommerceAddress> getBillingCommerceAddresses()
		throws PortalException {

		return _commerceAddressService.getBillingCommerceAddresses(
			_cpRequestHelper.getCompanyId(), CommerceAccount.class.getName(),
			getCommerceAccountId());
	}

	public CommerceAccount getCommerceAccount() {
		return _commerceAccount;
	}

	public String getCommerceAccountDetailURL(CommerceAccount commerceAccount)
		throws PortalException {

		PortletURL portletURL = PortletProviderUtil.getPortletURL(
			_cpRequestHelper.getRequest(), CommerceAccount.class.getName(),
			PortletProvider.Action.VIEW);

		portletURL.setParameter(
			"commerceAccountId",
			String.valueOf(commerceAccount.getCommerceAccountId()));

		portletURL.setParameter(
			PortletQName.PUBLIC_RENDER_PARAMETER_NAMESPACE + "backURL",
			_cpRequestHelper.getCurrentURL());

		return portletURL.toString();
	}

	public long getCommerceAccountId() {
		long commerceAccountId = 0;

		if (_commerceAccount != null) {
			commerceAccountId = _commerceAccount.getCommerceAccountId();
		}

		return commerceAccountId;
	}

	public String getCommerceAccountThumbnailURL() throws PortalException {
		CommerceOrder commerceOrder = getCommerceOrder();

		if (commerceOrder == null) {
			return StringPool.BLANK;
		}

		CommerceAccount commerceAccount = commerceOrder.getCommerceAccount();

		ThemeDisplay themeDisplay = _cpRequestHelper.getThemeDisplay();

		StringBundler sb = new StringBundler(5);

		sb.append(themeDisplay.getPathImage());

		if (commerceAccount.getLogoId() == 0) {
			sb.append("/organization_logo?img_id=0");
		}
		else {
			sb.append("/organization_logo?img_id=");
			sb.append(commerceAccount.getLogoId());
			sb.append("&t=");
			sb.append(
				WebServerServletTokenUtil.getToken(
					commerceAccount.getLogoId()));
		}

		return sb.toString();
	}

	public CommerceOrder getCommerceOrder() throws PortalException {
		return _commerceOrderService.fetchCommerceOrder(getCommerceOrderId());
	}

	public String getCommerceOrderDateTime(Date date) throws PortalException {
		if ((getCommerceOrder() == null) || (date == null)) {
			return StringPool.BLANK;
		}

		return _commerceOrderDateFormatDateTime.format(date);
	}

	public long getCommerceOrderId() {
		return ParamUtil.getLong(_httpServletRequest, "commerceOrderId");
	}

	public String getCommerceOrderItemsDetailURL(long commerceOrderId) {
		LiferayPortletResponse liferayPortletResponse =
			_cpRequestHelper.getLiferayPortletResponse();

		PortletURL portletURL = liferayPortletResponse.createRenderURL();

		portletURL.setParameter(
			"mvcRenderCommandName", "viewCommerceOrderItems");
		portletURL.setParameter("redirect", _cpRequestHelper.getCurrentURL());
		portletURL.setParameter(
			"commerceOrderId", String.valueOf(commerceOrderId));

		return portletURL.toString();
	}

	public CommerceOrderNote getCommerceOrderNote() throws PortalException {
		if ((_commerceOrderNote == null) && (_commerceOrderNoteId > 0)) {
			_commerceOrderNote = _commerceOrderNoteService.getCommerceOrderNote(
				_commerceOrderNoteId);
		}

		return _commerceOrderNote;
	}

	public List<CommerceOrderNote> getCommerceOrderNotes(
			CommerceOrder commerceOrder)
		throws PortalException {

		if (hasModelPermission(
				commerceOrder,
				CommerceOrderActionKeys.
					MANAGE_COMMERCE_ORDER_RESTRICTED_NOTES)) {

			return _commerceOrderNoteService.getCommerceOrderNotes(
				commerceOrder.getCommerceOrderId(), QueryUtil.ALL_POS,
				QueryUtil.ALL_POS);
		}

		return _commerceOrderNoteService.getCommerceOrderNotes(
			commerceOrder.getCommerceOrderId(), false);
	}

	public int getCommerceOrderNotesCount(CommerceOrder commerceOrder)
		throws PortalException {

		if (hasModelPermission(commerceOrder, ActionKeys.UPDATE_DISCUSSION)) {
			return _commerceOrderNoteService.getCommerceOrderNotesCount(
				commerceOrder.getCommerceOrderId());
		}

		return _commerceOrderNoteService.getCommerceOrderNotesCount(
			commerceOrder.getCommerceOrderId(), false);
	}

	public List<CommerceOrder> getCommerceOrders() throws PortalException {
		if (_commerceOrders != null) {
			return _commerceOrders;
		}

		String keywords = ParamUtil.getString(_httpServletRequest, "keywords");

		if (isOpenOrderContentPortlet()) {
			_commerceOrders = _commerceOrderService.getPendingCommerceOrders(
				_cpRequestHelper.getChannelGroupId(), getCommerceAccountId(),
				keywords, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
		}
		else {
			_commerceOrders = _commerceOrderService.getPlacedCommerceOrders(
				_cpRequestHelper.getChannelGroupId(), getCommerceAccountId(),
				keywords, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
		}

		return _commerceOrders;
	}

	public List<ObjectValuePair<Long, String>> getCommerceOrderTransitionOVPs()
		throws PortalException {

		List<ObjectValuePair<Long, String>> transitionOVPs = new ArrayList<>();

		CommerceOrder commerceOrder = getCommerceOrder();

		if (commerceOrder == null) {
			return transitionOVPs;
		}

		if (!commerceOrder.isOpen()) {
			transitionOVPs.add(
				new ObjectValuePair<Long, String>(0L, "reorder"));
		}

		ObjectValuePair<Long, String> approveOVP = null;

		if (commerceOrder.isOpen() && commerceOrder.isPending() &&
			_modelResourcePermission.contains(
				_cpRequestHelper.getPermissionChecker(), commerceOrder,
				CommerceOrderActionKeys.APPROVE_COMMERCE_ORDER)) {

			approveOVP = new ObjectValuePair<>(0L, "approve");

			transitionOVPs.add(approveOVP);
		}

		if (commerceOrder.isOpen() && commerceOrder.isApproved() &&
			_modelResourcePermission.contains(
				_cpRequestHelper.getPermissionChecker(), commerceOrder,
				CommerceOrderActionKeys.CHECKOUT_COMMERCE_ORDER)) {

			transitionOVPs.add(new ObjectValuePair<>(0L, "checkout"));
		}

		if (commerceOrder.isOpen() && commerceOrder.isDraft() &&
			!commerceOrder.isEmpty() &&
			_modelResourcePermission.contains(
				_cpRequestHelper.getPermissionChecker(), commerceOrder,
				ActionKeys.UPDATE)) {

			transitionOVPs.add(new ObjectValuePair<>(0L, "submit"));
		}

		int start = transitionOVPs.size();

		transitionOVPs.addAll(
			_commerceOrderHelper.getWorkflowTransitions(
				_cpRequestHelper.getUserId(), commerceOrder));

		if (approveOVP != null) {
			for (int i = start; i < transitionOVPs.size(); i++) {
				ObjectValuePair<Long, String> objectValuePair =
					transitionOVPs.get(i);

				String value = objectValuePair.getValue();

				if (value.equals(approveOVP.getValue())) {
					approveOVP.setValue("force-" + value);

					break;
				}
			}
		}

		return transitionOVPs;
	}

	public List<CommerceShipmentItem> getCommerceShipmentItems(
			long commerceOrderItemId)
		throws PortalException {

		return _commerceShipmentItemService.getCommerceShipmentItems(
			commerceOrderItemId);
	}

	public String getCommerceShipmentStatusLabel(int status) {
		return LanguageUtil.get(
			_httpServletRequest,
			CommerceShipmentConstants.getShipmentStatusLabel(status));
	}

	public String getDescriptiveCommerceAddress(CommerceAddress commerceAddress)
		throws PortalException {

		if (commerceAddress == null) {
			return StringPool.BLANK;
		}

		CommerceRegion commerceRegion = commerceAddress.getCommerceRegion();

		StringBundler sb = new StringBundler((commerceRegion == null) ? 5 : 7);

		sb.append(commerceAddress.getStreet1());
		sb.append(StringPool.SPACE);
		sb.append(commerceAddress.getCity());
		sb.append(StringPool.NEW_LINE);

		if (commerceRegion != null) {
			sb.append(commerceRegion.getCode());
			sb.append(StringPool.SPACE);
		}

		sb.append(commerceAddress.getZip());

		return sb.toString();
	}

	public String getDisplayStyle() {
		return _commerceOrderContentPortletInstanceConfiguration.displayStyle();
	}

	public long getDisplayStyleGroupId() {
		if (_displayStyleGroupId > 0) {
			return _displayStyleGroupId;
		}

		_displayStyleGroupId =
			_commerceOrderContentPortletInstanceConfiguration.
				displayStyleGroupId();

		if (_displayStyleGroupId <= 0) {
			_displayStyleGroupId = _cpRequestHelper.getScopeGroupId();
		}

		return _displayStyleGroupId;
	}

	public List<DropdownItem> getDropdownItems() {
		List<DropdownItem> headerDropdownItems = new ArrayList<>();

		DropdownItem headerDropdownItem = new DropdownItem();

		headerDropdownItem.setHref("/first-link");
		headerDropdownItem.setIcon("home");
		headerDropdownItem.setLabel("First link");

		headerDropdownItems.add(headerDropdownItem);

		DropdownItem headerDropdownItem2 = new DropdownItem();

		headerDropdownItem2.setActive(true);
		headerDropdownItem2.setIcon("blogs");
		headerDropdownItem2.setHref("/second-link");
		headerDropdownItem2.setLabel("Second link");

		headerDropdownItems.add(headerDropdownItem2);

		return headerDropdownItems;
	}

	public List<HeaderActionModel> getHeaderActionModels()
		throws PortalException {

		List<HeaderActionModel> headerActionModels = new ArrayList<>();

		HeaderActionModel headerActionModel1 = new HeaderActionModel();

		headerActionModel1.setLabel("Action 1");
		headerActionModel1.setStyle("secondary");

		headerActionModels.add(headerActionModel1);

		HeaderActionModel headerActionModel2 = new HeaderActionModel();

		headerActionModel2.setLabel("Action 2");

		headerActionModels.add(headerActionModel2);

		return headerActionModels;
	}

	public OrderFilterImpl getOrderFilter() {
		OrderFilterImpl orderFilterImpl = new OrderFilterImpl();

		if (_commerceAccount != null) {
			orderFilterImpl.setAccountId(
				_commerceAccount.getCommerceAccountId());
		}

		return orderFilterImpl;
	}

	public PortletURL getPortletURL() {
		LiferayPortletResponse liferayPortletResponse =
			_cpRequestHelper.getLiferayPortletResponse();

		PortletURL portletURL = liferayPortletResponse.createRenderURL();

		String delta = ParamUtil.getString(_httpServletRequest, "delta");

		if (Validator.isNotNull(delta)) {
			portletURL.setParameter("delta", delta);
		}

		String deltaEntry = ParamUtil.getString(
			_httpServletRequest, "deltaEntry");

		if (Validator.isNotNull(deltaEntry)) {
			portletURL.setParameter("deltaEntry", deltaEntry);
		}

		return portletURL;
	}

	public List<CommerceAddress> getShippingCommerceAddresses()
		throws PortalException {

		return _commerceAddressService.getShippingCommerceAddresses(
			_cpRequestHelper.getCompanyId(), CommerceAccount.class.getName(),
			getCommerceAccountId());
	}

	public List<SummaryItem> getSummary() throws PortalException {
		List<SummaryItem> summary = new ArrayList<>();

		CommerceOrder commerceOrder = getCommerceOrder();

		if (commerceOrder == null) {
			return summary;
		}

		SummaryItem unitsSummaryItem = new SummaryItem();
		SummaryItem subtotalSummaryItem = new SummaryItem();
		SummaryItem discountSummaryItem = new SummaryItem();
		SummaryItem grandTotalSummaryItem = new SummaryItem();

		unitsSummaryItem.setLabel(
			LanguageUtil.get(_cpRequestHelper.getRequest(), "units"));

		unitsSummaryItem.setValue(
			LanguageUtil.format(
				_cpRequestHelper.getRequest(), "x-of-x-items",
				new Object[] {_getItemsQuantity(), _getItemsCount()}, false));

		subtotalSummaryItem.setLabel(
			LanguageUtil.get(_cpRequestHelper.getRequest(), "subtotal"));

		CommerceOrderPrice commerceOrderPrice =
			_commerceOrderPriceCalculation.getCommerceOrderPrice(
				commerceOrder, _commerceContext);

		CommerceMoney subtotal = commerceOrderPrice.getSubtotal();

		if (subtotal != null) {
			subtotalSummaryItem.setValue(
				subtotal.format(_cpRequestHelper.getLocale()));
		}

		discountSummaryItem.setLabel(
			LanguageUtil.get(_cpRequestHelper.getRequest(), "discount"));

		CommerceDiscountValue totalDiscountValue =
			commerceOrderPrice.getTotalDiscountValue();

		if (totalDiscountValue != null) {
			CommerceMoney discountAmount =
				totalDiscountValue.getDiscountAmount();

			discountSummaryItem.setValue(
				discountAmount.format(_cpRequestHelper.getLocale()));
		}
		else {
			discountSummaryItem.setValue("--");
		}

		grandTotalSummaryItem.setLabel(
			LanguageUtil.get(_cpRequestHelper.getRequest(), "grand-total"));
		grandTotalSummaryItem.setStyle("big");

		CommerceMoney total = commerceOrderPrice.getTotal();

		if (total != null) {
			grandTotalSummaryItem.setValue(
				total.format(_cpRequestHelper.getLocale()));
		}

		summary.add(unitsSummaryItem);
		summary.add(subtotalSummaryItem);
		summary.add(discountSummaryItem);
		summary.add(grandTotalSummaryItem);

		return summary;
	}

	public boolean hasModelPermission(
			CommerceOrder commerceOrder, String actionId)
		throws PortalException {

		return _modelResourcePermission.contains(
			_cpRequestHelper.getPermissionChecker(), commerceOrder, actionId);
	}

	public boolean hasModelPermission(long commerceOrderId, String actionId)
		throws PortalException {

		return _modelResourcePermission.contains(
			_cpRequestHelper.getPermissionChecker(), commerceOrderId, actionId);
	}

	public boolean hasPermission(String actionId) {
		return _portletResourcePermission.contains(
			_cpRequestHelper.getPermissionChecker(),
			_cpRequestHelper.getScopeGroupId(), actionId);
	}

	public boolean isCommerceSiteTypeB2C() {
		if (_commerceContext.getCommerceSiteType() ==
				CommerceAccountConstants.SITE_TYPE_B2C) {

			return true;
		}

		return false;
	}

	public boolean isOpenOrderContentPortlet() {
		String portletName = _cpRequestHelper.getPortletName();

		return portletName.equals(
			CommercePortletKeys.COMMERCE_OPEN_ORDER_CONTENT);
	}

	public boolean isShowPurchaseOrderNumber() {
		ThemeDisplay themeDisplay =
			(ThemeDisplay)_httpServletRequest.getAttribute(
				WebKeys.THEME_DISPLAY);

		try {
			CommerceOrderFieldsConfiguration commerceOrderFieldsConfiguration =
				ConfigurationProviderUtil.getConfiguration(
					CommerceOrderFieldsConfiguration.class,
					new GroupServiceSettingsLocator(
						themeDisplay.getScopeGroupId(),
						CommerceConstants.ORDER_SERVICE_NAME));

			return commerceOrderFieldsConfiguration.showPurchaseOrderNumber();
		}
		catch (PortalException pe) {
			_log.error(pe, pe);
		}

		return true;
	}

	private int _getItemsCount() throws PortalException {
		return _commerceOrderItemService.getCommerceOrderItemsCount(
			getCommerceOrderId());
	}

	private int _getItemsQuantity() throws PortalException {
		return _commerceOrderItemService.getCommerceOrderItemsQuantity(
			getCommerceOrderId());
	}

	private static final Log _log = LogFactoryUtil.getLog(
		CommerceOrderContentDisplayContext.class);

	private final CommerceAccount _commerceAccount;
	private final CommerceAddressService _commerceAddressService;
	private final CommerceChannelLocalService _commerceChannelLocalService;
	private final CommerceContext _commerceContext;
	private final CommerceOrderContentPortletInstanceConfiguration
		_commerceOrderContentPortletInstanceConfiguration;
	private final Format _commerceOrderDateFormatDateTime;
	private final CommerceOrderHelper _commerceOrderHelper;
	private final CommerceOrderItemService _commerceOrderItemService;
	private CommerceOrderNote _commerceOrderNote;
	private final long _commerceOrderNoteId;
	private final CommerceOrderNoteService _commerceOrderNoteService;
	private final CommerceOrderPriceCalculation _commerceOrderPriceCalculation;
	private List<CommerceOrder> _commerceOrders;
	private final CommerceOrderService _commerceOrderService;
	private final CommerceShipmentItemService _commerceShipmentItemService;
	private final CPRequestHelper _cpRequestHelper;
	private long _displayStyleGroupId;
	private final HttpServletRequest _httpServletRequest;
	private final ModelResourcePermission<CommerceOrder>
		_modelResourcePermission;
	private final PortletResourcePermission _portletResourcePermission;

}