import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/products/products.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/inventory/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/inventory/providers.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapInventoryEntryQuantityRepository extends Mock
    implements ISoapInventoryEntryQuantityRepository {}

class MockSoapInventoryAnnulRepository extends Mock
    implements ISoapInventoryAnnulRepository {}

void main() {
  late MockSoapInventoryEntryQuantityRepository mockEntryQuantityRepository;
  late ISoapInventoryAnnulRepository mockAnnulRepository;
  late UserSessionModel fakeSession;
  late int codigoInternoInvCont;
  late bool isSubtract;
  late int codigoInternoInventario;
  late int enterpriseCode;
  late FakeSearchProductsStateController spyProductsController;
  late ProductEntity fakeProduct;

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
    fakeProduct = EntityFactory.makeProductEntity();
    spyProductsController = FakeSearchProductsStateController([fakeProduct]);
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
        searchProductsStateControllerProvider(
          SearchProductKey(
            enterpriseCode,
            BsRoutine.generic,
            Modules.inventory,
            anotherKey: '$codigoInternoInvCont-$codigoInternoInventario',
          ),
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
            workingUrl: any(named: 'workingUrl'),
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
        final updated = await container
            .read(
              entryQuantityStateControllerProvider(
                codigoInternoInvCont,
              ).notifier,
            )
            .entry(
              codigoInternoProEmb: fakeProduct.codigoInternoProEmb!,
              quantity: fakeProduct.quantidadeInvContProEmb!,
              isSubtract: isSubtract,
              codigoInternoInventario: codigoInternoInventario,
              enterpriseCode: enterpriseCode,
            );
        expect(updated, isTrue);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(
          states.last.value,
          LastChangedProductEntity(
            codigoInternoProEmb: fakeProduct.codigoInternoProEmb!,
            quantity: fakeProduct.quantidadeInvContProEmb!,
            isSubtract: isSubtract,
          ),
        );
        verify(
          () => mockEntryQuantityRepository.entry(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            quantity: fakeProduct.quantidadeInvContProEmb!,
            productPackingCode: fakeProduct.codigoInternoProEmb!,
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
      final updated = await container
          .read(
            entryQuantityStateControllerProvider(codigoInternoInvCont).notifier,
          )
          .entry(
            codigoInternoInventario: codigoInternoInventario,
            enterpriseCode: enterpriseCode,
            codigoInternoProEmb: fakeProduct.codigoInternoProEmb!,
            quantity: fakeProduct.quantidadeInvContProEmb!,
            isSubtract: isSubtract,
          );

      expect(updated, isFalse);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockEntryQuantityRepository.entry(
          workingUrl: any(named: 'workingUrl'),
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
            workingUrl: any(named: 'workingUrl'),
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
        final quantityToAdd =
            (faker.randomGenerator.decimal() * (isSubtract ? 0.001 : 1000))
                //this split or multiplication avoid problem to turn the new quantity less than zero
                .toStringAsFixed(2)
                .toDouble()!;
        final updated = await container
            .read(
              entryQuantityStateControllerProvider(
                codigoInternoInvCont,
              ).notifier,
            )
            .entry(
              codigoInternoProEmb: fakeProduct.codigoInternoProEmb!,
              quantity: quantityToAdd,
              isSubtract: isSubtract,
              enterpriseCode:
                  enterpriseCode, // Pass dummy values for the family params
              codigoInternoInventario: codigoInternoInventario,
            );

        // ASSERT
        expect(updated, isTrue);
        // 1. Verify the repository was called.

        verify(
          () => mockEntryQuantityRepository.entry(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            productPackingCode: fakeProduct.codigoInternoProEmb!,
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
            workingUrl: any(named: 'workingUrl'),
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
        final updated = await container
            .read(
              entryQuantityStateControllerProvider(
                codigoInternoInvCont,
              ).notifier,
            )
            .entry(
              codigoInternoProEmb: fakeProduct.codigoInternoProEmb!,
              quantity: quantityToAdd,
              isSubtract: true,
              enterpriseCode:
                  enterpriseCode, // Pass dummy values for the family params
              codigoInternoInventario: codigoInternoInventario,
            );

        expect(updated, isFalse);

        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);

        // ASSERT
        // 1. Verify the repository was called.
        verifyNever(
          () => mockEntryQuantityRepository.entry(
            workingUrl: any(named: 'workingUrl'),
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
            workingUrl: any(named: 'workingUrl'),
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
              fakeProduct.codigoInternoProEmb!,
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
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            codigoInternoProEmb: fakeProduct.codigoInternoProEmb!,
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
            fakeProduct.codigoInternoProEmb!,
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
            workingUrl: any(named: 'workingUrl'),
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
              fakeProduct.codigoInternoProEmb!,
              enterpriseCode,
              codigoInternoInventario,
            );

        // ASSERT
        // 1. Verify the repository was called.
        verify(
          () => mockAnnulRepository.annul(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            codigoInternoProEmb: fakeProduct.codigoInternoProEmb!,
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
