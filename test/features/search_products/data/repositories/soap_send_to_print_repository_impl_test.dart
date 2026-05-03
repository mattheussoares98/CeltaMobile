import 'package:celta_inventario/features/search_products/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/search_products/data/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapSendToPrintRepository sut;
  late SoapSendToPrintDatasourceSpy mockDatasource;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late int productPackingCode;
  late bool newValue;

  setUp(() {
    mockDatasource = SoapSendToPrintDatasourceSpy();
    sut = SoapSendToPrintRepositoryImpl(mockDatasource);

    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    productPackingCode = faker.randomGenerator.integer(100);
    newValue = faker.randomGenerator.boolean();
    enterpriseCode = faker.randomGenerator.integer(100);
  });

  setUpAll(() {});

  test('should call datasource with correct values', () async {
    await sut.send(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productPackingCode: productPackingCode,
      newValue: newValue,
    );

    verify(
      () => mockDatasource.send(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        productPackingCode: productPackingCode,
        newValue: newValue,
      ),
    );
  });
}
