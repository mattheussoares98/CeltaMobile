import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/repositories/buyer/buyer.dart';
import 'package:celta_inventario/core/data/repositories/buyer/buyer.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadBuyersRepository sut;

  late SoapLoadBuyersDatasourceSpy datasource;

  late List<BuyerModel> buyersModels;
  late String crossIdentity;
  late String workingUrl;

  void initSut() {
    sut = SoapLoadBuyersRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadBuyersDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(buyersModels);
  }

  void initEntities() {
    buyersModels = [
      EntityFactory.makeBuyerEntity(),
      EntityFactory.makeBuyerEntity(),
      EntityFactory.makeBuyerEntity(),
    ].map((e) => BuyerModel.fromEntity(e)).toList();

    crossIdentity = faker.guid.guid();
    workingUrl = faker.internet.httpUrl();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUserEntity());
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
  });

  test('should behave correctly on success', () async {
    final buyers = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );

    expect(buyers, buyersModels.map((e) => e.toEntity()).toList());
    verify(
      () =>
          datasource.load(workingUrl: workingUrl, crossIdentity: crossIdentity),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
