import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/auth/data/models/models.dart';
import 'package:celta_inventario/features/enterprise_manager/data/models/models.dart';
import 'package:celta_inventario/features/enterprise_manager/data/repositories/repositories.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapUrlValidationDatasourceSpy extends Mock
    implements ISoapUrlValidationDatasource {
  void mockWorkingUrl(String response) {
    _findWorkingUrlCall().thenAnswer((_) async => response);
  }

  void mockWorkingUrlError() {
    _findWorkingUrlCall().thenThrow(Exception());
  }

  When _findWorkingUrlCall() => when(() => this.findWorkingUrl(any()));
}

void main() {
  late EnterpriseManagerRepositoryImpl sut;

  late EnterpriseManagerDatasourceSpy enterpriseManagerDatasource;
  late SoapLoginDatasourceSpy soapLoginDatasource;
  late SoapEnterpriseDatasourceSpy soapEnterpriseDatasource;
  late SoapUrlValidationDatasourceSpy soapUrlValidationDatasource;

  late List<EnterprisePermissionEntity> enterprisePermissionEntities;
  late String enterpriseName;
  late String remoteHttpUrl;
  late String remoteHttpsUrl;
  late String localHttpUrl;
  late String localHttpsUrl;
  late String workingUrl;
  late String userName;
  late String password;
  late int enterpriseId;
  late List<UpdateModulePermissionModel> permissions;

  void initSut() {
    sut = EnterpriseManagerRepositoryImpl(
      enterpriseManagerDatasource: enterpriseManagerDatasource,
      soapLoginDatasource: soapLoginDatasource,
      soapEnterpriseDatasource: soapEnterpriseDatasource,
      soapUrlValidationDatasource: soapUrlValidationDatasource,
    );
  }

  void initInjections() {
    enterpriseManagerDatasource = EnterpriseManagerDatasourceSpy();
    soapLoginDatasource = SoapLoginDatasourceSpy();
    soapEnterpriseDatasource = SoapEnterpriseDatasourceSpy();
    soapUrlValidationDatasource = SoapUrlValidationDatasourceSpy();
  }

  void mockSuccess() {
    enterpriseManagerDatasource.mockGetAllEnterprisesPermissions(
      enterprisePermissionEntities
          .map((e) => EnterprisePermissionModel.fromEntity(e))
          .toList(),
    );
    soapUrlValidationDatasource.mockWorkingUrl(workingUrl);
  }

  void initEntities() {
    enterprisePermissionEntities = [
      EntityFactory.makeEnterprisePermissionEntity(),
      EntityFactory.makeEnterprisePermissionEntity(),
      EntityFactory.makeEnterprisePermissionEntity(),
    ];

    enterpriseName = faker.company.name();
    remoteHttpUrl = faker.internet.httpUrl();
    remoteHttpsUrl = faker.internet.httpsUrl();
    localHttpUrl = faker.internet.httpUrl();
    localHttpsUrl = faker.internet.httpsUrl();
    userName = faker.internet.userName();
    password = faker.internet.password();
    workingUrl = faker.internet.httpUrl();
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
        CodigoInterno_Usuario: faker.randomGenerator.integer(100),
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
        remoteHttpUrl: remoteHttpUrl,
        remoteHttpsUrl: remoteHttpsUrl,
        localHttpUrl: localHttpUrl,
        localHttpsUrl: localHttpsUrl,
        userName: userName,
        password: password,
      );

      verify(
        () => soapLoginDatasource.login(
          workingUrl: workingUrl,
          user: userName,
          password: password,
        ),
      ).called(1);

      verify(
        () => soapEnterpriseDatasource.getEnterprises(
          workingUrl: workingUrl,
          crossIdentity: user.CrossIdentity_Usuario ?? "",
        ),
      ).called(1);

      verify(
        () => enterpriseManagerDatasource.createEnterpriseWithSubEnterprises(
          enterpriseName: enterpriseName,
          remoteHttpUrl: remoteHttpUrl,
          remoteHttpsUrl: remoteHttpsUrl,
          localHttpUrl: localHttpUrl,
          localHttpsUrl: localHttpsUrl,
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
      verify(
        () => soapUrlValidationDatasource.findWorkingUrl([
          remoteHttpUrl,
          remoteHttpsUrl,
          localHttpUrl,
          localHttpsUrl,
        ]),
      ).called(1);
    });
  });

  group('Update module permission', () {
    test('should behave correctly on success', () async {
      await sut.updateModulePermissions(
        enterpriseId: enterpriseId,
        permissions: permissions,
        remoteHttpUrl: remoteHttpUrl,
        remoteHttpsUrl: remoteHttpsUrl,
        localHttpUrl: localHttpUrl,
        localHttpsUrl: localHttpsUrl,
      );

      verify(
        () => enterpriseManagerDatasource.updateUrlAndPermissions(
          enterpriseId: enterpriseId,
          permissions: permissions,
          remoteHttpUrl: remoteHttpUrl,
          remoteHttpsUrl: remoteHttpsUrl,
          localHttpUrl: localHttpUrl,
          localHttpsUrl: localHttpsUrl,
        ),
      );
      verifyNoMoreInteractions(enterpriseManagerDatasource);
    });
  });
}
