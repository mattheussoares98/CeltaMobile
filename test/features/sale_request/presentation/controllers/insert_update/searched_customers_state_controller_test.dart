import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';
import '../fakers.dart';

void main() {
  late EcBSFCustomersRepositorySpy mockRepository;
  late UserSessionModel fakeSession;
  late int enterpriseCode;
  late int saleRequestId;
  late int customerCode;
  late BSFCustomerEntity fakeCustomer;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    mockRepository = EcBSFCustomersRepositorySpy();
    enterpriseCode = faker.randomGenerator.integer(999);
    saleRequestId = faker.randomGenerator.integer(9999);
    customerCode = faker.randomGenerator.integer(9999);
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    // User requested to use a high number for code to avoid repetitions
    fakeCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(code: 999999);
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        ecBSFCustomersRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        saleRequestDetailsStateControllerProvider(
          customerCode: customerCode,
          enterpriseCode: enterpriseCode,
          saleRequestCode: saleRequestId,
        ).overrideWith(
          () => FakeSaleRequestDetailsController(
            BSFSaleRequestEntity.empty().copyWith(customer: fakeCustomer),
          ),
        ),
        insertUpdateStateControllerProvider(
          customerCode: customerCode,
          enterpriseCode: enterpriseCode,
          saleRequestId: saleRequestId,
        ).overrideWith(
          () => FakeInsertUpdateStateController(
            BSFSaleRequestEntity.empty().copyWith(customer: fakeCustomer),
          ),
        ),
      ],
    );
  }

  group('CustomersStateController', () {
    test(
      'build should initialize with current customer from sale request details',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final state = await container.read(
          searchedCustomersStateControllerProvider(
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
            customerCode: customerCode,
          ).future,
        );

        expect(state, [fakeCustomer]);
      },
    );

    test('Should behave correctly on load', () async {
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      final searchResults = [
        EntityFactory.makeBSFCustomerEntity(),
        EntityFactory.makeBSFCustomerEntity(),
      ];

      mockRepository.mockSearchForMobileApp(searchResults);

      final controller = container.read(
        searchedCustomersStateControllerProvider(
          enterpriseCode: enterpriseCode,
          saleRequestId: saleRequestId,
          customerCode: customerCode,
        ).notifier,
      );

      final succeeds = await controller.loadCustomer('search query', false);

      expect(succeeds, isTrue);

      final state = container.read(
        searchedCustomersStateControllerProvider(
          enterpriseCode: enterpriseCode,
          saleRequestId: saleRequestId,
          customerCode: customerCode,
        ),
      );

      expect(state.value, [fakeCustomer, ...searchResults]);
      verify(
        () => mockRepository.searchForMobileApp(
          params: EcRequestParams(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
          ),
          searchValue: 'search query',
          enterpriseCode: enterpriseCode,
          searchByPersonalizedCode: false,
        ),
      ).called(1);
    });

    test(
      'Should put the customer with same code from insertUpdateController at first position and updated',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final updatedFakeCustomer = EntityFactory.makeBSFCustomerEntity()
            .copyWith(code: fakeCustomer.code);

        final otherCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(
          code: 1,
        );
        final searchResults = [otherCustomer, updatedFakeCustomer];

        mockRepository.mockSearchForMobileApp(searchResults);

        final controller = container.read(
          searchedCustomersStateControllerProvider(
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
            customerCode: customerCode,
          ).notifier,
        );

        await controller.loadCustomer('search query', false);

        final state = container.read(
          searchedCustomersStateControllerProvider(
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
            customerCode: customerCode,
          ),
        );

        expect(state.value!.first, updatedFakeCustomer);
        expect(state.value!.length, 2);
        expect(state.value![1], otherCustomer);
      },
    );

    test(
      'loadCustomer should prepend selected customer even if repository does NOT return it',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final otherCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(
          code: 2,
        );
        final searchResults = [otherCustomer];

        mockRepository.mockSearchForMobileApp(searchResults);

        final controller = container.read(
          searchedCustomersStateControllerProvider(
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
            customerCode: customerCode,
          ).notifier,
        );

        await controller.loadCustomer('search query', false);

        final state = container.read(
          searchedCustomersStateControllerProvider(
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
            customerCode: customerCode,
          ),
        );

        expect(state.value!.first, fakeCustomer);
        expect(state.value!.length, 2);
        expect(state.value![1], otherCustomer);
      },
    );

    test(
      'loadCustomer should set state to error if repository fails',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        mockRepository.mockSearchForMobileAppError();

        final controller = container.read(
          searchedCustomersStateControllerProvider(
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
            customerCode: customerCode,
          ).notifier,
        );

        final succeeds = await controller.loadCustomer('search query', false);

        expect(succeeds, false);

        final state = container.read(
          searchedCustomersStateControllerProvider(
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
            customerCode: customerCode,
          ),
        );

        expect(state.hasError, true);
      },
    );
  });
}
