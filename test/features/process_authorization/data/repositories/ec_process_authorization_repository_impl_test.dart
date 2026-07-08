// test/features/process_authorization/data/repositories/ec_process_authorization_repository_impl_test.dart
import 'package:celta_inventario/core/domain/entities/ec/ec.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/data/repositories/repositorires.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcProcessAuthorizationDatasourceSpy extends Mock
    implements IEcProcessAuthorizationDatasource {}

void main() {
  late IEcProcessAuthorizationRepository sut;
  late EcProcessAuthorizationDatasourceSpy datasource;
  late EcRequestParams params;
  late int? processCode;
  late SaleRequestErrorType errorType;

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
    errorType =
        SaleRequestErrorType.values[faker.randomGenerator.integer(
          SaleRequestErrorType.values.length,
        )];
  });

  setUpAll(() {
    for (var errorType in SaleRequestErrorType.values) {
      registerFallbackValue(errorType);
    }
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

  group('getSaleRequestErrors', () {
    late BSFSaleRequestErrorEntity entity;
    late int enterpriseCode;
    late int saleRequestCode;
    late int customerCode;

    setUp(() {
      entity = EntityFactory.makeBSFSaleRequestErrorEntity();
      enterpriseCode = faker.randomGenerator.integer(100);
      saleRequestCode = faker.randomGenerator.integer(100);
      customerCode = faker.randomGenerator.integer(100);
    });

    test('should return sale request errors on success', () async {
      when(
        () => datasource.getSaleRequestErrors(
          any(),
          enterpriseCode: any(named: 'enterpriseCode'),
          saleRequestCode: any(named: 'saleRequestCode'),
          customerCode: any(named: 'customerCode'),
          errorType: any(named: 'errorType'),
        ),
      ).thenAnswer((_) async => BSFSaleRequestErrorModel.fromEntity(entity));

      final response = await sut.getSaleRequestErrors(
        params,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestCode,
        customerCode: customerCode,
        errorType: errorType,
      );

      expect(response, entity);
      verify(
        () => datasource.getSaleRequestErrors(
          params,
          enterpriseCode: enterpriseCode,
          saleRequestCode: saleRequestCode,
          customerCode: customerCode,
          errorType: errorType,
        ),
      ).called(1);
    });
  });
  group('Vote', () {
    test('should vote on success', () async {
      final authorized = faker.randomGenerator.boolean();
      final observations = faker.lorem.sentence();
      final processCode = faker.randomGenerator.integer(100);

      when(
        () => datasource.vote(
          any(),
          processCode: any(named: 'processCode'),
          authorized: any(named: 'authorized'),
          observations: any(named: 'observations'),
        ),
      ).thenAnswer((_) async {});

      await sut.vote(
        params,
        processCode: processCode,
        authorized: authorized,
        observations: observations,
      );

      verify(
        () => datasource.vote(
          params,
          processCode: processCode,
          authorized: authorized,
          observations: observations,
        ),
      ).called(1);
    });
  });
}
