// test/features/process_authorization/data/repositories/ec_process_authorization_repository_impl_test.dart
import 'package:celta_inventario/core/domain/entities/ec/ec.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/data/repositories/repositorires.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcProcessAuthorizationDatasourceSpy extends Mock
    implements IEcProcessAuthorizationDatasource {}

void main() {
  late EcProcessAuthorizationRepositoryImpl sut;
  late EcProcessAuthorizationDatasourceSpy datasource;
  late EcRequestParams params;
  late int? processCode;

  setUp(() {
    datasource = EcProcessAuthorizationDatasourceSpy();
    sut = EcProcessAuthorizationRepositoryImpl(datasource);
    processCode = faker.randomGenerator.boolean()
        ? null
        : faker.randomGenerator.integer(100);
    params = EcRequestParams(
      workingUrl: faker.internet.httpUrl(),
      user: faker.guid.guid(),
      accessKey: faker.guid.guid(),
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
  });

  group('getJudgments', () {
    late List<BSFProcessAuthorizationJudgmentModel> models;

    setUp(() {
      models = [
        BSFProcessAuthorizationJudgmentModel.fromEntity(
          EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(),
        ),
        BSFProcessAuthorizationJudgmentModel.fromEntity(
          EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(),
        ),
      ];
    });

    test('should return list of judgments on success', () async {
      when(
        () => datasource.getJudgments(
          any(),
          processCode: any(named: 'processCode'),
        ),
      ).thenAnswer((_) async => models);

      final response = await sut.getJudgments(params, processCode: processCode);

      expect(response, models.map((e) => e.toEntity()).toList());
      verify(
        () => datasource.getJudgments(params, processCode: processCode),
      ).called(1);
    });
  });

  group('getStatistics', () {
    late BsfProcessAuthorizationStatisticModel model;

    setUp(() {
      model = BsfProcessAuthorizationStatisticModel.fromEntity(
        EntityFactory.makeBsfProcessAuthorizationStatisticEntity(),
      );
    });

    test('should return statistics on success', () async {
      when(
        () => datasource.getStatistics(any()),
      ).thenAnswer((_) async => model);

      final response = await sut.getStatistics(params);

      expect(response, model.toEntity());
      verify(() => datasource.getStatistics(params)).called(1);
    });
  });
}
