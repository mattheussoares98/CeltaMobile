import 'package:celta_inventario/core/data/datasource/request_type/request_type.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcGetRequestTypesDatasource sut;
  late HttpClientSpy httpClient;

  late int enterpriseCode;
  late BSFSearchRequestTypeParametersEntity parameters;
  late EcRequestParams params;
  late List<BSFRequestTypeEntity> requestTypes;

  void initSut() {
    sut = EcGetRequestTypesDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void initEntities() {
    enterpriseCode = faker.randomGenerator.integer(100);
    parameters = EntityFactory.makeBSFSearchRequestTypeParametersEntity();
    params = EntityFactory.makeEcRequestParams();
    requestTypes = [
      EntityFactory.makeBSFRequestTypeEntity(),
      EntityFactory.makeBSFRequestTypeEntity(),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
  });

  group('search', () {
    test('should call httpClient with correct params', () async {
      final mockResponse = requestTypes
          .map((e) => BSFRequestTypeModel.fromEntity(e).toJson())
          .toList();
      httpClient.mockRequest(mockResponse);

      final result = await sut.search(
        parameters: parameters,
        enterpriseCode: enterpriseCode,
        params: params,
      );

      expect(result, isA<List<BSFRequestTypeModel>>());
      expect(result.length, requestTypes.length);
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/RequestTypes/GetRequestTypes',
          method: 'post',
          headers: params.toHeaders(),
          body: {
            'parameters': BSFSearchRequestTypeParametersModel.fromEntity(
              parameters,
            ).toJson(),
            'enterpriseCode': enterpriseCode,
          },
        ),
      ).called(1);
    });
  });
}
