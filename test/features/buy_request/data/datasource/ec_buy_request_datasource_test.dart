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
  late LoadShallowBuyRequestParams shallowParams;
  late LoadBuyRequestDetailsParams detailsParams;
  late List<EcBuyRequestDtoModel> models;

  setUp(() {
    httpClient = HttpClientSpy();
    sut = EcBuyRequestDatasource(httpClient);

    shallowParams = LoadShallowBuyRequestParams(
      requestParams: EntityFactory.makeEcRequestParams(),
      selectedDate: DateTime(2026, 7, 20),
      enterpriseCode: faker.randomGenerator.integer(100),
    );

    detailsParams = LoadBuyRequestDetailsParams(
      requestParams: EntityFactory.makeEcRequestParams(),
      buyRequestCode: faker.randomGenerator.integer(100),
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

        final response = await sut.loadShallow(shallowParams);

        expect(response, models);

        verify(
          () => httpClient.request(
            url:
                '${shallowParams.requestParams.workingUrl}/api/BuyRequest/Shallow',
            method: 'post',
            headers: shallowParams.requestParams.toHeaders(),
            body: {
              ...shallowParams.requestParams.toMap(),
              'InitialCreateDate': shallowParams.selectedDate.toIso8601String(),
              'EnterpriseCode': shallowParams.enterpriseCode,
            },
          ),
        ).called(1);
      },
    );
  });
  group('loadDetails', () {
    test(
      'should call httpClient with correct parameters and return list of EcBuyRequestDtoModel on success',
      () async {
        httpClient.mockRequest(models.first.toJson());

        final response = await sut.loadDetails(detailsParams);

        expect(response, models.first);

        verify(
          () => httpClient.request(
            url:
                '${detailsParams.requestParams.workingUrl}/api/BuyRequest/Details',
            method: 'post',
            headers: detailsParams.requestParams.toHeaders(),
            body: {
              ...detailsParams.requestParams.toMap(),
              'BuyRequestCode': detailsParams.buyRequestCode,
            },
          ),
        ).called(1);
      },
    );
  });
}
