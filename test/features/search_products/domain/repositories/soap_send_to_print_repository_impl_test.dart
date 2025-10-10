import 'package:celta_intelligence/features/search_products/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapSendToPrintRepository sut;
  late SoapSendToPrintDatasourceSpy mockDatasource;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late String productPackingCode;
  late bool newValue;

  setUp(() {
    mockDatasource = SoapSendToPrintDatasourceSpy();
    sut = SoapSendToPrintRepositoryImpl(mockDatasource);

    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    productPackingCode = faker.guid.guid();
    newValue = faker.randomGenerator.boolean();
    enterpriseCode = faker.randomGenerator.integer(100);
  });

  setUpAll(() {});

  test('should call datasource with correct values', () async {
    await sut.send(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productPackingCode: productPackingCode,
      newValue: newValue,
    );

    verify(
      () => mockDatasource.send(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        productPackingCode: productPackingCode,
        newValue: newValue,
      ),
    );
  });
}
