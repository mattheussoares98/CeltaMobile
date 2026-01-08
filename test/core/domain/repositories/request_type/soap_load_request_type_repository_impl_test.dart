import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/repositories/request_type/request_type.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadRequestTypeRepository sut;

  late SoapLoadRequestTypeDatasourceSpy soapLoadRequestTypeDatasource;

  late List<RequestTypeModel> requestTypeModels;
  late String workingUrl;
  late String crossIdentity;
  late bool inclusiveBuy;
  late bool inclusiveTransfer;
  late bool inclusiveSale;

  void initSut() {
    sut = SoapLoadRequestTypeRepositoryImpl(soapLoadRequestTypeDatasource);
  }

  void initInjections() {
    soapLoadRequestTypeDatasource = SoapLoadRequestTypeDatasourceSpy();
  }

  void mockSuccess() {
    soapLoadRequestTypeDatasource.mockLoad(requestTypeModels);
  }

  void initEntities() {
    requestTypeModels = [
      EntityFactory.makeRequestTypeEntity(),
      EntityFactory.makeRequestTypeEntity(),
      EntityFactory.makeRequestTypeEntity(),
    ].map((e) => RequestTypeModel.fromEntity(e)).toList();
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    inclusiveBuy = faker.randomGenerator.boolean();
    inclusiveTransfer = faker.randomGenerator.boolean();
    inclusiveSale = faker.randomGenerator.boolean();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });
  setUpAll(() {});

  test("Should behave correctly on load", () async {
    final response = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      inclusiveBuy: inclusiveBuy,
      inclusiveTransfer: inclusiveTransfer,
      inclusiveSale: inclusiveSale,
    );

    expect(response, requestTypeModels.map((e) => e.toEntity()).toList());

    verify(
      () => soapLoadRequestTypeDatasource.load(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        inclusiveBuy: inclusiveBuy,
        inclusiveTransfer: inclusiveTransfer,
        inclusiveSale: inclusiveSale,
      ),
    ).called(1);
  });
}
