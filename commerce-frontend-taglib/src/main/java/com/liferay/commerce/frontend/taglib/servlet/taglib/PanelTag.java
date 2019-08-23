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

package com.liferay.commerce.frontend.taglib.servlet.taglib;

import com.liferay.commerce.frontend.taglib.internal.servlet.ServletContextUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.taglib.util.IncludeTag;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

/**
 * @author Fabio Diego Mastrorilli
 */
public class PanelTag extends IncludeTag {

	@Override
	public int doStartTag() throws JspException {

		setAttributeNamespace(_ATTRIBUTE_NAMESPACE);

		setNamespacedAttribute(request, "spritemap", _spritemap);
		setNamespacedAttribute(request, "title", _title);
		setNamespacedAttribute(request, "headerActionUrl", _headerActionUrl);
		setNamespacedAttribute(request, "headerActionLabel", _headerActionLabel);
		setNamespacedAttribute(request, "headerActionIcon", _headerActionIcon);
		setNamespacedAttribute(request, "headerActionId", _headerActionId);
		setNamespacedAttribute(request, "showMoreRefId", _showMoreRefId);
        setNamespacedAttribute(request, "showMoreId", _showMoreId);
        setNamespacedAttribute(request, "showMoreUrl", _showMoreUrl);
		setNamespacedAttribute(request, "elementClasses", _elementClasses);

		if(_spritemap == null){

			ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
			_spritemap = themeDisplay.getPathThemeImages() + "/commerce-icons.svg";
		}

		super.doStartTag();

		return EVAL_BODY_INCLUDE;
	}

	@Override
	public int doEndTag() throws JspException {
		setAttributeNamespace(_ATTRIBUTE_NAMESPACE);

		return super.doEndTag();
	}


	@Override
	protected String getEndPage() {
		return _END_PAGE;
	}

	@Override
	protected String getStartPage() {
		return _START_PAGE;
	}

	@Override
	public void setPageContext(PageContext pageContext) {
		super.setPageContext(pageContext);

		servletContext = ServletContextUtil.getServletContext();
	}

	private static final String _END_PAGE = "/panel/end.jsp";
	private static final String _START_PAGE = "/panel/start.jsp";
	private static final String _ATTRIBUTE_NAMESPACE =
			"liferay-commerce:panel:";
	private static final Log _log = LogFactoryUtil.getLog(PanelTag.class);

	public String getTitle() {
		return _title;
	}
	public String getSpritemap() {
		return _spritemap;
	}
	public String getHeaderActionUrl() {
		return _headerActionUrl;
	}
	public String getHeaderActionLabel() {
		return _headerActionLabel;
	}
	public String getHeaderActionIcon() {
		return _headerActionIcon;
	}
	public String getHeaderActionId() {
		return _headerActionId;
	}
	public String getShowMoreRefId() {
		return _showMoreRefId;
	}
    public String getShowMoreId() {
        return _showMoreId;
    }
    public String getShowMoreUrl() {
        return _showMoreUrl;
    }
	public String getElementClasses() {
		return _elementClasses;
	}

	@Override
	protected void cleanUp() {
		super.cleanUp();

		_title = null;
		_spritemap = null;
		_headerActionUrl = null;
		_headerActionLabel = null;
		_headerActionIcon = null;
		_headerActionId = null;
		_showMoreRefId = null;
        _showMoreId = null;
        _showMoreUrl = null;
		_elementClasses = null;
	}

	private String _title= null;
	private String _spritemap = null;
	private String _headerActionUrl;
	private String _headerActionLabel;
	private String _headerActionIcon;
	private String _headerActionId;
	private String _showMoreRefId;
    private String _showMoreId;
    private String _showMoreUrl;
	private String _elementClasses;

	public void setTitle(String title) {
		_title = title;
	}
	public void setSpritemap(String spritemap) {
		_spritemap = spritemap;
	}
	public void setHeaderActionUrl(String headerActionUrl) {
		_headerActionUrl = headerActionUrl;
	}
	public void setHeaderActionLabel(String headerActionLabel) {
		_headerActionLabel = headerActionLabel;
	}
	public void setHeaderActionIcon(String headerActionIcon) {
		_headerActionIcon = headerActionIcon;
	}
	public void setHeaderActionId(String headerActionId) {
		_headerActionId = headerActionId;
	}
	public void setShowMoreRefId(String showMoreRefId) {
		_showMoreRefId = showMoreRefId;
	}
    public void setShowMoreId(String showMoreId) {
        _showMoreId = showMoreId;
    }
    public void setShowMoreUrl(String showMoreUrl) {
        _showMoreUrl = showMoreUrl;
    }
	public void setElementClasses(String elementClasses) {
		_elementClasses = elementClasses;
	}

}