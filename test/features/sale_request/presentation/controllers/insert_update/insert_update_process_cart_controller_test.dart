// test/features/sale_request/presentation/controllers/insert_update/process_cart_controller_test.dart

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';
import '../fakers.dart';

class MockEcSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

void main() {
  late BSFSaleRequestEntity fakeSaleRequest;
  late SaleRequestArgs fakeArgs;
  late MockEcSaleRequestsRepository mockEcSaleRequestsRepository;
  late UserSessionModel fakeSession;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeBSFSaleRequestEntity());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  ProviderContainer makeProviderContainer({required int saleRequestId}) {
    final args = fakeArgs.copyWith(saleRequestId: saleRequestId);
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        saleRequestArgsProvider.overrideWithValue(args),
        saleRequestDetailsStateControllerProvider(
          args,
        ).overrideWith(() => FakeSaleRequestDetailsController(fakeSaleRequest)),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    mockEcSaleRequestsRepository = MockEcSaleRequestsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    fakeArgs = SaleRequestArgs(
      customerCode: fakeSaleRequest.customer?.code ?? 0,
      enterpriseCode: fakeSaleRequest.enterprise?.code ?? 0,
      saleRequestId: fakeSaleRequest.code ?? 0,
    );
  });

  group('InsertUpdateProcessCartController', () {
    test('processCart should behave correctly on success', () async {
      final container = makeProviderContainer(saleRequestId: 0);

      final insertUpdateStateNotifier = container.read(
        insertUpdateStateControllerProvider.notifier,
      );
      final processCartNotifier = container.read(
        insertUpdateProcessCartControllerProvider.notifier,
      );

      // Load initial state
      await container.read(insertUpdateStateControllerProvider.future);

      final product = EntityFactory.makeProductEntity(
        plu: 'plu123',
        enterpriseCode: fakeArgs.enterpriseCode,
      );
      insertUpdateStateNotifier.addItem(product);
      expect(insertUpdateStateNotifier.needsProcessing, isTrue);

      // Update the request type so processCart has a valid requestTypeCode
      final requestType = EntityFactory.makeBSFRequestTypeEntity().copyWith(
        code: 1,
      );
      insertUpdateStateNotifier.updateRequestType(requestType);

      // Update the customer so processCart has a valid customerCode
      final customer = EntityFactory.makeBSFCustomerEntity().copyWith(code: 1);
      insertUpdateStateNotifier.updateCustomer(customer, onlyValidating: false);

      final processedRequest = fakeSaleRequest.copyWith(code: 999);
      when(
        () => mockEcSaleRequestsRepository.processCart(
          saleRequest: any(named: 'saleRequest'),
          enterpriseCode: any(named: 'enterpriseCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
          customerCode: any(named: 'customerCode'),
          saleRequestCode: any(named: 'saleRequestCode'),
          params: any(named: 'params'),
        ),
      ).thenAnswer((_) async => processedRequest);

      await processCartNotifier.processCart();

      // Check state of InsertUpdateProcessCartController is AsyncData(null) on success
      expect(
        container.read(insertUpdateProcessCartControllerProvider),
        isA<AsyncData<void>>(),
      );
      // Main insertUpdateStateController state is updated to processed request
      expect(
        container.read(insertUpdateStateControllerProvider).value,
        processedRequest,
      );
      expect(insertUpdateStateNotifier.needsProcessing, isFalse);

      verify(
        () => mockEcSaleRequestsRepository.processCart(
          saleRequest: any(named: 'saleRequest'),
          enterpriseCode: any(named: 'enterpriseCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
          customerCode: any(named: 'customerCode'),
          saleRequestCode: any(named: 'saleRequestCode'),
          params: any(named: 'params'),
        ),
      ).called(1);
    });

    test(
      'processCart should capture error and set state to AsyncError on failure',
      () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final insertUpdateStateNotifier = container.read(
          insertUpdateStateControllerProvider.notifier,
        );
        final processCartNotifier = container.read(
          insertUpdateProcessCartControllerProvider.notifier,
        );

        // Load initial state
        await container.read(insertUpdateStateControllerProvider.future);

        final product = EntityFactory.makeProductEntity(
          plu: 'plu123',
          enterpriseCode: fakeArgs.enterpriseCode,
        );
        insertUpdateStateNotifier.addItem(product);

        // Update the request type so processCart has a valid requestTypeCode
        final requestType = EntityFactory.makeBSFRequestTypeEntity().copyWith(
          code: 1,
        );
        insertUpdateStateNotifier.updateRequestType(requestType);

        // Update the customer so processCart has a valid customerCode
        final customer = EntityFactory.makeBSFCustomerEntity().copyWith(
          code: 1,
        );
        insertUpdateStateNotifier.updateCustomer(customer, onlyValidating: false);

        final draftValue = container
            .read(insertUpdateStateControllerProvider)
            .value!;

        when(
          () => mockEcSaleRequestsRepository.processCart(
            saleRequest: any(named: 'saleRequest'),
            enterpriseCode: any(named: 'enterpriseCode'),
            requestTypeCode: any(named: 'requestTypeCode'),
            customerCode: any(named: 'customerCode'),
            saleRequestCode: any(named: 'saleRequestCode'),
            params: any(named: 'params'),
          ),
        ).thenThrow(Exception('API error'));

        await processCartNotifier.processCart();

        // InsertUpdateProcessCartController should be in AsyncError state
        expect(
          container.read(insertUpdateProcessCartControllerProvider),
          isA<AsyncError>(),
        );
        // Main state remains intact as draft value and is not an error state!
        expect(
          container.read(insertUpdateStateControllerProvider).value,
          draftValue,
        );
        expect(
          container.read(insertUpdateStateControllerProvider),
          isA<AsyncData>(),
        );
        expect(insertUpdateStateNotifier.needsProcessing, isTrue);
      },
    );

    test(
      'processCart should throw mandatory model error when requestType code is null or zero',
      () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final processCartNotifier = container.read(
          insertUpdateProcessCartControllerProvider.notifier,
        );

        // Load initial state
        await container.read(insertUpdateStateControllerProvider.future);

        // Do not set requestType, so requestTypeCode remains null or zero
        await processCartNotifier.processCart();

        expect(
          container.read(insertUpdateProcessCartControllerProvider),
          isA<AsyncError>(),
        );
        final errorState =
            container.read(insertUpdateProcessCartControllerProvider)
                as AsyncError;
        expect(errorState.error.toString(), isNotEmpty);
      },
    );

    test(
      'processCart should throw mandatory customer error when customer code is null or zero',
      () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final insertUpdateStateNotifier = container.read(
          insertUpdateStateControllerProvider.notifier,
        );
        final processCartNotifier = container.read(
          insertUpdateProcessCartControllerProvider.notifier,
        );

        // Load initial state
        await container.read(insertUpdateStateControllerProvider.future);

        // Set requestType, but do not set customer so customer code remains null or zero
        final requestType = EntityFactory.makeBSFRequestTypeEntity().copyWith(
          code: 1,
        );
        insertUpdateStateNotifier.updateRequestType(requestType);

        await processCartNotifier.processCart();

        expect(
          container.read(insertUpdateProcessCartControllerProvider),
          isA<AsyncError>(),
        );
        final errorState =
            container.read(insertUpdateProcessCartControllerProvider)
                as AsyncError;
        expect(errorState.error.toString(), isNotEmpty);
      },
    );
  });
}
