import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/customer_register/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late IEcGlobalParametersDatasource sut;
  late MockHttpClient httpClient;
  late EcRequestParams params;
  late BSFGlobalParametersModel model;

  setUp(() {
    httpClient = MockHttpClient();
    sut = EcGlobalParametersDatasource(httpClient);
    params = EntityFactory.makeEcRequestParams();
    model = const BSFGlobalParametersModel(requiredCpfCnpjInCustomer: true);
  });

  test('should get and map the global parameters', () async {
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/GlobalParameters',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenAnswer((_) async => model.toJson());

    final result = await sut.getGlobalParameters(params);

    expect(result, model);
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/GlobalParameters',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should propagate request errors', () async {
    final exception = Exception('Failed to get global parameters');
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/GlobalParameters',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenThrow(exception);

    final call = sut.getGlobalParameters(params);

    await expectLater(call, throwsA(same(exception)));
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/GlobalParameters',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });
}
