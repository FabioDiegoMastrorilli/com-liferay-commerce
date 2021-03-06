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

package com.liferay.commerce.openapi.util.importer;

import com.fasterxml.jackson.databind.JsonNode;

import com.liferay.commerce.openapi.util.OpenApiComponent;
import com.liferay.commerce.openapi.util.OpenApiProperty;
import com.liferay.commerce.openapi.util.util.GetterUtil;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Igor Beslic
 */
public class ComponentImporter {

	public List<OpenApiComponent> getComponents(JsonNode componentsJSONNode) {
		List<OpenApiComponent> components = new ArrayList<>();

		if (componentsJSONNode.has("schemas")) {
			components.addAll(_getSchemas(componentsJSONNode));
		}

		if (componentsJSONNode.has("parameters")) {
			components.addAll(_getParameters(componentsJSONNode));
		}

		return components;
	}

	private OpenApiComponent _getOpenApiComponent(
		String name, JsonNode schemaEntryJSONNode) {

		String type = GetterUtil.getAsText(
			"type", schemaEntryJSONNode, "object");

		String itemsReference = null;

		if ("array".equals(type)) {
			JsonNode itemsJSONNode = schemaEntryJSONNode.get("items");

			if (itemsJSONNode.has("$ref")) {
				JsonNode referenceJSONNode = itemsJSONNode.get("$ref");

				itemsReference = referenceJSONNode.asText();
			}
		}
		else if (schemaEntryJSONNode.has("additionalProperties")) {
			JsonNode additionalPropertiesJSONNode = schemaEntryJSONNode.get(
				"additionalProperties");

			if (additionalPropertiesJSONNode.has("$ref")) {
				JsonNode referenceJSONNode = additionalPropertiesJSONNode.get(
					"$ref");

				itemsReference = referenceJSONNode.asText();
			}

			type = "dictionary";
		}

		return new OpenApiComponent(
			name, _getPropertyDefinitions(schemaEntryJSONNode), type,
			itemsReference);
	}

	private List<OpenApiComponent> _getParameters(JsonNode componentsJSONNode) {
		List<OpenApiComponent> components = new ArrayList<>();

		JsonNode parametersJSONNode = componentsJSONNode.get("parameters");

		Iterator<Map.Entry<String, JsonNode>> fields =
			parametersJSONNode.fields();

		while (fields.hasNext()) {
			Map.Entry<String, JsonNode> parameterField = fields.next();

			OpenApiComponent openApiComponent = new OpenApiComponent(
				parameterField.getKey(),
				ParameterImporter.fromJSONNode(parameterField.getValue()));

			components.add(openApiComponent);

			_logger.debug("Resolved parameter {}", openApiComponent);
		}

		return components;
	}

	private List<OpenApiProperty> _getPropertyDefinitions(
		JsonNode schemaEntryJSONNode) {

		List<OpenApiProperty> openApiProperties = new ArrayList<>();

		List<String> requiredProperties = new ArrayList<>();

		if (schemaEntryJSONNode.has("required")) {
			requiredProperties.addAll(
				GetterUtil.getAsTextList(schemaEntryJSONNode.get("required")));
		}

		if (schemaEntryJSONNode.has("properties")) {
			JsonNode propertiesJSONNode = schemaEntryJSONNode.get("properties");

			Iterator<Map.Entry<String, JsonNode>> fields =
				propertiesJSONNode.fields();

			while (fields.hasNext()) {
				Map.Entry<String, JsonNode> propertyEntry = fields.next();

				String name = propertyEntry.getKey();

				JsonNode propertyJSONNode = propertyEntry.getValue();

				OpenApiProperty.OpenApiPropertyBuilder openApiPropertyBuilder =
					new OpenApiProperty.OpenApiPropertyBuilder();

				openApiPropertyBuilder.name(name);

				String openApiTypeDefinition = GetterUtil.getAsText(
					"type", propertyJSONNode, "object");

				openApiPropertyBuilder.openApiTypeDefinition(
					openApiTypeDefinition);

				_setIfHas(
					propertyJSONNode, "example",
					openApiPropertyBuilder :: example);
				_setIfHas(
					propertyJSONNode, "format",
					openApiPropertyBuilder :: openApiFormatDefinition);

				if (propertyJSONNode.has("items")) {
					JsonNode itemsJSONNode = propertyJSONNode.get("items");

					_setIfHas(
						itemsJSONNode, "type",
						openApiPropertyBuilder :: itemOpenApiTypeDefinition);
					_setIfHas(
						itemsJSONNode, "format",
						openApiPropertyBuilder ::itemOpenApiFormatDefinition);
					_setIfHas(
						itemsJSONNode, "$ref",
						openApiPropertyBuilder :: componentReference);
				}

				_setIfHas(
					propertyJSONNode, "$ref",
					openApiPropertyBuilder :: componentReference);

				if (requiredProperties.contains(name)) {
					openApiPropertyBuilder.required(true);
				}

				if ("object".equals(openApiTypeDefinition)) {
					OpenApiComponent openApiComponent = _getOpenApiComponent(
						propertyEntry.getKey(), propertyJSONNode);

					if (openApiComponent.isDictionary()) {
						openApiPropertyBuilder.openApiTypeDefinition(
							"dictionary");
						openApiPropertyBuilder.componentReference(
							openApiComponent.getItemsReference());
					}

					_logger.warn("Detected nested object {}", openApiComponent);
				}

				openApiProperties.add(openApiPropertyBuilder.build());
			}
		}

		return openApiProperties;
	}

	private List<OpenApiComponent> _getSchemas(JsonNode componentsJSONNode) {
		List<OpenApiComponent> components = new ArrayList<>();

		JsonNode schemasJSONNode = componentsJSONNode.get("schemas");

		Iterator<Map.Entry<String, JsonNode>> schemaFields =
			schemasJSONNode.fields();

		while (schemaFields.hasNext()) {
			Map.Entry<String, JsonNode> schemaEntry = schemaFields.next();

			OpenApiComponent openApiComponent = _getOpenApiComponent(
				schemaEntry.getKey(), schemaEntry.getValue());

			components.add(openApiComponent);

			_logger.debug("Resolved schema {}", openApiComponent);
		}

		return components;
	}

	private void _setIfHas(
		JsonNode jsonNode, String name, Consumer<String> setter) {

		if (!jsonNode.has(name)) {
			return;
		}

		JsonNode valueJSONNOde = jsonNode.get(name);

		setter.accept(valueJSONNOde.asText());
	}

	private static final Logger _logger = LoggerFactory.getLogger(
		ComponentImporter.class);

}