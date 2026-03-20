import 'package:celta_inventario/core/domain/entities/entities.dart';
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
  void mockGet(EcPaginationResults<EcSaleRequestModel> response) => when(
    () => this.get(
      params: any(named: 'params'),
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

  late EcRequestParams params;
  late List<int> enterpriseIds;
  late DateTime endDateHourOfCreation;
  late DateTime startDateHourOfCreation;
  late List<String> personalizedCodes;
  late bool mountCustomer;
  late bool mountSeller;
  late bool mountRequestType;
  late bool mountProducts;

  late EcPaginationResults<SaleRequestEntity> saleRequests;

  setUp(() {
    mockDatasource = EcGetSaleRequestsDatasourceSpy();
    sut = EcGetSaleRequestsRepositoryImpl(mockDatasource);

    params = EntityFactory.makeEcRequestParams();
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
    mountCustomer = faker.randomGenerator.boolean();
    mountSeller = faker.randomGenerator.boolean();
    mountRequestType = faker.randomGenerator.boolean();
    mountProducts = faker.randomGenerator.boolean();

    saleRequests = EcPaginationResults(
      totalRecords: faker.randomGenerator.integer(1000),
      recordsByPage: faker.randomGenerator.integer(100),
      actualPage: faker.randomGenerator.integer(5),
      recordsOnThisPage: faker.randomGenerator.integer(5),
      totalPages: faker.randomGenerator.integer(5),
      collection: [
        for (var x = 0; x < 3; x++)
          EcSaleRequestModel.fromEntity(
            EntityFactory.makeSaleRequestEntity(),
          ).toEntity(),
      ],
    );
  });

  setUpAll(() {
    registerFallbackValue(
      SoapSaleRequestModel.fromEntity(EntityFactory.makeSaleRequestEntity()),
    );
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  group('Get', () {
    test('should behave correctly on load', () async {
      mockDatasource.mockGet(
        saleRequests.map((e) => EcSaleRequestModel.fromEntity(e)),
      );

      final response = await sut.get(
        params: params,
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
          params: params,
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
        saleRequests.map((e) => EcSaleRequestModel.fromEntity(e)),
      );

      final response = await sut.get(
        params: params,
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
                  params: any(named: 'params'),
                  enterpriseIds: any(named: 'enterpriseIds'),
                  startDateHourOfCreation: any(
                    named: 'startDateHourOfCreation',
                  ),
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

    test(
      'should call with correct values when doesnt pass the optional parameters',
      () async {
        mockDatasource.mockGet(
          saleRequests.map((e) => EcSaleRequestModel.fromEntity(e)),
        );

        final response = await sut.get(params: params);

        expect(response, saleRequests);

        verify(
          () => mockDatasource.get(
            params: params,
            endDateHourOfCreation: any(
              named: 'endDateHourOfCreation',
            ), //DateTime.now(),
            enterpriseIds: null,
            startDateHourOfCreation: null,
            mountCustomer: null,
            mountProducts: null,
            mountRequestType: null,
            mountSeller: null,
            personalizedCodes: null,
            id: null,
          ),
        ).called(1);
      },
    );
  });
  group('Get complete', () {
    //TODO create tests
  });
}
