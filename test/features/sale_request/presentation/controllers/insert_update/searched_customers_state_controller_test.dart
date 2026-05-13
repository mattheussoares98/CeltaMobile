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
    fakeCustomer = EntityFactory.makeBSFCustomerEntity();
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

      await controller.loadCustomer('search query', false);

      final state = container.read(
        searchedCustomersStateControllerProvider(
          enterpriseCode: enterpriseCode,
          saleRequestId: saleRequestId,
          customerCode: customerCode,
        ),
      );

      expect(state.value, searchResults);
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

        await controller.loadCustomer('search query', false);

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
