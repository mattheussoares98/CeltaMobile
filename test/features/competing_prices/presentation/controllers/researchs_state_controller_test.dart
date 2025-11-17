import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_intelligence/features/competing_prices/domain/repository/repository.dart';
import 'package:celta_intelligence/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/competing_prices/providers/providers.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapLoadResearchsRepository extends Mock
    implements ISoapLoadResearchsRepository {}

void main() {
  late MockSoapLoadResearchsRepository mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late List<ResearchEntity> fakeResearchs;
  late String? fakeSearchValue;

  setUpAll(() {
    // Register fallbacks for any custom types used in `any()`
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  setUp(() {
    mockRepository = MockSoapLoadResearchsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeResearchs = [EntityFactory.makeResearchEntity()];
    fakeSearchValue = faker.randomGenerator.boolean()
        ? faker.lorem.word()
        : null;
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    EnterpriseEntity? enterprise,
  }) {
    // We create a new container for each test to avoid keepAlive conflicts
    final container = ProviderContainer(
      overrides: [
        soapLoadResearchsRepositoryProvider.overrideWithValue(mockRepository),
        // Override the keepAlive providers
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('ResearchsStateController', () {
    test('build should return an empty list as initial data', () async {
      // ARRANGE
      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );

      // ACT: Wait for the build method to complete
      final result = await container.read(
        researchsStateControllerProvider.future,
      );

      // ASSERT
      expect(result, isEmpty);
      expectLater(
        await container.read(researchsStateControllerProvider.future),
        const [],
      );
    });

    group('load', () {
      test(
        'should emit [loading, data] and call repository on success',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(
              crossIdentity: any(named: 'crossIdentity'),
              baseUrl: any(named: 'baseUrl'),
              enterpriseCode: any(named: 'enterpriseCode'),
              searchValue: any(named: 'searchValue'),
            ),
          ).thenAnswer((_) async {
            await Future.delayed(Duration.zero);
            return fakeResearchs;
          });

          final container = makeProviderContainer(
            session: fakeSession,
            enterprise: fakeEnterprise,
          );
          // Wait for the initial build to complete
          await container.read(researchsStateControllerProvider.future);

          final states = <AsyncValue<List<ResearchEntity>>>[];
          container.listen(
            researchsStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(researchsStateControllerProvider.notifier)
              .load(fakeSearchValue);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          expect(states.last.value, fakeResearchs);

          // Verify the repository was called with the correct data
          verify(
            () => mockRepository.load(
              crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
              baseUrl: fakeSession.enterprise!.baseUrl!,
              enterpriseCode: fakeEnterprise.Code!,
              searchValue: fakeSearchValue,
            ),
          ).called(1);
        },
      );

      test('should emit [loading, error] when session is invalid', () async {
        // ARRANGE: Pass a null session
        final container = makeProviderContainer(
          session: null,
          enterprise: fakeEnterprise,
        );
        await container.read(researchsStateControllerProvider.future);

        final states = <AsyncValue<List<ResearchEntity>>>[];
        container.listen(
          researchsStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(researchsStateControllerProvider.notifier)
            .load(fakeSearchValue);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        expect(states.last.error, isA<AppException>());

        // Verify the repository was never called
        verifyNever(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            baseUrl: any(named: 'baseUrl'),
            enterpriseCode: any(named: 'enterpriseCode'),
            searchValue: any(named: 'searchValue'),
          ),
        );
      });

      test(
        'should emit [loading, error] when selectedEnterprise is null',
        () async {
          // ARRANGE: Pass a null enterprise
          final container = makeProviderContainer(
            session: fakeSession,
            enterprise: null,
          );
          await container.read(researchsStateControllerProvider.future);

          final states = <AsyncValue<List<ResearchEntity>>>[];
          container.listen(
            researchsStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(researchsStateControllerProvider.notifier)
              .load(fakeSearchValue);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
          // This will be a null check error because of `selectedEnterprise!.Code!`
          expect(states.last.error, isA<Error>());
          verifyNever(
            () => mockRepository.load(
              crossIdentity: any(named: 'crossIdentity'),
              baseUrl: any(named: 'baseUrl'),
              enterpriseCode: any(named: 'enterpriseCode'),
              searchValue: any(named: 'searchValue'),
            ),
          );
        },
      );
    });
  });
}
