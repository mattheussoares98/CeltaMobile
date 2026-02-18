import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(retry: (retryCount, error) => null);
  });

  group('ExpeditionDocumentsStateController', () {
    test('build should return 0', () {
      // ARRANGE / ACT
      final state = container.read(pageIndexStateControllerProvider);

      // ASSERT
      expect(state, 0);
    });

    test('should update the index correctly', () {
      final first = faker.randomGenerator.integer(100);
      final second = faker.randomGenerator.integer(100);

      container
          .read(pageIndexStateControllerProvider.notifier)
          .updateIndex(first);
      expect(container.read(pageIndexStateControllerProvider), first);

      container
          .read(pageIndexStateControllerProvider.notifier)
          .updateIndex(second);
      expect(container.read(pageIndexStateControllerProvider), second);

      container
          .read(pageIndexStateControllerProvider.notifier)
          .updateIndex(second);
      expect(container.read(pageIndexStateControllerProvider), second);
    });
  });
}
