import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
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
  late MockEcSynchronizerRepository repository;
  late UserSessionModel session;
  late EcRequestParams params;
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
  }) {
    return ProviderContainer(
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
  }

  test(
    'should dispatch coupon codes to the coupon repository method',
    () async {
      const codes = [123, 456];
      when(
        () => repository.markCouponsToReadAgain(params, codes),
      ).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(
        markSynchronizerItemsToReadAgainControllerProvider.future,
      );

      await container
          .read(markSynchronizerItemsToReadAgainControllerProvider.notifier)
          .markToReadAgain(codes, errorKey);

      verify(() => repository.markCouponsToReadAgain(params, codes)).called(1);
      expect(
        container.read(markSynchronizerItemsToReadAgainControllerProvider),
        const AsyncData<void>(null),
      );
      verifyNoMoreInteractions(repository);
    },
  );

  test('should expose repository errors in its state', () async {
    const codes = [123];
    final exception = Exception('Failed to mark coupons for rereading');
    when(
      () => repository.markCouponsToReadAgain(params, codes),
    ).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(
      markSynchronizerItemsToReadAgainControllerProvider.future,
    );

    await container
        .read(markSynchronizerItemsToReadAgainControllerProvider.notifier)
        .markToReadAgain(codes, errorKey);

    expect(
      container.read(markSynchronizerItemsToReadAgainControllerProvider).error,
      same(exception),
    );
    verify(() => repository.markCouponsToReadAgain(params, codes)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should invalidate synchronizer details after success', () async {
    const codes = [123];
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
        .read(markSynchronizerItemsToReadAgainControllerProvider.notifier)
        .markToReadAgain(codes, errorKey);
    await container.read(detailsProvider.future);

    expect(detailsController.buildCount, 2);
  });

  test('should invalidate selected synchronizer codes after success', () async {
    const codes = [123];
    when(
      () => repository.markCouponsToReadAgain(params, codes),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);
    final selectedCodesProvider =
        selectedSynchronizerCodesStateControllerProvider(
          SynchronizerErrorDetailType.couponMarkedToReadAgain,
        );
    container.read(selectedCodesProvider.notifier).select(codes.first);

    await container
        .read(markSynchronizerItemsToReadAgainControllerProvider.notifier)
        .markToReadAgain(codes, errorKey);

    expect(container.read(selectedCodesProvider), isEmpty);
  });

  test('should ignore an empty code list', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(
      markSynchronizerItemsToReadAgainControllerProvider.future,
    );

    await container
        .read(markSynchronizerItemsToReadAgainControllerProvider.notifier)
        .markToReadAgain(const [], errorKey);

    expect(
      container.read(markSynchronizerItemsToReadAgainControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });
}
