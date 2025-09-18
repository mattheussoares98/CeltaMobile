import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/features/auth/data/models/models.dart';
import 'package:celta_intelligence/features/enterprise_manager/data/models/models.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late EnterpriseManagerRepositoryImpl sut;

  late EnterpriseManagerDatasourceSpy enterpriseManagerDatasource;
  late LoginRemoteDatasourceSpy soapLoginDatasource;
  late SoapEnterpriseDatasourceSpy soapEnterpriseDatasource;

  late List<EnterprisePermissionEntity> enterprisePermissionEntities;
  late String enterpriseName;
  late String baseUrl;
  late String userName;
  late String password;
  late int enterpriseId;
  late List<UpdateModulePermissionModel> permissions;

  void initSut() {
    sut = EnterpriseManagerRepositoryImpl(
      enterpriseManagerDatasource: enterpriseManagerDatasource,
      soapLoginDatasource: soapLoginDatasource,
      soapEnterpriseDatasource: soapEnterpriseDatasource,
    );
  }

  void initInjections() {
    enterpriseManagerDatasource = EnterpriseManagerDatasourceSpy();
    soapLoginDatasource = LoginRemoteDatasourceSpy();
    soapEnterpriseDatasource = SoapEnterpriseDatasourceSpy();
  }

  void mockSuccess() {
    enterpriseManagerDatasource.mockGetAllEnterprisesPermissions(
      enterprisePermissionEntities
          .map((e) => EnterprisePermissionModel.fromEntity(e))
          .toList(),
    );
  }

  void initEntities() {
    enterprisePermissionEntities = [
      EntityFactory.makeEnterprisePermissionEntity(),
      EntityFactory.makeEnterprisePermissionEntity(),
      EntityFactory.makeEnterprisePermissionEntity(),
    ];

    enterpriseName = faker.company.name();
    baseUrl = faker.internet.httpsUrl();
    userName = faker.internet.userName();
    password = faker.internet.password();
    enterpriseId = faker.randomGenerator.integer(100);
    permissions = [
      UpdateModulePermissionModel(
        moduleId: faker.randomGenerator.integer(100),
        isEnabled: faker.randomGenerator.boolean(),
      ),
      UpdateModulePermissionModel(
        moduleId: faker.randomGenerator.integer(100),
        isEnabled: faker.randomGenerator.boolean(),
      ),
      UpdateModulePermissionModel(
        moduleId: faker.randomGenerator.integer(100),
        isEnabled: faker.randomGenerator.boolean(),
      ),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Get all enterprise permissions', () {
    test('should behave correctly on success', () async {
      final response = await sut.getAllEnterprisePermissions();

      expect(response, enterprisePermissionEntities);
      verify(() => enterpriseManagerDatasource.getEnterprisePermissions());
      verifyNoMoreInteractions(enterpriseManagerDatasource);
    });
  });
  group('Get enterprise permissions by id', () {
    test('should behave correctly on success', () async {
      enterpriseManagerDatasource.mockGetEnterprisePermissionsById(
        EnterprisePermissionModel.fromEntity(
          enterprisePermissionEntities.first,
        ),
      );

      final id = faker.randomGenerator.integer(100);
      final response = await sut.getEnterprisePermissionsById(id);

      expect(response, enterprisePermissionEntities.first);
      verify(
        () => enterpriseManagerDatasource.getEnterprisePermissionsById(id),
      );
      verifyNoMoreInteractions(enterpriseManagerDatasource);
    });
  });

  group("Create enterprise", () {
    test("Should behave correctly", () async {
      final user = UserModel(
        name: userName,
        enterpriseName: enterpriseName,
        AccessKey: faker.guid.guid(),
        CrossIdentity_Usuario: faker.guid.guid(),
      );
      soapLoginDatasource.mockLogin(user);

      List<SoapEnterpriseModel> enterprises = [
        SoapEnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity()),
        SoapEnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity()),
        SoapEnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity()),
      ];
      soapEnterpriseDatasource.mockGetEnterprises(enterprises);

      await sut.createEnterprise(
        enterpriseName: enterpriseName,
        baseUrl: baseUrl,
        userName: userName,
        password: password,
      );

      verify(
        () => soapLoginDatasource.login(
          baseUrl: baseUrl,
          user: userName,
          password: password,
        ),
      ).called(1);

      verify(
        () => soapEnterpriseDatasource.getEnterprises(
          baseUrl: baseUrl,
          crossIdentity: user.CrossIdentity_Usuario ?? "",
        ),
      ).called(1);

      verify(
        () => enterpriseManagerDatasource.createEnterpriseWithSubEnterprises(
          enterpriseName: enterpriseName,
          baseUrl: baseUrl,
          subEnterprises: enterprises
              .map(
                (e) => SubEnterpriseModel(
                  cnpj: e.CnpjNumber!,
                  name: e.Name!,
                  personalizedCode: e.PersonalizedCode!,
                  id: e.Code!,
                ),
              )
              .toList(),
        ),
      ).called(1);
    });
  });

  group('Update module permission', () {
    test('should behave correctly on success', () async {
      await sut.updateModulePermissions(
        enterpriseId: enterpriseId,
        permissions: permissions,
      );

      verify(
        () => enterpriseManagerDatasource.updateModulePermissions(
          enterpriseId: enterpriseId,
          permissions: permissions,
        ),
      );
      verifyNoMoreInteractions(enterpriseManagerDatasource);
    });
  });
}
