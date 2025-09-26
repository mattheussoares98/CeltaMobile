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

  late LoginRemoteDatasourceSpy authRemoteDatasource;
  late EnterpriseRepositorySpy enterpriseRepository;
  late LocalUserSessionDatasourceSpy localSessionDatasource;

  late EnterpriseEntity enterpriseEntity;
  late String userName;
  late String password;
  late UserEntity userEntity;
  late UserSessionEntity userSessionEntity;

  void initSut() {
    sut = AuthRepositoryImpl(
      soapLoginDatasource: authRemoteDatasource,
      enterpriseRepository: enterpriseRepository,
      localUserSessionDatasource: localSessionDatasource,
    );
  }

  void initInjections() {
    authRemoteDatasource = LoginRemoteDatasourceSpy();
    enterpriseRepository = EnterpriseRepositorySpy();
    localSessionDatasource = LocalUserSessionDatasourceSpy();
  }

  void mockSuccess() {
    enterpriseRepository.mockGetSupabaseEnterpriseByName(
      SupabaseEnterpriseModel.fromEntity(enterpriseEntity).toEntity(),
    );
    authRemoteDatasource.mockLogin(UserModel.fromEntity(userEntity));
    localSessionDatasource.mockSaveSession(
      UserSessionModel.fromEntity(userSessionEntity),
    );
  }

  void initEntities() {
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    userName = faker.internet.userName();
    password = faker.internet.password();
    userEntity = EntityFactory.makeUserEntity();
    userSessionEntity = UserSessionEntity(
      user: userEntity,
      supabaseEnterprise: enterpriseEntity,
    );
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
        () => authRemoteDatasource.login(
          baseUrl: enterpriseEntity.baseUrl!,
          user: userName,
          password: password,
        ),
      ).called(1);
      verify(
        () => localSessionDatasource.save(
          UserSessionModel.fromEntity(userSessionEntity),
        ),
      ).called(1);

      verifyNoMoreInteractions(enterpriseRepository);
      verifyNoMoreInteractions(authRemoteDatasource);
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
}
