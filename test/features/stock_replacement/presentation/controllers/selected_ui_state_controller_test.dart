import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/stock_replacement/domain/entities/entities.dart';
import 'package:celta_inventario/features/stock_replacement/presentation/controllers/controllers.dart';
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
  late StockTypeEntity? selectedStockType;
  late int enterpriseCode;
  late List<StockTypeEntity> fakeStocks;
  late UserSessionModel userSession;

  setUp(() {
    fakerInstance = Faker();

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
          selectedStockType: EntityFactory.makeStockTypeEntity(),
        );
        final secondState = SelectedItemUIState(
          selectedIndex: fakerInstance.randomGenerator.integer(20, min: 11),
          selectedStockType: EntityFactory.makeStockTypeEntity(),
        );

        // Act
        await notifier.updateValues(
          selectedIndex: firstState.selectedIndex,
          selectedStockType: firstState.selectedStockType,
        );
        await notifier.updateValues(
          selectedIndex: secondState.selectedIndex,
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
          selectedStockType: EntityFactory.makeStockTypeEntity(),
        );

        // Act
        await notifier.updateValues(
          selectedIndex: firstState.selectedIndex,
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

    test('should not update properties that wasnt passed', () async {
      // Arrange
      final container = makeProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(
        selectedUIStateControllerProvider(enterpriseCode).notifier,
      );

      final state = SelectedItemUIState(
        selectedIndex: faker.randomGenerator.integer(100),
        selectedStockType: selectedStockType,
      );

      await notifier.updateValues(
        selectedIndex: state.selectedIndex,
        selectedStockType: state.selectedStockType,
      );
      await notifier.updateValues();
      final currentState = container.read(
        selectedUIStateControllerProvider(enterpriseCode),
      );
      expect(currentState.selectedIndex, state.selectedIndex);
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
          selectedStockType: selectedStockType,
        );
        await notifier.updateValues(
          selectedIndex: state.selectedIndex,
          selectedStockType: state.selectedStockType,
        );

        final currentState1 = container.read(
          selectedUIStateControllerProvider(enterpriseCode),
        );
        expect(currentState1.selectedIndex, state.selectedIndex);
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
