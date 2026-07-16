// test/features/process_authorization/data/repositories/ec_process_authorization_repository_impl_test.dart
import 'package:celta_inventario/core/domain/entities/ec/ec.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/data/repositories/repositorires.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
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
    for (final judgmentStatus
        in BsfGoodsReceivingProductJudgmentStatus.values) {
      registerFallbackValue(judgmentStatus);
    }
    for (final judgementType in BsfGoodsReceivingProductJudgmentType.values) {
      registerFallbackValue(judgementType);
    }
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

  group('getGRDocFiscalNoteDifferences', () {
    test('should get GRDocFiscalNoteDifferences on success', () async {
      final List<int> grDocProductCodes = [faker.randomGenerator.integer(100)];
      final int grDocGroupCode = faker.randomGenerator.integer(100);
      final BsfGoodsReceivingProductJudgmentStatus judgmentStatus =
          BsfGoodsReceivingProductJudgmentStatus.values[faker.randomGenerator
              .integer(BsfGoodsReceivingProductJudgmentStatus.values.length)];
      final BsfGoodsReceivingProductJudgmentType judgementType =
          BsfGoodsReceivingProductJudgmentType.values[faker.randomGenerator
              .integer(BsfGoodsReceivingProductJudgmentType.values.length)];

      when(
        () => datasource.markStatusJudgment(
          any(),
          grDocProductCodes: any(named: 'grDocProductCodes'),
          grDocGroupCode: any(named: 'grDocGroupCode'),
          judgmentStatus: any(named: 'judgmentStatus'),
          judgementType: any(named: 'judgementType'),
        ),
      ).thenAnswer((_) async {});

      await sut.markStatusJudgment(
        params,
        grDocProductCodes: grDocProductCodes,
        grDocGroupCode: grDocGroupCode,
        judgmentStatus: judgmentStatus,
        judgementType: judgementType,
      );

      verify(
        () => datasource.markStatusJudgment(
          params,
          grDocProductCodes: grDocProductCodes,
          grDocGroupCode: grDocGroupCode,
          judgmentStatus: judgmentStatus,
          judgementType: judgementType,
        ),
      ).called(1);
    });
  });
  group('markStatusJudgment', () {
    test('should mark status judgment on success', () async {
      final grDocProductCodes = [
        faker.randomGenerator.integer(100),
        faker.randomGenerator.integer(100),
      ];
      final grDocGroupCode = faker.randomGenerator.integer(100);
      const judgmentStatus = BsfGoodsReceivingProductJudgmentStatus.accept;
      const judgementType =
          BsfGoodsReceivingProductJudgmentType.requestForCounting;

      when(
        () => datasource.markStatusJudgment(
          any(),
          grDocProductCodes: any(named: 'grDocProductCodes'),
          grDocGroupCode: any(named: 'grDocGroupCode'),
          judgmentStatus: any(named: 'judgmentStatus'),
          judgementType: any(named: 'judgementType'),
        ),
      ).thenAnswer((_) async {});

      await sut.markStatusJudgment(
        params,
        grDocProductCodes: grDocProductCodes,
        grDocGroupCode: grDocGroupCode,
        judgmentStatus: judgmentStatus,
        judgementType: judgementType,
      );

      verify(
        () => datasource.markStatusJudgment(
          params,
          grDocProductCodes: grDocProductCodes,
          grDocGroupCode: grDocGroupCode,
          judgmentStatus: judgmentStatus,
          judgementType: judgementType,
        ),
      ).called(1);
    });
  });
}
