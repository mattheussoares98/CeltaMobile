import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/customer_register/data/models/models.dart';
import 'package:celta_inventario/features/customer_register/data/repositories/repositories.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/domain/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcGlobalParametersDatasource extends Mock
    implements IEcGlobalParametersDatasource {}

BSFGlobalParametersEntity makeGlobalParametersEntity() =>
    const BSFGlobalParametersEntity(requiredCpfCnpjInCustomer: true);

void main() {
  late IEcGlobalParametersRepository sut;
  late MockEcGlobalParametersDatasource datasource;
  late EcRequestParams params;

  setUp(() {
    datasource = MockEcGlobalParametersDatasource();
    sut = EcGlobalParametersRepositoryImpl(datasource);
    params = EntityFactory.makeEcRequestParams();
  });

  test('should map the global parameters model to an entity', () async {
    final entity = makeGlobalParametersEntity();
    final model = BSFGlobalParametersModel.fromEntity(entity);
    when(
      () => datasource.getGlobalParameters(params),
    ).thenAnswer((_) async => model);

    final result = await sut.getGlobalParameters(params);

    expect(result, entity);
    verify(() => datasource.getGlobalParameters(params)).called(1);
    verifyNoMoreInteractions(datasource);
  });

  test('should propagate datasource errors', () async {
    final exception = Exception('Failed to get global parameters');
    when(() => datasource.getGlobalParameters(params)).thenThrow(exception);

    final call = sut.getGlobalParameters(params);

    await expectLater(call, throwsA(same(exception)));
    verify(() => datasource.getGlobalParameters(params)).called(1);
    verifyNoMoreInteractions(datasource);
  });
}
