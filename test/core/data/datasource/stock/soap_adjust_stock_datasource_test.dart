import 'package:celta_intelligence/core/data/datasource/stock/stock.dart';
import 'package:celta_intelligence/core/data/models/stock/stock.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapAdjustStockDatasource sut;

  late SoapRequestSpy soapAdapter;

  late List<AdjustStockItemModel> items;
  late String workingUrl;
  late String crossIdentity;

  void initSut() {
    sut = SoapAdjustStockDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    items = [
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
    ].map((e) => AdjustStockItemModel.fromEntity(e)).toList();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {});

  test('should call with correct params', () async {
    await sut.confirm(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      items: items,
    );

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "ConfirmAdjustStockResponse",
        soapAction: "ConfirmAdjustStock",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: null,
        parameters: {
          "crossIdentity": crossIdentity,
          "jsonAdjustStock": items.map((e) => e.toJson()).toList(),
        },
      ),
    ).called(1);
  });
}
