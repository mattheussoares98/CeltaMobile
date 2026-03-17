import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcGetSaleRequestsDatasourceSpy extends Mock
    implements IEcGetSaleRequestsDatasource {
  void mockGet(List<EcSaleRequestModel> response) => when(
    () => this.get(
      workingUrl: any(named: 'workingUrl'),
      user: any(named: 'user'),
      accessKey: any(named: 'accessKey'),
      enterpriseIds: any(named: 'enterpriseIds'),
      endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
      startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
      personalizedCodes: any(named: 'personalizedCodes'),
      mountCustomer: any(named: 'mountCustomer'),
      mountSeller: any(named: 'mountSeller'),
      mountRequestType: any(named: 'mountRequestType'),
      mountProducts: any(named: 'mountProducts'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late IEcGetSaleRequestsRepository sut;
  late EcGetSaleRequestsDatasourceSpy mockDatasource;

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

  late List<SaleRequestEntity> saleRequests;

  setUp(() {
    mockDatasource = EcGetSaleRequestsDatasourceSpy();
    sut = EcGetSaleRequestsRepositoryImpl(mockDatasource);

    workingUrl = faker.internet.httpsUrl();
    user = faker.internet.userName();
    accessKey = faker.guid.guid();
    enterpriseIds = [1, 2, 3];
    startDateHourOfCreation = faker.date.dateTime();
    endDateHourOfCreation = startDateHourOfCreation.add(
      const Duration(days: 1),
    );
    personalizedCodes = [
      faker.randomGenerator.integer(100).toString(),
      faker.randomGenerator.integer(100).toString(),
      faker.randomGenerator.integer(100).toString(),
    ];
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

    saleRequests = [
      for (var x = 0; x < 3; x++)
        EcSaleRequestModel.fromEntity(
          EntityFactory.makeSaleRequestEntity(),
        ).toEntity(),
    ];
  });

  setUpAll(() {
    registerFallbackValue(
      SoapSaleRequestModel.fromEntity(EntityFactory.makeSaleRequestEntity()),
    );
  });

  test('should behave correctly on save', () async {
    mockDatasource.mockGet(
      saleRequests.map((e) => EcSaleRequestModel.fromEntity(e)).toList(),
    );

    final response = await sut.get(
      workingUrl: workingUrl,
      user: user,
      accessKey: accessKey,
      enterpriseIds: enterpriseIds,
      endDateHourOfCreation: endDateHourOfCreation,
      startDateHourOfCreation: startDateHourOfCreation,
      personalizedCodes: personalizedCodes,
      mountCustomer: mountCustomer,
      mountSeller: mountSeller,
      mountRequestType: mountRequestType,
      mountProducts: mountProducts,
    );

    expect(response, saleRequests);

    verify(
      () => mockDatasource.get(
        workingUrl: workingUrl,
        user: user,
        accessKey: accessKey,
        enterpriseIds: enterpriseIds,
        endDateHourOfCreation: endDateHourOfCreation,
        startDateHourOfCreation: startDateHourOfCreation,
        personalizedCodes: personalizedCodes,
        mountCustomer: mountCustomer,
        mountSeller: mountSeller,
        mountRequestType: mountRequestType,
        mountProducts: mountProducts,
      ),
    ).called(1);
  });
  test('should call with correct end date if pass null value', () async {
    mockDatasource.mockGet(
      saleRequests.map((e) => EcSaleRequestModel.fromEntity(e)).toList(),
    );

    final response = await sut.get(
      workingUrl: workingUrl,
      user: user,
      accessKey: accessKey,
      enterpriseIds: enterpriseIds,
      endDateHourOfCreation: null,
      startDateHourOfCreation: startDateHourOfCreation,
    );

    expect(response, saleRequests);

    final captured =
        verify(
              () => mockDatasource.get(
                endDateHourOfCreation: captureAny(
                  named: 'endDateHourOfCreation',
                ),
                workingUrl: any(named: 'workingUrl'),
                user: any(named: 'user'),
                accessKey: any(named: 'accessKey'),
                enterpriseIds: any(named: 'enterpriseIds'),
                startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
                mountCustomer: any(named: 'mountCustomer'),
                mountProducts: any(named: 'mountProducts'),
                mountRequestType: any(named: 'mountRequestType'),
                mountSeller: any(named: 'mountSeller'),
                personalizedCodes: any(named: 'personalizedCodes'),
              ),
            ).captured.first
            as DateTime?;

    expect(captured?.year, DateTime.now().year);
    expect(captured?.month, DateTime.now().month);
    expect(captured?.day, DateTime.now().day);
  });
}
