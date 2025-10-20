import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/inventory/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/inventory/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapInventoryEntryQuantityRepository extends Mock
    implements ISoapInventoryEntryQuantityRepository {}

class MockSoapInventoryAnnulRepository extends Mock
    implements ISoapInventoryAnnulRepository {}

class SpyInventoryProductsStateController
    extends InventoryProductsStateController {
  final List<InventoryProductEntity> initialState;
  SpyInventoryProductsStateController(this.initialState);

  InventoryProductEntity? updatedProduct;

  @override
  Future<List<InventoryProductEntity>> build(int a, int b, int c) async =>
      initialState;

  @override
  void updateProduct(InventoryProductEntity product) {
    updatedProduct = product;
  }
}

void main() {
  late MockSoapInventoryEntryQuantityRepository mockEntryQuantityRepository;
  late ISoapInventoryAnnulRepository mockAnnulRepository;
  late UserSessionModel fakeSession;
  late int codigoInternoInvCont;
  late bool isSubtract;
  late int codigoInternoInventario;
  late int enterpriseCode;
  late SpyInventoryProductsStateController spyProductsController;
  late InventoryProductEntity fakeProduct;

  setUp(() {
    mockEntryQuantityRepository = MockSoapInventoryEntryQuantityRepository();
    mockAnnulRepository = MockSoapInventoryAnnulRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    codigoInternoInvCont = faker.randomGenerator.integer(1000);
    isSubtract = faker.randomGenerator.boolean();
    codigoInternoInventario = faker.randomGenerator.integer(1000);
    enterpriseCode = faker.randomGenerator.integer(1000);
    fakeProduct = EntityFactory.makeInventoryProductEntity();
    spyProductsController = SpyInventoryProductsStateController([fakeProduct]);
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapInventoryEntryQuantityRepositoryProvider.overrideWithValue(
          mockEntryQuantityRepository,
        ),
        soapInventoryAnnulRepositoryProvider.overrideWithValue(
          mockAnnulRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ).overrideWith(() => spyProductsController),
      ],
    );
  }

  group('EntryQuantityController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockEntryQuantityRepository.entry(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
            productPackingCode: any(named: 'productPackingCode'),
            quantity: any(named: 'quantity'),
            isSubtract: any(named: 'isSubtract'),
          ),
        ).thenAnswer((_) async => {});

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        await container.read(
          entryQuantityStateControllerProvider(codigoInternoInvCont).future,
        );
        final states = <AsyncValue<LastChangedProductEntity?>>[];
        container.listen(
          entryQuantityStateControllerProvider(codigoInternoInvCont),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              entryQuantityStateControllerProvider(
                codigoInternoInvCont,
              ).notifier,
            )
            .entry(
              codigoInternoProEmb: fakeProduct.codigoInternoProEmb,
              quantity: fakeProduct.quantidadeInvContProEmb!,
              isSubtract: isSubtract,
              codigoInternoInventario: codigoInternoInventario,
              enterpriseCode: enterpriseCode,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(
          states.last.value,
          LastChangedProductEntity(
            codigoInternoProEmb: fakeProduct.codigoInternoProEmb,
            quantity: fakeProduct.quantidadeInvContProEmb!,
            isSubtract: isSubtract,
          ),
        );
        verify(
          () => mockEntryQuantityRepository.entry(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            quantity: fakeProduct.quantidadeInvContProEmb!,
            productPackingCode: fakeProduct.codigoInternoProEmb,
            isSubtract: isSubtract,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path in the Fake
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      await container.read(
        entryQuantityStateControllerProvider(codigoInternoInvCont).future,
      );
      final states = <AsyncValue<LastChangedProductEntity?>>[];
      container.listen(
        entryQuantityStateControllerProvider(codigoInternoInvCont),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            entryQuantityStateControllerProvider(codigoInternoInvCont).notifier,
          )
          .entry(
            codigoInternoInventario: codigoInternoInventario,
            enterpriseCode: enterpriseCode,
            codigoInternoProEmb: fakeProduct.codigoInternoProEmb,
            quantity: fakeProduct.quantidadeInvContProEmb!,
            isSubtract: isSubtract,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockEntryQuantityRepository.entry(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
          productPackingCode: any(named: 'productPackingCode'),
          quantity: any(named: 'quantity'),
          isSubtract: any(named: 'isSubtract'),
        ),
      );
    });

    test(
      'should call updateProduct on the products controller with the new quantity',
      () async {
        // ARRANGE
        when(
          () => mockEntryQuantityRepository.entry(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
            productPackingCode: any(named: 'productPackingCode'),
            quantity: any(named: 'quantity'),
            isSubtract: any(named: 'isSubtract'),
          ),
        ).thenAnswer((_) async => {});

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final quantityToAdd = faker.randomGenerator.decimal();
        await container
            .read(
              entryQuantityStateControllerProvider(
                codigoInternoInvCont,
              ).notifier,
            )
            .entry(
              codigoInternoProEmb: fakeProduct.codigoInternoProEmb,
              quantity: quantityToAdd,
              isSubtract: isSubtract,
              enterpriseCode:
                  enterpriseCode, // Pass dummy values for the family params
              codigoInternoInventario: codigoInternoInventario,
            );

        // ASSERT
        // 1. Verify the repository was called.
        verify(
          () => mockEntryQuantityRepository.entry(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            productPackingCode: fakeProduct.codigoInternoProEmb,
            quantity: quantityToAdd,
            isSubtract: isSubtract,
          ),
        ).called(1);

        // 2. Check the public property on our Spy object.
        expect(spyProductsController.updatedProduct, isNotNull);
        // 3. Check that the new quantity is correct (initial 5.0 + added 10.0)
        expect(
          spyProductsController.updatedProduct!.quantidadeInvContProEmb,
          isSubtract
              ? fakeProduct.quantidadeInvContProEmb! - quantityToAdd
              : fakeProduct.quantidadeInvContProEmb! + quantityToAdd,
        );
      },
    );
    test(
      'should emit error when the new quantity is going to be negative',
      () async {
        // ARRANGE
        when(
          () => mockEntryQuantityRepository.entry(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
            productPackingCode: any(named: 'productPackingCode'),
            quantity: any(named: 'quantity'),
            isSubtract: any(named: 'isSubtract'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        await container.read(
          entryQuantityStateControllerProvider(codigoInternoInvCont).future,
        );
        final states = <AsyncValue<LastChangedProductEntity?>>[];
        container.listen(
          entryQuantityStateControllerProvider(codigoInternoInvCont),
          (_, next) => states.add(next),
        );

        // ACT
        final quantityToAdd = fakeProduct.quantidadeInvContProEmb! * 2;
        await container
            .read(
              entryQuantityStateControllerProvider(
                codigoInternoInvCont,
              ).notifier,
            )
            .entry(
              codigoInternoProEmb: fakeProduct.codigoInternoProEmb,
              quantity: quantityToAdd,
              isSubtract: true,
              enterpriseCode:
                  enterpriseCode, // Pass dummy values for the family params
              codigoInternoInventario: codigoInternoInventario,
            );

        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);

        // ASSERT
        // 1. Verify the repository was called.
        verifyNever(
          () => mockEntryQuantityRepository.entry(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
            productPackingCode: any(named: 'productPackingCode'),
            quantity: any(named: 'quantity'),
            isSubtract: any(named: 'isSubtract'),
          ),
        );
      },
    );
  });

  group('annul', () {
    test(
      'should emit [loading, data(null)] and call repository on success',
      () async {
        // Stub its 'annul' method to succeed
        when(
          () => mockAnnulRepository.annul(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
            codigoInternoProEmb: any(named: 'codigoInternoProEmb'),
          ),
        ).thenAnswer((_) async => {});

        final container = makeProviderContainer(session: fakeSession);
        // Override the annul repository provider for this specific test

        addTearDown(container.dispose);

        // Let the initial build finish
        await container.read(
          entryQuantityStateControllerProvider(codigoInternoInvCont).future,
        );

        final states = <AsyncValue<LastChangedProductEntity?>>[];
        container.listen(
          entryQuantityStateControllerProvider(codigoInternoInvCont),
          (_, next) => states.add(next),
        );

        // ACT: Call the annul method
        await container
            .read(
              entryQuantityStateControllerProvider(
                codigoInternoInvCont,
              ).notifier,
            )
            .annul(
              fakeProduct.codigoInternoProEmb,
              enterpriseCode,
              codigoInternoInventario,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        // The final state should be data with a null value
        expect(states.last.value, isNull);

        // Verify the repository was called correctly
        verify(
          () => mockAnnulRepository.annul(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            codigoInternoProEmb: fakeProduct.codigoInternoProEmb,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the failure path
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);
      await container.read(
        entryQuantityStateControllerProvider(codigoInternoInvCont).future,
      );

      final states = <AsyncValue<LastChangedProductEntity?>>[];
      container.listen(
        entryQuantityStateControllerProvider(codigoInternoInvCont),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            entryQuantityStateControllerProvider(codigoInternoInvCont).notifier,
          )
          .annul(
            fakeProduct.codigoInternoProEmb,
            enterpriseCode,
            codigoInternoInventario,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });

    test(
      'should call updateProduct on the products controller with the new quantity',
      () async {
        when(
          () => mockAnnulRepository.annul(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
            codigoInternoProEmb: any(named: 'codigoInternoProEmb'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
        });

        final container = makeProviderContainer(session: fakeSession);
        // Override the annul repository provider for this specific test

        addTearDown(container.dispose);

        // Let the initial build finish
        await container.read(
          entryQuantityStateControllerProvider(codigoInternoInvCont).future,
        );

        final states = <AsyncValue<LastChangedProductEntity?>>[];
        container.listen(
          entryQuantityStateControllerProvider(codigoInternoInvCont),
          (_, next) => states.add(next),
        );

        // ACT: Call the annul method
        await container
            .read(
              entryQuantityStateControllerProvider(
                codigoInternoInvCont,
              ).notifier,
            )
            .annul(
              fakeProduct.codigoInternoProEmb,
              enterpriseCode,
              codigoInternoInventario,
            );

        // ASSERT
        // 1. Verify the repository was called.
        verify(
          () => mockAnnulRepository.annul(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            codigoInternoProEmb: fakeProduct.codigoInternoProEmb,
          ),
        ).called(1);

        // 2. Check the public property on our Spy object.
        expect(spyProductsController.updatedProduct, isNotNull);
        // 3. Check that the new quantity is correct (initial 5.0 + added 10.0)
        expect(
          spyProductsController.updatedProduct!.quantidadeInvContProEmb,
          null,
        );
      },
    );
  });
}
