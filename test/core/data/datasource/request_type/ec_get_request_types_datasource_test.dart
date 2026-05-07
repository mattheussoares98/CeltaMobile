import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/request_type/request_type.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcGetRequestTypesDatasource sut;
  late HttpClientSpy httpClient;

  late EcRequestTypeParametersEntity parameters;
  late EcRequestParams params;
  late List<BSFRequestTypeEntity> requestTypes;

  void initSut() {
    sut = EcGetRequestTypesDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void initEntities() {
    parameters = EntityFactory.makeEcRequestTypeParametersEntity();
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
      final mockResponse = json.encode(
        requestTypes
            .map((e) => BSFRequestTypeModel.fromEntity(e).toJson())
            .toList(),
      );
      httpClient.mockRequest(mockResponse);

      final result = await sut.search(parameters: parameters, params: params);

      expect(result, isA<List<BSFRequestTypeModel>>());
      expect(result.length, requestTypes.length);
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/RequestTypes/v2',
          method: 'post',
          headers: params.toHeaders(),
          body: EcRequestTypeParametersModel.fromEntity(parameters).toJson(),
        ),
      ).called(1);
    });
  });
}
