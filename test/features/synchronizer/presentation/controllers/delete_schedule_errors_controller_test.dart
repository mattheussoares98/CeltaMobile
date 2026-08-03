import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
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
  late List<int> codes;
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
    codes = [
      faker.randomGenerator.integer(100),
      faker.randomGenerator.integer(100),
      faker.randomGenerator.integer(100),
    ];
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
    'should dispatch schedule codes to the schedule repository method',
    () async {
      when(
        () => repository.deleteScheduleErrors(params, codes),
      ).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(deleteScheduleErrorsControllerProvider.future);

      await container
          .read(deleteScheduleErrorsControllerProvider.notifier)
          .delete(codes, errorKey);

      verify(() => repository.deleteScheduleErrors(params, codes)).called(1);
      expect(
        container.read(deleteScheduleErrorsControllerProvider),
        const AsyncData<void>(null),
      );
      verifyNoMoreInteractions(repository);
    },
  );

  test('should expose repository errors in its state', () async {
    final exception = Exception('Failed to delete');
    when(
      () => repository.deleteScheduleErrors(params, codes),
    ).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(deleteScheduleErrorsControllerProvider.future);

    await container
        .read(deleteScheduleErrorsControllerProvider.notifier)
        .delete(codes, errorKey);

    expect(
      container.read(deleteScheduleErrorsControllerProvider).error,
      same(exception),
    );
    verify(() => repository.deleteScheduleErrors(params, codes)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should invalidate synchronizer details after success', () async {
    final detailsController = FakeSynchronizerDetailsStateController();
    when(
      () => repository.deleteScheduleErrors(params, codes),
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
        .read(deleteScheduleErrorsControllerProvider.notifier)
        .delete(codes, errorKey);
    await container.read(detailsProvider.future);

    expect(detailsController.buildCount, 2);
  });

  test('should invalidate selected synchronizer codes after success', () async {
    when(
      () => repository.deleteScheduleErrors(params, codes),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);
    final selectedCodesProvider =
        selectedSynchronizerCodesStateControllerProvider(
          SynchronizerErrorDetailType.schedule,
        );
    container.read(selectedCodesProvider.notifier).select(codes.first);

    await container
        .read(deleteScheduleErrorsControllerProvider.notifier)
        .delete(codes, errorKey);

    expect(container.read(selectedCodesProvider), isEmpty);
  });

  test('should ignore an empty code list', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(deleteScheduleErrorsControllerProvider.future);

    await container
        .read(deleteScheduleErrorsControllerProvider.notifier)
        .delete([], errorKey);

    expect(
      container.read(deleteScheduleErrorsControllerProvider),
      const AsyncData<void>(null),
    );
    verifyNoMoreInteractions(repository);
  });
}
