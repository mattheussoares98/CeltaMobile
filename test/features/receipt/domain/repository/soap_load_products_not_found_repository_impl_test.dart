import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/data/model/model.dart';
import 'package:celta_intelligence/features/receipt/domain/entity/entity.dart';
import 'package:celta_intelligence/features/receipt/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapLoadProductsNotFoundDatasourceSpy extends Mock
    implements ISoapLoadProductsNotFoundDatasource {
  void mockLoad(List<ProductNotFoundModel> response) => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      receiptCode: any(named: 'receiptCode'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late ISoapLoadProductsNotFoundRepository sut;
  late SoapLoadProductsNotFoundDatasourceSpy mockDatasource;

  late List<ProductNotFoundEntity> productsEntities;

  late String workingUrl;
  late String crossIdentity;
  late int receiptCode;

  setUp(() {
    mockDatasource = SoapLoadProductsNotFoundDatasourceSpy();
    sut = SoapLoadProductsNotFoundRepositoryImpl(mockDatasource);

    productsEntities = [
      EntityFactory.makeProductNotFoundEntity(),
      EntityFactory.makeProductNotFoundEntity(),
      EntityFactory.makeProductNotFoundEntity(),
    ];

    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    receiptCode = faker.randomGenerator.integer(100);

    mockDatasource.mockLoad(
      productsEntities.map((e) => ProductNotFoundModel.fromEntity(e)).toList(),
    );
  });

  test('should behave correctly on success', () async {
    final response = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      receiptCode: receiptCode,
    );

    expect(response, productsEntities);

    verify(
      () => mockDatasource.load(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        receiptCode: receiptCode,
      ),
    ).called(1);
  });
}
