import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_request/data/models/models.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapInsertTransferRequestDatasourceSpy extends Mock
    implements ISoapInsertTransferRequestDatasource {
  void mockSave(String response) {
    when(
      () => this.save(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        enterpriseOriginCode: any(named: 'enterpriseOriginCode'),
        enterpriseDestinyCode: any(named: 'enterpriseDestinyCode'),
        requestTypeCode: any(named: 'requestTypeCode'),
        products: any(named: 'products'),
      ),
    ).thenAnswer((_) async => response);
  }
}

void main() {
  late ISoapInsertTransferRequestRepository sut;

  late SoapInsertTransferRequestDatasourceSpy datasource;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseOriginCode;
  late int requestTypeCode;
  late int enterpriseDestinyCode;
  late String lastSavedRequestNumber;
  late List<TransferRequestProductItemEntity> products;

  void initSut() {
    sut = SoapInsertTransferRequestRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInsertTransferRequestDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockSave(lastSavedRequestNumber);
  }

  void initEntities() {
    workingUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseOriginCode = faker.randomGenerator.integer(1000);
    requestTypeCode = faker.randomGenerator.integer(1000);

    enterpriseDestinyCode = faker.randomGenerator.integer(1000);
    lastSavedRequestNumber = faker.randomGenerator.integer(100).toString();
    products = [
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
      ),
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
      ),
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
      ),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final response = await sut.save(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
      requestTypeCode: requestTypeCode,
      products: products,
    );

    expect(response, lastSavedRequestNumber);

    verify(
      () => datasource.save(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        enterpriseOriginCode: enterpriseOriginCode,
        enterpriseDestinyCode: enterpriseDestinyCode,
        requestTypeCode: requestTypeCode,
        products: products
            .map((e) => TransferRequestProductItemModel.fromEntity(e))
            .toList(),
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
