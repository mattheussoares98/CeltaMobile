# Scope and Mandatory Rules

Read this file before every implementation session.

## Included

- Load synchronization error categories and counts.
- Preserve the BSF category/key.
- Load errors lazily for a selected category.
- Display read-only summaries and category-specific details.
- Include synchronizer task-execution errors; they are errors, not schedule configuration.

The read flow must match the ERP UI:

1. Call `SearchCount`.
2. Display categories with errors.
3. Call `SearchByKey` only when a category is opened.

## Excluded

- BSF changes.
- Marking, correcting, approving, ignoring, resending, or reprocessing errors.
- Synchronizer URL or enterprise configuration.
- Schedule frequency, execution times, or other schedule configuration.
- Synchronizer server configuration or management.

Treating errors will require a later plan, one category and operation at a time.

## Mandatory agent rules

1. Read `README.md` and this file first.
2. Read only the routed plan file for the current step.
3. Work on one unchecked step at a time.
4. Keep changes small; do not combine several checklist items.
5. Update the relevant plan file before changing implementation scope or design.
6. After implementation and validation, immediately mark the step `[x]` and record its result.
7. Never mark a step complete before its stated validation succeeds.
8. Leave partial or blocked work unchecked and record its state.
9. Add discovered work as a new small step instead of silently expanding another step.
10. Do not begin mutation behavior while read-only work remains incomplete.
11. Do not change BSF.
12. Before creating any enum or shared contract in Commerce API or CeltaMobile, search BSF first. If BSF already defines the same concept, reuse the BSF type and do not duplicate it.
13. Do not run `build_runner`.
14. Do not run Git commands without explicit authorization for the current task.
15. Do not create or add unit tests for the ECommerce API project; validate its changes with the required Release builds.

## Completion boundaries

The module is complete only when:

- Commerce API uses existing BSF BLL methods.
- Enterprise/resource authorization is enforced.
- Every displayed error retains its category/key.
- CeltaMobile synchronizer contracts contain no `dynamic`.
- Summary and details reproduce ERP UI read behavior.
- No schedule/configuration management or error mutation is exposed.
- Required builds, analysis, tests, and manual validation succeed.
