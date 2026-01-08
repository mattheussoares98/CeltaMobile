import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/data/model/model.dart';
import 'package:celta_intelligence/features/receipt/domain/entity/entity.dart';
import 'package:celta_intelligence/features/receipt/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapLoadReceiptsDatasourceSpy extends Mock
    implements ISoapLoadReceiptsDatasource {
  void mockLoad(List<ReceiptModel> response) => when(
    () => this.loadReceipts(
      urlInUse: any(named: 'urlInUse'),
      crossIdentity: any(named: 'crossIdentity'),
      enterpriseCode: any(named: 'enterpriseCode'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late ISoapLoadReceiptsRepository sut;
  late SoapLoadReceiptsDatasourceSpy mockDatasource;

  late List<ReceiptEntity> receiptsEntities;

  late String urlInUse;
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

    urlInUse = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);

    mockDatasource.mockLoad(
      receiptsEntities.map((e) => ReceiptModel.fromEntity(e)).toList(),
    );
  });

  test('should behave correctly on success', () async {
    final response = await sut.loadReceipts(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    expect(response, receiptsEntities);

    verify(
      () => mockDatasource.loadReceipts(
        urlInUse: urlInUse,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
      ),
    ).called(1);
  });
}
