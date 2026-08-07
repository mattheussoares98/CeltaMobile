import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/entity_factory.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late IEcSellerDatasource datasource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = EcSellerDatasource(mockHttpClient);
  });

  group('get', () {
    final tParams = EntityFactory.makeEcRequestParams();
    final tEntity = EntityFactory.makeSellerEntity();
    final tModel = EcSellerModel.fromEntity(tEntity);
    final tModelList = [tModel];
    final tJsonList = [tModel.toJson()];
    final tEnterpriseCode = faker.randomGenerator.integer(100);

    test(
      'should return List<EcSellerModel> when the request is successful',
      () async {
        // Arrange
        when(
          () => mockHttpClient.request(
            url:
                '${tParams.workingUrl}/api/Sellers?enterpriseCode=$tEnterpriseCode',
            method: 'get',
            headers: tParams.toHeaders(),
          ),
        ).thenAnswer((_) async => tJsonList);

        // Act
        final result = await datasource.get(
          GetSellerParams(params: tParams, enterpriseCode: tEnterpriseCode),
        );

        // Assert
        expect(result, equals(tModelList));
        verify(
          () => mockHttpClient.request(
            url:
                '${tParams.workingUrl}/api/Sellers?enterpriseCode=$tEnterpriseCode',
            method: 'get',
            headers: tParams.toHeaders(),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test('should throw an exception when the request fails', () async {
      // Arrange
      final exception = Exception('Failed to get sellers');
      when(
        () => mockHttpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(exception);

      // Act
      final call = datasource.get(
        GetSellerParams(params: tParams, enterpriseCode: tEnterpriseCode),
      );

      // Assert
      expect(() => call, throwsA(equals(exception)));
      verify(
        () => mockHttpClient.request(
          url:
              '${tParams.workingUrl}/api/Sellers?enterpriseCode=$tEnterpriseCode',
          method: 'get',
          headers: tParams.toHeaders(),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });
}
