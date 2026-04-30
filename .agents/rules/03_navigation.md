---
trigger: model_decision
description: Activate this rule whenever the user asks to create a new screen, modify the router, handle deep linking, pass data between pages, or display dialogs/bottom sheets
---

Navigation and Routing Rulebook

This document defines the strict patterns used for navigation, routing, and overlay management within the CeltaMobile application. Do not invent new paradigms; use the established patterns documented here.

## 1. Routing Package and Core Setup

- **Package:** The application uses **`go_router`** for declarative routing, deeply integrated with **Riverpod** for state-based redirection.
- **Router Configuration:** The central router configuration is found in `lib/routing/app_router.dart`, managed by a `@Riverpod` provider (`goRouter`). This provider handles authentication redirects, splash screen logic, and dynamic refresh listeners via custom `Bridge` classes.
- **Route Names:** All route names must be registered in the `Routes` enum located at `lib/routing/routes.dart`. Never use raw string names for routing definitions or `context.goNamed()` calls.
Strict Prohibition: Never use Navigator.push(), Navigator.pop(), or Navigator.pushReplacement(). You must exclusively use context.pushNamed(), context.goNamed(), and context.pop() provided by the go_router package

## 2. Registering New Routes

Routes are kept highly modular. Instead of a massive monolithic router array, each route is defined in its own file inside the `lib/routing/routes/` directory (often grouped by feature, e.g., `lib/routing/routes/sale_request/`).

**Required Syntax for Sub-routes:**
Create a top-level function that returns a `RouteBase` (usually a `GoRoute`). If the route can have children, it must accept a `List<RouteBase> routes` parameter.

```dart
// lib/routing/routes/my_feature/my_feature_route.dart
import 'package:go_router/go_router.dart';
import '../../routing.dart'; // To access the Routes enum
import '../../../features/my_feature/presentation/pages/pages.dart';

RouteBase myFeatureRoute(List<RouteBase> routes) => GoRoute(
  path: 'my-feature', // Use absolute path '/' only for root routes
  name: Routes.myFeature.name,
  builder: (context, state) => const MyFeaturePage(),
  routes: routes,
);
```

These functions are then assembled hierarchically inside `app_router.dart`.

## 3. Passing Data Between Screens

**Path Parameters for IDs:**
Use path parameters (`state.pathParameters`) to pass simple data like entity IDs (`enterpriseCode`, `customerCode`). Always parse them safely.
```dart
path: ':enterpriseCode/details/:itemId',
builder: (context, state) {
  final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
  final itemId = int.parse(state.pathParameters['itemId']!);
  return DetailsPage(enterpriseCode: enterpriseCode, itemId: itemId);
}
```

**`extra` for Complex Objects:**
Do not pass complex objects (like `Entity` classes) via query strings. Use the `state.extra` property, typically casting it to a `Map<String, dynamic>` to pass multiple complex objects.
```dart
builder: (context, state) {
  final extraMap = state.extra as Map<String, dynamic>;
  final product = extraMap['product'] as ProductEntity;
  
  return InsertProductPage(product: product);
}
```
When navigating, pass the map:
```dart
context.pushNamed(
  Routes.insertProduct.name,
  extra: {'product': myProductEntity},
);
```

- **Strict Prohibition:** Never use `Navigator.push()`, `Navigator.pop()`, or `Navigator.pushReplacement()`. You must exclusively use `context.pushNamed()`, `context.goNamed()`, and `context.pop()` provided by the `go_router` package.

## 4. Dialogs, Bottom Sheets, and Overlays

Dialogs and bottom sheets are **not** tied to `go_router` pages or URL paths. They are managed via standard Flutter imperative navigation (`showDialog`, `showModalBottomSheet`), but must use the predefined wrapper functions in `lib/commom_widgets`.

- **Bottom Sheets / Modal Pages:** Use `showModalPage(Widget body, BuildContext context)` from `lib/commom_widgets/show_modal_page.dart`. This ensures a uniform, platform-aware, draggable bottom sheet that acts as a modal screen.
- **Alert Dialogs:** Use `showAlertDialog(...)` or `showExceptionAlertDialog(...)` from `lib/commom_widgets/alert_dialogs.dart`. These use `AlertDialog.adaptive` to automatically provide Cupertino or Material styling based on the platform.

To dismiss these overlays, use standard `context.pop()`
