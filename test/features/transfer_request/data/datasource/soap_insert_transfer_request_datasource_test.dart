import 'dart:convert';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_request/data/models/models.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertTransferRequestDatasource sut;

  late SoapRequestSpy soapRequest;

  late String workingUrl;
  late String crossIdentity;
  late int requestTypeCode;
  late int enterpriseOriginCode;
  late int enterpriseDestinyCode;
  late String lastSavedRequestNumber;
  late List<TransferRequestProductItemModel> products;

  void initDependencies() {
    soapRequest = SoapRequestSpy();
  }

  void initSut() {
    sut = SoapInsertTransferRequestDatasource(soapRequest);
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    requestTypeCode = faker.randomGenerator.integer(100);
    enterpriseOriginCode = faker.randomGenerator.integer(100);
    enterpriseDestinyCode = faker.randomGenerator.integer(100);
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
    ].map((e) => TransferRequestProductItemModel.fromEntity(e)).toList();
  }

  void mockSuccess() {
    soapRequest.mockPost(lastSavedRequestNumber);
  }

  setUp(() {
    initEntities();
    initDependencies();
    initSut();
    mockSuccess();
  });

  test('should works correctly on success', () async {
    final result = await sut.save(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
      requestTypeCode: requestTypeCode,
      products: products,
    );

    expect(result, lastSavedRequestNumber);

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResult: null,
        typeOfResponse: "InsertResponse",
        soapAction: "Insert",
        serviceASMX: "CeltaTransferRequestService.asmx",
        parameters: {
          "crossIdentity": crossIdentity,
          "json": json.encode({
            "crossId": crossIdentity,
            "EnterpriseOriginCode": enterpriseOriginCode,
            "EnterpriseDestinyCode": enterpriseDestinyCode,
            "RequestTypeCode": requestTypeCode,
            "Products": products.map((e) {
              final entityWithNewValue = e.product.toEntity().copyWith(
                Value: e.value,
              );
              final json = ProductModel.fromEntity(entityWithNewValue).toJson();
              json.addAll({'quantity': e.quantity});

              return json;
            }).toList(),
          }),
        },
      ),
    ).called(1);
  });
}
