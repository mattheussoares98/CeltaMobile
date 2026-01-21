import 'package:celta_inventario/features/inventory/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInventoryAnnulDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late int codigoInternoInvCont;
  late int productPackingCode;

  void initSut() {
    sut = SoapInventoryAnnulDatasource(soapAdapter);
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
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    await sut.annul(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      codigoInternoProEmb: productPackingCode,
    );

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResult: null,
        typeOfResponse: "AnnulQuantityResponse",
        soapAction: "AnnulQuantity",
        serviceASMX: "CeltaInventoryService.asmx",
        parameters: {
          "crossIdentity": crossIdentity,
          "countingCode": codigoInternoInvCont,
          "productPackingCode": productPackingCode,
        },
      ),
    ).called(1);
  });
}
