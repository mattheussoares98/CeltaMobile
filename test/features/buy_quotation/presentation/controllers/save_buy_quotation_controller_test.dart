import 'dart:async';

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/repository/repository.dart';
import 'package:celta_intelligence/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_intelligence/features/buy_quotation/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapInsertUpdateBuyQuotationRepository extends Mock
    implements ISoapInsertUpdateBuyQuotationRepository {}

// Spy/Fake for the CompleteBuyQuotationsStateController (to control the data input)
class FakeCompleteBuyQuotationsStateController
    extends CompleteBuyQuotationsStateController {
  final BuyQuotationEntity entityToReturn;
  FakeCompleteBuyQuotationsStateController(this.entityToReturn);

  @override
  FutureOr<BuyQuotationEntity> build(
    int enterpriseCode,
    String codeForFullSearch,
  ) async {
    return entityToReturn;
  }
}

// Spy for the BuyQuotationsStateController (to check invalidation effect)
class MockBuyQuotationsStateController extends BuyQuotationsStateController {
  @override
  Future<List<BuyQuotationEntity>> build(int enterpriseCode) async {
    wasRebuilt = true;
    return [];
  }

  bool wasRebuilt = false;
}

void main() {
  late MockSoapInsertUpdateBuyQuotationRepository mockRepository;
  late UserSessionModel fakeSession;
  late int fakeEnterpriseCode;
  late String fakeCode;

  // Test data variables

  setUpAll(() {
    registerFallbackValue(BuyQuotationEntity.empty());
    registerFallbackValue(1);
    registerFallbackValue('any_string');
  });

  setUp(() {
    mockRepository = MockSoapInsertUpdateBuyQuotationRepository();
    fakeEnterpriseCode = faker.randomGenerator.integer(100);
    fakeCode = faker.randomGenerator.numberOfLength(5);

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    // Stub the repository call to simulate success by default
    when(
      () => mockRepository.insertUpdate(
        baseUrl: any(named: 'baseUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        buyQuotation: any(named: 'buyQuotation'),
      ),
    ).thenAnswer((_) async {});
  });

  ProviderContainer makeProviderContainer({
    required BuyQuotationEntity buyQuotationInput,
    UserSessionModel? session,
    MockBuyQuotationsStateController? mockBuyQuotationsNotifier,
  }) {
    // Determine the notifier for spying on invalidation
    final spyNotifier =
        mockBuyQuotationsNotifier ?? MockBuyQuotationsStateController();

    return ProviderContainer(
      overrides: [
        // Mock the repository for the write operation
        soapInsertUpdateBuyQuotationRepositoryProvider.overrideWithValue(
          mockRepository,
        ),

        // Mock the session provider
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),

        // Fake the data input provider (the entity we are trying to save)
        completeBuyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
          fakeCode,
        ).overrideWith(
          () => FakeCompleteBuyQuotationsStateController(buyQuotationInput),
        ),

        // Spy on the target list provider for invalidation checks
        buyQuotationsStateControllerProvider(
          fakeEnterpriseCode,
        ).overrideWith(() => spyNotifier),
      ],
    );
  }

  // Helper to create a valid entity for success tests
  BuyQuotationEntity createValidBuyQuotation() {
    return EntityFactory.makeBuyQuotationEntity();
  }

  group('SaveBuyQuotationController', () {
    test(
      'save should call repository and invalidate both providers on SUCCESS',
      () async {
        // ARRANGE
        final validQuotation = createValidBuyQuotation();
        final mockBuyQuotationsNotifier = MockBuyQuotationsStateController();
        final container = makeProviderContainer(
          buyQuotationInput: validQuotation,
          session: fakeSession,
          mockBuyQuotationsNotifier: mockBuyQuotationsNotifier,
        );
        addTearDown(container.dispose);

        await container.read(
          saveBuyQuotationControllerProvider(
            fakeEnterpriseCode,
            fakeCode,
          ).future,
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          saveBuyQuotationControllerProvider(fakeEnterpriseCode, fakeCode),
          (_, next) => states.add(next),
        );

        // ACT
        final saved = await container
            .read(
              saveBuyQuotationControllerProvider(
                fakeEnterpriseCode,
                fakeCode,
              ).notifier,
            )
            .save();

        // ASSERT
        // 1. Verify state transitions (Loading -> Data)
        expect(states, [isA<AsyncLoading>()]);
        expect(saved, isTrue);

        // 2. Verify repository call with the correct entity
        verify(
          () => mockRepository.insertUpdate(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            buyQuotation: validQuotation,
          ),
        ).called(1);

        // 3. Verify side-effect: Invalidation of the list provider
        // (Checking the spy flag after the future completes)
        expect(
          mockBuyQuotationsNotifier.wasRebuilt,
          isTrue,
          reason:
              'The buyQuotationsStateControllerProvider should have been invalidated.',
        );
      },
    );

    // --- Failure Tests: Validation ---

    test('save should throw AppException if Buyer is null', () async {
      // ARRANGE
      final invalidQuotation = createValidBuyQuotation().annulValues(
        annulBuyer: true,
      );
      final container = makeProviderContainer(
        buyQuotationInput: invalidQuotation,
        session: fakeSession,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      final saved = await container
          .read(
            saveBuyQuotationControllerProvider(
              fakeEnterpriseCode,
              fakeCode,
            ).notifier,
          )
          .save();

      // Expect the AppException to be thrown
      expect(saved, isFalse);

      // Verify state transitioned to error
      expect(
        container
            .read(
              saveBuyQuotationControllerProvider(fakeEnterpriseCode, fakeCode),
            )
            .hasError,
        isTrue,
      );
      expect(
        container
            .read(
              saveBuyQuotationControllerProvider(fakeEnterpriseCode, fakeCode),
            )
            .error
            .toString(),
        isNotEmpty,
      );

      // Verify repository was NOT called
      verifyNever(
        () => mockRepository.insertUpdate(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          buyQuotation: any(named: 'buyQuotation'),
        ),
      );
    });

    test(
      'save should throw AppException if Enterprises list is empty',
      () async {
        // ARRANGE
        final invalidQuotation = createValidBuyQuotation().annulValues(
          annulEnterprises: true,
        );
        final container = makeProviderContainer(
          buyQuotationInput: invalidQuotation,
          session: fakeSession,
        );
        addTearDown(container.dispose);

        // ACT & ASSERT
        final udpated = await container
            .read(
              saveBuyQuotationControllerProvider(
                fakeEnterpriseCode,
                fakeCode,
              ).notifier,
            )
            .save();

        expect(udpated, isFalse);

        // Verify state transitioned to error
        expect(
          container
              .read(
                saveBuyQuotationControllerProvider(
                  fakeEnterpriseCode,
                  fakeCode,
                ),
              )
              .hasError,
          isTrue,
        );
        expect(
          container
              .read(
                saveBuyQuotationControllerProvider(
                  fakeEnterpriseCode,
                  fakeCode,
                ),
              )
              .error
              .toString(),
          contains('Ao menos uma empresa deve ser informada'),
        );
      },
    );

    test('save should throw AppException if Products list is null', () async {
      // ARRANGE
      final invalidQuotation = createValidBuyQuotation().annulValues(
        annulProducts: true,
      );
      final container = makeProviderContainer(
        buyQuotationInput: invalidQuotation,
        session: fakeSession,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      final updated = await container
          .read(
            saveBuyQuotationControllerProvider(
              fakeEnterpriseCode,
              fakeCode,
            ).notifier,
          )
          .save();

      expectLater(updated, isFalse);

      // Verify state transitioned to error
      expect(
        container
            .read(
              saveBuyQuotationControllerProvider(fakeEnterpriseCode, fakeCode),
            )
            .hasError,
        isTrue,
      );
      expect(
        container
            .read(
              saveBuyQuotationControllerProvider(fakeEnterpriseCode, fakeCode),
            )
            .error
            .toString(),
        contains('Ao menos um produto deve ser informado'),
      );
    });

    // --- Failure Tests: Dependencies and Repository ---

    test(
      'save should emit [loading, error] if validatedUserSession is invalid',
      () async {
        // ARRANGE
        final validQuotation = createValidBuyQuotation();
        final container = makeProviderContainer(
          buyQuotationInput: validQuotation,
          session: null, // Invalid session
        );
        addTearDown(container.dispose);

        // ACT & ASSERT
        final updated = await container
            .read(
              saveBuyQuotationControllerProvider(
                fakeEnterpriseCode,
                fakeCode,
              ).notifier,
            )
            .save();

        expectLater(updated, isFalse);

        // Verify state transitioned to error
        expect(
          container
              .read(
                saveBuyQuotationControllerProvider(
                  fakeEnterpriseCode,
                  fakeCode,
                ),
              )
              .hasError,
          isTrue,
        );
        expect(
          container
              .read(
                saveBuyQuotationControllerProvider(
                  fakeEnterpriseCode,
                  fakeCode,
                ),
              )
              .error
              .toString(),
          isNotEmpty,
        );

        // Verify repository was NOT called
        verifyNever(
          () => mockRepository.insertUpdate(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            buyQuotation: any(named: 'buyQuotation'),
          ),
        );
      },
    );

    test('save should emit [loading, error] if repository fails', () async {
      // ARRANGE
      final exception = Exception('Repository write failed');
      when(
        () => mockRepository.insertUpdate(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          buyQuotation: any(named: 'buyQuotation'),
        ),
      ).thenThrow(exception);

      final validQuotation = createValidBuyQuotation();
      final container = makeProviderContainer(
        buyQuotationInput: validQuotation,
        session: fakeSession,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      final updated = await container
          .read(
            saveBuyQuotationControllerProvider(
              fakeEnterpriseCode,
              fakeCode,
            ).notifier,
          )
          .save();

      expect(updated, isFalse);

      // Verify state transitioned to error
      expect(
        container
            .read(
              saveBuyQuotationControllerProvider(fakeEnterpriseCode, fakeCode),
            )
            .hasError,
        isTrue,
      );
      expect(
        container
            .read(
              saveBuyQuotationControllerProvider(fakeEnterpriseCode, fakeCode),
            )
            .error,
        exception,
      );
    });
  });
}
