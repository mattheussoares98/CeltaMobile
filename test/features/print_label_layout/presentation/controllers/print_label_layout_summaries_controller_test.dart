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
  late BSFPrintLabelLayoutSummaryEntity summary;

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
    summary = EntityFactory.makeBSFPrintLabelLayoutSummaryEntity();
  });

  test('build should load and return label layout summaries', () async {
    when(
      () => repository.getSummaries(params),
    ).thenAnswer((_) async => [summary]);
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      printLabelLayoutSummariesControllerProvider.future,
    );

    expect(result, [summary]);
    verify(() => repository.getSummaries(params)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('build should propagate repository errors', () async {
    final exception = Exception('Failed to load label layout summaries');
    when(() => repository.getSummaries(params)).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);

    final call = container.read(
      printLabelLayoutSummariesControllerProvider.future,
    );

    await expectLater(call, throwsA(same(exception)));
    verify(() => repository.getSummaries(params)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
