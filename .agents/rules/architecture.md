---
trigger: always_on
---

Data path
- Every Model should have Model in the end of the name
- Every Model should have _model.dart in the end of the name
- Every Model should have functionalities. fromJson, toJson, fromEntity and toEntity
- Datasources abstract class should start with I
- Datasources implementations only remove the I from the start
- Example of abstract and implementation datasource name "ILocalLoadProductsDatasource" and "LocalLoadProductsDatasource"

Domain path
- Entity should have Entity in the end of the name
- Every entity should have _entity.dart in the end of the name
- Every repository implementation should have Impl in the end of the name, 
without I in the start of the name, and should add the abstract datasource in the constructor
- Example of abstract and implementation repository name "ILocalLoadProductsRepository" and "LocalLoadProductsRepositoryImpl"

Every folder should have a .dart file with the same name, exporting all files and folder from the same path. 

Every import should import the file with the same name of the file that export all files from the same folder. 

Every datasource, repository and controller should have a test file

When creating a new feature, should add the route too, following others routes patterns

If are not sure about how create a file, look at sale_request feature and compare to build similarly

In the presentation widgets, all texts should contains .hardcoded at the end