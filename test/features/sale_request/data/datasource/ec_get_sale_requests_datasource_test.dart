import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcGetSaleRequestsDatasource sut;

  late HttpClientSpy httpClient;

  late EcRequestParams params;
  late List<int> enterpriseIds;
  late DateTime endDateHourOfCreation;
  late DateTime startDateHourOfCreation;
  late List<String> personalizedCodes;
  late bool mountCustomer;
  late bool mountSeller;
  late bool mountRequestType;
  late bool mountProducts;
  late int id;
  late EcPaginationResults<EcSaleRequestModel> saleRequests;

  void initSut() {
    sut = EcGetSaleRequestsDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void mockSuccess() {
    httpClient.mockRequest(saleRequests.toJson((e) => e.toJson()));
  }

  void initEntities() {
    saleRequests = EcPaginationResults(
      totalRecords: faker.randomGenerator.integer(1000),
      recordsByPage: faker.randomGenerator.integer(1000),
      actualPage: faker.randomGenerator.integer(5),
      recordsOnThisPage: faker.randomGenerator.integer(5),
      totalPages: faker.randomGenerator.integer(5),
      collection: [
        for (var x = 0; x < 3; x++)
          EcSaleRequestModel.fromEntity(EntityFactory.makeSaleRequestEntity()),
      ],
    );

    params = EntityFactory.makeEcRequestParams();
    enterpriseIds = [1, 2, 3];
    startDateHourOfCreation = faker.date.dateTime();
    endDateHourOfCreation = startDateHourOfCreation.add(
      const Duration(days: 1),
    );
    personalizedCodes = [faker.randomGenerator.string(10)];
    mountCustomer = faker.randomGenerator.boolean();
    mountSeller = faker.randomGenerator.boolean();
    mountRequestType = faker.randomGenerator.boolean();
    mountProducts = faker.randomGenerator.boolean();
    id = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    final response = await sut.get(
      params: params,
      enterpriseIds: enterpriseIds,
      endDateHourOfCreation: endDateHourOfCreation,
      startDateHourOfCreation: startDateHourOfCreation,
      mountCustomer: mountCustomer,
      mountProducts: mountProducts,
      mountRequestType: mountRequestType,
      mountSeller: mountSeller,
      personalizedCodes: personalizedCodes,
      id: id,
    );

    expect(response, saleRequests);

    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/SaleRequests/GetSaleRequests',
        method: 'post',
        headers: params.toHeaders(),
        body: {
          'enterpriseIds': enterpriseIds,
          'id': id,
          'dateHourOfCreation': {
            'EndDate': endDateHourOfCreation.toIso8601String(),
            'StartDate': startDateHourOfCreation.toIso8601String(),
          },
          'personalizedCodes': personalizedCodes,
          'mountCustomer': mountCustomer,
          'mountSeller': mountSeller,
          'mountRequestType': mountRequestType,
          'mountProducts': mountProducts,
          ...params.toMap(),
        },
      ),
    ).called(1);
  });
  test('should behave correctly when receive null values', () async {
    final response = await sut.get(params: params);

    expect(response, saleRequests);

    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/SaleRequests/GetSaleRequests',
        method: 'post',
        headers: params.toHeaders(),
        body: {...params.toMap()},
      ),
    ).called(1);
  });
}
