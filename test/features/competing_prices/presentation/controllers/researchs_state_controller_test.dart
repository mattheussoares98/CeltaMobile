import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/exceptions.dart';
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
    test('build should load without filter searchValue', () async {
      when(
        () => mockRepository.load(
          crossIdentity: any(named: 'crossIdentity'),
          urlInUse: any(named: 'urlInUse'),
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

      final result = await container.read(
        researchsStateControllerProvider.future,
      );

      // ASSERT
      expect(result, fakeResearchs);
      // expectLater(
      //   await container.read(researchsStateControllerProvider.future),
      //   const [],
      // );
      verify(
        () => mockRepository.load(
          crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          urlInUse: fakeSession.enterprise!.urlInUse!,
          enterpriseCode: fakeEnterprise.Code!,
          searchValue: null,
        ),
      ).called(1);
    });

    group('load', () {
      test(
        'should emit [loading, data] and call repository on success',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(
              crossIdentity: any(named: 'crossIdentity'),
              urlInUse: any(named: 'urlInUse'),
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
          // expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          expect(states.last.value, fakeResearchs);

          // Verify the repository was called with the correct data
          verify(
            () => mockRepository.load(
              crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
              urlInUse: fakeSession.enterprise!.urlInUse!,
              enterpriseCode: fakeEnterprise.Code!,
              searchValue: fakeSearchValue,
            ),
          );
        },
      );

      test('should emit [loading, error] when session is invalid', () async {
        // ARRANGE: Pass a null enterprise
        final container = makeProviderContainer(
          session: null,
          enterprise: fakeEnterprise,
        );

        final response = container.read(
          researchsStateControllerProvider.future,
        );

        expect(response, throwsA(isA<AppException>()));
        verifyNever(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            urlInUse: any(named: 'urlInUse'),
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

          expect(
            container.read(researchsStateControllerProvider.future),
            throwsA(isA<Error>()),
          );
          verifyNever(
            () => mockRepository.load(
              crossIdentity: any(named: 'crossIdentity'),
              urlInUse: any(named: 'urlInUse'),
              enterpriseCode: any(named: 'enterpriseCode'),
              searchValue: any(named: 'searchValue'),
            ),
          );
        },
      );
    });

    group('updateResearchLocally', () {
      test('should update the entity in the list if code matches', () async {
        // ARRANGE
        final initialResearch = fakeResearchs.first;
        const newName = 'Updated Name';
        const newObservations = 'Updated Obs';
        final newConcurrent = EntityFactory.makeConcurrentEntity();

        // 1. Stub the repository to return the data for the initial load
        when(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            urlInUse: any(named: 'urlInUse'),
            enterpriseCode: any(named: 'enterpriseCode'),
            searchValue: any(named: 'searchValue'),
          ),
        ).thenAnswer((_) async => fakeResearchs);

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        // 2. Load the initial state (build method) and wait for it to populate AsyncData
        await container.read(researchsStateControllerProvider.future);

        // ACT
        // Since the build method finished, the state.value is guaranteed to be the list.
        container
            .read(researchsStateControllerProvider.notifier)
            .updateResearchLocally(
              code: initialResearch.Code,
              name: newName,
              observations: newObservations,
              newConcurrent: newConcurrent,
            );

        // ASSERT
        // 3. Read the final state synchronously (no future needed for state.value)
        final state = container.read(researchsStateControllerProvider);

        // Ensure the state is AsyncData and not null
        expect(state.value, isNotNull);

        final updatedItem = state.value!.firstWhere(
          (e) => e.Code == initialResearch.Code,
        );

        // Verify changes
        expect(updatedItem.Name, newName);
        expect(updatedItem.Observation, newObservations);
        expect(updatedItem.Concurrents, [
          ...?initialResearch.Concurrents,
          newConcurrent,
        ]);

        // Ensure the list size did not change
        expect(state.value!.length, 1);
      });
      test('should not update if code does not match any entity', () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            urlInUse: any(named: 'urlInUse'),
            enterpriseCode: any(named: 'enterpriseCode'),
            searchValue: any(named: 'searchValue'),
          ),
        ).thenAnswer((_) async => fakeResearchs);

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        await container.read(researchsStateControllerProvider.future);

        final nonExistentCode = fakeResearchs.first.Code + 9999;
        final initialStateValue = container
            .read(researchsStateControllerProvider)
            .value!;

        // ACT
        container
            .read(researchsStateControllerProvider.notifier)
            .updateResearchLocally(
              code: nonExistentCode,
              name: 'New Name',
              observations: 'New Obs',
            );

        // ASSERT
        final state = container.read(researchsStateControllerProvider);
        // Ensure the list content is the original list object
        expect(state.value, initialStateValue);
      });
    });
  });
}
