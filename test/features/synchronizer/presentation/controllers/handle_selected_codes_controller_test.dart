import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcSynchronizerRepository extends Mock
    implements IEcSynchronizerRepository {}

class FakeSynchronizerDetailsStateController
    extends SynchronizerDetailsStateController {
  int buildCount = 0;

  @override
  Future<SynchronizerErrorDetailsEntity> build(String errorKey) async {
    buildCount++;
    return EntityFactory.makeSynchronizerErrorDetailsEntity();
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

  ProviderContainer makeContainer({
    FakeSynchronizerDetailsStateController? detailsController,
  }) => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      ecSynchronizerRepositoryProvider.overrideWithValue(repository),
      validatedUserSessionProvider.overrideWith(
        () => FakeValidatedUserSession(session),
      ),
      if (detailsController != null)
        synchronizerDetailsStateControllerProvider(
          errorKey,
        ).overrideWith(() => detailsController),
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

  test('should insert sale requests to read again', () async {
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

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .insertSaleRequestsToReadAgain(
          errorKey,
          enterpriseCode: enterpriseCode,
          enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
          saleRequestIds: saleRequestIds,
        );

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

    expect(detailsController.buildCount, 2);
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

    await container
        .read(handleSelectedCodesControllerProvider.notifier)
        .insertSaleRequestsToReadAgain(
          errorKey,
          enterpriseCode: enterpriseCode,
          enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
          saleRequestIds: const [],
        );

    expect(
      container.read(handleSelectedCodesControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });
}
