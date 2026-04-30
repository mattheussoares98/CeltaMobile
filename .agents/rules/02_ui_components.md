---
trigger: model_decision
description: Activate this rule whenever the user asks to create, modify, style, or review any Flutter UI components, widgets, screens, pages, or dialogs. This contains the required shared widgets, spacing/padding constants (Gaps), and theming rules
---

UI Components Rulebook

This document defines the strict rules for creating, modifying, and styling Flutter UI components within the CeltaMobile application.

## 1. File Path Header and Imports (Barrel Files)
Do not use the exact widget file path at the top of the file. Instead, write the path of the nearest barrel file (e.g., `components.dart`) that exports the widget. Similarly, when importing widgets from a folder, always prefer to import its barrel file to gain access to all related widgets simultaneously.
```dart
// lib/features/sale_request/presentation/pages/components/components.dart
import 'package:flutter/material.dart';
...

## 2. Reusability of Common Widgets

**Prioritize reusing existing common widgets over creating new ones.** Check the `lib/commom_widgets` directory before building custom UI elements.

Key reusable widgets include:
- **Buttons**: `PrimaryButton`, `PrimaryTextButton`, `ActionTextButton`, `DefaultPaginationButtons`
- **Inputs & Controls**: `DefaultDropDown`, `DefaultSimpleDropDown`, `DefaultCheckBox`, `DefaultSwitch`, `DefaultChoiceChip`, `DefaultSegmentedButtons`
- **Layout & Structure**: `ResponsiveCenter`, `ResponsiveListFlow`, `ResponsiveScrollableWidget`, `TitleAndSubtitle`
- **Feedback & States**: `LoadingWidget` (and `LoadingExtension`), `EmptyPlaceholderWidget`, `AsyncValueWidget`
- **Dialogs & Overlays**: `AlertDialogs`, `ShowSnackBarMessage`, `ShowModalPage`
- **Icons**: `PlatformIcon`

## 3. Strict Real Data Requirement

**Never use `faker` or mock data when generating UI widgets.** 
Always use real variable structures, passing the proper domain entities or UI state models to the widgets. Mocking UI state with fake values is strictly forbidden.

## 4. Padding and Spacing (Gap Pattern)

Always use the standard spacing constants defined in `lib/constants/app_sizes.dart`. Never use hardcoded pixel values (e.g., `SizedBox(height: 16)`) or raw `EdgeInsets.all(16)`.

### Sizes
Use the `Sizes` class for padding values (`EdgeInsets`):
- `Sizes.p4` (4.0)
- `Sizes.p8` (8.0)
- `Sizes.p12` (12.0)
- `Sizes.p16` (16.0)
- `Sizes.p20` (20.0)
- `Sizes.p24` (24.0)
- `Sizes.p32` (32.0)
- ... up to `Sizes.p120`

### Gaps (Box/Flex Layouts)
Use the predefined `SizedBox` constants for spacing between widgets in `Row` or `Column` layouts:
- **Width**: `gapW4`, `gapW8`, `gapW12`, `gapW16`, `gapW24`, `gapW32`, etc.
- **Height**: `gapH4`, `gapH8`, `gapH12`, `gapH16`, `gapH24`, `gapH32`, etc.

### Sliver Gaps (CustomScrollView)
Use the predefined `SliverToBoxAdapter` constants for spacing inside slivers:
- **Width**: `gapSliverW4`, `gapSliverW8`, `gapSliverW16`, etc.
- **Height**: `gapSliverH4`, `gapSliverH8`, `gapSliverH16`, etc.

**Example Implementation:**
```dart
Column(
  children: [
    Text('First Item'),
    gapH16, // Correct spacing
    Text('Second Item'),
  ],
)
```

## 5. Typography and Theme

- **Localization:** All widget texts should end with `.hardcoded`.

The application theme is defined in `lib/core/presentation/theme/app_theme.dart`.

- **Colors**: Rely on `Theme.of(context).colorScheme` or specific theme colors:
  - `Theme.of(context).primaryColor` (Green base)
  - `Theme.of(context).disabledColor` (Grey base)
  - `Theme.of(context).scaffoldBackgroundColor` (White)
  - **Avoid hardcoding specific Hex or RGB colors.**

- **Typography**: The text theme modifies `titleLarge`, `titleMedium`, and `titleSmall` to use `FontWeight.bold`. Use standard Material typography styles by accessing `Theme.of(context).textTheme`.

```dart
Text(
  'Header',
  style: Theme.of(context).textTheme.titleLarge,
)
```

## 6. Other Rules
- When a file exceeds 100 lines, extract parts of the UI into separate component files inside the `components` folder.
- Extracted components should read providers directly (e.g., via `ref.watch` or `ref.read`) instead of receiving values through constructor parameters to avoid prop drilling.
- Follow the exact folder and file organization pattern used in `BuyRequestPage`.
- **Controller & Focus Node Initialization:** Never use the `late` keyword for `TextEditingController`, `FocusNode`, or similar UI controllers unless the initial value explicitly depends on a `widget.` property. Always initialize them directly inline (e.g., `final _controller = TextEditingController();`). Ensure they are still properly disposed of in the `dispose()` method.