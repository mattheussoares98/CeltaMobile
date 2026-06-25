import 'package:celta_inventario/core/domain/entities/ec/ec.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcProcessAuthorizationDatasource sut;

  late HttpClientSpy httpClient;

  late EcRequestParams params;
  late BsfProcessAuthorizationStatisticEntity entity;

  void initSut() {
    sut = EcProcessAuthorizationDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void mockSuccess() {
    httpClient.mockRequest(
      BsfProcessAuthorizationStatisticModel.fromEntity(entity).toJson(),
    );
  }

  void initEntities() {
    params = EcRequestParams(
      workingUrl: faker.internet.httpUrl(),
      user: faker.guid.guid(),
      accessKey: faker.guid.guid(),
    );
    entity = EntityFactory.makeBsfProcessAuthorizationStatisticEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call http with correct parameters', () async {
    final response = await sut.getStatistics(
      EcRequestParams(
        workingUrl: params.workingUrl,
        user: params.user,
        accessKey: params.accessKey,
      ),
    );

    expect(response, BsfProcessAuthorizationStatisticModel.fromEntity(entity));

    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/ProcessAuthorization/Statistics',
        method: 'post',
        headers: params.toHeaders(),
        body: params.toMap(),
      ),
    ).called(1);
  });
}
