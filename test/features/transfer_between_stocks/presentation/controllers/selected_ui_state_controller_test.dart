import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/stock/stock.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks ---

class FakeStockTypeStateController extends StockTypeStateController {
  final List<StockTypeEntity> stocks;
  FakeStockTypeStateController(this.stocks);

  @override
  Future<List<StockTypeEntity>> build(int enterpriseCode) async => stocks;
}

void main() {
  late ProviderContainer container;
  late int fakeEnterpriseCode;
  late List<StockTypeEntity> fakeStocks;

  setUp(() {
    fakeEnterpriseCode = faker.randomGenerator.integer(1000);

    // Create a list of stocks to simulate the lookup logic
    fakeStocks = [
      EntityFactory.makeStockTypeEntity(CodigoInterno_TipoEstoque: 10),
      EntityFactory.makeStockTypeEntity(CodigoInterno_TipoEstoque: 20),
    ];
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        // Override the stock provider so the UI controller can read the future
        stockTypeStateControllerProvider(
          fakeEnterpriseCode,
        ).overrideWith(() => FakeStockTypeStateController(fakeStocks)),
      ],
    );
  }

  group('SelectedUIStateController', () {
    test('build should return an empty state initially', () {
      container = makeProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(
        selectedUIStateControllerProvider(fakeEnterpriseCode),
      );

      expect(state, SelectedUIStateEntity.empty());
    });

    test(
      'updateValues should update all fields correctly when index is new',
      () async {
        // Arrange
        final justification = EntityFactory.makeTransferJustificationEntity()
            .annulValues(annulCodigoInterno_TipoEstoque: true);
        final originStock = EntityFactory.makeStockTypeEntity();
        final destinyStock = EntityFactory.makeStockTypeEntity();
        final productIndex = faker.randomGenerator.integer(100);
        final pageIndex = faker.randomGenerator.integer(100);

        container = makeProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        // Act
        await notifier.updateValues(
          justification: justification,
          originStock: originStock,
          destinyStock: destinyStock,
          productIndex: productIndex,
          pageIndex: pageIndex,
        );

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );

        expect(state.selectedJustification, justification);
        expect(state.selectedOriginStock, originStock);
        expect(state.selectedDestinyStock, destinyStock);
        expect(state.productIndex, productIndex);
        expect(state.pageIndex, pageIndex);
      },
    );

    test(
      'updateValues should automatically update originStock based on justification',
      () async {
        // Arrange
        // Create a justification that points to stock code 10
        final justificationWithStock =
            EntityFactory.makeTransferJustificationEntity(
              CodigoInterno_TipoEstoque: 10,
            );
        final wrongOriginStock = EntityFactory.makeStockTypeEntity(
          CodigoInterno_TipoEstoque: 999,
        );

        container = makeProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        // Act
        await notifier.updateValues(
          justification: justificationWithStock,
          originStock:
              wrongOriginStock, // This should be ignored because justification has a stock
        );

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );

        // Verification: originStock must be the one from the fakeStocks list with code 10
        expect(state.selectedOriginStock!.CodigoInterno_TipoEstoque, 10);
        expect(state.selectedJustification, justificationWithStock);
      },
    );

    test(
      'updateValues should toggle productIndex to null using annulValues when same index is passed',
      () async {
        // Arrange
        final productIndex = faker.randomGenerator.integer(100);
        container = makeProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        // Set initial index
        notifier.updateValues(productIndex: productIndex);
        expect(
          container
              .read(selectedUIStateControllerProvider(fakeEnterpriseCode))
              .productIndex,
          productIndex,
        );

        // Act: Passing the same index should trigger the toggle to null
        notifier.updateValues(productIndex: productIndex);

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );
        expect(state.productIndex, isNull);
      },
    );

    test(
      'updateValues should change to a different productIndex without nulling',
      () async {
        // Arrange
        const firstIndex = 1;
        const secondIndex = 2;
        container = makeProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        // Set first index
        notifier.updateValues(productIndex: firstIndex);

        // Act: Passing a different index should update the value
        notifier.updateValues(productIndex: secondIndex);

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );
        expect(state.productIndex, secondIndex);
      },
    );

    test(
      'updateValues should correctly handle passing null explicitly as productIndex',
      () async {
        // Arrange
        final initialIndex = faker.randomGenerator.integer(100);
        container = makeProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        notifier.updateValues(productIndex: initialIndex);

        // Act: Passing null explicitly
        notifier.updateValues(productIndex: null);

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );
        expect(state.productIndex, isNull);
      },
    );
  });
}
