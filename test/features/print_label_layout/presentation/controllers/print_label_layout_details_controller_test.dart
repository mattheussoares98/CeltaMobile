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
  late BSFPrintLabelLayoutEntity layout;

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
    layout = EntityFactory.makeBSFPrintLabelLayoutEntity();
  });

  test('build should load details for the requested layout code', () async {
    when(
      () => repository.getDetails(params, layout.code),
    ).thenAnswer((_) async => layout);
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      printLabelLayoutDetailsControllerProvider(layout.code).future,
    );

    expect(result, layout);
    verify(() => repository.getDetails(params, layout.code)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('build should propagate repository errors', () async {
    final exception = Exception('Failed to load label layout details');
    when(() => repository.getDetails(params, layout.code)).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);

    final call = container.read(
      printLabelLayoutDetailsControllerProvider(layout.code).future,
    );

    await expectLater(call, throwsA(same(exception)));
    verify(() => repository.getDetails(params, layout.code)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
