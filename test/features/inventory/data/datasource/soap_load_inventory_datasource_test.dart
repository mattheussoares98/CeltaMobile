import 'package:celta_intelligence/features/inventory/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/inventory/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadInventoryDatasource sut;

  late SoapRequestSpy soapRequest;

  late String urlInUse;
  late String crossIdentity;
  late int enterpriseCode;
  late InventoryModel inventoryModel;

  void initSut() {
    sut = SoapLoadInventoryDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(inventoryModel.toJson());
  }

  void initEntities() {
    urlInUse = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(1000);
    inventoryModel = InventoryModel.fromEntity(
      EntityFactory.makeInventoryEntity(),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    final response = await sut.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    expect(response, inventoryModel);

    verify(
      () => soapRequest.post(
        url: urlInUse,
        typeOfResponse: "GetFrozenProcessesResponse",
        soapAction: "GetFrozenProcesses",
        serviceASMX: "CeltaInventoryService.asmx",
        typeOfResult: "GetFrozenProcessesResult",
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseCode,
        },
      ),
    ).called(1);
  });
}
