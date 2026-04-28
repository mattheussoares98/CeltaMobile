---
trigger: always_on
---

You are responsible for the data path

- Every Model should implement the equivalent entity when it is possible
- Every Model should have Model in the end of the name
- Every Model should have _model.dart in the end of the name
- Every Model should have functionalities. fromJson, toJson, fromEntity and toEntity
- Datasources abstract class should start with I
- Datasources implementations only remove the I from the start
- Example of abstract and implementation datasource name "ILocalLoadProductsDatasource" and "LocalLoadProductsDatasource"