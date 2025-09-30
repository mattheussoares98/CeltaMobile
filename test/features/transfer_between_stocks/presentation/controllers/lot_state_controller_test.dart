import 'package:celta_intelligence/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/presentation/controllers/lot_state_controller.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// 1. Create a Mock for the repository dependency
class MockLocalItemsLotRepository extends Mock
    implements ILocalItemsLotRepository {}

void main() {
  late MockLocalItemsLotRepository mockRepository;
  late List<ProductLotInfoEntity> fakeLot;
  late ProductLotInfoEntity newItem;
  late int enterpriseCode;

  setUp(() {
    mockRepository = MockLocalItemsLotRepository();
    fakeLot = [
      EntityFactory.makeProductLotInfoEntity(),
      EntityFactory.makeProductLotInfoEntity(),
    ];
    newItem = EntityFactory.makeProductLotInfoEntity();
    enterpriseCode = faker.randomGenerator.integer(100);

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
              .addItem(newItem);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          // Check that the final state contains the new item
          expect(states.last.value, hasLength(3));
          expect(
            states.last.value!.any(
              (item) =>
                  item.product.ProductPackingCode ==
                  newItem.product.ProductPackingCode,
            ),
            isTrue,
          );
          verify(() => mockRepository.addItem(newItem)).called(1);
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
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
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
