import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes, Mocks, and Spies ---

// Your Spy for SaleRequest is correct
class SpySaleRequest extends PendingSaleRequestStateController {
  final SaleRequestEntity? requestToReturn;
  SpySaleRequest(this.requestToReturn);
  @override
  Future<SaleRequestEntity> build(int enterpriseCode) async =>
      requestToReturn ?? SaleRequestEntity.empty();
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

class FakeInsertUpdateStateController extends InsertUpdateStateController {
  final BSFSaleRequestEntity saleRequestEntity;
  FakeInsertUpdateStateController({required this.saleRequestEntity});

  @override
  FutureOr<BSFSaleRequestEntity> build() async {
    return saleRequestEntity;
  }
}

class MockSoapSaveSaleRequestRepository extends Mock
    implements ISoapSaveSaleRequestRepository {}

// New Mock for the local repository
class MockLocalSaleRequestRepository extends Mock
    implements ILocalSaleRequestRepository {}

class MockEcSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

void main() {
  late MockSoapSaveSaleRequestRepository mockSoapSaveSaleRequestRepository;
  late MockLocalSaleRequestRepository mockLocalPendingRepo;
  late MockEcSaleRequestsRepository mockEcSaleRequestsRepository;
  late FakeAppUsageStateController fakeAppUsage;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late SaleRequestEntity fakePendingRequest;
  late SaleRequestEntity fakeRequestNoCustomer;
  late int fakeRequestTypeCode;
  late String instructions;
  late String observations;
  late int saleRequestId;
  late BSFSaleRequestEntity fakeBSFSaleRequestEntity;

  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSaleRequestEntity());
    registerFallbackValue(
      LastSavedSaleRequestEntity(
        saleRequestEntity: EntityFactory.makeSaleRequestEntity(),
        saleRequestNumber: faker.randomGenerator.integer(100).toString(),
      ),
    );
    registerFallbackValue(EntityFactory.makeBSFSaleRequestEntity());
    registerFallbackValue(EntityFactory.makeEcRequestParams());

    // --- Initialize Mocks and Data ONCE ---
    mockSoapSaveSaleRequestRepository = MockSoapSaveSaleRequestRepository();
    mockLocalPendingRepo = MockLocalSaleRequestRepository(); // New
    mockEcSaleRequestsRepository = MockEcSaleRequestsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakePendingRequest = EntityFactory.makeSaleRequestEntity(
      customer: EntityFactory.makeCustomerEntity(), // Valid request
    );
    fakeRequestNoCustomer = SaleRequestEntity.empty(); // Invalid request
    fakeRequestTypeCode = faker.randomGenerator.integer(100);
    instructions = faker.lorem.sentence();
    observations = faker.lorem.sentence();
    fakeAppUsage = FakeAppUsageStateController();
    saleRequestId = faker.randomGenerator.integer(100);
    fakeBSFSaleRequestEntity = EntityFactory.makeBSFSaleRequestEntity();

    // --- Create the single container ONCE with ALL providers ---
    container = ProviderContainer(
      retry: (retryCount, error) => null,
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
        pendingSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => SpySaleRequest(fakePendingRequest)),

