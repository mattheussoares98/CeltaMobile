import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapSaveSaleRequestDatasourceSpy extends Mock
    implements ISoapSaveSaleRequestDatasource {
  void mockSave(String? response) => when(
    () => this.save(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      enterpriseCode: any(named: 'enterpriseCode'),
      requestTypeCode: any(named: 'requestTypeCode'),
      saleRequest: any(named: 'saleRequest'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late ISoapSaveSaleRequestRepository sut;
  late SoapSaveSaleRequestDatasourceSpy mockDatasource;

  late String crossId;
  late String workingUrl;
  late int enterpriseCode;
  late int requestTypeCode;
  late String saleRequestNumber;
  late SaleRequestEntity saleRequest;

  setUp(() {
    mockDatasource = SoapSaveSaleRequestDatasourceSpy();
    sut = SoapSaveSaleRequestRepositoryImpl(mockDatasource);

    crossId = faker.guid.guid();
    workingUrl = faker.internet.httpsUrl();
    enterpriseCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
    saleRequestNumber = faker.randomGenerator.integer(100).toString();
    saleRequest = EntityFactory.makeSaleRequestEntity();

    mockDatasource.mockSave(saleRequestNumber);
  });

  setUpAll(() {
    registerFallbackValue(
      SoapSaleRequestModel.fromEntity(EntityFactory.makeSaleRequestEntity()),
    );
  });

  test('should behave correctly on save', () async {
    final response = await sut.save(
      workingUrl: workingUrl,
      crossIdentity: crossId,
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
      saleRequest: saleRequest,
    );

    expect(response, saleRequestNumber);

    verify(
      () => mockDatasource.save(
        workingUrl: workingUrl,
        crossIdentity: crossId,
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
        saleRequest: SoapSaleRequestModel.fromEntity(
          saleRequest.copyWith(
            cart: saleRequest.cart.map(
              (key, value) => MapEntry(
                key,
                value.copyWith(
                  DiscountValue: value.DiscountValue == null
                      ? null
                      : (value.DiscountValue ?? 0) / value.Quantity,
                  DiscountPercentageOrValue: PercentageOrValue.reais,
                ),
              ),
            ),
          ),
        ),
      ),
    ).called(1);
  });
}
