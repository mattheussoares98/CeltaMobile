import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/features/buy_request/data/models/models.dart';
import 'package:celta_intelligence/features/buy_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/buy_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertBuyRequestRepository sut;

  late SoapInsertBuyRequestDatasourceSpy datasource;

  late String savedRequestNumber;
  late String baseUrl;
  late String crossIdentity;
  late int buyerCode;
  late int requestTypeCode;
  late int supplierCode;
  late String? observations;
  late List<int> enterpriseCodes;
  late List<BuyRequestProductItemEntity> products;

  void initSut() {
    sut = SoapInsertBuyRequestRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInsertBuyRequestDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockInsert(savedRequestNumber);
  }

  void initEntities() {
    savedRequestNumber = faker.lorem.word();
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    buyerCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
    supplierCode = faker.randomGenerator.integer(100);
    observations = faker.lorem.word();
    enterpriseCodes = [
      faker.randomGenerator.integer(100, min: 0),
      faker.randomGenerator.integer(200, min: 101),
      faker.randomGenerator.integer(300, min: 201),
    ];
    products = enterpriseCodes
        .map(
          (e) =>
              EntityFactory.makeBuyRequestProductItemEntity(enterpriseCode: e),
        )
        .toList();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUserEntity());
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
  });

  test('should behave correctly on success', () async {
    final response = await sut.insertBuyRequest(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      buyerCode: buyerCode,
      requestTypeCode: requestTypeCode,
      supplierCode: supplierCode,
      observations: observations,
      enterpriseCodes: enterpriseCodes,
      products: products,
    );

    expect(response, savedRequestNumber);
    verify(
      () => datasource.insertBuyRequest(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        buyerCode: buyerCode,
        requestTypeCode: requestTypeCode,
        supplierCode: supplierCode,
        observations: observations,
        enterpriseCodes: enterpriseCodes,
        products: products
            .map((e) => BuyRequestProductItemModel.fromEntity(e))
            .toList(),
      ),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
