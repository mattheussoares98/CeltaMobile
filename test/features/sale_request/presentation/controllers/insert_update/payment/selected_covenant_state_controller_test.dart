import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../mocks/mocks.dart';

void main() {
  group('SelectedCovenantStateController', () {
    setUp(() {});

    test('should have null as initial state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(selectedCovenantStateControllerProvider);

      expect(state, isNull);
    });

    test('should update state when select is called', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final covenant = faker.randomGenerator.boolean()
          ? EntityFactory.makeBsfCovenantEntity()
          : null;

      container
          .read(selectedCovenantStateControllerProvider.notifier)
          .select(covenant);

      final state = container.read(selectedCovenantStateControllerProvider);

      expect(state, covenant);
    });
  });
}
