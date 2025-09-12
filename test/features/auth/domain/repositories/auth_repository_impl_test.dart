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

  late LoginRemoteDataSourceSpy authRemoteDataSource;
  late AuthLocalDatasourceSpy authLocalDataSource;
  late EnterpriseRepositorySpy enterpriseRepository;

  late EnterpriseEntity enterpriseEntity;
  late String userName;
  late String password;
  late UserEntity userEntity;

  void initSut() {
    sut = AuthRepositoryImpl(
      soapLoginDataSource: authRemoteDataSource,
      authLocalDatasource: authLocalDataSource,
      enterpriseRepository: enterpriseRepository,
    );
  }

  void initInjections() {
    authRemoteDataSource = LoginRemoteDataSourceSpy();
    authLocalDataSource = AuthLocalDatasourceSpy();
    enterpriseRepository = EnterpriseRepositorySpy();
  }

  void mockSuccess() {
    enterpriseRepository.mockGetSupabaseEnterpriseByName(
      SupabaseEnterpriseModel.fromEntity(enterpriseEntity).toEntity(),
    );
    authRemoteDataSource.mockLogin(UserModel.fromEntity(userEntity));
    authLocalDataSource.mockGetUser(userEntity);
  }

  void initEntities() {
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    userName = faker.internet.userName();
    password = faker.internet.password();
    userEntity = EntityFactory.makeUserEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUserEntity());
  });

  group('logIn', () {
    test('should behave correctly on success', () async {
      await sut.login(
        enterpriseName: enterpriseEntity.name,
        userName: userName,
        password: password,
      );

      verify(
        () => enterpriseRepository.getSupabaseEnterpriseByName(
          enterpriseEntity.name,
        ),
      ).called(1);
      verify(
        () => authRemoteDataSource.login(
          baseUrl: enterpriseEntity.baseUrl!,
          user: userName,
          password: password,
        ),
      ).called(1);
      verify(
        () => authLocalDataSource.saveUser(
          UserEntity(
            name: userName,
            enterpriseName: enterpriseEntity.name,
            AccessKey: userEntity.AccessKey,
            CrossIdentity_Usuario: userEntity.CrossIdentity_Usuario,
          ),
        ),
      ).called(1);

      verifyNoMoreInteractions(enterpriseRepository);
      verifyNoMoreInteractions(authLocalDataSource);
      verifyNoMoreInteractions(authRemoteDataSource);
    });

    test("Should throw an AppException on enterprise not found", () async {
      enterpriseRepository.mockGetSupabaseEnterpriseByName(null);

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

      verify(() => authLocalDataSource.logout()).called(1);

      verifyNoMoreInteractions(authLocalDataSource);
    });
  });
}
