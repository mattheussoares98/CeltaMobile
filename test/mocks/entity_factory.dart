import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static EnterpriseEntity makeEnterpriseEntity({String? id, String? name}) =>
      EnterpriseEntity(
        id: id ?? faker.guid.guid(),
        name: name ?? faker.company.name(),
        baseUrl: faker.internet.httpsUrl(),
        subEnterprises: [
          makeSubEnterpriseEntity(),
          makeSubEnterpriseEntity(),
          makeSubEnterpriseEntity(),
        ],
      );

  static SubEnterpriseEntity makeSubEnterpriseEntity() => SubEnterpriseEntity(
    id: faker.guid.guid(),
    name: faker.company.name(),
    cnpj: faker.randomGenerator.integer(14, min: 14).toString(),
  );

  static UserEntity makeUserEntity() => UserEntity(
    name: faker.person.name(),
    AccessKey: faker.guid.guid(),
    CrossIdentity_Usuario: faker.guid.guid(),
  );

  static EnterprisePermissionEntity makeEnterprisePermissionEntity() =>
      EnterprisePermissionEntity(
        id: faker.guid.guid(),
        name: faker.company.name(),
        baseUrl: faker.internet.httpsUrl(),
        subEnterprises: [
          makeSubEnterprisePermissionEntity(),
          makeSubEnterprisePermissionEntity(),
          makeSubEnterprisePermissionEntity(),
        ],
      );

  static SubEnterprisePermissionEntity makeSubEnterprisePermissionEntity() =>
      SubEnterprisePermissionEntity(
        id: faker.guid.guid(),
        name: faker.company.name(),
        cnpjNumber: faker.randomGenerator.integer(14, min: 14).toString(),
        modules: [
          makeModulePermissionEntity(),
          makeModulePermissionEntity(),
          makeModulePermissionEntity(),
        ],
      );

  static ModulePermissionEntity makeModulePermissionEntity() =>
      ModulePermissionEntity(
        id: faker.guid.guid(),
        moduleKey: faker.guid.guid(),
        name: faker.lorem.word(),
        isEnabled: faker.randomGenerator.boolean(),
      );
}
