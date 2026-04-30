---
trigger: model_decision
description: Activate this rule whenever the user asks to write, modify, or review unit tests, integration tests, or mock data. Also activate when the user specifically asks for performance improvements or refactoring
---

# 05 Testing, Code Generation, and Performance Rulebook

As a QA Lead and Principal Software Engineer, this document establishes the definitive, non-negotiable standards for testing, data generation, and performance optimization in the CeltaMobile codebase.

## 1. Test Coverage & Structure

- **Mandatory Test Files:** Every `datasource`, `repository`, and `controller` MUST have a corresponding test file in the `test/` directory following the identical path structure of the implementation.
- **Mandatory Function Tests:** Every public function exposed in a `datasource`, `repository`, or `controller` MUST have a dedicated, explicitly named test validating its logic, edge cases, and failure modes.

## 2. Mocking & Validation (mocktail)

- **Mocking Framework:** Prefer using `mocktail` for generating mocks and validating interactions.
- **CRITICAL - Strict Argument Validation:** Every time `verify` or `expect` is utilized from `mocktail`, you **MUST** validate all arguments being passed exactly. 
- **FORBIDDEN:** The use of `any()` or `any(named: "...")` fallback matchers is **strictly forbidden**. You must explicitly match the arguments to ensure precise test contracts.

## 3. Test Data Generation

- **Entity Factory Pattern:** When returning an entity or generating a JSON object for tests, strictly follow the `EntityFactory` pattern. If an entity factory does not exist for the required class, create a new `make` method (e.g., `newEntity`) and utilize it.
- **Model Conversion:** If a data model or JSON map is required for an API test, first generate the Entity via the factory, and then use the respective model's conversion methods (e.g., `fromEntity` or `toJson`) to produce the final test data.
- **Faker Usage:** Use the `faker` package to generate randomized variables **ONLY** when writing test code. 
- **Exception for Regional Formats:** If testing specific Brazilian formatted data (such as CPF, CNPJ, or specific phone numbers), do not use raw `faker` randomization. Instead, use explicit, valid mocked string formats to avoid validation errors in domain logic.

## 4. Performance Standards & Code Output

- **Mandatory Performance Optimization:** Every single code suggestion or refactor must be optimized for performance. You must consider widget rebuilds, memory allocation, and time complexity.
- **Explicit Explanations:** When writing or modifying code, always explain the performance improvement explicitly within brief comments.
- **Zero Filler Output:** Never include conversational filler such as "Here is the starting change", "Ending code", or generic pleasantries in the output. Provide only the required code changes and concise technical comments explaining the logic or performance optimizations.
