import 'package:celta_intelligence/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/sale_request/data/models/models.dart';
import 'package:celta_intelligence/features/sale_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapSaveSaleRequestDatasourceSpy extends Mock
    implements ISoapSaveSaleRequestDatasource {
  void mockSave(String? response) => when(
    () => this.save(
      baseUrl: any(named: 'baseUrl'),
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
  late String baseUrl;
  late int enterpriseCode;
  late int requestTypeCode;
  late String saleRequestNumber;
  late PendingSaleRequestEntity saleRequest;

  setUp(() {
    mockDatasource = SoapSaveSaleRequestDatasourceSpy();
    sut = SoapSaveSaleRequestRepositoryImpl(mockDatasource);

    crossId = faker.guid.guid();
    baseUrl = faker.internet.httpsUrl();
    enterpriseCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
    saleRequestNumber = faker.randomGenerator.integer(100).toString();
    saleRequest = EntityFactory.makePendingSaleRequestEntity();

    mockDatasource.mockSave(saleRequestNumber);
  });

  setUpAll(() {
    registerFallbackValue(
      PendingSaleRequestModel.fromEntity(
        EntityFactory.makePendingSaleRequestEntity(),
      ),
    );
  });

  test('should behave correctly on save', () async {
    final response = await sut.save(
      baseUrl: baseUrl,
      crossIdentity: crossId,
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
      saleRequest: saleRequest,
    );

    expect(response, saleRequestNumber);

    verify(
      () => mockDatasource.save(
        baseUrl: baseUrl,
        crossIdentity: crossId,
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
        saleRequest: PendingSaleRequestModel.fromEntity(
          saleRequest.copyWith(
            cart: saleRequest.cart.map(
              (key, value) => MapEntry(
                key,
                value.copyWith(
                  DiscountValue: value.DiscountValue == null
                      ? null
                      : (value.DiscountValue ?? 0) / value.Quantity,
                  DiscountPercentageOrValue: PercentageOrValue.value,
                ),
              ),
            ),
          ),
        ),
      ),
    ).called(1);
  });
}
