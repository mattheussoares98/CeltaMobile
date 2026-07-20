import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/models/ec_buy_request_dto/ec_buy_request_dto_model.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcBuyRequestDatasource sut;
  late HttpClientSpy httpClient;
  late LoadShallowBuyRequestParams params;
  late List<EcBuyRequestDtoModel> models;

  setUp(() {
    httpClient = HttpClientSpy();
    sut = EcBuyRequestDatasource(httpClient);

    params = LoadShallowBuyRequestParams(
      requestParams: EcRequestParams(
        workingUrl: faker.internet.httpUrl(),
        user: faker.guid.guid(),
        accessKey: faker.guid.guid(),
      ),
      selectedDate: DateTime(2026, 7, 20),
      enterpriseCode: faker.randomGenerator.integer(100),
    );

    models = [
      EntityFactory.makeEcBuyRequestDtoEntity(),
      EntityFactory.makeEcBuyRequestDtoEntity(),
      EntityFactory.makeEcBuyRequestDtoEntity(),
    ].map((e) => EcBuyRequestDtoModel.fromEntity(e)).toList();
  });

  group('loadShallow', () {
    test(
      'should call httpClient with correct parameters and return list of EcBuyRequestDtoModel on success',
      () async {
        httpClient.mockRequest(models.map((e) => e.toJson()).toList());

        final response = await sut.loadShallow(params);

        expect(response, models);

        verify(
          () => httpClient.request(
            url: '${params.requestParams.workingUrl}/api/BuyRequest/Shallow',
            method: 'post',
            headers: params.requestParams.toHeaders(),
            body: {
              ...params.requestParams.toMap(),
              'InitialCreateDate': params.selectedDate.toIso8601String(),
              'EnterpriseCode': params.enterpriseCode,
            },
          ),
        ).called(1);
      },
    );
  });
}
