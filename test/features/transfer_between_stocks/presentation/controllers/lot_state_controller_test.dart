import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_between_stocks/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// 1. Create a Mock for the repository dependency
class MockLocalItemsLotRepository extends Mock
    implements ILocalItemsLotRepository {}

class FakeSelectedUIStateController extends SelectedProductUIStateController {
  final SelectedProductUIStateEntity initialState;
  FakeSelectedUIStateController(this.initialState);

  @override
  SelectedProductUIStateEntity build(int enterpriseCode) => initialState;
}

void main() {
  late MockLocalItemsLotRepository mockRepository;
  late List<ProductLotInfoEntity> fakeLot;
  late ProductEntity fakeProduct;
  late int enterpriseCode;
  late SelectedProductUIStateEntity fakeUIState;
  late double fakeQuantity;

  setUp(() {
    mockRepository = MockLocalItemsLotRepository();
    fakeLot = [
      EntityFactory.makeProductLotInfoEntity(),
      EntityFactory.makeProductLotInfoEntity(),
    ];
    fakeQuantity = faker.randomGenerator.decimal();
    enterpriseCode = faker.randomGenerator.integer(100);
    fakeUIState = SelectedProductUIStateEntity(
      selectedJustification: EntityFactory.makeTransferJustificationEntity(),
      selectedOriginStock: EntityFactory.makeStockTypeEntity(),
      selectedDestinyStock: EntityFactory.makeStockTypeEntity(),
      productIndex: null,
      pageIndex: 0,
    );
    fakeProduct = EntityFactory.makeProductEntity();

    // Register fallback value for mocktail's `any()` matcher
    registerFallbackValue(EntityFactory.makeProductLotInfoEntity());
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localItemsLotRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  }

  group('LotStateController', () {
    group('build', () {
      test(
        'should call repository.load and return a list on success',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(enterpriseCode),
          ).thenAnswer((_) async => fakeLot);

          final container = makeProviderContainer();
          addTearDown(container.dispose);

          // ACT: Wait for the build method to complete
          final result = await container.read(
            lotStateControllerProvider(enterpriseCode).future,
          );

          // ASSERT
          expect(result, fakeLot);
          verify(() => mockRepository.load(enterpriseCode)).called(1);
        },
      );
    });

    group('addItem', () {
      test(
        'should emit [loading, data] and add the item to the list',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(any()),
          ).thenAnswer((_) async => fakeLot);
          when(() => mockRepository.addItem(any())).thenAnswer((_) async {});

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            lotStateControllerProvider(enterpriseCode).future,
          ); // Wait for initial build

          final states = <AsyncValue<List<ProductLotInfoEntity>>>[];
          container.listen(
            lotStateControllerProvider(enterpriseCode),
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(lotStateControllerProvider(enterpriseCode).notifier)
              .addItem(
                product: fakeProduct,
                quantity: fakeQuantity,
                selectedJustification: fakeUIState.selectedJustification!,
                selectedOriginStock: fakeUIState.selectedOriginStock!,
                selectedDestinyStock: fakeUIState.selectedDestinyStock!,
              );

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          // 3. Verify final list length (2 initial + 1 added)
          expect(states.last.value, hasLength(3));
          verify(
            () => mockRepository.addItem(
              ProductLotInfoEntity(
                product: fakeProduct,
                selectedJustification: fakeUIState.selectedJustification!,
                selectedOriginStock: fakeUIState.selectedOriginStock!,
                selectedDestinyStock: fakeUIState.selectedDestinyStock!,
                quantity: fakeQuantity,
              ),
            ),
          ).called(1);
        },
      );
    });

    group('removeItem', () {
      test(
        'should emit [loading, data] and remove the item from the list',
        () async {
          // ARRANGE
          final itemToRemove = fakeLot.first;
          when(
            () => mockRepository.load(any()),
          ).thenAnswer((_) async => fakeLot);
          when(() => mockRepository.removeItem(any())).thenAnswer((_) async {});

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            lotStateControllerProvider(enterpriseCode).future,
          );

          final states = <AsyncValue<List<ProductLotInfoEntity>>>[];
          container.listen(
            lotStateControllerProvider(enterpriseCode),
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(lotStateControllerProvider(enterpriseCode).notifier)
              .removeItem(itemToRemove);

          // ASSERT
          expect(states, [isA<AsyncData>()]);
          expect(states.last.value, hasLength(1));
          expect(
            states.last.value!.any(
              (item) =>
                  item.product.ProductPackingCode ==
                  itemToRemove.product.ProductPackingCode,
            ),
            isFalse,
          );
          verify(() => mockRepository.removeItem(itemToRemove)).called(1);
        },
      );
    });

    group('clearLot', () {
      test('should emit [loading, data] with an empty list', () async {
        // ARRANGE
        when(() => mockRepository.load(any())).thenAnswer((_) async => fakeLot);
        when(() => mockRepository.clear(any())).thenAnswer((_) async {});

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(lotStateControllerProvider(enterpriseCode).future);

        final states = <AsyncValue<List<ProductLotInfoEntity>>>[];
        container.listen(
          lotStateControllerProvider(enterpriseCode),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(lotStateControllerProvider(enterpriseCode).notifier)
            .clearLot(enterpriseCode);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, isEmpty);
        verify(() => mockRepository.clear(enterpriseCode)).called(1);
      });
    });
  });
}
