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
- Entity should always extends Equatable and implement all properties inside the props
- Every new entity that I send you the ERP model, should start with BSF in the name. Even though is calling the Ec Api because the Ec, by default, only serializate the model from ERP in most of the cases

Tests
- When need return an entity, or a json that should be converter, maintain the pattern from the EntityFactory and create a new make (newEntity) when it is necessary. Then, you use this entity in the test. If need to return a model or json, you can convert using the model.
- The preference is using mocktail to use different values

- You should find the default place where is putting the provider, and create a new provider for every new datasource and repository

Every folder should have a .dart file with the same name, exporting all files and folder from the same path. 

Every import should import the file with the same name of the file that export all files from the same folder. 

Every datasource, repository and controller should have a test file

When creating a new feature, should add the route too, following others routes patterns

If are not sure about how create a file, look at sale_request feature and compare to build similarly

UI
- All widgets texts should contains .hardcoded at the end
- You should create performatic widgets, adding const as maximum as possible