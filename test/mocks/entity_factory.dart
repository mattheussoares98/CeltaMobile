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
        CnpjNumber: faker.randomGenerator.integer(100).toString(),
        Code: faker.randomGenerator.integer(100),
        CodigoInternoVendaMobile_ModeloPedido: faker.randomGenerator.integer(
          100,
        ),
        ProductCodeSizeOfBalanceLabel: faker.randomGenerator.integer(100),
        PersonalizedCode: faker.randomGenerator.integer(100).toString(),
        InscriptionNumber: faker.randomGenerator.integer(100).toString(),
        EnterpriseParticipateEnterpriseGroup: faker.randomGenerator.boolean(),
        ProductCodeWithCheckerDigit: faker.randomGenerator.boolean(),
        UseEcommerceSale: faker.randomGenerator.boolean(),
        UseRetailSale: faker.randomGenerator.boolean(),
        UseWholeSale: faker.randomGenerator.boolean(),
      );

  static SubEnterpriseEntity makeSubEnterpriseEntity() => SubEnterpriseEntity(
    id: faker.randomGenerator.integer(100),
    personalizedCode: faker.randomGenerator.integer(100).toString(),
    name: faker.company.name(),
    cnpjNumber: faker.randomGenerator.integer(14, min: 14).toString(),
  );

  static UserEntity makeUserEntity() => UserEntity(
    name: faker.person.name(),
    AccessKey: faker.guid.guid(),
    CrossIdentity_Usuario: faker.guid.guid(),
  );

  static EnterprisePermissionEntity makeEnterprisePermissionEntity() =>
      EnterprisePermissionEntity(
        id: faker.randomGenerator.integer(100),
        name: faker.company.name(),
        baseUrl: faker.internet.httpsUrl(),
        globalEnabledModules: [
          faker.lorem.word(),
          faker.lorem.word(),
          faker.lorem.word(),
        ],
        subEnterprises: [
          makeSubEnterprisePermissionEntity(),
          makeSubEnterprisePermissionEntity(),
          makeSubEnterprisePermissionEntity(),
        ],
      );

  static SubEnterprisePermissionEntity makeSubEnterprisePermissionEntity() =>
      SubEnterprisePermissionEntity(
        id: faker.randomGenerator.integer(100),
        name: faker.company.name(),
        cnpjNumber: faker.randomGenerator.integer(200).toString(),
        personalizedCode: faker.randomGenerator.integer(100).toString(),
        modules: [
          makeModulePermissionEntity(),
          makeModulePermissionEntity(),
          makeModulePermissionEntity(),
        ],
      );

  static ModulePermissionEntity makeModulePermissionEntity() =>
      ModulePermissionEntity(
        id: faker.randomGenerator.integer(100),
        moduleKey: faker.guid.guid(),
        name: faker.lorem.word(),
        isEnabled: faker.randomGenerator.boolean(),
        isDefinedAtCnpjLevel: faker.randomGenerator.boolean(),
      );
}
