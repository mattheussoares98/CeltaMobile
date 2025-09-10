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

  late EnterpriseManagerDataSourceSpy enterpriseManagerDataSource;
  late LoginRemoteDataSourceSpy soapLoginDataSource;
  late SoapEnterpriseDataSourceSpy soapEnterpriseDataSource;

  late List<EnterprisePermissionEntity> enterprisePermissionEntities;
  late String enterpriseName;
  late String baseUrl;
  late String userName;
  late String password;

  void initSut() {
    sut = EnterpriseManagerRepositoryImpl(
      enterpriseManagerDataSource: enterpriseManagerDataSource,
      soapLoginDataSource: soapLoginDataSource,
      soapEnterpriseDataSource: soapEnterpriseDataSource,
    );
  }

  void initInjections() {
    enterpriseManagerDataSource = EnterpriseManagerDataSourceSpy();
    soapLoginDataSource = LoginRemoteDataSourceSpy();
    soapEnterpriseDataSource = SoapEnterpriseDataSourceSpy();
  }

  void mockSuccess() {
    enterpriseManagerDataSource.mockGetAllEnterprisesPermissions(
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
      verify(() => enterpriseManagerDataSource.getEnterprisePermissions());
      verifyNoMoreInteractions(enterpriseManagerDataSource);
    });
  });
  group('Get enterprise permissions by id', () {
    test('should behave correctly on success', () async {
      final id = faker.randomGenerator.integer(100);

      final response = await sut.getEnterprisePermissionsById(id);

      expect(response, enterprisePermissionEntities);
      verify(
        () => enterpriseManagerDataSource.getEnterprisePermissionsById(id),
      );
      verifyNoMoreInteractions(enterpriseManagerDataSource);
    });
  });

  group("Create enterprise", () {
    test("Should behave correctly", () async {
      final user = UserModel(
        name: userName,
        AccessKey: faker.guid.guid(),
        CrossIdentity_Usuario: faker.guid.guid(),
      );
      soapLoginDataSource.mockLogin(user);

      List<SoapEnterpriseModel> enterprises = [
        SoapEnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity()),
        SoapEnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity()),
        SoapEnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity()),
      ];
      soapEnterpriseDataSource.mockGetEnterprises(enterprises);

      await sut.createEnterprise(
        enterpriseName: enterpriseName,
        baseUrl: baseUrl,
        userName: userName,
        password: password,
      );

      verify(
        () => soapLoginDataSource.login(
          baseUrl: baseUrl,
          user: userName,
          password: password,
        ),
      ).called(1);

      verify(
        () => soapEnterpriseDataSource.getEnterprises(
          baseUrl: baseUrl,
          crossIdentity: user.CrossIdentity_Usuario ?? "",
        ),
      ).called(1);

      verify(
        () => enterpriseManagerDataSource.createEnterpriseWithSubEnterprises(
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
}
