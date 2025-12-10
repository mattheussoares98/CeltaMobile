import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/data/model/model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadProductsNotFoundDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late String crossIdentity;
  late int receiptCode;
  late List<ProductNotFoundModel> productsNotFoundModels;
  late bool returnSingleProduct;

  void initSut() {
    sut = SoapLoadProductsNotFoundDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost({
      "ProdutosSemCadastro": returnSingleProduct
          ? productsNotFoundModels.first.toJson()
          : productsNotFoundModels.map((e) => e.toJson()).toList(),
    });
  }

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    receiptCode = faker.randomGenerator.integer(100);

    productsNotFoundModels = [
      EntityFactory.makeProductNotFoundEntity(),
      EntityFactory.makeProductNotFoundEntity(),
      EntityFactory.makeProductNotFoundEntity(),
    ].map((e) => ProductNotFoundModel.fromEntity(e)).toList();
    returnSingleProduct = faker.randomGenerator.boolean();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final response = await sut.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      receiptCode: receiptCode,
    );

    expect(
      response,
      returnSingleProduct
          ? [productsNotFoundModels.first]
          : productsNotFoundModels,
    );

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "GetProductProductWithoutCadasterResponse",
        soapAction: "GetProductProductWithoutCadaster",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "GetProductProductWithoutCadasterResult",
        parameters: {"crossIdentity": crossIdentity, "grDocCode": receiptCode},
      ),
    ).called(1);
  });
}
