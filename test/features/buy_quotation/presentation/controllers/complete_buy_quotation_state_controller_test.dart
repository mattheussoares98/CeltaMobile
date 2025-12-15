import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/entities/buy_quotation_entity.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/repository/repository.dart';
import 'package:celta_intelligence/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_intelligence/features/buy_quotation/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapLoadBuyQuotationsRepository extends Mock
    implements ISoapLoadBuyQuotationsRepository {}

void main() {
  late MockSoapLoadBuyQuotationsRepository mockRepository;
  late UserSessionModel fakeSession;
  late BuyQuotationEntity fakeQuotation;
  late int fakeEnterpriseCode;
  late String fakeCodeForFullSearch;

  setUpAll(() {
    registerFallbackValue('any_string');
    registerFallbackValue(1);
    registerFallbackValue(null);
  });

  setUp(() {
    mockRepository = MockSoapLoadBuyQuotationsRepository();
    fakeEnterpriseCode = faker.randomGenerator.integer(100);
    fakeCodeForFullSearch = faker.randomGenerator.numberOfLength(
      5,
    ); // Non-null code

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    // Create the single entity that the repository mock will return inside a list
    fakeQuotation = EntityFactory.makeBuyQuotationEntity();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadBuyQuotationsRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('CompleteBuyQuotationsStateController', () {
    test(
      'build should fetch the single quotation and return the first element',
      () async {
        // ARRANGE
        // The repository must return a List, and the controller returns the first element
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            codeForFullSearch: fakeCodeForFullSearch,
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return [fakeQuotation]; // Must return a list
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          completeBuyQuotationsStateControllerProvider(
            fakeEnterpriseCode,
            fakeCodeForFullSearch,
          ).future,
        );

        // ASSERT
        expect(result, isA<BuyQuotationEntity>());
        expect(result, fakeQuotation);

        // Verify repository was called correctly
        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterpriseCode,
            codeForFullSearch: fakeCodeForFullSearch,
          ),
        ).called(1);
      },
    );

    test(
      'build should throw StateError if the repository returns an empty list',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            codeForFullSearch: any(named: 'codeForFullSearch'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return []; // Returns empty list
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT & ASSERT
        // The controller attempts to access response.first, which throws a StateError
        await expectLater(
          container.read(
            completeBuyQuotationsStateControllerProvider(
              fakeEnterpriseCode,
              fakeCodeForFullSearch,
            ).future,
          ),
          throwsA(isA<StateError>()),
        );
      },
    );

    test(
      'build should throw AppException if validatedUserSession is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: null,
        ); // Invalid session
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(
            completeBuyQuotationsStateControllerProvider(
              fakeEnterpriseCode,
              fakeCodeForFullSearch,
            ).future,
          ),
          throwsA(isA<AppException>()),
        );

        // Verify the repository was never called
        verifyNever(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            codeForFullSearch: any(named: 'codeForFullSearch'),
          ),
        );
      },
    );

    test('should behave correctly when CodeForFullSearch is 0', () async {
      // ARRANGE

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT
      final result = await container.read(
        completeBuyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
          '0',
        ).future,
      );

      // ASSERT
      expect(result, isA<BuyQuotationEntity>());
      expect(result, BuyQuotationEntity.empty());

      // Verify repository was called correctly
      verifyNever(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
          codeForFullSearch: any(named: 'codeForFullSearch'),
        ),
      );
    });
  });

  group('updateEntity', () {
    test('should update properties correctly', () async {
      // ARRANGE
      final newQuotation = EntityFactory.makeBuyQuotationEntity();

      // 1. Stub load to ensure state has initial data
      when(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
          codeForFullSearch: any(named: 'codeForFullSearch'),
        ),
      ).thenAnswer((_) async => [fakeQuotation]);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // 2. Wait for initial state to settle (AsyncData(fakeQuotation))
      await container.read(
        completeBuyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
          fakeCodeForFullSearch,
        ).future,
      );

      final notifier = container.read(
        completeBuyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
          fakeCodeForFullSearch,
        ).notifier,
      );

      final initialEntity = container
          .read(
            completeBuyQuotationsStateControllerProvider(
              fakeEnterpriseCode,
              fakeCodeForFullSearch,
            ),
          )
          .value;

      // ACT
      notifier.updateValues(
        Buyer: newQuotation.Buyer,
        DateOfLimit: newQuotation.DateOfLimit,
        Enterprises: newQuotation.Enterprises,
        Observations: newQuotation.Observations,
        Products: newQuotation.Products,
      );

      // ASSERT
      final updatedState = container.read(
        completeBuyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
          fakeCodeForFullSearch,
        ),
      );

      final updatedEntity = updatedState.value!;

      // 1. Verify updated fields
      expect(updatedEntity.Observations, newQuotation.Observations);
      expect(updatedEntity.DateOfLimit, newQuotation.DateOfLimit);
      expect(updatedEntity.Enterprises, newQuotation.Enterprises);
      expect(updatedEntity.Observations, newQuotation.Observations);
      expect(updatedEntity.Products, newQuotation.Products);

      expect(updatedEntity, isNot(equals(initialEntity)));
    });
    test('should annul date of limit correctly', () async {
      // 1. Stub load to ensure state has initial data
      when(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
          codeForFullSearch: any(named: 'codeForFullSearch'),
        ),
      ).thenAnswer((_) async => [fakeQuotation]);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // 2. Wait for initial state to settle (AsyncData(fakeQuotation))
      await container.read(
        completeBuyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
          fakeCodeForFullSearch,
        ).future,
      );

      final notifier = container.read(
        completeBuyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
          fakeCodeForFullSearch,
        ).notifier,
      );

      final initialEntity = container
          .read(
            completeBuyQuotationsStateControllerProvider(
              fakeEnterpriseCode,
              fakeCodeForFullSearch,
            ),
          )
          .value;

      // ACT
      notifier.updateValues(annulDateOfLimit: true);

      // ASSERT
      final updatedState = container.read(
        completeBuyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
          fakeCodeForFullSearch,
        ),
      );

      final updatedEntity = updatedState.value!;

      // 1. Verify updated fields
      expect(updatedEntity.DateOfLimit, null);
      expect(updatedEntity.Observations, initialEntity?.Observations);
      expect(updatedEntity.Enterprises, initialEntity?.Enterprises);
      expect(updatedEntity.Observations, initialEntity?.Observations);
      expect(updatedEntity.Products, initialEntity?.Products);
    });

    test(
      'should do nothing if state.value is null (e.g., loading or error state)',
      () async {
        // ARRANGE
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // State is AsyncLoading due to repository stubbing
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            codeForFullSearch: any(named: 'codeForFullSearch'),
          ),
        ).thenAnswer((_) async => [fakeQuotation]);

        final notifier = container.read(
          completeBuyQuotationsStateControllerProvider(
            fakeEnterpriseCode,
            fakeCodeForFullSearch,
          ).notifier,
        );

        // Read to start the load process (state = AsyncLoading) but DO NOT await
        container.read(
          completeBuyQuotationsStateControllerProvider(
            fakeEnterpriseCode,
            fakeCodeForFullSearch,
          ),
        );

        // ACT
        // Call updateEntity while state.value is null (AsyncLoading)
        notifier.updateValues(Observations: 'Test');

        // ASSERT
        // Ensure state is still AsyncLoading (no change should occur)
        final finalState = container.read(
          completeBuyQuotationsStateControllerProvider(
            fakeEnterpriseCode,
            fakeCodeForFullSearch,
          ),
        );
        expect(finalState, isA<AsyncLoading>());

        // Await the future to clean up the test properly
        await container.read(
          completeBuyQuotationsStateControllerProvider(
            fakeEnterpriseCode,
            fakeCodeForFullSearch,
          ).future,
        );
      },
    );
  });
}
