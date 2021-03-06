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

package com.liferay.commerce.openapi.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Igor Beslic
 * @author Ivica Cardic
 */
public class OpenApiComponent {

	public static OpenApiComponent asComponentTypeArray(
		OpenApiComponent openApiComponent, String itemsReference) {

		return new OpenApiComponent(
			openApiComponent._name, openApiComponent._openApiProperties,
			"array", itemsReference);
	}

	public OpenApiComponent(
		String name, List<OpenApiProperty> openApiProperties, String type,
		String itemsReference) {

		_name = name;
		_parameter = null;
		_openApiProperties = new ArrayList<>(openApiProperties);

		ComponentType componentType = ComponentType.OBJECT;

		if (type != null) {
			if (type.equals("array")) {
				componentType = ComponentType.ARRAY;
			}
			else if (type.equals("dictionary")) {
				componentType = ComponentType.DICTIONARY;
			}
		}

		_componentType = componentType;

		_itemsReference = itemsReference;

		if (_itemsReference != null) {
			Matcher matcher = _itemsReferenceModelPattern.matcher(
				_itemsReference);

			if (matcher.find()) {
				_itemsReferencedModel = matcher.group(2);
			}
		}
	}

	public OpenApiComponent(String name, Parameter parameter) {
		_name = name;
		_parameter = parameter;
		_componentType = ComponentType.PARAMETER;
		_openApiProperties = Collections.emptyList();
	}

	public String getItemsReference() {
		return _itemsReference;
	}

	public String getItemsReferencedModel() {
		return _itemsReferencedModel;
	}

	public String getName() {
		return _name;
	}

	public List<OpenApiProperty> getOpenApiProperties() {
		return new ArrayList<>(_openApiProperties);
	}

	public Parameter getParameter() {
		return _parameter;
	}

	public boolean isArray() {
		if (_componentType == ComponentType.ARRAY) {
			return true;
		}

		return false;
	}

	public boolean isDictionary() {
		if (_componentType == ComponentType.DICTIONARY) {
			return true;
		}

		return false;
	}

	public boolean isObject() {
		if (_componentType == ComponentType.OBJECT) {
			return true;
		}

		return false;
	}

	public boolean isParameter() {
		if (_componentType == ComponentType.PARAMETER) {
			return true;
		}

		return false;
	}

	@Override
	public String toString() {
		if (_toString != null) {
			return _toString;
		}

		StringBuilder sb = new StringBuilder();

		sb.append("{name=");
		sb.append(_name);
		sb.append(", propertyDefinitions={");

		Iterator<OpenApiProperty> iterator = _openApiProperties.iterator();

		while (iterator.hasNext()) {
			sb.append(iterator.next());

			if (iterator.hasNext()) {
				sb.append(",");
			}
		}

		sb.append("}");
		sb.append(", componentType=");
		sb.append(_componentType);
		sb.append(", itemsReference=");
		sb.append(_itemsReference);
		sb.append(", itemsReferencedModel=");
		sb.append(_itemsReferencedModel);
		sb.append("}");

		_toString = sb.toString();

		return _toString;
	}

	public enum ComponentType {

		ARRAY, DICTIONARY, OBJECT, PARAMETER

	}

	private static final Pattern _itemsReferenceModelPattern = Pattern.compile(
		"^#/?(\\w+/)+(\\w+)$");

	private final ComponentType _componentType;
	private String _itemsReference;
	private String _itemsReferencedModel;
	private final String _name;
	private final List<OpenApiProperty> _openApiProperties;
	private final Parameter _parameter;
	private String _toString;

}