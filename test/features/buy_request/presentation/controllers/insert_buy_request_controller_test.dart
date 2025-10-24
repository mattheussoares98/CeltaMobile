import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/buy_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/buy_request/domain/repository/repository.dart';
import 'package:celta_intelligence/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/buy_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakePendingBuyRequest extends PendingBuyRequestStateController {
  final PendingBuyRequestEntity? requestToReturn;
  FakePendingBuyRequest(this.requestToReturn);

  PendingBuyRequestEntity? updatedEntity;

  @override
  Future<PendingBuyRequestEntity> build() async {
    if (requestToReturn == null) {
      throw AppException('Pedido pendente inválido.');
    }
    return requestToReturn!;
  }

  // We override updatePending to "spy" on the value passed to it.
  @override
  Future<void> updatePending(PendingBuyRequestEntity entity) async {
    updatedEntity = entity;
    // We don't need to call super() or update the state,
    // just record the value.
  }
}

class MockSoapInsertBuyRequestRepository extends Mock
    implements ISoapInsertBuyRequestRepository {}

void main() {
  late MockSoapInsertBuyRequestRepository mockRepository;
  late UserSessionModel fakeSession;
  late PendingBuyRequestEntity fakePendingRequest;
  late String fakeObservations;
  late String fakeLastSavedRequestNumber;

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
        pendingBuyRequestStateControllerProvider.overrideWith(
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
            baseUrl: any(named: 'baseUrl'),
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
        await container.read(insertBuyRequestControllerProvider.future);

        final states = <AsyncValue<void>>[];
        container.listen(
          insertBuyRequestControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call the 'insert' method, not read the provider's future
        await container
            .read(insertBuyRequestControllerProvider.notifier)
            .insert(fakeObservations);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockRepository.insertBuyRequest(
            baseUrl: fakeSession.enterprise!.baseUrl!,
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
      await container.read(insertBuyRequestControllerProvider.future);

      final states = <AsyncValue<void>>[];
      container.listen(
        insertBuyRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(insertBuyRequestControllerProvider.notifier)
          .insert(fakeObservations);

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
        await container.read(insertBuyRequestControllerProvider.future);

        final states = <AsyncValue<void>>[];
        container.listen(
          insertBuyRequestControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(insertBuyRequestControllerProvider.notifier)
            .insert(fakeObservations);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      },
    );

    test(
      'should call updatePending with correct data after successful insert',
      () async {
        // ARRANGE
        final spyPendingController = FakePendingBuyRequest(fakePendingRequest);
        when(
          () => mockRepository.insertBuyRequest(
            baseUrl: any(named: 'baseUrl'),
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
        await container
            .read(insertBuyRequestControllerProvider.notifier)
            .insert(fakeObservations);

        // ASSERT
        // Check the 'updatedEntity' property on our spy
        expect(spyPendingController.updatedEntity, isNotNull);
        expect(
          spyPendingController.updatedEntity,
          PendingBuyRequestEntity.empty().copyWith(
            lastSavedRequestNumber: fakeLastSavedRequestNumber,
          ),
        );
      },
    );
  });
}
