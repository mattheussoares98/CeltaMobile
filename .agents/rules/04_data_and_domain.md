---
trigger: model_decision
description: Activate this rule whenever the user asks to create or modify data models, domain entities, datasources, repositories, or when handling API requests and JSON serialization
---

# 04 Data and Domain Layer Rulebook

As a Principal Software Engineer, this document establishes the strict, non-negotiable architectural conventions and data mapping rules for the Domain and Data layers in the CeltaMobile application.

## 1. Barrel Files and Imports

- **Mandatory Exporters:** Every directory must contain a `.dart` barrel file with the exact same name as the directory. This file must export all files and subdirectories contained within that path.
- **Import Rules:** Every import statement across the application MUST reference these exporter barrel files rather than targeting specific files deep within the tree.
- **Automatic Resolution:** Always check and fix broken relative imports automatically to adhere to the barrel file convention.

## 2. Entities (Domain Layer)

- **Naming Convention:** Entity class names must end with `Entity`, and their respective files must be named `_entity.dart`.
- **ERP Prefix Requirement:** Every new entity generated from an ERP model MUST be prefixed with `BSF` (e.g., `BSFCustomerEntity`).
- **Immutability and Comparison:** Entities must extend `Equatable` to ensure value equality. Every property defined in the entity must be included inside the overridden `props` list.

## 3. Models (Data Layer)

- **ERP Prefix Requirement:** Just like Entities, any Model generated from an ERP object MUST be prefixed with `BSF` (e.g., `BSFSaleRequestModel`).
- **Naming Convention:** Model class names must end with `Model`, and their respective files must be named `_model.dart`.
- **Mandatory Methods:** Every data model must implement the following four methods to handle serialization and domain mapping safely:
  1. `fromJson`
  2. `toJson`
  3. `fromEntity`
  4. `toEntity`

## 4. Datasources and Repositories

- **Interface Naming:** Abstract contracts (interfaces) for both datasources and repositories must start with the prefix `I` (e.g., `ILocalLoadProductsDatasource`, `IProductRepository`).
- **Implementation Naming:** 
  - Datasource implementations must use the exact name of the interface, stripping the leading `I` (e.g., `LocalLoadProductsDatasource`).
  - Repository implementations must strip the leading `I` and append `Impl` at the end (e.g., `ProductRepositoryImpl`).
- **Dependency Injection Constraint:** Repositories must explicitly receive their dependencies (the abstract datasource) via their constructor. Do not instantiate datasources inside repositories.

## 5. Ec Datasource HTTP Pattern

If a datasource class name starts with the `Ec` prefix (e.g., `EcSaleRequestsDatasource`), it MUST strictly adhere to the following HTTP request execution pattern for every method:

1. **Parameter Requirement:** The method signature must require an `EcRequestParams params` parameter.
2. **URL Construction:** The endpoint URL must be dynamically constructed utilizing the parameter's working URL property.
   - Example: `url: '${params.workingUrl}/api/EndpointName'`
3. **Header Injection:** HTTP headers must be passed using the params object.
   - Example: `headers: params.toHeaders()`
4. **Body Construction:** When submitting a body payload (POST/PUT), the request body must spread the `params.toMap()` alongside any other necessary variables.
   - Example: `body: { ...params.toMap(), 'myVariable': myVariable }`
