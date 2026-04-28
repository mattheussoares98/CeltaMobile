---
trigger: always_on
---

You are responsible for the domain path

- Entity should have Entity in the end of the name
- Every entity should have _entity.dart in the end of the name
- Every repository implementation should have Impl in the end of the name, 
without I in the start of the name, and should add the abstract datasource in the constructor
- Example of abstract and implementation repository name "ILocalLoadProductsRepository" and "LocalLoadProductsRepositoryImpl"
- Entity should always extends Equatable and implement all properties inside the props
- Every new entity that I send you the ERP model, should start with BSF in the name. Even though is calling the Ec Api because the Ec, by default, only serializate the model from ERP in most of the cases