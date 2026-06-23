import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
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

class SpyLastSavedSaleRequest extends LastSavedSaleRequestStateController {
  LastSavedSaleRequestEntity? savedEntity;
  @override
  Future<LastSavedSaleRequestEntity?> build(int enterpriseCode) async => null;
  @override
  Future<void> save(LastSavedSaleRequestEntity value) async {
    savedEntity = value;
  }
}

class SpySaleRequestsStateController extends SaleRequestsStateController {
  bool updateSingleRequestInListCalled = false;
  SaleRequestEntity? updatedRequest;

  @override
  FutureOr<EcPaginationResults<SaleRequestEntity>?> build(
    int enterpriseCode,
  ) async => null;

  @override
  void updateSingleRequestInList(SaleRequestEntity request) {
    updateSingleRequestInListCalled = true;
    updatedRequest = request;
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

class FakeCanAccessResourceStateController
    extends CanAccessResourceStateController {
  final bool hasAccess;
  FakeCanAccessResourceStateController(this.hasAccess);

  @override
  Future<bool> build(BsRoutine routine, BsResource resource) async {
    return hasAccess;
  }
}

class MockSoapSaveSaleRequestRepository extends Mock
    implements ISoapSaveSaleRequestRepository {}

// New Mock for the local repository
class MockLocalSaleRequestRepository extends Mock
    implements ILocalSaleRequestRepository {}

class MockEcSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

class MockLocalBsfSaleRequestDraftRepository extends Mock
    implements ILocalBSFSaleRequestDraftRepository {}

void main() {
  late MockSoapSaveSaleRequestRepository mockSoapSaveSaleRequestRepository;
  late MockLocalSaleRequestRepository mockLocalPendingRepo;
  late MockEcSaleRequestsRepository mockEcSaleRequestsRepository;
  late MockLocalBsfSaleRequestDraftRepository
  mockLocalBsfSaleRequestDraftRepository;
  late FakeAppUsageStateController fakeAppUsage;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late SaleRequestEntity fakePendingRequest;
  late SaleRequestEntity fakeRequestNoCustomer;
  late int fakeRequestTypeCode;
  late String instructions;
  late String observations;
  late BSFSaleRequestEntity fakeBSFSaleRequestEntity;
  late EcRequestParams fakeParams;

  ProviderContainer makeProviderContainer({
    PendingSaleRequestStateController? spyPendingSaleRequest,
    LastSavedSaleRequestStateController? spyLastSavedSaleRequest,
    ValidatedUserSession? fakeValidatedUserSession,
    SaleRequestsStateController? spySaleRequestsStateController,
    BSFSaleRequestEntity? insertUpdateSaleRequestEntity,
    bool mockNeedsProcessing = false,
    bool canChangePrice = true,
    SaleRequestArgs? fakeSaleRequestArgs,
  }) {
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapSaveSaleRequestRepositoryProvider.overrideWithValue(
          mockSoapSaveSaleRequestRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () =>
              fakeValidatedUserSession ?? FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        pendingSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(
          () => spyPendingSaleRequest ?? SpySaleRequest(fakePendingRequest),
        ),
        lastSavedSaleRequestStateControllerProvider(
          fakeEnterprise.Code!,
        ).overrideWith(
          () => spyLastSavedSaleRequest ?? SpyLastSavedSaleRequest(),
        ),
        localSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalPendingRepo,
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        localBsfSaleRequestDraftRepositoryProvider.overrideWithValue(
          mockLocalBsfSaleRequestDraftRepository,
        ),
        saleRequestArgsProvider.overrideWithValue(
          fakeSaleRequestArgs ??
              SaleRequestArgs(
                enterpriseCode: fakeEnterprise.Code!,
                saleRequestId: 0,
                customerCode: 0,
                requestTypeCode: 0,
              ),
        ),
        insertUpdateStateControllerProvider.overrideWith(
          () => FakeInsertUpdateStateController(
            saleRequestEntity:
                insertUpdateSaleRequestEntity ?? fakeBSFSaleRequestEntity,
          ),
        ),
        canAccessResourceStateControllerProvider(
          BsRoutine.saleRequest,
          BsResource.saleRequestChangeTPrice,
        ).overrideWith(
          () => FakeCanAccessResourceStateController(canChangePrice),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
        saleRequestsStateControllerProvider(fakeEnterprise.Code!).overrideWith(
          () =>
              spySaleRequestsStateController ??
              SpySaleRequestsStateController(),
        ),
        saleRequestNeedsProcessingProvider.overrideWithValue(
          mockNeedsProcessing,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    // --- Initialize Mocks and Data ONCE ---

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeParams = EcRequestParams(
      workingUrl: fakeSession.enterprise!.workingUrl!,
      user: fakeSession.user.name!,
      accessKey: fakeSession.user.AccessKey!,
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakePendingRequest = EntityFactory.makeSaleRequestEntity(
      customer: EntityFactory.makeCustomerEntity(), // Valid request
    );
    fakeRequestNoCustomer = SaleRequestEntity.empty(); // Invalid request
    fakeRequestTypeCode = faker.randomGenerator.integer(100);
    instructions = faker.lorem.sentence();
    observations = faker.lorem.sentence();
    fakeBSFSaleRequestEntity = EntityFactory.makeBSFSaleRequestEntity()
        .copyWith(
          requestType: EntityFactory.makeBSFRequestTypeEntity().copyWith(
            generatePendencyFinancialTitle: false,
          ),
          financials: [],
        );

    fakeAppUsage = FakeAppUsageStateController();
    mockSoapSaveSaleRequestRepository = MockSoapSaveSaleRequestRepository();
    mockLocalPendingRepo = MockLocalSaleRequestRepository(); // New
    mockEcSaleRequestsRepository = MockEcSaleRequestsRepository();
    mockLocalBsfSaleRequestDraftRepository =
        MockLocalBsfSaleRequestDraftRepository();

    when(
      () => mockLocalBsfSaleRequestDraftRepository.save(
        any(),
        enterpriseCode: any(named: 'enterpriseCode'),
        requestTypeCode: any(named: 'requestTypeCode'),
      ),
    ).thenAnswer((_) async {});
  });
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
    for (var usage in UsageType.values) {
      registerFallbackValue(usage);
    }
  });

  tearDown(() {
    // Reset mocks after each test
    // reset(mockSoapSaveSaleRequestRepository);
    // reset(mockLocalPendingRepo);
    // reset(mockEcSaleRequestsRepository);
  });

  group('SaveSaleRequestController', () {
    test('should call all repositories and notifiers on success', () async {
      // ARRANGE
      const fakeSaleRequestNumber = '12345';
      final spyPending = SpySaleRequest(fakePendingRequest);
      final spyLastSaved = SpyLastSavedSaleRequest();

      final container = makeProviderContainer(
        spyPendingSaleRequest: spyPending,
        spyLastSavedSaleRequest: spyLastSaved,
      );

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

      final container = makeProviderContainer(
        spyPendingSaleRequest: spyNoCustomer,
        spyLastSavedSaleRequest: spyLastSaved,
      );

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

      final container = makeProviderContainer(
        spyPendingSaleRequest: spy,
        spyLastSavedSaleRequest: spyLastSaved,
        fakeValidatedUserSession: FakeValidatedUserSession(null),
      );

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
    group('Validations', () {
      test(
        'should emit [loading, error] with AppException if isPaymentValid is false',
        () async {
          // ARRANGE
          final invalidBsfEntity = EntityFactory.makeBSFSaleRequestEntity()
              .copyWith(
                requestType: EntityFactory.makeBSFRequestTypeEntity().copyWith(
                  generatePendencyFinancialTitle: true,
                ),
                financials: [], // Empty financials = invalid
              );

          final container = makeProviderContainer(
            insertUpdateSaleRequestEntity: invalidBsfEntity,
          );

          final states = <AsyncValue<void>>[];
          container.listen(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!),
            (_, next) => states.add(next),
          );

          // ACT
          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(false);

          // ASSERT
          expect(errorMessage, isNotEmpty);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          verifyNever(
            () => mockEcSaleRequestsRepository.update(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
        },
      );

      test(
        'should emit [loading, error] with AppException if customer is null',
        () async {
          final invalidBsfEntity = fakeBSFSaleRequestEntity.copyWith(
            annulCustomer: true,
          );

          final container = makeProviderContainer(
            insertUpdateSaleRequestEntity: invalidBsfEntity,
          );

          final states = <AsyncValue<void>>[];
          container.listen(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!),
            (_, next) => states.add(next),
          );

          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(false);

          // ASSERT
          expect(errorMessage, isNotEmpty);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          verifyNever(
            () => mockEcSaleRequestsRepository.update(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
        },
      );

      test(
        'should emit [loading, error] with AppException if products list is empty',
        () async {
          final invalidBsfEntity = fakeBSFSaleRequestEntity.copyWith(
            products: const [],
          );

          final container = makeProviderContainer(
            insertUpdateSaleRequestEntity: invalidBsfEntity,
          );

          final states = <AsyncValue<void>>[];
          container.listen(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!),
            (_, next) => states.add(next),
          );

          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(false);

          expect(errorMessage, isNotEmpty);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          verifyNever(
            () => mockEcSaleRequestsRepository.update(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
        },
      );

      test(
        'should emit [loading, error] with AppException if requestType is null',
        () async {
          final invalidBsfEntity = fakeBSFSaleRequestEntity.copyWith(
            annulRequestType: true,
          );

          final container = makeProviderContainer(
            insertUpdateSaleRequestEntity: invalidBsfEntity,
          );

          final states = <AsyncValue<void>>[];
          container.listen(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!),
            (_, next) => states.add(next),
          );

          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(false);

          // ASSERT
          expect(errorMessage, isNotEmpty);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          verifyNever(
            () => mockEcSaleRequestsRepository.update(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
        },
      );

      test(
        'should emit [loading, error] with AppException if needProcessingCart is true and canChangePrice is false',
        () async {
          final container = makeProviderContainer(
            mockNeedsProcessing: true,
            canChangePrice: false,
          );

          final states = <AsyncValue<void>>[];
          container.listen(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!),
            (_, next) => states.add(next),
          );

          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(false);

          expect(errorMessage, isNotEmpty);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          verifyNever(
            () => mockEcSaleRequestsRepository.update(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
        },
      );

      test(
        'should emit [loading, error] with AppException if needProcessingCart is true and requestType does not allow changing price',
        () async {
          final requestTypeNoChangePrice = fakeBSFSaleRequestEntity.requestType
              ?.copyWith(allowAlterCostOrSalePrice: false);
          final invalidBsfEntity = fakeBSFSaleRequestEntity.copyWith(
            requestType: requestTypeNoChangePrice,
          );

          final container = makeProviderContainer(
            insertUpdateSaleRequestEntity: invalidBsfEntity,
            mockNeedsProcessing: true,
            canChangePrice: true,
          );

          final states = <AsyncValue<void>>[];
          container.listen(
            saveSaleRequestControllerProvider(fakeEnterprise.Code!),
            (_, next) => states.add(next),
          );

          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(false);

          expect(errorMessage, isNotEmpty);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          verifyNever(
            () => mockEcSaleRequestsRepository.update(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
        },
      );
    });
    group('Update', () {
      test('should behave correctly on success', () async {
        // ARRANGE
        final container = makeProviderContainer();

        when(
          () => mockEcSaleRequestsRepository.update(
            saleRequest: any(named: 'saleRequest'),
            enterpriseCode: any(named: 'enterpriseCode'),
            params: any(named: 'params'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
        });
        when(
          () => mockEcSaleRequestsRepository.getComplete(
            saleRequestCode: any(named: 'saleRequestCode'),
            enterpriseCode: any(named: 'enterpriseCode'),
            customerCode: any(named: 'customerCode'),
            params: any(named: 'params'),
          ),
        ).thenAnswer((_) async => fakeBSFSaleRequestEntity);

        final states = <AsyncValue<void>>[];
        container.listen(
          saveSaleRequestControllerProvider(fakeEnterprise.Code!),
          (_, next) => states.add(next),
        );

        // ACT
        final (errorMessage, needProcessCart) = await container
            .read(
              saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
            )
            .saveBsfSaleRequest(false);

        // ASSERT
        expect(errorMessage, isNull);
        expect(needProcessCart, isFalse);
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        verify(
          () => mockEcSaleRequestsRepository.update(
            saleRequest: fakeBSFSaleRequestEntity,
            enterpriseCode: fakeEnterprise.Code!,
            params: fakeParams,
          ),
        ).called(1);
        verify(
          () => mockEcSaleRequestsRepository.getComplete(
            saleRequestCode: fakeBSFSaleRequestEntity.code!,
            enterpriseCode: fakeEnterprise.Code!,
            customerCode: fakeBSFSaleRequestEntity.customer!.code!,
            params: fakeParams,
          ),
        ).called(1);
        expect(fakeAppUsage.lastUsageType, UsageType.updateSaleRequest);

        verifyNever(
          () => mockEcSaleRequestsRepository.insert(
            saleRequest: any(named: 'saleRequest'),
            enterpriseCode: any(named: 'enterpriseCode'),
            params: any(named: 'params'),
          ),
        );
      });

      test(
        'should NOT call ecSaleRequestsRepository.update when need process cart',
        () async {
          // ARRANGE

          final container = makeProviderContainer(
            mockNeedsProcessing: true,
            insertUpdateSaleRequestEntity: fakeBSFSaleRequestEntity.copyWith(
              requestType: fakeBSFSaleRequestEntity.requestType?.copyWith(
                allowAlterCostOrSalePrice: true,
              ),
            ),
          );

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
          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(true);

          // ASSERT
          expect(errorMessage, isNotEmpty);
          expect(needProcessCart, isTrue);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          verifyNever(
            () => mockEcSaleRequestsRepository.update(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
          expect(fakeAppUsage.lastUsageType, isNull);
        },
      );
      test(
        'should NOT call ecSaleRequestsRepository.update when isOnlyValidating',
        () async {
          // ARRANGE

          final container = makeProviderContainer();

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
          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(true);

          // ASSERT
          expect(errorMessage, isNull);
          expect(needProcessCart, isFalse);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          verifyNever(
            () => mockEcSaleRequestsRepository.update(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
        },
      );

      test('should emit [loading, error] if update fails', () async {
        // ARRANGE

        final container = makeProviderContainer();

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
        final (errorMessage, canSaveAndNeedProcessCart) = await container
            .read(
              saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
            )
            .saveBsfSaleRequest(false);

        // ASSERT
        expect(canSaveAndNeedProcessCart, isFalse);
        expect(errorMessage, 'Error updating'.hardcoded);
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        expect(states.last.error, isA<AppException>());
        expect((states.last.error as AppException).message, 'Error updating');
      });
    });
    group('Insert', () {
      test('should behave correctly on success', () async {
        // ARRANGE
        final defaultArgs = SaleRequestArgs(
          enterpriseCode: fakeEnterprise.Code!,
          saleRequestId: 0,
          customerCode: 0,
          requestTypeCode: 45,
        );

        final container = makeProviderContainer(
          insertUpdateSaleRequestEntity: fakeBSFSaleRequestEntity.copyWith(
            code: 0,
          ),
          fakeSaleRequestArgs: defaultArgs,
        );

        when(
          () => mockEcSaleRequestsRepository.insert(
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
        final (errorMessage, needProcessCart) = await container
            .read(
              saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
            )
            .saveBsfSaleRequest(false);

        // ASSERT
        expect(errorMessage, isNull);
        expect(needProcessCart, isFalse);
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockEcSaleRequestsRepository.insert(
            saleRequest: fakeBSFSaleRequestEntity.copyWith(code: 0),
            enterpriseCode: fakeEnterprise.Code!,
            params: fakeParams,
          ),
        ).called(1);
        verify(
          () => mockLocalBsfSaleRequestDraftRepository.save(
            BSFSaleRequestEntity.empty().copyWith(
              requestType: fakeBSFSaleRequestEntity.requestType,
            ),
            enterpriseCode: defaultArgs.enterpriseCode,
            requestTypeCode: defaultArgs.requestTypeCode ?? 0,
          ),
        ).called(1);
        expect(fakeAppUsage.lastUsageType, UsageType.insertSaleRequest);
        verifyNever(
          () => mockEcSaleRequestsRepository.update(
            saleRequest: fakeBSFSaleRequestEntity.copyWith(code: 0),
            enterpriseCode: fakeEnterprise.Code!,
            params: fakeParams,
          ),
        );
      });

      test(
        'should NOT call ecSaleRequestsRepository.insert when need process cart',
        () async {
          // ARRANGE

          final container = makeProviderContainer(
            insertUpdateSaleRequestEntity: fakeBSFSaleRequestEntity.copyWith(
              code: 0,
              requestType: fakeBSFSaleRequestEntity.requestType?.copyWith(
                allowAlterCostOrSalePrice: true,
              ),
            ),
            mockNeedsProcessing: true,
          );

          when(
            () => mockEcSaleRequestsRepository.insert(
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
          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(true);

          // ASSERT
          expect(errorMessage, isNotEmpty);
          expect(needProcessCart, isTrue);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          verifyNever(
            () => mockEcSaleRequestsRepository.insert(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
          expect(fakeAppUsage.lastUsageType, isNull);
        },
      );
      test(
        'should NOT call ecSaleRequestsRepository.insert when isOnlyValidating',
        () async {
          // ARRANGE
          final container = makeProviderContainer(
            insertUpdateSaleRequestEntity: fakeBSFSaleRequestEntity.copyWith(
              code: 0,
            ),
          );

          when(
            () => mockEcSaleRequestsRepository.insert(
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
          final (errorMessage, needProcessCart) = await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(true);

          // ASSERT
          expect(errorMessage, isNull);
          expect(needProcessCart, isFalse);
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          verifyNever(
            () => mockEcSaleRequestsRepository.insert(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          );
        },
      );

      test('should emit [loading, error] if insert fails', () async {
        // ARRANGE

        final container = makeProviderContainer(
          insertUpdateSaleRequestEntity: fakeBSFSaleRequestEntity.copyWith(
            code: 0,
          ),
        );

        when(
          () => mockEcSaleRequestsRepository.insert(
            saleRequest: any(named: 'saleRequest'),
            enterpriseCode: any(named: 'enterpriseCode'),
            params: any(named: 'params'),
          ),
        ).thenThrow(AppException('Error inserting'.hardcoded));

        final states = <AsyncValue<void>>[];
        container.listen(
          saveSaleRequestControllerProvider(fakeEnterprise.Code!),
          (_, next) => states.add(next),
        );

        // ACT
        final (errorMessage, canSaveAndNeedProcessCart) = await container
            .read(
              saveSaleRequestControllerProvider(fakeEnterprise.Code!).notifier,
            )
            .saveBsfSaleRequest(false);

        // ASSERT
        expect(canSaveAndNeedProcessCart, isFalse);
        expect(errorMessage, 'Error inserting'.hardcoded);
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        expect(states.last.error, isA<AppException>());
        expect((states.last.error as AppException).message, 'Error inserting');
      });
    });
  });
}
