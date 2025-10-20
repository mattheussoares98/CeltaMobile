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
  late MockSoapInventoryEntryQuantityRepository mockRepository;
  late UserSessionModel fakeSession;
  late int codigoInternoInvCont;
  late bool isSubtract;
  late int codigoInternoInventario;
  late int enterpriseCode;
  late SpyInventoryProductsStateController spyProductsController;
  late InventoryProductEntity fakeProduct;

  setUp(() {
    mockRepository = MockSoapInventoryEntryQuantityRepository();
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
          mockRepository,
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
          () => mockRepository.entry(
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
          () => mockRepository.entry(
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
        () => mockRepository.entry(
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
          () => mockRepository.entry(
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
          () => mockRepository.entry(
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
  });
}
