import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart'; // Assuming EntityFactory is here

void main() {
  late ProviderContainer container;
  late EnterpriseEntity enterpriseEntity;

  // This runs before each test, ensuring a clean state.
  setUp(() {
    container = ProviderContainer();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    // Clean up the container after each test.
    addTearDown(container.dispose);
  });

  test('Initial state should be null', () {
    // ARRANGE & ACT: Read the initial state of the provider.
    final state = container.read(selectedEnterpriseStateControllerProvider);

    // ASSERT: Verify that the initial state is null.
    expect(state, isNull);
  });

  test(
    'selectEnterprise should update the state with the provided enterprise',
    () {
      // ARRANGE: Get the controller (notifier) from the container.
      final controller = container.read(
        selectedEnterpriseStateControllerProvider.notifier,
      );

      // ACT: Call the method to change the state.
      controller.selectEnterprise(enterpriseEntity);

      // ASSERT: Read the provider again and verify the state has been updated.
      final newState = container.read(
        selectedEnterpriseStateControllerProvider,
      );
      expect(newState, enterpriseEntity);
    },
  );

  test('clear should reset the state to null', () {
    // ARRANGE: First, set an initial state.
    container
        .read(selectedEnterpriseStateControllerProvider.notifier)
        .selectEnterprise(enterpriseEntity);

    // Check that the state was set correctly (optional sanity check).
    expect(
      container.read(selectedEnterpriseStateControllerProvider),
      enterpriseEntity,
    );

    // ACT: Call the clear method.
    container.read(selectedEnterpriseStateControllerProvider.notifier).clear();

    // ASSERT: Verify the state is now null.
    final clearedState = container.read(
      selectedEnterpriseStateControllerProvider,
    );
    expect(clearedState, isNull);
  });
}
