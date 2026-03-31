import 'package:celta_inventario/features/adjust_cost/data/datasource/datasource.dart';
import 'package:celta_inventario/features/adjust_cost/data/model/model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcAdjustCostDatasource sut;

  late HttpClientSpy httpClient;

  late String workingUrl;
  late String accessKey;
  late String user;
  late AdjustCostParametersModel parameters;

  void initSut() {
    sut = EcAdjustCostDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void mockSuccess() {
    httpClient.mockRequest(null);
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    accessKey = faker.guid.guid();
    user = faker.guid.guid();
    parameters = AdjustCostParametersModel.fromEntity(
      EntityFactory.makeAdjustCostParametersEntity(),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test(
    'should save with correct params when pass offer WITHOUT effectuation date and end date',
    () async {
      await sut.adjust(
        workingUrl: workingUrl,
        user: user,
        accessKey: accessKey,
        parameters: parameters,
      );

      verify(
        () => httpClient.request(
          url: '$workingUrl/Products/AdjustCostsIndividual',
          method: 'post',
          headers: {'user': user, 'accessKey': accessKey},
          body: parameters.toJson(),
        ),
      ).called(1);
    },
  );
}
