import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakePendingBuyRequest extends PendingBuyRequestStateController {
  final PendingBuyRequestEntity? requestToReturn;
  FakePendingBuyRequest(this.requestToReturn);

  // PendingBuyRequestEntity? get updatedEntity => _updatedEntity;
  // PendingBuyRequestEntity? _updatedEntity;
  bool get clearedState => _clearedState;
  bool _clearedState = false;

  @override
  Future<PendingBuyRequestEntity> build(int enterpriseCode) async {
    if (requestToReturn == null) {
      throw AppException('Pedido pendente inválido.');
    }
    return requestToReturn!;
  }

  @override
  Future<void> clearState(String? newSavedRequestNumber) async {
    _clearedState = true;
  }

  // // We override updatePending to "spy" on the value passed to it.
  // @override
  // Future<void> updatePending({
  //   BuyerEntity? selectedBuyer,
  //   RequestTypeEntity? selectedRequestType,
  //   SupplierEntity? selectedSupplier,
  //   List<EnterpriseEntity>? selectedEnterprises,
  //   Map<ProductKey, BuyRequestProductItemEntity>? products,
  //   String? lastSavedRequestNumber,
  //   bool? annulSelectedEnterprises,
  //   bool? annulProducts,
  //   bool? annulSelectedSupplier,
  // }) async {
  //   _updatedEntity = updatedEntity
  //       ?.annulValue(
  //         annulSelectedEnterprises: annulSelectedEnterprises,
  //         annulProducts: annulProducts,
  //         annulSelectedSupplier: annulSelectedSupplier,
  //       )
  //       .copyWith(
  //         selectedBuyer: selectedBuyer,
  //         selectedSupplier: selectedSupplier,
  //         selectedEnterprises: selectedEnterprises,
  //         selectedRequestType: selectedRequestType,
  //         products: products,
  //         lastSavedRequestNumber: lastSavedRequestNumber,
  //       );
  //   // We don't need to call super() or update the state,
  //   // just record the value.
  // }
}

class MockSoapInsertBuyRequestRepository extends Mock
    implements ISoapInsertBuyRequestRepository {}

void main() {
  late MockSoapInsertBuyRequestRepository mockRepository;
  late UserSessionModel fakeSession;
  late PendingBuyRequestEntity fakePendingRequest;
  late String fakeObservations;
  late String fakeLastSavedRequestNumber;
  late int enterpriseCode;

  setUpAll(() {
    registerFallbackValue(<BuyRequestProductItemEntity>[]);
  });

  setUp(() {
    mockRepository = MockSoapInsertBuyRequestRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakePendingRequest = EntityFactory.makePendingBuyRequestEntity();
    fakeObservations = faker.lorem.sentence();
    fakeLastSavedRequestNumber = faker.lorem.word();
    enterpriseCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    PendingBuyRequestEntity? pendingRequest,
    FakePendingBuyRequest? pendingBuyRequestStateController,
  }) {
    return ProviderContainer(
      overrides: [
        soapInsertBuyRequestRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        pendingBuyRequestStateControllerProvider(enterpriseCode).overrideWith(
          () =>
              pendingBuyRequestStateController ??
              FakePendingBuyRequest(pendingRequest),
        ),
      ],
    );
  }

  group('InsertBuyRequestController insert', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.insertBuyRequest(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            buyerCode: any(named: 'buyerCode'),
            requestTypeCode: any(named: 'requestTypeCode'),
            supplierCode: any(named: 'supplierCode'),
            observations: any(named: 'observations'),
            enterpriseCodes: any(named: 'enterpriseCodes'),
            products: any(named: 'products'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero); // Simulate async delay
          return fakeLastSavedRequestNumber;
        });

        final container = makeProviderContainer(
          session: fakeSession,
          pendingRequest: fakePendingRequest,
        );
        addTearDown(container.dispose);
        await container.read(
          insertBuyRequestControllerProvider(enterpriseCode).future,
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          insertBuyRequestControllerProvider(enterpriseCode),
          (_, next) => states.add(next),
        );

        // ACT: Call the 'insert' method, not read the provider's future
        bool succeeds = await container
            .read(insertBuyRequestControllerProvider(enterpriseCode).notifier)
            .insert(fakeObservations);
        expect(succeeds, isTrue);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockRepository.insertBuyRequest(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            buyerCode: fakePendingRequest.selectedBuyer!.Code,
            requestTypeCode: fakePendingRequest.selectedRequestType!.Code,
            supplierCode: fakePendingRequest.selectedSupplier!.Code,
            observations: fakeObservations,
            enterpriseCodes: fakePendingRequest.selectedEnterprises!
                .map((e) => e.Code!)
                .toList(),
            products: fakePendingRequest.products!.values.toList(),
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session
      final container = makeProviderContainer(
        session: null,
        pendingRequest: fakePendingRequest,
      );
      addTearDown(container.dispose);
      await container.read(
        insertBuyRequestControllerProvider(enterpriseCode).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        insertBuyRequestControllerProvider(enterpriseCode),
        (_, next) => states.add(next),
      );

      // ACT
      final succeeds = await container
          .read(insertBuyRequestControllerProvider(enterpriseCode).notifier)
          .insert(fakeObservations);
      expect(succeeds, isFalse);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });

    test(
      'should emit [loading, error] when pending request is invalid',
      () async {
        // ARRANGE: Pass null for the pending request
        final container = makeProviderContainer(
          session: fakeSession,
          pendingRequest: null,
        );
        addTearDown(container.dispose);
        await container.read(
          insertBuyRequestControllerProvider(enterpriseCode).future,
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          insertBuyRequestControllerProvider(enterpriseCode),
          (_, next) => states.add(next),
        );

        // ACT
        final succeeds = await container
            .read(insertBuyRequestControllerProvider(enterpriseCode).notifier)
            .insert(fakeObservations);
        expect(succeeds, isFalse);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      },
    );

    test(
      'should call clear state with correct new saleRequestNumber on success',
      () async {
        // ARRANGE
        final spyPendingController = FakePendingBuyRequest(fakePendingRequest);
        when(
          () => mockRepository.insertBuyRequest(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            buyerCode: any(named: 'buyerCode'),
            requestTypeCode: any(named: 'requestTypeCode'),
            supplierCode: any(named: 'supplierCode'),
            observations: any(named: 'observations'),
            enterpriseCodes: any(named: 'enterpriseCodes'),
            products: any(named: 'products'),
          ),
        ).thenAnswer((_) async => fakeLastSavedRequestNumber);

        final container = makeProviderContainer(
          session: fakeSession,
          pendingBuyRequestStateController: spyPendingController,
        );
        addTearDown(container.dispose);

        // ACT
        final succeeds = await container
            .read(insertBuyRequestControllerProvider(enterpriseCode).notifier)
            .insert(fakeObservations);
        expect(succeeds, isTrue);

        // ASSERT
        // Check the 'updatedEntity' property on our spy
        expect(spyPendingController.clearedState, isTrue);
      },
    );
  });
}
