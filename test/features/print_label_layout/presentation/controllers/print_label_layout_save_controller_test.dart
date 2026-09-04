import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcPrintLabelLayoutRepository extends Mock
    implements IEcPrintLabelLayoutRepository {}

void main() {
  late MockEcPrintLabelLayoutRepository repository;
  late EcRequestParams params;
  late BSFPrintLabelLayoutEntity layout;

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      ecRequestParamsProvider().overrideWith((ref) => params),
      ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockEcPrintLabelLayoutRepository();
    params = EntityFactory.makeEcRequestParams();
    layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      formWidth: 100,
      formHeight: 50,
      quantityColumns: 1,
      labelWidth: 90,
      labelHeight: 40,
      labelRightMargin: 0,
      labelBottomMargin: 0,
      temperature: 10,
      printSpeed: 2,
      intervalPrintPackage: 1,
      applyFormSizeConfiguration: true,
    );
    when(
      () => repository.getDetails(params, layout.code),
    ).thenAnswer((_) async => layout);
  });

  test(
    'save should load separately and refresh details after success',
    () async {
      final updated = layout.copyWith(name: 'Server name');
      final completer = Completer<BSFPrintLabelLayoutEntity>();
      when(
        () => repository.update(params, layout),
      ).thenAnswer((_) => completer.future);
      final container = makeContainer();
      addTearDown(container.dispose);
      final detailsProvider = printLabelLayoutDetailsControllerProvider(
        layout.code,
      );
      final saveProvider = printLabelLayoutSaveControllerProvider(layout.code);
      await container.read(detailsProvider.future);

      final save = container.read(saveProvider.notifier).save();

      expect(container.read(saveProvider).isLoading, isTrue);
      expect(container.read(detailsProvider).requireValue, layout);
      completer.complete(updated);
      await save;
      expect(container.read(saveProvider).hasValue, isTrue);
      expect(container.read(detailsProvider).requireValue, updated);
      verify(() => repository.update(params, layout)).called(1);
    },
  );

  test(
    'save should expose validation errors without calling the repository',
    () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final detailsProvider = printLabelLayoutDetailsControllerProvider(
        layout.code,
      );
      final saveProvider = printLabelLayoutSaveControllerProvider(layout.code);
      await container.read(detailsProvider.future);
      container.read(detailsProvider.notifier).updateName(' ');

      await container.read(saveProvider.notifier).save();

      expect(container.read(saveProvider).error, isA<AppException>());
      expect(container.read(saveProvider).error.toString(), contains('Nome:'));
      verifyNever(() => repository.update(params, layout));
    },
  );

  test(
    'save should retain details on failure, allow retry, and deduplicate',
    () async {
      final exception = Exception('Update failed');
      final completer = Completer<BSFPrintLabelLayoutEntity>();
      var attempts = 0;
      when(() => repository.update(params, layout)).thenAnswer((_) {
        attempts++;
        if (attempts == 1) return Future.error(exception);
        return completer.future;
      });
      final container = makeContainer();
      addTearDown(container.dispose);
      final detailsProvider = printLabelLayoutDetailsControllerProvider(
        layout.code,
      );
      final saveProvider = printLabelLayoutSaveControllerProvider(layout.code);
      await container.read(detailsProvider.future);

      await container.read(saveProvider.notifier).save();
      expect(container.read(saveProvider).error, same(exception));
      expect(container.read(detailsProvider).requireValue, layout);

      final retry = container.read(saveProvider.notifier).save();
      await container.read(saveProvider.notifier).save();
      completer.complete(layout);
      await retry;

      verify(() => repository.update(params, layout)).called(2);
    },
  );
}
