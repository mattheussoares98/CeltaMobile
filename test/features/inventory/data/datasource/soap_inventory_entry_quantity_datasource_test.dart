import 'package:celta_inventario/features/inventory/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInventoryEntryQuantityDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late int codigoInternoInvCont;
  late int productPackingCode;
  late double quantity;
  late bool isSubtract;

  void initSut() {
    sut = SoapInventoryEntryQuantityDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    codigoInternoInvCont = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    isSubtract = faker.randomGenerator.boolean();
    quantity = isSubtract
        ? -faker.randomGenerator.decimal()
        : faker.randomGenerator.decimal();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    await sut.entry(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      productPackingCode: productPackingCode,
      quantity: quantity,
      isSubtract: isSubtract,
    );

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResult: null,
        typeOfResponse: "EntryQuantityResponse",
        soapAction: "EntryQuantity",
        serviceASMX: "CeltaInventoryService.asmx",
        parameters: {
          "crossIdentity": crossIdentity,
          "countingCode": codigoInternoInvCont,
          "productPackingCode": productPackingCode,
          "quantity": isSubtract ? quantity * -1 : quantity,
        },
      ),
    ).called(1);
  });
}
