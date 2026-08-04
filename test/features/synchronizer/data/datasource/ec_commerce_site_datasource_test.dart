import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late IEcCommerceSiteDatasource sut;
  late MockHttpClient httpClient;

  final params = EntityFactory.makeEcRequestParams();
  final entity = EntityFactory.makeEcCommerceSiteEntity();
  final model = EcCommerceSiteModel.fromEntity(entity);
  final body = {...params.toMap(), 'EnterpriseCode': entity.enterpriseCode};

  setUp(() {
    httpClient = MockHttpClient();
    sut = EcCommerceSiteDatasource(httpClient);
  });

  test('should post the enterprise code and return commerce sites', () async {
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/Enterprises/CommerceSites',
        method: 'post',
        headers: params.toHeaders(),
        body: body,
      ),
    ).thenAnswer((_) async => [model.toJson()]);

    final result = await sut.getCommerceSites(params, entity.enterpriseCode);

    expect(result, [model]);
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/Enterprises/CommerceSites',
        method: 'post',
        headers: params.toHeaders(),
        body: body,
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should propagate request errors', () async {
    final exception = Exception('Failed to get commerce sites');
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/Enterprises/CommerceSites',
        method: 'post',
        headers: params.toHeaders(),
        body: body,
      ),
    ).thenThrow(exception);

    final call = sut.getCommerceSites(params, entity.enterpriseCode);

    await expectLater(call, throwsA(same(exception)));
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/Enterprises/CommerceSites',
        method: 'post',
        headers: params.toHeaders(),
        body: body,
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });
}
