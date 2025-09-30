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
  late IAuthRepository sut;

  late SoapLoginDatasourceSpy soapLoginDatasource;
  late EnterpriseRepositorySpy enterpriseRepository;
  late LocalUserSessionDatasourceSpy localSessionDatasource;

  late String password;
  late UserSessionEntity userSessionEntity;

  void initSut() {
    sut = AuthRepositoryImpl(
      soapLoginDatasource: soapLoginDatasource,
      enterpriseRepository: enterpriseRepository,
      localUserSessionDatasource: localSessionDatasource,
    );
  }

  void initInjections() {
    soapLoginDatasource = SoapLoginDatasourceSpy();
    enterpriseRepository = EnterpriseRepositorySpy();
    localSessionDatasource = LocalUserSessionDatasourceSpy();
  }

  void mockSuccess() {
    enterpriseRepository.mockGetSupabaseEnterpriseByName(
      userSessionEntity.supabaseEnterprise,
    );
    soapLoginDatasource.mockLogin(UserModel.fromEntity(userSessionEntity.user));
  }

  void initEntities() {
    password = faker.internet.password();
    final enterprise = SupabaseEnterpriseModel.fromEntity(
      EntityFactory.makeEnterpriseEntity(),
    ).toEntity();
    userSessionEntity = UserSessionEntity(
      user: EntityFactory.makeUserEntity().copyWith(
        enterpriseName: enterprise.name,
      ),
      supabaseEnterprise: SupabaseEnterpriseModel.fromEntity(
        EntityFactory.makeEnterpriseEntity(),
      ).toEntity(),
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
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
  });

  group('logIn', () {
    test('should behave correctly on success', () async {
      await sut.login(
        enterpriseName: userSessionEntity.supabaseEnterprise!.name,
        userName: userSessionEntity.user.name!,
        password: password,
      );

      verify(
        () => enterpriseRepository.getSupabaseEnterpriseByName(
          userSessionEntity.supabaseEnterprise!.name,
        ),
      ).called(1);
      verify(
        () => soapLoginDatasource.login(
          baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
          user: userSessionEntity.user.name!,
          password: password,
        ),
      ).called(1);
      verify(
        () => localSessionDatasource.save(
          UserSessionModel(
            user: UserModel(
              name: userSessionEntity.user.name,
              enterpriseName: userSessionEntity.supabaseEnterprise!.name,
              AccessKey: userSessionEntity.user.AccessKey,
              CrossIdentity_Usuario:
                  userSessionEntity.user.CrossIdentity_Usuario,
            ),
            enterprise: SupabaseEnterpriseModel.fromEntity(
              userSessionEntity.supabaseEnterprise!,
            ),
          ),
        ),
      ).called(1);

      verifyNoMoreInteractions(enterpriseRepository);
      verifyNoMoreInteractions(soapLoginDatasource);
    });

    test("Should throw an AppException on enterprise not found", () async {
      enterpriseRepository.mockGetSupabaseEnterpriseByName(null);

      final result = sut.login(
        enterpriseName: userSessionEntity.supabaseEnterprise!.name,
        userName: userSessionEntity.user.name!,
        password: password,
      );

      expect(result, throwsA(isA<AppException>()));
    });
  });
}
