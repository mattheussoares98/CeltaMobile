import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';
import 'package:celta_inventario/features/receipt/data/model/model.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapLoadReceiptsDatasourceSpy extends Mock
    implements ISoapLoadReceiptsDatasource {
  void mockLoad(List<ReceiptModel> response) => when(
    () => this.loadReceipts(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      enterpriseCode: any(named: 'enterpriseCode'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late ISoapLoadReceiptsRepository sut;
  late SoapLoadReceiptsDatasourceSpy mockDatasource;

  late List<ReceiptEntity> receiptsEntities;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;

  setUp(() {
    mockDatasource = SoapLoadReceiptsDatasourceSpy();
    sut = SoapLoadReceiptsRepositoryImpl(mockDatasource);

    receiptsEntities = [
      EntityFactory.makeReceiptEntity(),
      EntityFactory.makeReceiptEntity(),
      EntityFactory.makeReceiptEntity(),
    ];

    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);

    mockDatasource.mockLoad(
      receiptsEntities.map((e) => ReceiptModel.fromEntity(e)).toList(),
    );
  });

  test('should behave correctly on success', () async {
    final response = await sut.loadReceipts(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    expect(response, receiptsEntities);

    verify(
      () => mockDatasource.loadReceipts(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
      ),
    ).called(1);
  });
}
