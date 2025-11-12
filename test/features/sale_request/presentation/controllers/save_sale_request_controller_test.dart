import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/sale_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/sale_request/domain/repository/repository.dart';
import 'package:celta_intelligence/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Your Fakes and Mocks are correct ---
class SpyPendingSaleRequest extends PendingSaleRequestStateController {
  final PendingSaleRequestEntity? requestToReturn;
  SpyPendingSaleRequest(this.requestToReturn);
  ProcessedCartEntity? processedCart;
  @override
  Future<PendingSaleRequestEntity> build() async =>
      requestToReturn ?? PendingSaleRequestEntity.empty();
  @override
  Future<void> updateProductsFromProcessedCart(
    ProcessedCartEntity products,
  ) async {
    processedCart = products;
  }
}

class MockSoapSaveSaleRequestRepository extends Mock
    implements ISoapSaveSaleRequestRepository {}

void main() {
  late MockSoapSaveSaleRequestRepository mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late PendingSaleRequestEntity fakePendingRequest;
  late PendingSaleRequestEntity fakeRequestNoCustomer;
  late int fakeRequestTypeCode;

  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makePendingSaleRequestEntity());
    registerFallbackValue(PendingSaleRequestEntity.empty());

    // --- Initialize Mocks and Data ONCE ---
    mockRepository = MockSoapSaveSaleRequestRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakePendingRequest = EntityFactory.makePendingSaleRequestEntity(
      customer: EntityFactory.makeCustomerEntity(), // Valid request
    );
    fakeRequestNoCustomer = PendingSaleRequestEntity.empty(); // Invalid request
    fakeRequestTypeCode = faker.randomGenerator.integer(100);

    // --- Create the single container ONCE with ALL 4 providers ---
    container = ProviderContainer(
      overrides: [
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider.overrideWith(
          () => SpyPendingSaleRequest(fakePendingRequest),
        ),
      ],
    );
  });

  tearDownAll(() {
    container.dispose();
  });

  tearDown(() {
    reset(mockRepository);
  });

  group('SaveSaleRequestController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        final spy = SpyPendingSaleRequest(fakePendingRequest);

        // THE FIX: You must update ALL 4 overrides.
        container.updateOverrides([
          soapSaveSaleRequestRepositoryProvider.overrideWithValue(
            mockRepository,
          ),
          validatedUserSessionProvider.overrideWith(
            () => FakeValidatedUserSession(fakeSession),
          ),
          selectedEnterpriseStateControllerProvider.overrideWith(
            () => FakeSelectedEnterpriseStateController(fakeEnterprise),
          ),
          pendingSaleRequestStateControllerProvider.overrideWith(
            () => spy,
          ), // Use the new spy
        ]);

        when(
          () => mockRepository.save(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            requestTypeCode: any(named: 'requestTypeCode'),
            saleRequest: any(named: 'saleRequest'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return '12345'; // Return a fake response number
        });

        final states = <AsyncValue<void>>[];
        container.listen(
          saveSaleRequestControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(saveSaleRequestControllerProvider.notifier)
            .save(requestTypeCode: fakeRequestTypeCode);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockRepository.save(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterprise.Code!,
            requestTypeCode: fakeRequestTypeCode,
            saleRequest: fakePendingRequest,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] if customer is null', () async {
      // ARRANGE
      final spyNoCustomer = SpyPendingSaleRequest(fakeRequestNoCustomer);

      // THE FIX: You must update ALL 4 overrides.
      container.updateOverrides([
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider.overrideWith(
          () => spyNoCustomer,
        ), // Use the "no customer" spy
      ]);

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(saveSaleRequestControllerProvider.notifier)
          .save(requestTypeCode: fakeRequestTypeCode);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());
      expect(
        (states.last.error as AppException).message,
        'Selecione o cliente!',
      );
      verifyNever(
        () => mockRepository.save(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
          saleRequest: any(named: 'saleRequest'),
        ),
      );
    });

    test('should emit [loading, error] if session is invalid', () async {
      // ARRANGE
      final spy = SpyPendingSaleRequest(fakePendingRequest);

      // THE FIX: You must update ALL 4 overrides.
      container.updateOverrides([
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(null),
        ), // Invalid session
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider.overrideWith(() => spy),
      ]);

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(saveSaleRequestControllerProvider.notifier)
          .save(requestTypeCode: fakeRequestTypeCode);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());
    });
  });
}
