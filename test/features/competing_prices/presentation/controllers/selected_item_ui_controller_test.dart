import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(retry: (retryCount, error) => null);
    addTearDown(container.dispose);
  });

  setUpAll(() {
    for (var value in SearchProductCompetingPriceType.values) {
      registerFallbackValue(value);
    }
  });

  group('SelectedItemUIController', () {
    group('build', () {
      test('build start the state with correct initial state', () {
        // ARRANGE / ACT: Read the initial state. Since build is synchronous,
        // we read the provider directly, not the future.
        final state = container.read(selectedItemUIControllerProvider);

        // ASSERT
        expect(state, const SelectedItemUIState());
      });
    });

    group('updateSelectedIndex', () {
      test('should update selectedIndex when is different from previous', () {
        // ARRANGE
        final notifier = container.read(
          selectedItemUIControllerProvider.notifier,
        );
        const newIndex = 1;

        // ACT
        notifier.updateSelectedIndex(newIndex);

        // ASSERT
        expect(
          container.read(selectedItemUIControllerProvider).selectedIndex,
          newIndex,
        );
      });

      test('clean the selected index when select the same', () {
        // ARRANGE
        final notifier = container.read(
          selectedItemUIControllerProvider.notifier,
        );

        final index = faker.randomGenerator.integer(100);

        // ACT
        notifier.updateSelectedIndex(index);
        expect(
          container.read(selectedItemUIControllerProvider).selectedIndex,
          index,
        );

        //change again
        notifier.updateSelectedIndex(index);

        expect(
          container.read(selectedItemUIControllerProvider).selectedIndex,
          isNull,
        );
      });

      test('should update to null when pass null value', () {
        // ARRANGE
        final notifier = container.read(
          selectedItemUIControllerProvider.notifier,
        );

        // ACT
        notifier.updateSelectedIndex(faker.randomGenerator.integer(100));
        expect(
          container.read(selectedItemUIControllerProvider).selectedIndex,
          isNotNull,
        );

        notifier.updateSelectedIndex(null);
        expect(
          container.read(selectedItemUIControllerProvider).selectedIndex,
          isNull,
        );
      });
    });

    group('updateSearchType', () {
      test('should update searchType correctly', () {
        // ARRANGE
        final notifier = container.read(
          selectedItemUIControllerProvider.notifier,
        );
        final searchType =
            SearchProductCompetingPriceType.values[faker.randomGenerator
                .integer(SearchProductCompetingPriceType.values.length)];

        // ACT
        notifier.updateSearchType(searchType);

        // ASSERT
        expect(
          container.read(selectedItemUIControllerProvider).searchType,
          searchType,
        );
      });
    });

    group('updateOnlyAssociateds', () {
      test('should update onlyAssociateds correctly', () {
        // ARRANGE
        final notifier = container.read(
          selectedItemUIControllerProvider.notifier,
        );

        // ACT
        notifier.updateOnlyAssociateds(false);

        // ASSERT
        expect(
          container.read(selectedItemUIControllerProvider).onlyAssociateds,
          isFalse,
        );

        // ACT
        notifier.updateOnlyAssociateds(true);

        // ASSERT
        expect(
          container.read(selectedItemUIControllerProvider).onlyAssociateds,
          isTrue,
        );
      });
    });
  });
}
