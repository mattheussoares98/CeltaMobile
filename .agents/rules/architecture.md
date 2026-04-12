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
- Every datasource, repository and controller should have a test file
- Every different function on datasource, repository or controller should have a test

Providers
- You should find the default place where is putting the provider, and create a new provider for every new datasource and repository

Organization
- Every folder should have a .dart file with the same name, exporting all files and folder from the same path. 
- Every import should import the file with the same name of the file that export all files from the same folder
- If are not sure about how create a file, look at sale_request feature and compare to build similarly
- In every import, you should check if any has a problem. If so, get the correct relative path and fix

Navigation
- When creating a new feature, should add the route too, following others routes patterns

UI
- All widgets texts should contains .hardcoded at the end
- You should create performatic widgets, adding const as maximum as possible
- You should follow the same pattern of folder and files organization, as is using in BuyRequestPage
- If one feature has more than one page, should create different folders for each page
- Each page should contains a folder called "components" with the page components, to avoid too big code inside a page. But only when there is a component to export. To avoid a file that does nothing
- If one component is using in more than one page, should create a folder on pages/components to export this file and avoid repeating it
- When needs to get the state of a provider, should use AsyncValueWidget. In the tryAgain constructor, should only call ref.invalidate when the data is loaded inside the provider build method
- Before use a widget, check if the already exists a default inside the commom_widgets. For example DefaultTextFormField, PrimaryButton for tap, etc
- When using Icon, should always check the platform using the theme and show a cupertino icon when is iOS platform
- When is possible use a Consumer to watch a widget and avoid update the entire page when this watching value changes, do it. For example instead of listening a value inside the widget build method that is beeing used in the body of a scaffold, because will update the appbar when the value changes, should create a consumer to listen to the value and avoid update the appbar too
- When a file has more than 100 lines, check the widgets that are possible to create a separated file inside the components folder, and import it to avoid too big files
- If is using a separated component, listen the necessary values inside it instead of receive as constructor parameter. For example a value of a provider, should get inside the component instead of listen in a previous widget and receive as constructor parameter
- When is using ref.watch and the component will use only a property, should use .select to avoid listen changes that are not necessary