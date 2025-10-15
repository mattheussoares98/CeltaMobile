import 'package:celta_intelligence/features/inventory/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/inventory/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadInventoryDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late List<InventoryModel> inventoryModels;

  void initSut() {
    sut = SoapLoadInventoryDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(inventoryModels.map((e) => e.toJson()).toList());
  }

  void initEntities() {
    baseUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(1000);
    inventoryModels = [
      EntityFactory.makeInventoryEntity(),
      EntityFactory.makeInventoryEntity(),
      EntityFactory.makeInventoryEntity(),
    ].map((e) => InventoryModel.fromEntity(e)).toList();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    final response = await sut.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    expect(response, inventoryModels);

    verify(
      () => soapRequest.post(
        url: baseUrl,
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
