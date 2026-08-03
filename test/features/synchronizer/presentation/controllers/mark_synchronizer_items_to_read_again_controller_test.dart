import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcSynchronizerRepository extends Mock
    implements IEcSynchronizerRepository {}

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

  ProviderContainer makeContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecSynchronizerRepositoryProvider.overrideWithValue(repository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
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
