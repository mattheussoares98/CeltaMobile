import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_intelligence/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  setUpAll(() {
    for (var value in SearchProductCompetingPriceType.values) {
      registerFallbackValue(value);
    }
  });

  group('SelectedItemUIController', () {
    test('build start the state with correct initial state', () {
      // ARRANGE / ACT: Read the initial state. Since build is synchronous,
      // we read the provider directly, not the future.
      final state = container.read(selectedItemUIControllerProvider);

      // ASSERT
      expect(state, const SelectedItemUIState());
    });

    test('update should replace the state with the new provided value', () {
      // ARRANGE
      final notifier = container.read(
        selectedItemUIControllerProvider.notifier,
      );

      final updatedState = SelectedItemUIState(
        selectedIndex: faker.randomGenerator.integer(100),
        searchType:
            SearchProductCompetingPriceType.values[faker.randomGenerator
                .integer(SearchProductCompetingPriceType.values.length)],
      );

      final states = <SelectedItemUIState>[];
      // Listen to capture the state change
      container.listen(
        selectedItemUIControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      notifier.update(updatedState);

      // ASSERT
      // 1. Verify the state transition list
      expect(states, [updatedState]);

      // 2. Verify the final state value
      expect(container.read(selectedItemUIControllerProvider), updatedState);
    });
    test('clean the selected index when select the same', () {
      // ARRANGE
      final notifier = container.read(
        selectedItemUIControllerProvider.notifier,
      );

      final updatedState = SelectedItemUIState(
        selectedIndex: faker.randomGenerator.integer(100),
        searchType:
            SearchProductCompetingPriceType.values[faker.randomGenerator
                .integer(SearchProductCompetingPriceType.values.length)],
      );

      final states = <SelectedItemUIState>[];
      // Listen to capture the state change
      container.listen(
        selectedItemUIControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      notifier.update(updatedState);
      //change again
      notifier.update(updatedState);

      // ASSERT
      // 1. Verify the state transition list
      expect(states, [
        updatedState,
        SelectedItemUIState(searchType: updatedState.searchType),
      ]);

      // 2. Verify the final state value
      expect(
        container.read(selectedItemUIControllerProvider),
        SelectedItemUIState(searchType: updatedState.searchType),
      );
    });
    test('Should update correctly when both indexes are null', () {
      // ARRANGE
      final notifier = container.read(
        selectedItemUIControllerProvider.notifier,
      );

      final updatedState = SelectedItemUIState(
        selectedIndex: null,
        searchType:
            SearchProductCompetingPriceType.values[faker.randomGenerator
                .integer(SearchProductCompetingPriceType.values.length)],
        onlyAssociateds: false,
      );

      final states = <SelectedItemUIState>[];
      // Listen to capture the state change
      container.listen(
        selectedItemUIControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      notifier.update(updatedState);

      // ASSERT
      // 1. Verify the state transition list
      expect(states, [updatedState]);

      // 2. Verify the final state value
      expect(
        container.read(selectedItemUIControllerProvider).onlyAssociateds,
        isFalse,
      );
    });
  });
}
