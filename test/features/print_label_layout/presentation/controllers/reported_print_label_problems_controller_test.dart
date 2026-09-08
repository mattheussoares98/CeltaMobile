import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockPrintLabelProblemReportRepository extends Mock
    implements IPrintLabelProblemReportRepository {}

void main() {
  late MockPrintLabelProblemReportRepository repository;
  late ReportedPrintLabelProblemEntity report;

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      printLabelProblemReportRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockPrintLabelProblemReportRepository();
    report = EntityFactory.makeReportedPrintLabelProblemEntity();
  });

  test('provider loads and returns every reported problem', () async {
    when(() => repository.getAll()).thenAnswer((_) async => [report]);
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      reportedPrintLabelProblemsControllerProvider.future,
    );

    expect(result, [report]);
    verify(() => repository.getAll()).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('provider propagates repository errors', () async {
    final exception = Exception('Failed to load reported problems');
    when(() => repository.getAll()).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);

    final call = container.read(
      reportedPrintLabelProblemsControllerProvider.future,
    );

    await expectLater(call, throwsA(same(exception)));
    verify(() => repository.getAll()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
