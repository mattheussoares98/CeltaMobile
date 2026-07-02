// test/features/process_authorization/data/datasource/ec_process_authorization_datasource_test.dart
import 'dart:convert';

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
  late int? processCode;

  setUp(() {
    httpClient = HttpClientSpy();
    sut = EcProcessAuthorizationDatasource(httpClient);
    processCode = faker.randomGenerator.boolean()
        ? null
        : faker.randomGenerator.integer(100);
    params = EcRequestParams(
      workingUrl: faker.internet.httpUrl(),
      user: faker.guid.guid(),
      accessKey: faker.guid.guid(),
    );
  });

  group('getJudgments', () {
    late List<BSFProcessAuthorizationJudgmentEntity> entities;

    setUp(() {
      entities = [
        EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(),
        EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(),
      ];
    });

    test(
      'should call http with correct parameters and return judgments on success',
      () async {
        final models = entities
            .map(
              (e) => BSFProcessAuthorizationJudgmentModel.fromJson(
                BSFProcessAuthorizationJudgmentModel.fromEntity(e).toJson(),
              ),
            )
            .toList();
        final jsonResponse = json.encode(
          models.map((e) => e.toJson()).toList(),
        );

        httpClient.mockRequest(jsonResponse);

        final response = await sut.getJudgments(
          params,
          processCode: processCode,
        );

        expect(response, models);
        verify(
          () => httpClient.request(
            url:
                '${params.workingUrl}/api/ProcessAuthorization/Judgment?processCode=${processCode ?? -1}',
            method: 'post',
            headers: params.toHeaders(),
            body: params.toMap(),
          ),
        ).called(1);
      },
    );
  });

  group('getStatistics', () {
    late BsfProcessAuthorizationStatisticEntity entity;

    setUp(() {
      entity = EntityFactory.makeBsfProcessAuthorizationStatisticEntity();
    });

    test(
      'should call http with correct parameters and return statistics on success',
      () async {
        final model = BsfProcessAuthorizationStatisticModel.fromEntity(entity);
        final jsonResponse = json.encode(model.toJson());

        httpClient.mockRequest(jsonResponse);

        final response = await sut.getStatistics(params);

        expect(response, model);
        verify(
          () => httpClient.request(
            url: '${params.workingUrl}/api/ProcessAuthorization/Statistics',
            method: 'post',
            headers: params.toHeaders(),
            body: params.toMap(),
          ),
        ).called(1);
      },
    );
  });
}
