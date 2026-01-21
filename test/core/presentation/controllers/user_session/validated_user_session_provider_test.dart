import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/enterprise/enterprise.dart';
import 'package:celta_inventario/core/domain/repositories/enterprise/enterprise.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/enterprise/enterprise.dart';
import 'package:celta_inventario/core/providers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/auth/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapUrlValidationRepositorySpy extends Mock
    implements ISoapUrlValidationRepository {
  void mockWorkingUrl(String? response) {
    when(() => this.findWorkingUrl(any())).thenAnswer((_) async => response);
  }
}

void main() {
  late LocalUserSessionDatasourceSpy localUserSessionDatasource;
  late UserSessionModel userSession;
  late EnterpriseRepositorySpy enterpriseRepository;
  late EnterpriseEntity enterprise;
  late SoapUrlValidationRepositorySpy soapUrlValidationRepository;

  setUp(() {
    localUserSessionDatasource = LocalUserSessionDatasourceSpy();
    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    enterpriseRepository = EnterpriseRepositorySpy();
    soapUrlValidationRepository = SoapUrlValidationRepositorySpy();

    enterprise = EntityFactory.makeEnterpriseEntity();

    registerFallbackValue(userSession);

    localUserSessionDatasource.mockGetSession(userSession);
    enterpriseRepository.mockGetSupabaseEnterpriseByName(enterprise);
    soapUrlValidationRepository.mockWorkingUrl(enterprise.remoteHttpUrl);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localUserSessionDatasourceProvider.overrideWithValue(
          localUserSessionDatasource,
        ),
        enterpriseRepositoryProvider.overrideWithValue(enterpriseRepository),
        soapUrlValidationRepositoryProvider.overrideWithValue(
          soapUrlValidationRepository,
        ),
      ],
    );
  }

  setUpAll(() {
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
  });

  group('Validated UserSession Controller', () {
    group('build', () {
      test('should behave correctly on success', () async {
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT: Wait for the build method to complete
        final result = await container.read(
          validatedUserSessionProvider.future,
        );

        // ASSERT
        expect(
          result,
          UserSessionModel(
            user: userSession.user,
            enterprise: SupabaseEnterpriseModel.fromEntity(
              enterprise,
              workingUrl: enterprise.remoteHttpUrl,
            ),
          ),
        );
        verify(() => localUserSessionDatasource.get()).called(1);
        verify(
          () => soapUrlValidationRepository.findWorkingUrl([
            enterprise.remoteHttpUrl!,
            enterprise.remoteHttpsUrl!,
            enterprise.localHttpUrl!,
            enterprise.localHttpsUrl!,
          ]),
        ).called(1);
      });

      test('should throw if datasource returns null', () async {
        localUserSessionDatasource.mockGetSession(null);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT
        final result = container.read(validatedUserSessionProvider.future);

        // ASSERT
        expect(result, throwsA(isA<AppException>()));
      });

      test('should throw if datasource returns user without crossId', () async {
        localUserSessionDatasource.mockGetSession(
          UserSessionModel(
            user: UserModel(
              name: faker.person.name(),
              enterpriseName: faker.company.name(),
              AccessKey: faker.guid.guid(),
              CrossIdentity_Usuario: null,
            ),
            enterprise: SupabaseEnterpriseModel(
              id: faker.randomGenerator.integer(100),
              name: faker.company.name(),
              subEnterprises: const [],
              workingUrl: faker.internet.httpUrl(),
              remoteHttpUrl: faker.internet.httpUrl(),
              remoteHttpsUrl: faker.internet.httpsUrl(),
              localHttpUrl: faker.internet.httpUrl(),
              localHttpsUrl: faker.internet.httpsUrl(),
            ),
          ),
        );

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT
        final result = container.read(validatedUserSessionProvider.future);

        // ASSERT
        expect(result, throwsA(isA<AppException>()));
      });
      test(
        'should throw if datasource returns user without accessKey',
        () async {
          localUserSessionDatasource.mockGetSession(
            UserSessionModel(
              user: UserModel(
                name: faker.person.name(),
                enterpriseName: faker.company.name(),
                AccessKey: null,
                CrossIdentity_Usuario: faker.guid.guid(),
              ),
              enterprise: SupabaseEnterpriseModel(
                id: faker.randomGenerator.integer(100),
                name: faker.company.name(),
                subEnterprises: const [],
                workingUrl: faker.internet.httpUrl(),
                remoteHttpUrl: faker.internet.httpUrl(),
                remoteHttpsUrl: faker.internet.httpsUrl(),
                localHttpUrl: faker.internet.httpUrl(),
                localHttpsUrl: faker.internet.httpsUrl(),
              ),
            ),
          );

          final container = makeProviderContainer();
          addTearDown(container.dispose);

          // ACT
          final result = container.read(validatedUserSessionProvider.future);

          // ASSERT
          expect(result, throwsA(isA<AppException>()));
        },
      );
    });
  });
}
