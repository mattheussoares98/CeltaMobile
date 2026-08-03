import 'dart:async';

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
  int loadSilentlyCount = 0;
  Object? loadSilentlyError;

  @override
  Future<SynchronizerErrorDetailsEntity> build(String errorKey) async =>
      EntityFactory.makeSynchronizerErrorDetailsEntity();

  @override
  Future<void> loadSilently() async {
    loadSilentlyCount++;
    if (loadSilentlyError case final error?) throw error;
  }
}

void main() {
  late MockEcSynchronizerRepository repository;
  late FakeSynchronizerDetailsStateController detailsController;
  late UserSessionModel session;
  late EcRequestParams params;

  const errorKey = 'sale_request_product_not_found';
  const productNotFoundCode = 101;
  const productCode = 202;
  const productPackingCode = 303;

  setUp(() {
    repository = MockEcSynchronizerRepository();
    detailsController = FakeSynchronizerDetailsStateController();
    session = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    params = EcRequestParams(
      workingUrl: session.enterprise!.workingUrl!,
      user: session.user.name!,
      accessKey: session.user.AccessKey!,
    );
  });

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      ecSynchronizerRepositoryProvider.overrideWithValue(repository),
      validatedUserSessionProvider.overrideWith(
        () => FakeValidatedUserSession(session),
      ),
      synchronizerDetailsStateControllerProvider(
        errorKey,
      ).overrideWith(() => detailsController),
    ],
  );

  Future<AsyncValue<void>> link(ProviderContainer container) async {
    final completer = Completer<AsyncValue<void>>();
    final subscription = container.listen(
      linkProductWithoutRegisterControllerProvider,
      (previous, next) {
        if (previous is AsyncLoading<void> && next is! AsyncLoading<void>) {
          completer.complete(next);
        }
      },
    );
    addTearDown(subscription.close);
    await container.read(linkProductWithoutRegisterControllerProvider.future);

    container
        .read(linkProductWithoutRegisterControllerProvider.notifier)
        .link(
          errorKey: errorKey,
          productNotFoundCode: productNotFoundCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
        );

    return completer.future;
  }

  test('link should link the product and refresh details', () async {
    when(
      () => repository.linkSaleRequestProductNotFound(
        params,
        productNotFoundCode: productNotFoundCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
      ),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await link(container);

    expect(result, const AsyncData<void>(null));
    verify(
      () => repository.linkSaleRequestProductNotFound(
        params,
        productNotFoundCode: productNotFoundCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
      ),
    ).called(1);
    expect(detailsController.loadSilentlyCount, 1);
    verifyNoMoreInteractions(repository);
  });

  test(
    'link should expose repository errors and not refresh details',
    () async {
      final exception = Exception('Failed to link product');
      when(
        () => repository.linkSaleRequestProductNotFound(
          params,
          productNotFoundCode: productNotFoundCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
        ),
      ).thenThrow(exception);
      final container = makeContainer();
      addTearDown(container.dispose);

      final result = await link(container);

      expect(result.error, same(exception));
      verify(
        () => repository.linkSaleRequestProductNotFound(
          params,
          productNotFoundCode: productNotFoundCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
        ),
      ).called(1);
      expect(detailsController.loadSilentlyCount, 0);
      verifyNoMoreInteractions(repository);
    },
  );

  test('link should expose detail refresh errors', () async {
    final exception = Exception('Failed to refresh details');
    detailsController.loadSilentlyError = exception;
    when(
      () => repository.linkSaleRequestProductNotFound(
        params,
        productNotFoundCode: productNotFoundCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
      ),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await link(container);

    expect(result.error, same(exception));
    expect(detailsController.loadSilentlyCount, 1);
    verify(
      () => repository.linkSaleRequestProductNotFound(
        params,
        productNotFoundCode: productNotFoundCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
      ),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });
}