        // New dependencies to override
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => SpyLastSavedSaleRequest()),
        localSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        insertUpdateStateControllerProvider.overrideWith(
          () => FakeInsertUpdateStateController(
            saleRequestEntity: fakeBSFSaleRequestEntity,
          ),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
        // saleRequestArgsProvider.overrideWith((ref) => SaleRequestArgs(
        //       customerCode: fakeBSFSaleRequestEntity.customer?.code ?? 0,
        //       enterpriseCode: fakeEnterprise.Code!,
        //       saleRequestId: saleRequestId,
        //     )),
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
    reset(mockEcSaleRequestsRepository);
  });

  group('SaveSaleRequestController', () {
    test('should call all repositories and notifiers on success', () async {
      // ARRANGE
      const fakeSaleRequestNumber = '12345';
      final spyPending = SpySaleRequest(fakePendingRequest);
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
        pendingSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spyPending),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spyLastSaved),
        localSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        insertUpdateStateControllerProvider.overrideWith(
          () => FakeInsertUpdateStateController(
            saleRequestEntity: fakeBSFSaleRequestEntity,
          ),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ]);

      // Stub all async calls
      when(
        () => mockSoapSaveSaleRequestRepository.save(
          workingUrl: any(named: 'workingUrl'),
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
        saveSaleRequestControllerProvider(fakeEnterprise.Code!),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
          )
          .save(
            requestTypeCode: fakeRequestTypeCode,
            observations: observations,
            instructions: instructions,
            enterpriseCode: fakeEnterprise.Code!,
          );

      // ASSERT
      // 1. Check state
      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

      // 2. Verify SOAP repository was called
      verify(
        () => mockSoapSaveSaleRequestRepository.save(
          workingUrl: fakeSession.enterprise!.workingUrl!,
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
        spyLastSaved.savedEntity?.saleRequestEntity,
        fakePendingRequest.copyWith(
          observations: observations,
          instructions: instructions,
        ),
      );

      // 4. Verify local repo was cleared
      verify(() => mockLocalPendingRepo.clear(fakeEnterprise.Code!)).called(1);
      expect(fakeAppUsage.lastUsageType, UsageType.insertSaleRequest);
    });

    test('should emit [loading, error] if customer is null', () async {
      // ARRANGE
      final spyNoCustomer = SpySaleRequest(fakeRequestNoCustomer);
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
        pendingSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spyNoCustomer),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spyLastSaved),
        localSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        insertUpdateStateControllerProvider.overrideWith(
          () => FakeInsertUpdateStateController(
            saleRequestEntity: fakeBSFSaleRequestEntity,
          ),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ]);

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider(fakeEnterprise.Code!),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
          )
          .save(
            requestTypeCode: fakeRequestTypeCode,
            observations: observations,
            instructions: instructions,
            enterpriseCode: fakeEnterprise.Code!,
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
          workingUrl: any(named: 'workingUrl'),
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
      final spy = SpySaleRequest(fakePendingRequest);
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
        pendingSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spy),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => spyLastSaved),
        localSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        insertUpdateStateControllerProvider.overrideWith(
          () => FakeInsertUpdateStateController(
            saleRequestEntity: fakeBSFSaleRequestEntity,
          ),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ]);

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider(fakeEnterprise.Code!),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
          )
          .save(
            requestTypeCode: fakeRequestTypeCode,
            observations: observations,
            instructions: instructions,
            enterpriseCode: fakeEnterprise.Code!,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });

  group('saveBsfSaleRequest', () {
    test('should call ecSaleRequestsRepository.update on success', () async {
      // ARRANGE

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
        pendingSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => SpySaleRequest(fakePendingRequest)),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => SpyLastSavedSaleRequest()),
        localSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),

        insertUpdateStateControllerProvider.overrideWith(
          () => FakeInsertUpdateStateController(
            saleRequestEntity: fakeBSFSaleRequestEntity,
          ),
        ),
      ]);

      when(
        () => mockEcSaleRequestsRepository.update(
          saleRequest: any(named: 'saleRequest'),
          enterpriseCode: any(named: 'enterpriseCode'),
          params: any(named: 'params'),
        ),
      ).thenAnswer((_) async {});

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider(fakeEnterprise.Code!),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
          )
          .saveBsfSaleRequest(
            customerCode: fakePendingRequest.customer!.Code!,
            saleRequestId: saleRequestId,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
      final capturedParams =
          verify(
                () => mockEcSaleRequestsRepository.update(
                  saleRequest: fakeBSFSaleRequestEntity,
                  enterpriseCode: fakeEnterprise.Code!,
                  params: captureAny(named: 'params'),
                ),
              ).captured.single
              as EcRequestParams;

      expect(capturedParams.workingUrl, fakeSession.enterprise!.workingUrl);
      expect(capturedParams.user, fakeSession.user.name);
      expect(capturedParams.accessKey, fakeSession.user.AccessKey);
    });

    test('should emit [loading, error] if update fails', () async {
      // ARRANGE

      // Update ALL overrides
      container.updateOverrides([
        insertUpdateStateControllerProvider.overrideWith(
          () => FakeInsertUpdateStateController(
            saleRequestEntity: fakeBSFSaleRequestEntity,
          ),
        ),
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(
          mockSoapSaveSaleRequestRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => SpySaleRequest(fakePendingRequest)),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(() => SpyLastSavedSaleRequest()),
        localSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ]);

      when(
        () => mockEcSaleRequestsRepository.update(
          saleRequest: any(named: 'saleRequest'),
          enterpriseCode: any(named: 'enterpriseCode'),
          params: any(named: 'params'),
        ),
      ).thenThrow(AppException('Error updating'.hardcoded));

      final states = <AsyncValue<void>>[];
      container.listen(
        saveSaleRequestControllerProvider(fakeEnterprise.Code!),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
          )
          .saveBsfSaleRequest(
            customerCode: fakePendingRequest.customer!.Code!,
            saleRequestId: saleRequestId,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());
      expect((states.last.error as AppException).message, 'Error updating');
    });
  });
}
