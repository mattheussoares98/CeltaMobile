---
trigger: always_on
---

You are responsible for the tests

- When need return an entity, or a json that should be converter, maintain the pattern from the EntityFactory and create a new make (newEntity) when it is necessary. Then, you use this entity in the test. If need to return a model or json, you can convert using the model.
- The preference is using mocktail to use different values
- Every datasource, repository and controller should have a test file
- Every different function on datasource, repository or controller should have a test
- Every time that use expect from mocktail, should validate all values that is calling. You can't use any() or any(named:"")