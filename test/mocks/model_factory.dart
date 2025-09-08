import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/features/auth/data/models/models.dart';
import 'package:faker/faker.dart';

class ModelFactory {
  ModelFactory._();

  static EnterpriseModel makeEnterpriseModel({String? id, String? name}) =>
      EnterpriseModel(
        id: id ?? faker.guid.guid(),
        name: name ?? faker.company.name(),
        baseUrl: faker.internet.httpsUrl(),
        subEnterprises: [
          makeSubEnterpriseModel(),
          makeSubEnterpriseModel(),
          makeSubEnterpriseModel(),
        ],
      );

  static SubEnterpriseModel makeSubEnterpriseModel() => SubEnterpriseModel(
    id: faker.guid.guid(),
    name: faker.company.name(),
    cnpj: faker.randomGenerator.integer(14, min: 14).toString(),
  );

  static UserModel makeUserModel() => UserModel(
    name: faker.person.name(),
    AccessKey: faker.guid.guid(),
    CrossIdentity_Usuario: faker.guid.guid(),
  );
}
