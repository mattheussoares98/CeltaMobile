import 'package:celta_intelligence/features/adjust_sale_price/data/models/models.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapGetPriceSchedulesRepositoryImpl sut;

  late SoapGetPriceSchedulesDatasourceSpy soapGetPriceSchedulesDatasource;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late int productCode;
  late int productPackingCode;
  late List<PriceScheduleEntity> priceScheduleEntities;

  void initSut() {
    sut = SoapGetPriceSchedulesRepositoryImpl(
      soapGetPriceSchedulesDatasource: soapGetPriceSchedulesDatasource,
    );
  }

  void initInjections() {
    soapGetPriceSchedulesDatasource = SoapGetPriceSchedulesDatasourceSpy();
  }

  void mockSuccess() {
    soapGetPriceSchedulesDatasource.mockGetPriceSchedules(
      priceScheduleEntities
          .map((e) => PriceScheduleModel.fromEntity(e))
          .toList(),
    );
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    productCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    priceScheduleEntities = [
      EntityFactory.makePriceScheduleEntity(),
      EntityFactory.makePriceScheduleEntity(),
      EntityFactory.makePriceScheduleEntity(),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var saleType in SaleType.values) {
      registerFallbackValue(saleType);
    }
  });
  test('should behave correctly on success', () async {
    final result = await sut.getPriceSchedules(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productCode: productCode,
      productPackingCode: productPackingCode,
    );

    expect(result, priceScheduleEntities);

    verify(
      () => soapGetPriceSchedulesDatasource.getPriceSchedules(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
      ),
    ).called(1);

    verifyNoMoreInteractions(soapGetPriceSchedulesDatasource);
  });
  test('should behave correctly on error', () async {
    soapGetPriceSchedulesDatasource.mockGetPriceSchedulesError();

    final result = sut.getPriceSchedules(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productCode: productCode,
      productPackingCode: productPackingCode,
    );

    expect(result, throwsA(isA<Exception>()));
  });
}
