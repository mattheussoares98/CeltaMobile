import 'package:celta_intelligence/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/sale_request/data/models/models.dart';
import 'package:celta_intelligence/features/sale_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapProcessCartDatasourceSpy extends Mock
    implements ISoapProcessCartDatasource {
  void mockProcess(ProcessedCartModel response) => when(
    () => this.process(
      crossId: any(named: 'crossId'),
      baseUrl: any(named: 'baseUrl'),
      enterpriseCode: any(named: 'enterpriseCode'),
      requestTypeCode: any(named: 'requestTypeCode'),
      customerCode: any(named: 'customerCode'),
      covenantCode: any(named: 'covenantCode'),
      products: any(named: 'products'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late ISoapProcessCartRepository sut;
  late SoapProcessCartDatasourceSpy mockDatasource;

  late String crossId;
  late String baseUrl;
  late int enterpriseCode;
  late int requestTypeCode;
  late int customerCode;
  late int? covenantCode;
  late List<CartProductEntity> products;
  late ProcessedCartEntity processedCart;

  setUp(() {
    mockDatasource = SoapProcessCartDatasourceSpy();
    sut = SoapProcessCartRepositoryImpl(mockDatasource);

    crossId = faker.guid.guid();
    baseUrl = faker.internet.httpsUrl();
    enterpriseCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
    customerCode = faker.randomGenerator.integer(100);
    covenantCode = faker.randomGenerator.integer(100);
    products = [
      EntityFactory.makeCartProductEntity(),
      EntityFactory.makeCartProductEntity(),
      EntityFactory.makeCartProductEntity(),
    ];

    processedCart = ProcessedCartEntity(
      crossId: crossId,
      EnterpriseCode: enterpriseCode,
      RequestTypeCode: requestTypeCode,
      SellerCode: faker.randomGenerator.integer(100),
      CovenantCode: covenantCode,
      CustomerCode: customerCode,
      Products: products,
      Instructions: faker.lorem.sentence(),
      Observations: faker.lorem.sentence(),
    );

    mockDatasource.mockProcess(ProcessedCartModel.fromEntity(processedCart));
  });

  test('should behave correctly on save', () async {
    final response = await sut.process(
      crossId: crossId,
      baseUrl: baseUrl,
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
      customerCode: customerCode,
      covenantCode: covenantCode,
      products: products,
    );

    expect(response, processedCart);

    verify(
      () => mockDatasource.process(
        crossId: crossId,
        baseUrl: baseUrl,
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
        customerCode: customerCode,
        covenantCode: covenantCode,
        products: products.map((e) => CartProductModel.fromEntity(e)).toList(),
      ),
    ).called(1);
  });
}
