import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../mocks/mocks.dart';
import '../../fakers.dart';

void main() {
  late EcBSFCustomersRepositorySpy mockRepository;
  late UserSessionModel fakeSession;
  late SaleRequestArgs fakeArgs;
  late BSFSaleRequestEntity saleRequest;
  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcRequestParams());
    registerFallbackValue(EntityFactory.makeEcGetCustomersParams());
  });

  setUp(() {
    mockRepository = EcBSFCustomersRepositorySpy();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeArgs = SaleRequestArgs(
      customerCode: faker.randomGenerator.integer(100),
      saleRequestId: faker.randomGenerator.integer(100),
      enterpriseCode: faker.randomGenerator.integer(100),
    );
    // User requested to use a high number for code to avoid repetitions
    saleRequest = BSFSaleRequestEntity.empty().copyWith(
      customer: EntityFactory.makeBSFCustomerEntity().copyWith(code: 999999),
      seller: EntityFactory.makeBSFEmployeeEntity().copyWith(
        annulCode: faker.randomGenerator.boolean(),
      ),
    );
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        saleRequestArgsProvider.overrideWithValue(fakeArgs),
        ecCustomersRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        saleRequestDetailsStateControllerProvider(
          fakeArgs,
        ).overrideWith(() => FakeSaleRequestDetailsController(saleRequest)),
        insertUpdateStateControllerProvider.overrideWith(
          () => FakeInsertUpdateStateController(saleRequest),
        ),
      ],
    );
  }

  group('CustomersStateController', () {
    test(
      'build should return the selected customer on saleRequestDetails',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final state = await container.read(
          searchedCustomersStateControllerProvider.future,
        );

        expect(state.customers, [saleRequest.customer]);
      },
    );

    test('Should behave correctly on load', () async {
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      await container.read(searchedCustomersStateControllerProvider.future);

      final searchResults = [
        EntityFactory.makeBSFCustomerEntity(),
        EntityFactory.makeBSFCustomerEntity(),
      ];

      mockRepository.mockSearchForMobileApp(searchResults);

      final controller = container.read(
        searchedCustomersStateControllerProvider.notifier,
      );

      final searchByPersonalizedCode = faker.randomGenerator.boolean();
      if (searchByPersonalizedCode) {
        controller.toggleSearchByPersonalizedCode();
      }
      final searchValue = faker.lorem.word();
      final succeeds = await controller.loadCustomer(searchValue);

      expect(succeeds, isTrue);

      final state = container.read(searchedCustomersStateControllerProvider);

      expect(state.value?.customers, [saleRequest.customer, ...searchResults]);
      expect(state.value?.errorMessage, isNull);
      expect(state.value?.searchByPersonalizedCode, searchByPersonalizedCode);
      verify(
        () => mockRepository.searchForMobileApp(
          EcGetCustomersParams(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: searchValue,
            enterpriseCode: fakeArgs.enterpriseCode,
            searchByPersonalizedCode: searchByPersonalizedCode,
            sellerCode: saleRequest.seller?.code,
          ),
        ),
      ).called(1);
    });

    test(
      'Should return the updated customer and update insertUpdateStateController when search returns a customer with the same code',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final updatedFakeCustomer = EntityFactory.makeBSFCustomerEntity()
            .copyWith(code: saleRequest.customer?.code);

        final otherCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(
          code: 1,
        );
        final searchResults = [otherCustomer, updatedFakeCustomer];

        mockRepository.mockSearchForMobileApp(searchResults);

        final controller = container.read(
          searchedCustomersStateControllerProvider.notifier,
        );

        await controller.loadCustomer('search query');

        final state = container.read(searchedCustomersStateControllerProvider);

        expect(state.value?.customers, [updatedFakeCustomer, otherCustomer]);
        expect(
          container.read(insertUpdateStateControllerProvider).value?.customer,
          // updateCustomerData annuls the covenant because fakeCustomer.covenantCode
          // (random) is unlikely to match any covenant in updatedFakeCustomer.covenants.
          // The customer code (999999) stays the same — only the covenant is cleared.
          updatedFakeCustomer.copyWith(
            annulCovenantCode: true,
            annulSelectedCovenant: true,
          ),
        );
      },
    );

    test(
      'loadCustomer should set state to error if repository fails',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        mockRepository.mockSearchForMobileAppError();

        final controller = container.read(
          searchedCustomersStateControllerProvider.notifier,
        );

        final succeeds = await controller.loadCustomer('search query');

        expect(succeeds, false);

        final state = container.read(searchedCustomersStateControllerProvider);

        expect(state.value?.errorMessage, isNotEmpty);
      },
    );

    test(
      'toggleSearchByPersonalizedCode should toggle the boolean in state',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final controller = container.read(
          searchedCustomersStateControllerProvider.notifier,
        );

        await container.read(searchedCustomersStateControllerProvider.future);

        var state = container.read(searchedCustomersStateControllerProvider);
        expect(state.value?.searchByPersonalizedCode, isFalse);

        controller.toggleSearchByPersonalizedCode();

        state = container.read(searchedCustomersStateControllerProvider);
        expect(state.value?.searchByPersonalizedCode, isTrue);

        controller.toggleSearchByPersonalizedCode();

        state = container.read(searchedCustomersStateControllerProvider);
        expect(state.value?.searchByPersonalizedCode, isFalse);
      },
    );
  });
}
