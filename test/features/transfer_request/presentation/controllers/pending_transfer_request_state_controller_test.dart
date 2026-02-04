import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// 1. Create a Mock for the repository dependency
class MockLocalCartRepository extends Mock implements ILocalCartRepository {}

void main() {
  late MockLocalCartRepository mockRepository;
  late DraftKey fakeDraftKey;
  late List<TransferRequestProductItemEntity> fakeItems;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(
      const DraftKey(
        requestTypeCode: 0,
        enterpriseOrigin: 0,
        enterpriseDestinyCode: 0,
      ),
    );
    registerFallbackValue(
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: 0,
        value: 0,
      ),
    );
    for (var value in CartAdditionStrategy.values) {
      registerFallbackValue(value);
    }
  });

  setUp(() {
    mockRepository = MockLocalCartRepository();
    fakeDraftKey = const DraftKey(
      requestTypeCode: 1,
      enterpriseOrigin: 1,
      enterpriseDestinyCode: 2,
    );
    fakeItems = [
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
      ),
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
      ),
    ];
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localCartRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  }

  group('TransferLotController', () {
    group('build', () {
      test(
        'should call repository.load and return a list on success',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(any()),
          ).thenAnswer((_) async => fakeItems);

          final container = makeProviderContainer();
          addTearDown(container.dispose);

          // ACT: Wait for the build method to complete
          final result = await container.read(
            cartProductsStateControllerProvider(fakeDraftKey).future,
          );

          // ASSERT
          expect(result, fakeItems);
          verify(() => mockRepository.load(fakeDraftKey)).called(1);
        },
      );
    });

    group('addItem', () {
      test(
        'should call repository.addItem with correct values and invalidate the state',
        () async {
          // ARRANGE
          // 1. Initial load
          when(
            () => mockRepository.load(fakeDraftKey),
          ).thenAnswer((_) async => fakeItems);
          // 2. addItem call
          when(
            () => mockRepository.addItem(any(), any(), any()),
          ).thenAnswer((_) async {});
          // 3. The second load (from invalidateSelf)
          when(
            () => mockRepository.load(fakeDraftKey),
          ).thenAnswer((_) async => fakeItems);
          final cartAdditionStrategy =
              CartAdditionStrategy.values[faker.randomGenerator.integer(
                CartAdditionStrategy.values.length,
              )];

          final container = makeProviderContainer();
          addTearDown(container.dispose);

          // Wait for the initial build
          await container.read(
            cartProductsStateControllerProvider(fakeDraftKey).future,
          );

          // ACT
          await container
              .read(cartProductsStateControllerProvider(fakeDraftKey).notifier)
              .addItem(fakeItems[1], cartAdditionStrategy);

          // ASSERT
          // Verify the repository methods were called
          verify(
            () => mockRepository.addItem(
              fakeDraftKey,
              fakeItems[1],
              cartAdditionStrategy,
            ),
          ).called(1);
          verify(
            () => mockRepository.load(fakeDraftKey),
          ).called(2); // Called once in build, once for invalidate

          // Verify the final state is the new list
          final finalState = container.read(
            cartProductsStateControllerProvider(fakeDraftKey),
          );
          expect(finalState.value, hasLength(2));
          expect(finalState.value, fakeItems);
        },
      );
    });

    group('removeItem', () {
      test(
        'should call repository.removeItem and invalidate the state',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(fakeDraftKey),
          ).thenAnswer((_) async => fakeItems);
          when(
            () => mockRepository.removeItem(fakeDraftKey, fakeItems[0]),
          ).thenAnswer((_) async {});
          when(
            () => mockRepository.load(fakeDraftKey),
          ).thenAnswer((_) async => [fakeItems[1]]); // Return the new list

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            cartProductsStateControllerProvider(fakeDraftKey).future,
          );

          // ACT
          await container
              .read(cartProductsStateControllerProvider(fakeDraftKey).notifier)
              .removeItem(fakeItems[0]);

          // ASSERT
          verify(
            () => mockRepository.removeItem(fakeDraftKey, fakeItems[0]),
          ).called(1);
          verify(() => mockRepository.load(fakeDraftKey)).called(2);

          final finalState = container.read(
            cartProductsStateControllerProvider(fakeDraftKey),
          );
          expect(finalState.value, hasLength(1));
          expect(finalState.value, [fakeItems[1]]);
        },
      );
    });

    group('clearLot', () {
      test('should call repository.clear and invalidate the state', () async {
        // ARRANGE
        when(
          () => mockRepository.load(fakeDraftKey),
        ).thenAnswer((_) async => [fakeItems[0]]);
        when(() => mockRepository.clear(fakeDraftKey)).thenAnswer((_) async {});
        when(
          () => mockRepository.load(fakeDraftKey),
        ).thenAnswer((_) async => []); // Return an empty list

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(
          cartProductsStateControllerProvider(fakeDraftKey).future,
        );

        // ACT
        await container
            .read(cartProductsStateControllerProvider(fakeDraftKey).notifier)
            .clearLot();

        // ASSERT
        verify(() => mockRepository.clear(fakeDraftKey)).called(1);
        verify(() => mockRepository.load(fakeDraftKey)).called(2);

        final finalState = container.read(
          cartProductsStateControllerProvider(fakeDraftKey),
        );
        expect(finalState.value, isEmpty);
      });
    });
  });
}
