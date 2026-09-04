import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
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
  late BSFPrintLabelFieldEditorOptionsEntity options;
  late BSFPrintLabelLayoutEntity layout;
  late int layoutCode;

  ProviderContainer makeContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecRequestParamsProvider().overrideWith((ref) => params),
        ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
      ],
    );
  }

  setUp(() {
    repository = MockEcPrintLabelLayoutRepository();
    params = EntityFactory.makeEcRequestParams();
    options = EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity();
    layoutCode = 42;
    layout = EntityFactory.makeBSFPrintLabelLayoutEntity(code: layoutCode);
  });

  test('build should load all editor options for the layout', () async {
    when(
      () => repository.getFieldEditorOptions(params, layout),
    ).thenAnswer((_) async => options);
    when(
      () => repository.getDetails(params, layoutCode),
    ).thenAnswer((_) async => layout);
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      printLabelFieldEditorOptionsControllerProvider(layoutCode).future,
    );

    expect(result, options);
    verify(() => repository.getFieldEditorOptions(params, layout)).called(1);
    verify(() => repository.getDetails(params, layoutCode)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('build should propagate repository errors', () async {
    final exception = Exception('Failed to load field editor options');
    when(
      () => repository.getFieldEditorOptions(params, layout),
    ).thenThrow(exception);
    when(
      () => repository.getDetails(params, layoutCode),
    ).thenAnswer((_) async => layout);
    final container = makeContainer();
    addTearDown(container.dispose);

    final call = container.read(
      printLabelFieldEditorOptionsControllerProvider(layoutCode).future,
    );

    await expectLater(call, throwsA(same(exception)));
    verify(() => repository.getFieldEditorOptions(params, layout)).called(1);
    verify(() => repository.getDetails(params, layoutCode)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
