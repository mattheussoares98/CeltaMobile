import 'package:celta_inventario/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_movement/data/models/models.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcBuyMovementDatasource sut;
  late HttpClientSpy httpClient;
  late LoadShallowBuyMovementParams shallowParams;
  late LoadBuyMovementDetailsParams detailsParams;
  late EcBuyMovementDtoModel model;

  setUp(() {
    httpClient = HttpClientSpy();
    sut = EcBuyMovementDatasource(httpClient);

    final requestParams = EntityFactory.makeEcRequestParams();
    shallowParams = LoadShallowBuyMovementParams(
      requestParams: requestParams,
      selectedDate: faker.date.dateTime(),
      enterpriseCode: faker.randomGenerator.integer(100),
    );
    detailsParams = LoadBuyMovementDetailsParams(
      requestParams: requestParams,
      buyMovementCode: faker.randomGenerator.integer(100),
    );
    model = EcBuyMovementDtoModel.fromEntity(
      EntityFactory.makeEcBuyMovementDtoEntity(),
    );
  });

  group('loadShallow', () {
    test(
      'should call httpClient with correct parameters and return models',
      () async {
        httpClient.mockRequest([model.toJson()]);

        final response = await sut.loadShallow(shallowParams);

        expect(response, [model]);
        verify(
          () => httpClient.request(
            url:
                '${shallowParams.requestParams.workingUrl}/api/BuyMovements/Shallow',
            method: 'post',
            headers: shallowParams.requestParams.toHeaders(),
            body: {
              ...shallowParams.requestParams.toMap(),
              'InitialEntranceDate': shallowParams.selectedDate
                  .toIso8601String(),
              'EnterpriseCode': shallowParams.enterpriseCode,
            },
          ),
        ).called(1);
      },
    );
  });

  group('loadDetails', () {
    test(
      'should call httpClient with correct parameters and return model',
      () async {
        httpClient.mockRequest(model.toJson());

        final response = await sut.loadDetails(detailsParams);

        expect(response, model);
        verify(
          () => httpClient.request(
            url:
                '${detailsParams.requestParams.workingUrl}/api/BuyMovements/Details',
            method: 'post',
            headers: detailsParams.requestParams.toHeaders(),
            body: {
              ...detailsParams.requestParams.toMap(),
              'BuyMovementCode': detailsParams.buyMovementCode,
            },
          ),
        ).called(1);
      },
    );
  });
}
