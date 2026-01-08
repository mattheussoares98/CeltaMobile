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

// --- Fakes, Mocks, and Spies ---

// Your Spy for PendingSaleRequest is correct
class SpyPendingSaleRequest extends PendingSaleRequestStateController {
  final PendingSaleRequestEntity? requestToReturn;
  SpyPendingSaleRequest(this.requestToReturn);
  @override
  Future<PendingSaleRequestEntity> build() async =>
      requestToReturn ?? PendingSaleRequestEntity.empty();
  // We don't need to override updateProductsFromProcessedCart for this controller
}

// A Spy for the LastSavedSaleRequest controller
class SpyLastSavedSaleRequest extends LastSavedSaleRequestStateController {
  LastSavedSaleRequestEntity? savedEntity;
  @override
  Future<LastSavedSaleRequestEntity?> build(int enterpriseCode) async => null;
  @override
  Future<void> save(LastSavedSaleRequestEntity value) async {
    savedEntity = value;
  }
}

class MockSoapSaveSaleRequestRepository extends Mock
    implements ISoapSaveSaleRequestRepository {}

// New Mock for the local repository
class MockLocalPendingSaleRequestRepository extends Mock
    implements ILocalPendingSaleRequestRepository {}

void main() {
  late MockSoapSaveSaleRequestRepository mockSoapSaveSaleRequestRepository;
  late MockLocalPendingSaleRequestRepository mockLocalPendingRepo; // New
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late PendingSaleRequestEntity fakePendingRequest;
  late PendingSaleRequestEntity fakeRequestNoCustomer;
  late int fakeRequestTypeCode;
  late String instructions;
  late String observations;

  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makePendingSaleRequestEntity());
    registerFallbackValue(
      LastSavedSaleRequestEntity(
        pendingSaleRequestEntity: EntityFactory.makePendingSaleRequestEntity(),
        saleRequestNumber: faker.randomGenerator.integer(100).toString(),
      ),
    );

    // --- Initialize Mocks and Data ONCE ---
    mockSoapSaveSaleRequestRepository = MockSoapSaveSaleRequestRepository();
    mockLocalPendingRepo = MockLocalPendingSaleRequestRepository(); // New
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakePendingRequest = EntityFactory.makePendingSaleRequestEntity(
      customer: EntityFactory.makeCustomerEntity(), // Valid request
    );
    fakeRequestNoCustomer = PendingSaleRequestEntity.empty(); // Invalid request
    fakeRequestTypeCode = faker.randomGenerator.integer(100);
    instructions = faker.lorem.sentence();
    observations = faker.lorem.sentence();

    // --- Create the single container ONCE with ALL providers ---
    container = ProviderContainer(
      overrides: [
        // Dependencies for the controller
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(
          mockSoapSaveSaleRequestRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider.overrideWith(
          () => SpyPendingSaleRequest(fakePendingRequest),
        ),

        // New dependencies to override
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => SpyLastSavedSaleRequest()),
        localPendingSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
      ],
    );
  });

  tearDownAll(() {
    container.dispose();
  });

  tearDown(() {
    // Reset mocks after each test
    reset(mockSoapSaveSaleRequestRepository);
    reset(mockLocalPendingRepo);
  });

  group('SaveSaleRequestController', () {
    test('should call all repositories and notifiers on success', () async {
      // ARRANGE
      const fakeSaleRequestNumber = '12345';
      final spyPending = SpyPendingSaleRequest(fakePendingRequest);
      final spyLastSaved = SpyLastSavedSaleRequest();

      // Update ALL overrides, keeping the list length the same
      container.updateOverrides([
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(
          mockSoapSaveSaleRequestRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider.overrideWith(
          () => spyPending,
        ),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spyLastSaved),
        localPendingSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
      ]);

      // Stub all async calls
      when(
        () => mockSoapSaveSaleRequestRepository.save(
          urlInUse: any(named: 'urlInUse'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
          saleRequest: any(named: 'saleRequest'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(Duration.zero);
        return fakeSaleRequestNumber;
      });
      when(() => mockLocalPendingRepo.clear(any())).thenAnswer((_) async {});

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(saveSaleRequestControllerProvider.notifier)
          .save(
            requestTypeCode: fakeRequestTypeCode,
            observations: observations,
            instructions: instructions,
          );

      // ASSERT
      // 1. Check state
      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

      // 2. Verify SOAP repository was called
      verify(
        () => mockSoapSaveSaleRequestRepository.save(
          urlInUse: fakeSession.enterprise!.urlInUse!,
          crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          enterpriseCode: fakeEnterprise.Code!,
          requestTypeCode: fakeRequestTypeCode,
          saleRequest: fakePendingRequest.copyWith(
            observations: observations,
            instructions: instructions,
          ),
        ),
      ).called(1);

      // 3. Verify LastSaved controller was called
      expect(spyLastSaved.savedEntity, isNotNull);
      expect(
        spyLastSaved.savedEntity?.saleRequestNumber,
        fakeSaleRequestNumber,
      );
      expect(
        spyLastSaved.savedEntity?.pendingSaleRequestEntity,
        fakePendingRequest.copyWith(
          observations: observations,
          instructions: instructions,
        ),
      );

      // 4. Verify local repo was cleared
      verify(() => mockLocalPendingRepo.clear(fakeEnterprise.Code!)).called(1);
    });

    test('should emit [loading, error] if customer is null', () async {
      // ARRANGE
      final spyNoCustomer = SpyPendingSaleRequest(fakeRequestNoCustomer);
      final spyLastSaved = SpyLastSavedSaleRequest();

      // Update ALL overrides
      container.updateOverrides([
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(
          mockSoapSaveSaleRequestRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider.overrideWith(
          () => spyNoCustomer,
        ),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spyLastSaved),
        localPendingSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
      ]);

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(saveSaleRequestControllerProvider.notifier)
          .save(
            requestTypeCode: fakeRequestTypeCode,
            observations: observations,
            instructions: instructions,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());
      expect(
        (states.last.error as AppException).message,
        'Selecione o cliente!',
      );

      // Verify no side-effects happened
      verifyNever(
        () => mockSoapSaveSaleRequestRepository.save(
          urlInUse: any(named: 'urlInUse'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
          saleRequest: any(named: 'saleRequest'),
        ),
      );
      verifyNever(() => mockLocalPendingRepo.clear(any()));
      expect(spyLastSaved.savedEntity, isNull);
    });

    test('should emit [loading, error] if session is invalid', () async {
      // ARRANGE
      final spy = SpyPendingSaleRequest(fakePendingRequest);
      final spyLastSaved = SpyLastSavedSaleRequest();

      // Update ALL overrides
      container.updateOverrides([
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(
          mockSoapSaveSaleRequestRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(null),
        ), // Invalid session
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider.overrideWith(() => spy),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spyLastSaved),
        localPendingSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
      ]);

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(saveSaleRequestControllerProvider.notifier)
          .save(
            requestTypeCode: fakeRequestTypeCode,
            observations: observations,
            instructions: instructions,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
