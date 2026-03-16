import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcGetSaleRequestsDatasource sut;

  late HttpClientSpy httpClient;

  late String workingUrl;
  late String user;
  late String accessKey;
  late List<int> enterpriseIds;
  late DateTime endDateHourOfCreation;
  late DateTime startDateHourOfCreation;
  late List<String>? personalizedCodes;
  late bool? mountCustomer;
  late bool? mountSeller;
  late bool? mountRequestType;
  late bool? mountProducts;
  late List<EcSaleRequestModel> saleRequests;

  void initSut() {
    sut = EcGetSaleRequestsDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void mockSuccess() {
    httpClient.mockRequest(saleRequests.map((e) => e.toJson()).toList());
  }

  void initEntities() {
    saleRequests = [
      for (var x = 0; x < 3; x++)
        EcSaleRequestModel.fromEntity(
          EntityFactory.makePendingSaleRequestEntity(), //TODO update this name
        ),
    ];

    workingUrl = faker.internet.httpsUrl();

    user = faker.person.name();
    accessKey = faker.randomGenerator.string(10);
    enterpriseIds = [1, 2, 3];
    startDateHourOfCreation = faker.date.dateTime();
    endDateHourOfCreation = startDateHourOfCreation.add(
      const Duration(days: 1),
    );
    personalizedCodes = [faker.randomGenerator.string(10)];
    mountCustomer = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.boolean()
        : null;
    mountSeller = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.boolean()
        : null;
    mountRequestType = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.boolean()
        : null;
    mountProducts = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.boolean()
        : null;
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    final response = await sut.get(
      workingUrl: workingUrl,
      user: user,
      accessKey: accessKey,
      enterpriseIds: enterpriseIds,
      endDateHourOfCreation: endDateHourOfCreation,
      startDateHourOfCreation: startDateHourOfCreation,
      mountCustomer: mountCustomer,
      mountProducts: mountProducts,
      mountRequestType: mountRequestType,
      mountSeller: mountSeller,
      personalizedCodes: personalizedCodes,
    );

    expect(response, saleRequests);

    verify(
      () => httpClient.request(
        url: '$workingUrl/api/GetSaleRequests',
        method: 'post',
        headers: {'user': user, 'accessKey': accessKey},
        body: {
          'enterpriseIds': enterpriseIds,
          'endDateHourOfCreation': endDateHourOfCreation,
          'startDateHourOfCreation': startDateHourOfCreation,
          'personalizedCodes': ?personalizedCodes,
          'mountCustomer': ?mountCustomer,
          'mountSeller': ?mountSeller,
          'mountRequestType': ?mountRequestType,
          'mountProducts': ?mountProducts,
        },
      ),
    ).called(1);
  });
}
