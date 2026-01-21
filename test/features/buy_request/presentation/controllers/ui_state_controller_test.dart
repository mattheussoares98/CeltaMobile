import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/supplier/supplier.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakePendingBuyRequest extends PendingBuyRequestStateController {
  final PendingBuyRequestEntity requestToReturn;
  FakePendingBuyRequest(this.requestToReturn);

  @override
  Future<PendingBuyRequestEntity> build() async {
    return requestToReturn;
  }
}

class FakeSupplierStateController extends SupplierStateController {
  List<SupplierEntity>? fakeSuppliers;
  FakeSupplierStateController(this.fakeSuppliers);

  @override
  FutureOr<List<SupplierEntity>?> build(SearchSupplierType searchType) async {
    return fakeSuppliers;
  }
}

void main() {
  late List<SupplierEntity> fakeSuppliers;
  late PendingBuyRequestEntity fakePendingRequest;
  late UserSessionModel fakeSession;

  setUpAll(() {
    registerFallbackValue(SearchSupplierType.buyRequest);
  });

  setUp(() {
    // Generating fake data using the factory and faker
    fakeSuppliers = [
      EntityFactory.makeSupplierEntity(Code: 10),
      EntityFactory.makeSupplierEntity(Code: 20),
    ];

    // Create a pending request with a supplier not present in the main list to test merging
    fakePendingRequest = EntityFactory.makePendingBuyRequestEntity(
      selectedSupplier: EntityFactory.makeSupplierEntity(Code: 30),
    );

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
  });

  ProviderContainer makeProviderContainer({
    List<SupplierEntity>? suppliers,
    PendingBuyRequestEntity? pendingRequest,
  }) {
    return ProviderContainer(
      overrides: [
        // Mocking user session to satisfy the dependency inside build()
        userSessionProvider.overrideWith(() => FakeUserSession(fakeSession)),
        // Overriding the supplier list dependency
        supplierStateControllerProvider(
          SearchSupplierType.buyRequest,
        ).overrideWith(() => FakeSupplierStateController(suppliers)),
        // Overriding the pending request dependency
        pendingBuyRequestStateControllerProvider.overrideWith(
          () => FakePendingBuyRequest(pendingRequest ?? fakePendingRequest),
        ),
      ],
    );
  }

  group('UiStateController build', () {
    test(
      'should merge suppliers from list and pending request correctly',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          suppliers: fakeSuppliers,
          pendingRequest: fakePendingRequest,
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(uiStateControllerProvider.future);

        // ASSERT
        // The result should contain the 2 from the list + 1 from the pending request
        expect(result.suppliers.length, 3);
        expect(
          result.suppliers.any(
            (s) => s.Code == fakePendingRequest.selectedSupplier?.Code,
          ),
          isTrue,
        );
        expect(result.currentPageIndex, 0);
      },
    );

    test(
      'should not add duplicate supplier if it already exists in the list',
      () async {
        // ARRANGE
        // Set the pending supplier to one that is already in the list
        final duplicatePending = EntityFactory.makePendingBuyRequestEntity(
          selectedSupplier: fakeSuppliers.first,
        );
        final container = makeProviderContainer(
          suppliers: fakeSuppliers,
          pendingRequest: duplicatePending,
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(uiStateControllerProvider.future);

        // ASSERT
        // Length should remain 2 because the supplier code matched
        expect(result.suppliers.length, 2);
      },
    );
  });

  group('update page index', () {
    test('updatePageIndex should update the state correctly', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // Wait for initial build to settle
      await container.read(uiStateControllerProvider.future);

      final states = <AsyncValue<UiStateModel>>[];
      container.listen(
        uiStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      container.read(uiStateControllerProvider.notifier).updatePageIndex(2);

      // ASSERT
      expect(states.last.value?.currentPageIndex, 2);
    });
  });

  group('Update selected product index', () {
    test(
      'updateSelectedProductIndex should set index and toggle it off',
      () async {
        // ARRANGE
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        await container.read(uiStateControllerProvider.future);

        final notifier = container.read(uiStateControllerProvider.notifier);

        // ACT 1: Select an index
        notifier.updateSelectedProductIndex(5);
        expect(
          container.read(uiStateControllerProvider).value?.selectedProductIndex,
          5,
        );

        // ACT 2: Select the same index again (Toggle/Annul logic)
        notifier.updateSelectedProductIndex(5);

        // ASSERT
        expect(
          container.read(uiStateControllerProvider).value?.selectedProductIndex,
          isNull,
        );
      },
    );

    test(
      'updateSelectedProductIndex should update to a new index if different',
      () async {
        // ARRANGE
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(uiStateControllerProvider.future);
        final notifier = container.read(uiStateControllerProvider.notifier);

        // ACT
        notifier.updateSelectedProductIndex(1);
        notifier.updateSelectedProductIndex(2);

        // ASSERT
        expect(
          container.read(uiStateControllerProvider).value?.selectedProductIndex,
          2,
        );
      },
    );
  });
  group('Update selected CART product index', () {
    test(
      'updateSelectedCartProductIndex should set index and toggle it off',
      () async {
        // ARRANGE
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        await container.read(uiStateControllerProvider.future);

        final notifier = container.read(uiStateControllerProvider.notifier);

        // ACT 1: Select an index
        notifier.updateSelectedCartProductIndex(5);
        expect(
          container
              .read(uiStateControllerProvider)
              .value
              ?.selectedCartProductIndex,
          5,
        );

        // ACT 2: Select the same index again (Toggle/Annul logic)
        notifier.updateSelectedCartProductIndex(5);

        // ASSERT
        expect(
          container
              .read(uiStateControllerProvider)
              .value
              ?.selectedCartProductIndex,
          isNull,
        );
      },
    );

    test(
      'updateSelectedProductIndex should update to a new index if different',
      () async {
        // ARRANGE
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(uiStateControllerProvider.future);
        final notifier = container.read(uiStateControllerProvider.notifier);

        // ACT
        notifier.updateSelectedCartProductIndex(1);
        notifier.updateSelectedCartProductIndex(2);

        // ASSERT
        expect(
          container
              .read(uiStateControllerProvider)
              .value
              ?.selectedCartProductIndex,
          2,
        );
      },
    );
  });
}
