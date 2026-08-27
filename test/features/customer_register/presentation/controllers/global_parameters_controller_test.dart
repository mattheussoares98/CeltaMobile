import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/customer_register/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcGlobalParametersRepository extends Mock
    implements IEcGlobalParametersRepository {}

BSFGlobalParametersEntity makeGlobalParametersEntity() =>
    const BSFGlobalParametersEntity(requiredCpfCnpjInCustomer: true);

void main() {
  late MockEcGlobalParametersRepository repository;
  late EcRequestParams params;

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      ecRequestParamsProvider().overrideWith((ref) => params),
      ecGlobalParametersRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockEcGlobalParametersRepository();
    params = EntityFactory.makeEcRequestParams();
  });

  test('should load and keep the global parameters alive', () async {
    final entity = makeGlobalParametersEntity();
    when(
      () => repository.getGlobalParameters(params),
    ).thenAnswer((_) async => entity);
    final container = makeContainer();
    addTearDown(container.dispose);

    final firstResult = await container.read(
      globalParametersControllerProvider.future,
    );
    final secondResult = await container.read(
      globalParametersControllerProvider.future,
    );

    expect(firstResult, entity);
    expect(secondResult, entity);
    verify(() => repository.getGlobalParameters(params)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should propagate repository errors', () async {
    final exception = Exception('Failed to get global parameters');
    when(() => repository.getGlobalParameters(params)).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);

    final call = container.read(globalParametersControllerProvider.future);

    await expectLater(call, throwsA(same(exception)));
    verify(() => repository.getGlobalParameters(params)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
