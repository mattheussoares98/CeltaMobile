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

// --- Fakes and Mocks ---

class MockSoapInsertUpdateResearchRepository extends Mock
    implements ISoapInsertUpdateResearchRepository {}

class SpyResearchsStateController extends ResearchsStateController {
  bool updateCalled = false;
  int? updatedCode;

  @override
  Future<List<ResearchEntity>> build() async => [];

  @override
  void updateResearchLocally({
    required int code,
    required String name,
    required String? observations,
  }) {
    updateCalled = true;
    updatedCode = code;
  }
}

void main() {
  late MockSoapInsertUpdateResearchRepository mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;

  late String fakeName;
  late String fakeObservations;
  late int fakeResearchCode;

  setUp(() {
    mockRepository = MockSoapInsertUpdateResearchRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();

    fakeName = faker.lorem.words(3).join(' ');
    fakeObservations = faker.lorem.sentence();
    fakeResearchCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    EnterpriseEntity? enterprise,
    required SpyResearchsStateController spyResearchs,
  }) {
    return ProviderContainer(
      overrides: [
        soapInsertUpdateResearchRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
        researchsStateControllerProvider.overrideWith(() => spyResearchs),
      ],
    );
  }

  group('InsertUpdateResearchController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.insertUpdate(
            crossIdentity: any(named: 'crossIdentity'),
            baseUrl: any(named: 'baseUrl'),
            enterpriseCode: any(named: 'enterpriseCode'),
            name: any(named: 'name'),
            observations: any(named: 'observations'),
            researchCode: any(named: 'researchCode'),
          ),
        ).thenAnswer((_) async {});
        final spyResearchs = SpyResearchsStateController();

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
          spyResearchs: spyResearchs,
        );
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          insertUpdateResearchControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(insertUpdateResearchControllerProvider.notifier)
            .insertUpdate(
              name: fakeName,
              observations: fakeObservations,
              researchCode: fakeResearchCode,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        verify(
          () => mockRepository.insertUpdate(
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            baseUrl: fakeSession.enterprise!.baseUrl!,
            enterpriseCode: fakeEnterprise.Code!,
            name: fakeName,
            observations: fakeObservations,
            researchCode: fakeResearchCode,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE
      final spyResearchs = SpyResearchsStateController();
      final container = makeProviderContainer(
        session: null, // Invalid session
        enterprise: fakeEnterprise,
        spyResearchs: spyResearchs,
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        insertUpdateResearchControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(insertUpdateResearchControllerProvider.notifier)
          .insertUpdate(
            name: fakeName,
            observations: fakeObservations,
            researchCode: fakeResearchCode,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());

      verifyNever(
        () => mockRepository.insertUpdate(
          crossIdentity: any(named: 'crossIdentity'),
          baseUrl: any(named: 'baseUrl'),
          enterpriseCode: any(named: 'enterpriseCode'),
          name: any(named: 'name'),
          observations: any(named: 'observations'),
          researchCode: any(named: 'researchCode'),
        ),
      );
    });

    test(
      'should emit [loading, error] when selected enterprise is null',
      () async {
        // ARRANGE
        final spyResearchs = SpyResearchsStateController();
        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: null, // No enterprise selected
          spyResearchs: spyResearchs,
        );
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          insertUpdateResearchControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(insertUpdateResearchControllerProvider.notifier)
            .insertUpdate(
              name: fakeName,
              observations: fakeObservations,
              researchCode: fakeResearchCode,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        // This will likely throw a TypeError due to the ! operator on selectedEnterprise
        expect(states.last.error, isA<Error>());

        verifyNever(
          () => mockRepository.insertUpdate(
            crossIdentity: any(named: 'crossIdentity'),
            baseUrl: any(named: 'baseUrl'),
            enterpriseCode: any(named: 'enterpriseCode'),
            name: any(named: 'name'),
            observations: any(named: 'observations'),
            researchCode: any(named: 'researchCode'),
          ),
        );
      },
    );

    test('should pass null observations correctly to repository', () async {
      // ARRANGE
      when(
        () => mockRepository.insertUpdate(
          crossIdentity: any(named: 'crossIdentity'),
          baseUrl: any(named: 'baseUrl'),
          enterpriseCode: any(named: 'enterpriseCode'),
          name: any(named: 'name'),
          observations: any(named: 'observations'),
          researchCode: any(named: 'researchCode'),
        ),
      ).thenAnswer((_) async {});

      final spyResearchs = SpyResearchsStateController();
      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
        spyResearchs: spyResearchs,
      );
      addTearDown(container.dispose);

      // ACT
      await container
          .read(insertUpdateResearchControllerProvider.notifier)
          .insertUpdate(
            name: fakeName,
            observations: null, // Testing nullable input
            researchCode: fakeResearchCode,
          );

      // ASSERT
      verify(
        () => mockRepository.insertUpdate(
          crossIdentity: any(named: 'crossIdentity'),
          baseUrl: any(named: 'baseUrl'),
          enterpriseCode: any(named: 'enterpriseCode'),
          name: fakeName,
          observations: null, // Verify null was passed
          researchCode: fakeResearchCode,
        ),
      ).called(1);
    });

    test('Should update locally when pass the research code', () async {
      // ARRANGE
      when(
        () => mockRepository.insertUpdate(
          crossIdentity: any(named: 'crossIdentity'),
          baseUrl: any(named: 'baseUrl'),
          enterpriseCode: any(named: 'enterpriseCode'),
          name: any(named: 'name'),
          observations: any(named: 'observations'),
          researchCode: any(named: 'researchCode'),
        ),
      ).thenAnswer((_) async {});
      final spyResearchs = SpyResearchsStateController();

      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
        spyResearchs: spyResearchs,
      );
      addTearDown(container.dispose);

      // ACT
      await container
          .read(insertUpdateResearchControllerProvider.notifier)
          .insertUpdate(
            name: fakeName,
            observations: fakeObservations,
            researchCode: fakeResearchCode,
          );

      expect(spyResearchs.updateCalled, isTrue);
      expect(spyResearchs.updatedCode, fakeResearchCode);
    });
    test(
      'Should NOT update locally when DONT pass the research code',
      () async {
        // ARRANGE
        when(
          () => mockRepository.insertUpdate(
            crossIdentity: any(named: 'crossIdentity'),
            baseUrl: any(named: 'baseUrl'),
            enterpriseCode: any(named: 'enterpriseCode'),
            name: any(named: 'name'),
            observations: any(named: 'observations'),
            researchCode: any(named: 'researchCode'),
          ),
        ).thenAnswer((_) async {});
        final spyResearchs = SpyResearchsStateController();

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
          spyResearchs: spyResearchs,
        );
        addTearDown(container.dispose);

        // ACT
        await container
            .read(insertUpdateResearchControllerProvider.notifier)
            .insertUpdate(
              name: fakeName,
              observations: fakeObservations,
              researchCode: null,
            );

        expect(spyResearchs.updateCalled, isFalse);
      },
    );
  });
}
