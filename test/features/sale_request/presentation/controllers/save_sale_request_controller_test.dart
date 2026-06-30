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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes, Mocks, and Spies ---

// Your Spy for SaleRequest is correct

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

class MockEcSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

class MockLocalBsfSaleRequestDraftRepository extends Mock
    implements ILocalBSFSaleRequestDraftRepository {}

void main() {
  late MockEcSaleRequestsRepository mockEcSaleRequestsRepository;
  late MockLocalBsfSaleRequestDraftRepository
  mockLocalBsfSaleRequestDraftRepository;
  late FakeAppUsageStateController fakeAppUsage;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late BSFSaleRequestEntity fakeBSFSaleRequestEntity;
  late EcRequestParams fakeParams;

  ProviderContainer makeProviderContainer({
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
        validatedUserSessionProvider.overrideWith(
          () =>
              fakeValidatedUserSession ?? FakeValidatedUserSession(fakeSession),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
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
    fakeBSFSaleRequestEntity = EntityFactory.makeBSFSaleRequestEntity()
        .copyWith(
          requestType: EntityFactory.makeBSFRequestTypeEntity().copyWith(
            generatePendencyFinancialTitle: false,
          ),
          financials: [],
        );

    fakeAppUsage = FakeAppUsageStateController();
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
        'should invalidate insertUpdateStateControllerProvider on success',
        () async {
          // ARRANGE
          when(
            () => mockEcSaleRequestsRepository.insert(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          ).thenAnswer((_) async {});
          when(
            () => mockLocalBsfSaleRequestDraftRepository.save(
              any(),
              enterpriseCode: any(named: 'enterpriseCode'),
              requestTypeCode: any(named: 'requestTypeCode'),
            ),
          ).thenAnswer((_) async {});

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

          int buildCount = 0;
          container.listen(insertUpdateStateControllerProvider, (
            previous,
            next,
          ) {
            // Notifiers emit AsyncLoading then AsyncData on each build.
            // We count the number of times it successfully finishes building.
            if (next is AsyncData && !next.isLoading) {
              buildCount++;
            }
          }, fireImmediately: true);

          // Warm up the provider so the first build is counted
          await container.read(insertUpdateStateControllerProvider.future);
          expect(buildCount, 1);

          // ACT
          await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(false);

          // ASSERT
          await container.read(insertUpdateStateControllerProvider.future);
          // After invalidation and reading, the provider rebuilt and emitted a new AsyncData.
          expect(buildCount, 2);
        },
      );
      test(
        'should invalidate saleRequestsStateControllerProvider on success',
        () async {
          // ARRANGE
          when(
            () => mockEcSaleRequestsRepository.insert(
              saleRequest: any(named: 'saleRequest'),
              enterpriseCode: any(named: 'enterpriseCode'),
              params: any(named: 'params'),
            ),
          ).thenAnswer((_) async {});
          when(
            () => mockLocalBsfSaleRequestDraftRepository.save(
              any(),
              enterpriseCode: any(named: 'enterpriseCode'),
              requestTypeCode: any(named: 'requestTypeCode'),
            ),
          ).thenAnswer((_) async {});

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

          int buildCount = 0;
          container.listen(
            saleRequestsStateControllerProvider(fakeEnterprise.Code!),
            (previous, next) {
              // Notifiers emit AsyncLoading then AsyncData on each build.
              // We count the number of times it successfully finishes building.
              if (next is AsyncData && !next.isLoading) {
                buildCount++;
              }
            },
            fireImmediately: true,
          );

          // Warm up the provider so the first build is counted
          await container.read(
            saleRequestsStateControllerProvider(fakeEnterprise.Code!).future,
          );
          expect(buildCount, 1);

          // ACT
          await container
              .read(
                saveSaleRequestControllerProvider(
                  fakeEnterprise.Code!,
                ).notifier,
              )
              .saveBsfSaleRequest(false);

          // ASSERT
          await container.read(
            saleRequestsStateControllerProvider(fakeEnterprise.Code!).future,
          );
          // After invalidation and reading, the provider rebuilt and emitted a new AsyncData.
          expect(buildCount, 2);
        },
      );

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
