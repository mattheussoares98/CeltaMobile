import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/exceptions/exceptions.dart';
import 'package:celta_intelligence/features/auth/data/models/models.dart';
import 'package:celta_intelligence/features/auth/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late AuthRepositoryImpl sut;

  late MockAuthRemoteDataSource authRemoteDataSource;
  late MockAuthLocalDatasource authLocalDataSource;
  late MockEnterpriseDatasource enterpriseDatasource;

  late EnterpriseEntity enterpriseEntity;
  late String userName;
  late String password;
  late UserEntity userEntity;

  void initSut() {
    sut = AuthRepositoryImpl(
      authRemoteDatasource: authRemoteDataSource,
      authLocalDatasource: authLocalDataSource,
      enterpriseDatasource: enterpriseDatasource,
    );
  }

  void initInjections() {
    authRemoteDataSource = MockAuthRemoteDataSource();
    authLocalDataSource = MockAuthLocalDatasource();
    enterpriseDatasource = MockEnterpriseDatasource();
  }

  void mockSuccess() {
    enterpriseDatasource.mockGetEnterprise(
      EnterpriseModel.fromEntity(enterpriseEntity),
    );
    authRemoteDataSource.mockLogin(UserModel.fromEntity(userEntity));
    authLocalDataSource.mockSaveUser(userEntity);
    authLocalDataSource.mockGetUser(userEntity);
  }

  void initEntities() {
    enterpriseEntity = ModelFactory.makeEnterpriseEntity();
    userName = faker.internet.userName();
    password = faker.internet.password();
    userEntity = ModelFactory.makeUserEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('logIn', () {
    test('should behave correctly on success', () async {
      await sut.login(
        enterpriseName: enterpriseEntity.name,
        userName: userName,
        password: password,
      );

      verify(
        () => enterpriseDatasource.getEnterprise(enterpriseEntity.name),
      ).called(1);
      verify(
        () => authRemoteDataSource.login(
          url: enterpriseEntity.baseUrl!,
          user: userName,
          password: password,
        ),
      ).called(1);
      verify(() => authLocalDataSource.saveUser(userEntity)).called(1);

      verifyNoMoreInteractions(enterpriseDatasource);
      verifyNoMoreInteractions(authLocalDataSource);
      verifyNoMoreInteractions(authRemoteDataSource);
    });

    test("Should throw an AppException on enterprise not found", () async {
      enterpriseDatasource.mockGetEnterprise(null);

      final result = sut.login(
        enterpriseName: enterpriseEntity.name,
        userName: userName,
        password: password,
      );

      expect(result, throwsA(isA<AppException>()));
    });
  });

  group("Get current user", () {
    test("Should behave correctly on success", () async {
      final result = await sut.getCurrentUser();

      expect(result, userEntity);
      verify(() => authLocalDataSource.getUser()).called(1);

      verifyNoMoreInteractions(authLocalDataSource);
    });
  });

  group("Logout", () {
    test("Sould behave correctly", () async {
      await sut.logout();

      verify(() => authLocalDataSource.clearUser()).called(1);

      verifyNoMoreInteractions(authLocalDataSource);
    });
  });
}
