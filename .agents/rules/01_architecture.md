---
trigger: always_on
---

Architecture Rulebook

This document outlines the definitive structural patterns and architecture of the CeltaMobile application. All future development **must** strictly adhere to these patterns. Do not invent new architectural patterns; use the established ones documented here.

## 1. Overall Folder Structure

The project follows a **Feature-First (Domain-Driven)** architecture combined with **Clean Architecture** principles within each feature and core module.

```text
lib/
├── commom_widgets/   # Reusable, generic UI widgets not tied to a specific feature.
├── constants/        # Global constants.
├── core/             # Shared resources, base classes, and core infrastructure.
│   ├── data/
│   ├── domain/
│   ├── infraestructure/
│   ├── presentation/
│   └── ...
├── exceptions/       # Custom application exceptions.
├── features/         # Main application features (bounded contexts).
│   ├── auth/
│   ├── sale_request/
│   └── ...           # (See Feature Internal Structure below)
├── localization/     # i18n/l10n logic.
├── routing/          # Application routing configuration (go_router).
└── utils/            # Helpers, formatters, and utility functions.
```

## 2. Feature Internal Structure (Clean Architecture)

Inside `lib/features/[feature_name]/`, the code is strictly separated into three main layers: `data`, `domain`, and `presentation`, plus dependency injection.

```text
[feature_name]/
├── data/
│   ├── datasource/   # Interfaces (i_*.dart) and implementations for data access (API, Local DB, SOAP).
│   └── models/       # Data Transfer Objects (DTOs) and data-layer specific parsing models.
├── domain/
│   ├── entities/     # Core business objects and strictly domain-level data structures.
│   └── repository/   # Repository interfaces (i_*.dart) and their implementations (*_impl.dart) that orchestrate datasources.
├── presentation/
│   ├── controllers/  # Riverpod state controllers managing UI state and business logic execution.
│   ├── models/       # UI-specific state models (e.g., Form states) kept separate from domain entities.
│   └── pages/        # Flutter Widgets, screens, and internal UI components.
├── providers.dart    # Riverpod Dependency Injection for the feature (Datasources, Repositories).
└── providers.g.dart  # Generated Riverpod file.
```

## 3. Layer Separation Rules

- **Domain Layer:** Must be completely independent of Flutter and external libraries (like HTTP packages or Hive). It contains pure Dart code, `entities`, and abstract repository interfaces (`contracts`).
- **Data Layer:** Depends on the Domain layer (to implement repository interfaces and map models to entities). It handles all external communication (HTTP adapters, local storage, SOAP).
- **Presentation Layer:** Depends on the Domain layer (for entities and use cases/controllers) and Flutter. It must **never** directly access the Data layer (datasources). All data access must flow through controllers and repositories.

## 4. State Management and Dependency Injection

**Riverpod Performance Rules:**
- When a component only needs a specific property from a state, use `.select()` to avoid listening to unnecessary changes.
- Use a `Consumer` widget to watch a specific provider instead of watching a value inside the root build method to avoid rebuilding the entire page.
- When using `AsyncValueWidget` and its `tryAgain` constructor, only call `ref.invalidate` if the data is being loaded inside the provider's build method.
The project strictly uses **Riverpod** with code generation (`riverpod_annotation`).

### Dependency Injection
- Defined in `providers.dart` at the root of each feature or in `core/providers/`.
- Uses `@riverpod` annotations to expose instances of Datasources and Repositories.
- Example pattern:
  ```dart
  @riverpod
  IMyFeatureDatasource myFeatureDatasource(Ref ref) {
    return MyFeatureDatasourceImpl(ref.watch(httpClientProvider));
  }

  @riverpod
  IMyFeatureRepository myFeatureRepository(Ref ref) {
    return MyFeatureRepositoryImpl(ref.watch(myFeatureDatasourceProvider));
  }
  ```

### State Management (Controllers)
- Located in `presentation/controllers/`.
- Must be implemented using `@riverpod` annotations (generating `AsyncNotifier`, `Notifier`, etc.).
- The UI listens to these controllers to react to state changes. Controllers orchestrate the logic by calling Repositories and updating their internal `state`.
- **UI State Models**: For complex forms or screens, use dedicated UI State models inside `presentation/models/`. These models should be immutable (using `Equatable` and `copyWith` methods) and distinct from Domain entities. The controller will emit new instances of these UI state models.

### Example Controller Pattern
```dart
@riverpod
class MyFeatureStateController extends _$MyFeatureStateController {
  @override
  FutureOr<MyFeatureEntity> build({required int paramId}) async {
    // Initial fetch or state setup
  }

  void updateSomeField(String newValue) {
    if (state is! AsyncData<MyFeatureEntity>) return;
    final current = state.value!;
    state = AsyncData(current.copyWith(field: newValue));
  }
}
```

## 5. UI and Widget Architecture
- **Pages:** Top-level screens are located in `presentation/pages/`.
- **Components:** Sub-widgets and complex UI parts specific to a page should be extracted into a `components/` sub-folder within the respective page's directory to keep the main page file clean.
- Controllers should manage the business logic and state for these components, minimizing `StatefulWidget` usage where Riverpod controllers can cleanly handle the state.
- Always use `const` constructors for widgets whenever possible to optimize the Flutter build tree and avoid unnecessary rebuilds.

- **Absolute Package Imports:** Do not use relative imports (e.g., `../..`). Always use absolute paths starting with `package:celta_mobile/` (or your actual package name). This ensures consistency and prevents depth calculation errors.
- **Barrel File Pattern:** Every major folder (e.g., `entities/`, `controllers/`, `models/`) must contain a "barrel file" with the exact same name as the folder (e.g., `entities.dart`). This file must `export` all relevant files within that directory.
- **Import Strategy:** When importing, you must target the barrel file rather than individual files.
    - **Correct:** `import 'package:celta_mobile/features/auth/domain/entities/entities.dart';`
    - **Incorrect:** `import 'package:celta_mobile/features/auth/domain/entities/user_entity.dart';`
- **File Paths:** When providing code, always specify the full project path at the top of the file to maintain structural clarity.