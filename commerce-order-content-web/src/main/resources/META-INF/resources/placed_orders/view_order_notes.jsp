<%@ page import="com.liferay.frontend.taglib.clay.servlet.taglib.util.DropdownItem" %><%--
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

	List<DropdownItem> dropdownItems = new ArrayList<>();
	DropdownItem dropdownItem_1 = new DropdownItem();
	dropdownItem_1.setIcon("edit");
	dropdownItem_1.setHref("#");
	dropdownItem_1.setLabel("edit");
	DropdownItem dropdownItem_2 = new DropdownItem();
	dropdownItem_2.setIcon("delete");
	dropdownItem_2.setHref("#");
	dropdownItem_2.setLabel("delete");

	dropdownItems.add(dropdownItem_1);
	dropdownItems.add(dropdownItem_2);

%>
<h2 class="iframe-title pl-3 pr-5 py-2 border-bottom">
    <liferay-ui:message arguments="<%= commerceOrderContentDisplayContext.getCommerceOrderNotesCount(commerceOrder) %>" key="x-comments" />
</h2>

<div class="container mt-4">
	<div class="order-comment mb-5">
		<div class="row">
			<div class="col">
				<span class="sticker sticker-lg sticker-user-icon">
					<span class="sticker-overlay">
						<img
								alt="thumbnail"
								class="sticker-img"
								src="https://via.placeholder.com/40"
						/>
					</span>
				</span>
				<clay:link href="#" label="Ryan Connoly" title="Ryan Connoly" />
			</div>
			<div class="col align-items-center col-auto d-flex">
				<span class="text-muted">2 days ago</span>
			</div>
			<div class="col-auto">
				<clay:dropdown-menu
					triggerCssClasses="btn-monospaced"
					buttonType="button"
					dropdownItems="<%= dropdownItems %>"
					icon="ellipsis-v"
				/>
			</div>
		</div>
		<div class="mt-2">
			Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
		</div>
	</div>

	<div class="order-comment mb-5">
		<div class="row">
			<div class="col">
				<span class="sticker sticker-lg sticker-user-icon">
					<span class="sticker-overlay">
						<img
								alt="thumbnail"
								class="sticker-img"
								src="https://via.placeholder.com/40"
						/>
					</span>
				</span>
				<clay:link href="#" label="Andrea Censi" title="Andrea Censi" />
			</div>
			<div class="col align-items-center col-auto d-flex">
				<span class="text-muted">1 day ago</span>
			</div>
			<div class="col-auto">
				<clay:dropdown-menu
						triggerCssClasses="btn-monospaced"
						buttonType="button"
						dropdownItems="<%= dropdownItems %>"
						icon="ellipsis-v"
				/>
			</div>
		</div>
		<div class="mt-2">
			Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
		</div>
	</div>

	<div class="order-comment mb-5">
		<div class="row">
			<div class="col">
				<span class="sticker sticker-lg sticker-user-icon">
					<span class="sticker-overlay">
						<img
								alt="thumbnail"
								class="sticker-img"
								src="https://via.placeholder.com/40"
						/>
					</span>
				</span>
				<clay:link href="#" label="Ryan Connoly" title="Ryan Connoly" />
			</div>
			<div class="col align-items-center col-auto d-flex">
				<span class="text-muted">5 hours ago</span>
			</div>
			<div class="col-auto">
				<clay:dropdown-menu
						triggerCssClasses="btn-monospaced"
						buttonType="button"
						dropdownItems="<%= dropdownItems %>"
						icon="ellipsis-v"
				/>
			</div>
		</div>
		<div class="mt-2">
			Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula.
		</div>
	</div>
</div>

<div class="bottom-fixed-input">
    <div class="form-group">
        <div class="input-group">
            <div class="input-group-item input-group-prepend">
                <input
                    aria-label="Leave a comment..."
                    class="form-control"
                    placeholder="Leave a comment..."
                    type="text"
                />
            </div>
            <span
                class="input-group-append input-group-item input-group-item-shrink"
            >
			<button class="btn btn-secondary" type="button">Submit</button>
		</span>
        </div>
    </div>
</div>

<div class="taglib-discussion">

	<%
	Format dateFormatDateTime = FastDateFormatFactoryUtil.getDateTime(locale, timeZone);

	for (CommerceOrderNote commerceOrderNote : commerceOrderContentDisplayContext.getCommerceOrderNotes(commerceOrder)) {
	%>

		<article class="commerce-panel">
			<div class="commerce-panel__content">
				<div class="panel-body">
					<div class="card-row">
						<div class="card-col-content">
							<div class="lfr-discussion-details">
								<liferay-ui:user-portrait
									cssClass="user-icon-lg"
									userId="<%= commerceOrderNote.getUserId() %>"
									userName="<%= commerceOrderNote.getUserName() %>"
								/>
							</div>

							<div class="lfr-discussion-body">
								<div class="lfr-discussion-message">
									<header class="lfr-discussion-message-author">

										<%
										User noteUser = commerceOrderNote.getUser();
										%>

										<aui:a cssClass="author-link" href="<%= ((noteUser != null) && noteUser.isActive()) ? noteUser.getDisplayURL(themeDisplay) : null %>">
											<%= HtmlUtil.escape(commerceOrderNote.getUserName()) %>

											<c:if test="<%= commerceOrderNote.getUserId() == user.getUserId() %>">
												(<liferay-ui:message key="you" />)
											</c:if>
										</aui:a>

										<c:if test="<%= commerceOrderNote.isRestricted() %>">
											<aui:icon image="lock" markupView="lexicon" message="private" />
										</c:if>

										<%
										Date createDate = commerceOrderNote.getCreateDate();

										String createDateDescription = LanguageUtil.getTimeDescription(request, System.currentTimeMillis() - createDate.getTime(), true);
										%>

										<span class="small">
											<liferay-ui:message arguments="<%= createDateDescription %>" key="x-ago" translateArguments="<%= false %>" />

											<c:if test="<%= createDate.before(commerceOrderNote.getModifiedDate()) %>">
												<strong onmouseover="Liferay.Portal.ToolTip.show(this, '<%= HtmlUtil.escapeJS(dateFormatDateTime.format(commerceOrderNote.getModifiedDate())) %>');">
													- <liferay-ui:message key="edited" />
												</strong>
											</c:if>
										</span>
									</header>

									<div class="lfr-discussion-message-body">
										<%= HtmlUtil.escape(commerceOrderNote.getContent()) %>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</article>

	<%
	}
	%>

</div>