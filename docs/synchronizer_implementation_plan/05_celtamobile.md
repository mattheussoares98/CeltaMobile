# CeltaMobile Plan

Read this file when changing Mobile domain, data, controllers, navigation, pages, or components.

Follow the project `.agents` rules for architecture, models, UI, navigation, and tests.

## Domain and models

- [ ] Add synchronizer search-operation enum.
- [ ] Add Equatable summary entity with category/key, description, and count.
- [ ] Add base read-only detail entity preserving category/key.
- [ ] Add summary model with `fromJson`, `toJson`, `fromEntity`, and `toEntity`.
- [ ] Add detail-envelope model with all conversions.
- [ ] Add one typed detail entity/model per supported Commerce API adapter.
- [ ] Update barrel exports.
- [ ] Update shared test factories.

## Datasource and repository

- [ ] Replace GET count request with the typed POST contract.
- [ ] Remove `dynamic` from datasource interface.
- [ ] Implement typed `searchCount`.
- [ ] Implement typed `searchByKey`.
- [ ] Remove `dynamic` from repository interface.
- [ ] Map summaries in repository implementation.
- [ ] Map details in repository implementation.
- [ ] Preserve `ecRequestParamsProvider().future`.
- [ ] Update providers only as required.

## Controllers

- [ ] Type `SearchCountStateController`.
- [ ] Preserve and test reload.
- [ ] Add family controller for lazy details by category/key.
- [ ] Keep summary/detail loading states independent.
- [ ] Avoid reloading every category when one category is reopened/refreshed.

## Read-only UI

- [ ] Replace placeholder with summary shell.
- [ ] Add shared loading, empty, error, and retry states.
- [ ] Display category description and count.
- [ ] Add pull-to-refresh.
- [ ] Add detail navigation through existing `go_router` patterns.
- [ ] Add read-only detail page shell and states.
- [ ] Add one detail component per supported adapter.
- [ ] Add no mutation buttons or gestures.
- [ ] Prevent overflow for long messages/identifiers.
- [ ] Keep lists lazy.

