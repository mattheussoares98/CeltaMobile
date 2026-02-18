import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/adjust_stock/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

class FakeStockTypeStateController extends StockTypeStateController {
  final List<StockTypeEntity> stocks;
  FakeStockTypeStateController(this.stocks);

  @override
  Future<List<StockTypeEntity>> build(int arg) async => stocks;
}

class FakeSelectedUIStateController extends SelectedUIStateController {
  final SelectedItemUIState? value;
  FakeSelectedUIStateController(this.value);

  @override
  SelectedItemUIState build(int enterpriseCode) =>
      value ?? SelectedItemUIState.empty();
}

void main() {
  late Faker fakerInstance;
  late TransferJustificationEntity? selectedJustification;
  late StockTypeEntity? selectedStockType;
  late int enterpriseCode;
  late List<StockTypeEntity> fakeStocks;
  late UserSessionModel userSession;

  setUp(() {
    fakerInstance = Faker();

    selectedJustification = EntityFactory.makeTransferJustificationEntity()
        .annulValues(annulCodigoInterno_TipoEstoque: true);
    selectedStockType = EntityFactory.makeStockTypeEntity();
    enterpriseCode = fakerInstance.randomGenerator.integer(100);
    fakeStocks = [
      EntityFactory.makeStockTypeEntity(),
      EntityFactory.makeStockTypeEntity(),
    ];
    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
  });

  ProviderContainer makeProviderContainer({SelectedItemUIState? state}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        // 2. Override the internal provider dependency
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(userSession),
        ),
        stockTypeStateControllerProvider(
          enterpriseCode,
        ).overrideWith(() => FakeStockTypeStateController(fakeStocks)),
        selectedUIStateControllerProvider(enterpriseCode).overrideWith(
          () => FakeSelectedUIStateController(
            state ?? SelectedItemUIState.empty(),
          ),
        ),
      ],
    );
  }

  group('SelectedUIStateController', () {
    test(
      'build should return SelectedItemUIState.empty() as initial state',
      () {
        // Act
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        final state = container.read(
          selectedUIStateControllerProvider(enterpriseCode),
        );

        // Assert
        expect(state, SelectedItemUIState.empty());
        expect(state.selectedIndex, isNull);
      },
    );

    test(
      'udpateValues should replace the current state with the provided value',
      () async {
        // Arrange
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(
          selectedUIStateControllerProvider(enterpriseCode).notifier,
        );
        final newState = SelectedItemUIState(
          selectedIndex: fakerInstance.randomGenerator.integer(100),
          selectedJustification: selectedJustification,
          selectedStockType: selectedStockType,
        );

        final states = <SelectedItemUIState>[];
        container.listen(
          selectedUIStateControllerProvider(enterpriseCode),
          (_, next) => states.add(next),
        );

        // Act
        await notifier.updateValues(
          selectedIndex: newState.selectedIndex,
          selectedJustification: newState.selectedJustification,
          selectedStockType: newState.selectedStockType,
        );

        expect(states, [newState]);
      },
    );

    test(
      'multiple udpateValues calls should result in the last provided state',
      () async {
        // Arrange
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(
          selectedUIStateControllerProvider(enterpriseCode).notifier,
        );
        final firstState = SelectedItemUIState(
          selectedIndex: fakerInstance.randomGenerator.integer(10),
          selectedJustification: EntityFactory.makeTransferJustificationEntity()
              .annulValues(annulCodigoInterno_TipoEstoque: true),
          selectedStockType: EntityFactory.makeStockTypeEntity(),
        );
        final secondState = SelectedItemUIState(
          selectedIndex: fakerInstance.randomGenerator.integer(20, min: 11),
          selectedJustification: EntityFactory.makeTransferJustificationEntity()
              .annulValues(annulCodigoInterno_TipoEstoque: true),
          selectedStockType: EntityFactory.makeStockTypeEntity(),
        );

        // Act
        await notifier.updateValues(
          selectedIndex: firstState.selectedIndex,
          selectedJustification: firstState.selectedJustification,
          selectedStockType: firstState.selectedStockType,
        );
        await notifier.updateValues(
          selectedIndex: secondState.selectedIndex,
          selectedJustification: secondState.selectedJustification,
          selectedStockType: secondState.selectedStockType,
        );

        // Assert
        final finalState = container.read(
          selectedUIStateControllerProvider(enterpriseCode),
        );
        expect(finalState, secondState);
        expect(finalState.selectedIndex, isNot(firstState.selectedIndex));
      },
    );
    test(
      'should annul the selectedIndex if pass the same value as param',
      () async {
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(
          selectedUIStateControllerProvider(enterpriseCode).notifier,
        );
        final firstState = SelectedItemUIState(
          selectedIndex: fakerInstance.randomGenerator.integer(10),
          selectedJustification: EntityFactory.makeTransferJustificationEntity()
              .annulValues(annulCodigoInterno_TipoEstoque: true),
          selectedStockType: EntityFactory.makeStockTypeEntity(),
        );

        // Act
        await notifier.updateValues(
          selectedIndex: firstState.selectedIndex,
          selectedJustification: firstState.selectedJustification,
          selectedStockType: firstState.selectedStockType,
        );
        await notifier.updateValues(selectedIndex: firstState.selectedIndex);

        // Assert
        final finalState = container.read(
          selectedUIStateControllerProvider(enterpriseCode),
        );
        expect(finalState.selectedIndex, isNull);
        expect(finalState.selectedIndex, isNot(firstState.selectedIndex));
      },
    );
    test(
      'should update automatically the selected stock when the justification has a fixed stock',
      () async {
        // Arrange
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(
          selectedUIStateControllerProvider(enterpriseCode).notifier,
        );

        // Act
        await notifier.updateValues(
          selectedJustification: EntityFactory.makeTransferJustificationEntity(
            CodigoInterno_TipoEstoque:
                fakeStocks.first.CodigoInterno_TipoEstoque,
          ),
        );
        final firstState = container.read(
          selectedUIStateControllerProvider(enterpriseCode),
        );
        expect(firstState.selectedStockType, fakeStocks.first);
      },
    );
    test('should not update properties that wasnt passed', () async {
      // Arrange
      final container = makeProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(
        selectedUIStateControllerProvider(enterpriseCode).notifier,
      );

      final state = SelectedItemUIState(
        selectedIndex: faker.randomGenerator.integer(100),
        selectedJustification: selectedJustification,
        selectedStockType: selectedStockType,
      );

      await notifier.updateValues(
        selectedIndex: state.selectedIndex,
        selectedJustification: state.selectedJustification,
        selectedStockType: state.selectedStockType,
      );
      await notifier.updateValues();
      final currentState = container.read(
        selectedUIStateControllerProvider(enterpriseCode),
      );
      expect(currentState.selectedIndex, state.selectedIndex);
      expect(currentState.selectedJustification, state.selectedJustification);
      expect(currentState.selectedStockType, state.selectedStockType);
    });

    test(
      'should annul the selectedIndex if pass true value for annulSelectedIndex',
      () async {
        // Arrange
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(
          selectedUIStateControllerProvider(enterpriseCode).notifier,
        );

        final state = SelectedItemUIState(
          selectedIndex: faker.randomGenerator.integer(100),
          selectedJustification: selectedJustification,
          selectedStockType: selectedStockType,
        );
        await notifier.updateValues(
          selectedIndex: state.selectedIndex,
          selectedJustification: state.selectedJustification,
          selectedStockType: state.selectedStockType,
        );

        final currentState1 = container.read(
          selectedUIStateControllerProvider(enterpriseCode),
        );
        expect(currentState1.selectedIndex, state.selectedIndex);
        expect(
          currentState1.selectedJustification,
          state.selectedJustification,
        );
        expect(currentState1.selectedStockType, state.selectedStockType);

        await notifier.updateValues(annulSelectedIndex: true);
        final currentState2 = container.read(
          selectedUIStateControllerProvider(enterpriseCode),
        );
        expect(currentState2.selectedIndex, isNull);
      },
    );
  });
}
