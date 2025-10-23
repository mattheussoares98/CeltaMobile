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
  @override
  Future<PendingBuyRequestEntity> build() async {
    if (requestToReturn == null) {
      throw AppException('Pedido pendente inválido.');
    }
    return requestToReturn!;
  }
}

class MockSoapInsertBuyRequestRepository extends Mock
    implements ISoapInsertBuyRequestRepository {}

void main() {
  late MockSoapInsertBuyRequestRepository mockRepository;
  late UserSessionModel fakeSession;
  late PendingBuyRequestEntity fakePendingRequest;
  late String? fakeObservations;
  late String fakeLastSavedRequestNumber;

  setUpAll(() {
    // Register fallback values
    registerFallbackValue(<BuyRequestProductItemEntity>[]);
  });

  setUp(() {
    mockRepository = MockSoapInsertBuyRequestRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakePendingRequest = EntityFactory.makePendingBuyRequestEntity();
    fakeObservations = faker.randomGenerator.boolean() == false
        ? null
        : faker.lorem.sentence();
    fakeLastSavedRequestNumber = faker.lorem.word();
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    PendingBuyRequestEntity? pendingRequest,
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
          () => FakePendingBuyRequest(pendingRequest),
        ),
      ],
    );
  }

  group('InsertBuyRequestController', () {
    test('should call repository with correct data on success', () async {
      // ARRANGE
      when(
        () => mockRepository.insertBuyRequest(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          buyerCode: any(named: 'buyerCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
          supplierCode: any(named: 'supplierCode'),
          enterpriseCodes: any(named: 'enterpriseCodes'),
          observations: any(named: 'observations'),
          products: any(named: 'products'),
        ),
      ).thenAnswer((_) async => fakeLastSavedRequestNumber);

      final container = makeProviderContainer(
        session: fakeSession,
        pendingRequest: fakePendingRequest,
      );
      addTearDown(container.dispose);

      // ACT: Reading the future will trigger the build and wait for it to complete.
      await container.read(
        insertBuyRequestControllerProvider(fakeObservations ?? '').future,
      );

      // ASSERT
      verify(
        () => mockRepository.insertBuyRequest(
          baseUrl: fakeSession.enterprise!.baseUrl!,
          crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          buyerCode: fakePendingRequest.selectedBuyer!.Code,
          requestTypeCode: fakePendingRequest.selectedRequestType!.Code,
          supplierCode: fakePendingRequest.selectedSupplier!.Code,
          enterpriseCodes: fakePendingRequest.selectedEnterprises!
              .map((e) => e.Code!)
              .toList(),
          observations: fakeObservations,
          products: fakePendingRequest.products!.values.toList(),
        ),
      ).called(1);
    });

    test('should throw AppException when session is invalid', () async {
      // ARRANGE: Pass null for the session
      final container = makeProviderContainer(
        session: null,
        pendingRequest: fakePendingRequest,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT: Expect the future to throw an AppException
      await expectLater(
        container.read(
          insertBuyRequestControllerProvider(fakeObservations ?? '').future,
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('should throw error when pending request is invalid', () async {
      // ARRANGE: Pass null for the pending request
      final container = makeProviderContainer(
        session: fakeSession,
        pendingRequest: null,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          insertBuyRequestControllerProvider(fakeObservations ?? '').future,
        ),
        throwsA(isA<AppException>()),
      );
    });
  });
}
