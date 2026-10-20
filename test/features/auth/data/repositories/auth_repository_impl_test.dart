import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/auth/data/models/models.dart';
import 'package:celta_inventario/features/auth/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/auth/data/repositories/repositories.dart';
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
    _findWorkingUrlCall().thenAnswer((_) async => throw Exception());
  }

  When _findWorkingUrlCall() => when(() => this.findWorkingUrl(any()));
}

void main() {
  late IAuthRepository sut;

  late SoapLoginDatasourceSpy soapLoginDatasource;
  late EnterpriseRepositorySpy enterpriseRepository;
  late LocalUserSessionDatasourceSpy localSessionDatasource;
  late SoapUrlValidationDatasourceSpy soapUrlValidationDatasource;

  late String password;
  late UserSessionEntity userSessionEntity;

  late String workingUrl;

  void initSut() {
    sut = AuthRepositoryImpl(
      soapLoginDatasource: soapLoginDatasource,
      enterpriseRepository: enterpriseRepository,
      localUserSessionDatasource: localSessionDatasource,
      soapUrlValidationDatasource: soapUrlValidationDatasource,
    );
  }

  void initInjections() {
    soapLoginDatasource = SoapLoginDatasourceSpy();
    enterpriseRepository = EnterpriseRepositorySpy();
    localSessionDatasource = LocalUserSessionDatasourceSpy();
    soapUrlValidationDatasource = SoapUrlValidationDatasourceSpy();
  }

  void mockSuccess() {
    enterpriseRepository.mockGetSupabaseEnterpriseByName(
      userSessionEntity.supabaseEnterprise,
    );
    soapLoginDatasource.mockLogin(UserModel.fromEntity(userSessionEntity.user));
    soapUrlValidationDatasource.mockWorkingUrl(workingUrl);
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
    workingUrl = faker.internet.httpUrl();
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
          workingUrl: workingUrl,
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
              CodigoInterno_Usuario:
                  userSessionEntity.user.CodigoInterno_Usuario,
            ),
            enterprise: SupabaseEnterpriseModel.fromEntity(
              userSessionEntity.supabaseEnterprise!,
            ),
          ),
        ),
      ).called(1);
      verify(
        () => soapUrlValidationDatasource.findWorkingUrl([
          userSessionEntity.supabaseEnterprise!.remoteHttpUrl!,
          userSessionEntity.supabaseEnterprise!.remoteHttpsUrl!,
          userSessionEntity.supabaseEnterprise!.localHttpUrl!,
          userSessionEntity.supabaseEnterprise!.localHttpsUrl!,
        ]),
      ).called(1);

      verifyNoMoreInteractions(enterpriseRepository);
      verifyNoMoreInteractions(soapLoginDatasource);
      verifyNoMoreInteractions(soapUrlValidationDatasource);
    });

    test("Should throw an AppException on enterprise not found", () async {
      enterpriseRepository.mockGetSupabaseEnterpriseByName(null);

      final result = sut.login(
        enterpriseName: userSessionEntity.supabaseEnterprise!.name,
        userName: userSessionEntity.user.name!,
        password: password,
      );

      expect(
        result,
        throwsA(
          isA<AppException>().having(
            (error) => error.failure,
            'failure',
            CoreFailure.companyNotFound,
          ),
        ),
      );
    });

    test('should throw when doesnt has working url', () async {
      soapUrlValidationDatasource.mockWorkingUrlError();

      expect(
        sut.login(
          enterpriseName: userSessionEntity.supabaseEnterprise!.name,
          userName: userSessionEntity.user.name!,
          password: password,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
