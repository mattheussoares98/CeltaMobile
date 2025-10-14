import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_intelligence/features/expedition_conference/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/expedition_conference/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapLoadPendingProductsRepository extends Mock
    implements ISoapLoadPendingProductsRepository {}

class FakeConfirmConferenceController extends ConfirmConferenceController {
  bool wasCalled = false;
  int? expeditionCode;
  int? stepCode;

  @override
  Future<bool> confirm({
    required int expeditionControlCode,
    required int stepCode,
  }) async {
    wasCalled = true;
    this.expeditionCode = expeditionControlCode;
    this.stepCode = stepCode;
    return true;
  }
}

void main() {
  late MockSoapLoadPendingProductsRepository mockRepository;

  late FakeConfirmConferenceController fakeConfirmController;

  late UserSessionModel fakeSession;
  late List<ExpeditionProductEntity> fakeProducts;
  late int expeditionControlCode;

  setUp(() {
    mockRepository = MockSoapLoadPendingProductsRepository();
    fakeConfirmController = FakeConfirmConferenceController();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeProducts = [
      EntityFactory.makeExpeditionProductEntity(),
      EntityFactory.makeExpeditionProductEntity(),
      EntityFactory.makeExpeditionProductEntity(),
    ];
    expeditionControlCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadPendingProductsRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        confirmConferenceControllerProvider(
          '',
        ).overrideWith(() => fakeConfirmController),
      ],
    );
  }

  group('Expedition Pending Products State Controller', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            expeditionControlCode: any(named: 'expeditionControlCode'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero); // Simulate async call
          return fakeProducts;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        await expectLater(
          container.read(
            expeditionConferenceControllerProvider(
              expeditionControlCode,
              '',
            ).future,
          ),
          completion(equals(ExpeditionConferenceState.initial(fakeProducts))),
        );

        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            expeditionControlCode: expeditionControlCode,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      final states = <AsyncValue<List<ExpeditionDocumentEntity>?>>[];
      container.listen(
        expeditionDocumentsStateControllerProvider(expeditionControlCode, ''),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      // ACT
      await container
          .read(
            expeditionDocumentsStateControllerProvider(
              expeditionControlCode,
              '',
            ).future,
          )
          .catchError((_) {
            return null;
          });

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          expeditionControlCode: any(named: 'expeditionControlCode'),
        ),
      );
    });
  });

  group('scanProduct', () {
    test(
      'should decrement pending quantity and not call confirm on a partial scan',
      () async {
        // ARRANGE
        // Create a product with a quantity of 2
        final productToScan = EntityFactory.makeExpeditionProductEntity(
          quantity: 2,
          productPackingCode: 123,
        );

        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            expeditionControlCode: any(named: 'expeditionControlCode'),
          ),
        ).thenAnswer((_) async => [productToScan]);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // Wait for the initial products to load
        await container.read(
          expeditionConferenceControllerProvider(
            expeditionControlCode,
            '',
          ).future,
        );

        final controller = container.read(
          expeditionConferenceControllerProvider(
            expeditionControlCode,
            '',
          ).notifier,
        );

        // ACT: Scan the product once
        const stepCodeForConfirmation = 4;
        controller.scanProduct(
          productToScan.ProductPackingCode,
          stepCodeForConfirmation,
        );

        // ASSERT

        final state = container.read(
          expeditionConferenceControllerProvider(expeditionControlCode, ''),
        );
        expect(
          state.value?.pendingQuantities[productToScan.ProductPackingCode],
          1,
        );
        expect(
          state.value?.scannedQuantities[productToScan.ProductPackingCode],
          1,
        );
        expect(fakeConfirmController.wasCalled, isFalse);
      },
    );

    test(
      'should call confirm controller when the last product is scanned',
      () async {
        // ARRANGE
        // Create a product with a quantity of 2
        final productToScan = EntityFactory.makeExpeditionProductEntity(
          quantity: 1,
          productPackingCode: 123,
        );

        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            expeditionControlCode: any(named: 'expeditionControlCode'),
          ),
        ).thenAnswer((_) async => [productToScan]);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // Wait for the initial products to load
        await container.read(
          expeditionConferenceControllerProvider(
            expeditionControlCode,
            '',
          ).future,
        );

        final controller = container.read(
          expeditionConferenceControllerProvider(
            expeditionControlCode,
            '',
          ).notifier,
        );

        // ACT: Scan the product once
        const stepCodeForConfirmation = 4;
        controller.scanProduct(
          productToScan.ProductPackingCode,
          stepCodeForConfirmation,
        );

        // ASSERT

        final state = container.read(
          expeditionConferenceControllerProvider(expeditionControlCode, ''),
        );
        expect(
          state.value?.pendingQuantities[productToScan.ProductPackingCode],
          0,
        );
        expect(
          state.value?.scannedQuantities[productToScan.ProductPackingCode],
          1,
        );
        expect(fakeConfirmController.wasCalled, isTrue);
      },
    );
  });
}
