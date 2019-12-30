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

<%@ include file="/side_panel_content/init.jsp" %>

<aui:script require="commerce-frontend-js/utilities/iframes.es as iframesUtils">
	iframesUtils.initializeIframeListeners();
</aui:script>

<div class="side-panel-iframe-wrapper">
	<c:if test="<%= Validator.isNotNull(title) %>">
		<header class="side-panel-iframe-header">
			<h2 class="title"><%= title %></h2>
		</header>
	</c:if>

	<div class="side-panel-iframe-content">