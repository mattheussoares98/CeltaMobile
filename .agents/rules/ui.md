---
trigger: model_decision
description: Rules for Flutter UI, widgets, and styling
---

- All widget texts should end with `.hardcoded`.
- Create performant widgets by using the `const` keyword as much as possible.
- Follow the same folder and file organization pattern used in `BuyRequestPage`.
- If a feature has more than one page, create a separate folder for each page.
- Each page should contain a folder called `components` for page-specific components to prevent the page file from becoming too large. Only create this folder if there is an actual component to extract (don't create empty files).
- If a component is used in more than one page, move it to a shared `components` folder to avoid repeating code.
- Before using a widget, check if a default version already exists in the `common_widgets` path (e.g., `DefaultTextFormField`, `PrimaryButton`, etc.).
- When using an icon, always use `PlatformIcon` from the `common_widgets` path.
- When a file exceeds 100 lines, extract parts of the UI into separate component files inside the `components` folder, and import them.
- Extracted components should read providers directly (e.g., via `ref.watch` or `ref.read`) instead of receiving the values through constructor parameters, to avoid prop drilling.