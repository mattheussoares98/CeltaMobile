import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcSynchronizerRepository extends Mock
    implements IEcSynchronizerRepository {}

class FakeSynchronizerDetailsStateController
    extends SynchronizerDetailsStateController {
  int buildCount = 0;
  int loadSilentlyCount = 0;

  @override
  Future<SynchronizerErrorDetailsEntity> build(String errorKey) async {
    buildCount++;
    return EntityFactory.makeSynchronizerErrorDetailsEntity();
  }

  @override
  Future<void> loadSilently() async {
    loadSilentlyCount++;
  }
}

void main() {
  const rereadDetailTypes = <SynchronizerErrorDetailType>{
    SynchronizerErrorDetailType.coupon,
    SynchronizerErrorDetailType.saleRequestWithError,
  };
  const deleteDetailTypes = <SynchronizerErrorDetailType>{
    SynchronizerErrorDetailType.schedule,
    SynchronizerErrorDetailType.saleRequestWithError,
  };
  final unsupportedRereadDetailTypes =
      SynchronizerErrorDetailType.values.toSet()..removeAll(rereadDetailTypes);
  final unsupportedDeleteDetailTypes =
      SynchronizerErrorDetailType.values.toSet()..removeAll(deleteDetailTypes);

  late MockEcSynchronizerRepository repository;
  late UserSessionModel session;
  late EcRequestParams params;
  const codes = [123, 456];
  const enterpriseCode = 1;
  const enterpriseCommerceSiteCode = 2;
  const saleRequestIds = ['request-1', 'request-2'];
  const products = [
    ProductWithErrorActionParams(
      enterpriseCode: enterpriseCode,
      productCode: 10,
      productPackingCode: 20,
      enterpriseCommerceSiteCode: 30,
    ),
    ProductWithErrorActionParams(
      enterpriseCode: enterpriseCode,
      productCode: 40,
      productPackingCode: 50,
      enterpriseCommerceSiteCode: 60,
    ),
  ];
  const errorKey = 'any_key';

  setUp(() {
    repository = MockEcSynchronizerRepository();
    session = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    params = EcRequestParams(
      workingUrl: session.enterprise!.workingUrl!,
      user: session.user.name!,
      accessKey: session.user.AccessKey!,
    );
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  ProviderContainer makeContainer({
    FakeSynchronizerDetailsStateController? detailsController,
  }) => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      ecSynchronizerRepositoryProvider.overrideWithValue(repository),
      validatedUserSessionProvider.overrideWith(
        () => FakeValidatedUserSession(session),
      ),
      synchronizerDetailsStateControllerProvider(errorKey).overrideWith(
        () => detailsController ?? FakeSynchronizerDetailsStateController(),
      ),
    ],
  );

  void stubRepositoryMethod(SynchronizerErrorDetailType detailType) {
    switch (detailType) {
      case SynchronizerErrorDetailType.coupon:
        when(
          () => repository.markCouponsToReadAgain(params, codes),
        ).thenAnswer((_) async {});
      case SynchronizerErrorDetailType.schedule:
        when(
          () => repository.deleteScheduleErrors(params, codes),
        ).thenAnswer((_) async {});
      case SynchronizerErrorDetailType.saleRequestWithError:
        when(
          () => repository.markSaleRequestsWithErrorToReadAgain(params, codes),
        ).thenAnswer((_) async {});
        when(
          () => repository.deleteSaleRequestsWithError(params, codes),
        ).thenAnswer((_) async {});
      default:
        throw ArgumentError.value(detailType);
    }
  }

  void verifyRepositoryMethod(SynchronizerErrorDetailType detailType) {
    switch (detailType) {
      case SynchronizerErrorDetailType.coupon:
        verify(
          () => repository.markCouponsToReadAgain(params, codes),
        ).called(1);
      case SynchronizerErrorDetailType.schedule:
        verify(() => repository.deleteScheduleErrors(params, codes)).called(1);
      case SynchronizerErrorDetailType.saleRequestWithError:
        verify(
          () => repository.markSaleRequestsWithErrorToReadAgain(params, codes),
        ).called(1);
      default:
        throw ArgumentError.value(detailType);
    }
  }

  for (final detailType in rereadDetailTypes) {
    test('should reread $detailType through its repository method', () async {
      stubRepositoryMethod(detailType);
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(handleSelectedCodesControllerProvider.future);

      await container
          .read(handleSelectedCodesControllerProvider.notifier)
          .markToReadAgain(codes, errorKey, detailType);

      verifyRepositoryMethod(detailType);
      expect(
        container.read(handleSelectedCodesControllerProvider),
        const AsyncData<void>(null),
      );
      verifyNoMoreInteractions(repository);
    });
  }

  for (final detailType in deleteDetailTypes) {
    test('should delete $detailType through its repository method', () async {
      stubRepositoryMethod(detailType);
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(handleSelectedCodesControllerProvider.future);

      await container
          .read(handleSelectedCodesControllerProvider.notifier)
          .deleteSelected(codes, errorKey, detailType);

      switch (detailType) {
        case SynchronizerErrorDetailType.schedule:
          verify(
            () => repository.deleteScheduleErrors(params, codes),
          ).called(1);
        case SynchronizerErrorDetailType.saleRequestWithError:
          verify(
            () => repository.deleteSaleRequestsWithError(params, codes),
          ).called(1);
        default:
          throw ArgumentError.value(detailType);
      }
      expect(
        container.read(handleSelectedCodesControllerProvider),
        const AsyncData<void>(null),
      );
      verifyNoMoreInteractions(repository);
    });
  }

  group('unmarkSaleRequestsMarked', () {
    test('should delegate codes and refresh the related state', () async {
      final detailsController = FakeSynchronizerDetailsStateController();
      when(
        () => repository.unmarkSaleRequestsMarked(params, codes),
      ).thenAnswer((_) async {});
      final container = makeContainer(detailsController: detailsController);
      addTearDown(container.dispose);
      final detailsProvider = synchronizerDetailsStateControllerProvider(
        errorKey,
      );
      final detailsSubscription = container.listen(detailsProvider, (_, _) {});
      addTearDown(detailsSubscription.close);
      await container.read(detailsProvider.future);
      final selectedCodesProvider =
          selectedSynchronizerCodesStateControllerProvider(
            SynchronizerErrorDetailType.saleRequestMarked,
          );
      container.read(selectedCodesProvider.notifier).select(codes.first);

      await container
          .read(handleSelectedCodesControllerProvider.notifier)
          .unmarkSaleRequestsMarked(codes, errorKey);

      verify(
        () => repository.unmarkSaleRequestsMarked(params, codes),
      ).called(1);
      expect(detailsController.loadSilentlyCount, 1);
      expect(container.read(selectedCodesProvider), isEmpty);
      expect(
        container.read(handleSelectedCodesControllerProvider),
        const AsyncData<void>(null),
      );
      verifyNoMoreInteractions(repository);
    });

    test('should expose repository errors in its state', () async {
      final exception = Exception('Failed to unmark sale requests');
      when(
        () => repository.unmarkSaleRequestsMarked(params, codes),
      ).thenThrow(exception);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(handleSelectedCodesControllerProvider.notifier)
          .unmarkSaleRequestsMarked(codes, errorKey);

      expect(
        container.read(handleSelectedCodesControllerProvider).error,
        same(exception),
      );
      verify(
        () => repository.unmarkSaleRequestsMarked(params, codes),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should ignore an empty code list', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(handleSelectedCodesControllerProvider.future);

      await container
          .read(handleSelectedCodesControllerProvider.notifier)
          .unmarkSaleRequestsMarked(const [], errorKey);

      expect(
        container.read(handleSelectedCodesControllerProvider),
        const AsyncData<void>(null),
      );
      verifyNoMoreInteractions(repository);
    });
  });

  for (final detailType in unsupportedRereadDetailTypes) {
    test('should expose an error when rereading $detailType', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(handleSelectedCodesControllerProvider.future);

      await container
          .read(handleSelectedCodesControllerProvider.notifier)
          .markToReadAgain(codes, errorKey, detailType);

      expect(
        container.read(handleSelectedCodesControllerProvider).error,
        isA<AppException>(),
      );
      verifyNoMoreInteractions(repository);
    });
  }

  for (final detailType in unsupportedDeleteDetailTypes) {
    test('should expose an error when deleting $detailType', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(handleSelectedCodesControllerProvider.future);

      await container
          .read(handleSelectedCodesControllerProvider.notifier)
          .deleteSelected(codes, errorKey, detailType);

      expect(
        container.read(handleSelectedCodesControllerProvider).error,
        isA<AppException>(),
      );
      verifyNoMoreInteractions(repository);
    });
  }

  test('should expose repository errors in its state', () async {
    final exception = Exception('Failed to handle selected codes');
    when(
      () => repository.markCouponsToReadAgain(params, codes),
    ).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .markToReadAgain(codes, errorKey, SynchronizerErrorDetailType.coupon);

    expect(
      container.read(handleSelectedCodesControllerProvider).error,
      same(exception),
    );
    verify(() => repository.markCouponsToReadAgain(params, codes)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should mark products to send again', () async {
    when(
      () => repository.markProductsToSendAgain(params, products),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .markProductsToSendAgain(products, errorKey);

    verify(
      () => repository.markProductsToSendAgain(params, products),
    ).called(1);
    expect(
      container.read(handleSelectedCodesControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });

  test('should unmark products to send again', () async {
    when(
      () => repository.unmarkProductsToSendAgain(params, products),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .unmarkProductsToSendAgain(products, errorKey);

    verify(
      () => repository.unmarkProductsToSendAgain(params, products),
    ).called(1);
    expect(
      container.read(handleSelectedCodesControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });

  test('should mark products to ignore error', () async {
    when(
      () => repository.markProductsToIgnoreError(params, products),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .markProductsToIgnoreError(products, errorKey);

    verify(
      () => repository.markProductsToIgnoreError(params, products),
    ).called(1);
    expect(
      container.read(handleSelectedCodesControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });

  test('should expose product action repository errors in its state', () async {
    final exception = Exception('Failed to handle products');
    when(
      () => repository.markProductsToSendAgain(params, products),
    ).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .markProductsToSendAgain(products, errorKey);

    expect(
      container.read(handleSelectedCodesControllerProvider).error,
      same(exception),
    );
    verify(
      () => repository.markProductsToSendAgain(params, products),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });

  test(
    'should ignore an empty product list for every product action',
    () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(handleSelectedCodesControllerProvider.future);
      final controller = container.read(
        handleSelectedCodesControllerProvider.notifier,
      );

      await controller.markProductsToSendAgain(const [], errorKey);
      await controller.unmarkProductsToSendAgain(const [], errorKey);
      await controller.markProductsToIgnoreError(const [], errorKey);

      expect(
        container.read(handleSelectedCodesControllerProvider),
        const AsyncData<void>(null),
      );
      verifyNoMoreInteractions(repository);
    },
  );

  test('should insert sale requests to read again and return true', () async {
    when(
      () => repository.insertSaleRequestsToReadAgain(
        params,
        enterpriseCode: enterpriseCode,
        enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
        saleRequestIds: saleRequestIds,
      ),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);

    final succeeds = await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .insertSaleRequestsToReadAgain(
          errorKey,
          enterpriseCode: enterpriseCode,
          enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
          saleRequestIds: saleRequestIds,
        );

    expect(succeeds, isTrue);

    verify(
      () => repository.insertSaleRequestsToReadAgain(
        params,
        enterpriseCode: enterpriseCode,
        enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
        saleRequestIds: saleRequestIds,
      ),
    ).called(1);
    expect(
      container.read(handleSelectedCodesControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });

  test('should invalidate synchronizer details after success', () async {
    final detailsController = FakeSynchronizerDetailsStateController();
    when(
      () => repository.markCouponsToReadAgain(params, codes),
    ).thenAnswer((_) async {});
    final container = makeContainer(detailsController: detailsController);
    addTearDown(container.dispose);
    final detailsProvider = synchronizerDetailsStateControllerProvider(
      errorKey,
    );
    final subscription = container.listen(detailsProvider, (_, _) {});
    addTearDown(subscription.close);
    await container.read(detailsProvider.future);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .markToReadAgain(codes, errorKey, SynchronizerErrorDetailType.coupon);
    await container.read(detailsProvider.future);

    expect(detailsController.loadSilentlyCount, 1);
  });

  test('should invalidate selected synchronizer codes after success', () async {
    when(
      () => repository.markCouponsToReadAgain(params, codes),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);
    final selectedCodesProvider =
        selectedSynchronizerCodesStateControllerProvider(
          SynchronizerErrorDetailType.coupon,
        );
    container.read(selectedCodesProvider.notifier).select(codes.first);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .markToReadAgain(codes, errorKey, SynchronizerErrorDetailType.coupon);

    expect(container.read(selectedCodesProvider), isEmpty);
  });

  test('should ignore an empty code list', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(handleSelectedCodesControllerProvider.future);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .markToReadAgain(
          const [],
          errorKey,
          SynchronizerErrorDetailType.coupon,
        );

    expect(
      container.read(handleSelectedCodesControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });

  test('should ignore an empty sale request identifier list', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(handleSelectedCodesControllerProvider.future);

    final succeeds = await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .insertSaleRequestsToReadAgain(
          errorKey,
          enterpriseCode: enterpriseCode,
          enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
          saleRequestIds: [],
        );

    expect(succeeds, isFalse);

    expect(
      container.read(handleSelectedCodesControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });

  test('should mark send data to send again', () async {
    when(
      () => repository.markSendDataToSendAgain(
        any(),
        sendDataType: BSFSendDataType.sale,
        codes: any(named: 'codes'),
        mark: any(named: 'mark'),
      ),
    ).thenAnswer((_) async {});
    final mark = faker.randomGenerator.boolean();

    final container = makeContainer();
    addTearDown(container.dispose);

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .markSendDataToSendAgain(
          sendDataType: BSFSendDataType.sale,
          codes: codes,
          errorKey: errorKey,
          mark: mark,
        );

    verify(
      () => repository.markSendDataToSendAgain(
        params,
        sendDataType: BSFSendDataType.sale,
        codes: codes,
        mark: mark,
      ),
    ).called(1);
    expect(
      container.read(handleSelectedCodesControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });

  test(
    'should ignore an empty code list for markSendDataToSendAgain',
    () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(handleSelectedCodesControllerProvider.future);

      await container
          .read(handleSelectedCodesControllerProvider.notifier)
          .markSendDataToSendAgain(
            sendDataType: BSFSendDataType.sale,
            codes: const [],
            errorKey: errorKey,
            mark: true,
          );

      expect(
        container.read(handleSelectedCodesControllerProvider),
        const AsyncData<void>(null),
      );
      verifyNoMoreInteractions(repository);
    },
  );
}
