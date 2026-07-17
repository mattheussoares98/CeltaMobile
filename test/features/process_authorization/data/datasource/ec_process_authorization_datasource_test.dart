// test/features/process_authorization/data/datasource/ec_process_authorization_datasource_test.dart
import 'dart:convert';

import 'package:celta_inventario/core/domain/entities/ec/ec.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/receipt/data/model/model.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcProcessAuthorizationDatasource sut;
  late HttpClientSpy httpClient;
  late EcRequestParams params;
  late int? processCode;
  late SaleRequestErrorType errorType;
  late BSFSaleRequestErrorEntity saleRequestErrorEntity;
  late BsfProcessAuthorizationStatisticEntity
  processAuthorizationStatisticEntity;
  late int enterpriseCode;
  late int saleRequestCode;
  late int customerCode;

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
    saleRequestErrorEntity = EntityFactory.makeBSFSaleRequestErrorEntity();
    enterpriseCode = faker.randomGenerator.integer(100);
    saleRequestCode = faker.randomGenerator.integer(100);
    customerCode = faker.randomGenerator.integer(100);
    errorType =
        SaleRequestErrorType.values[faker.randomGenerator.integer(
          SaleRequestErrorType.values.length,
        )];
    processAuthorizationStatisticEntity =
        EntityFactory.makeBsfProcessAuthorizationStatisticEntity();
  });

  setUpAll(() {
    for (var errorType in SaleRequestErrorType.values) {
      registerFallbackValue(errorType);
    }
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
    test(
      'should call http with correct parameters and return statistics on success',
      () async {
        final model = BsfProcessAuthorizationStatisticModel.fromEntity(
          processAuthorizationStatisticEntity,
        );
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

  group('getSaleRequestErrors', () {
    test(
      'should call http with correct parameters and return sale request errors on success',
      () async {
        final model = BSFSaleRequestErrorModel.fromJson(
          BSFSaleRequestErrorModel.fromEntity(saleRequestErrorEntity).toJson(),
        );
        final jsonResponse = json.encode(model.toJson());

        httpClient.mockRequest(jsonResponse);

        final response = await sut.getSaleRequestErrors(
          params,
          enterpriseCode: enterpriseCode,
          saleRequestCode: saleRequestCode,
          customerCode: customerCode,
          errorType: errorType,
        );

        expect(response, model);
        verify(
          () => httpClient.request(
            url:
                '${params.workingUrl}/api/ProcessAuthorization/SaleRequestErrors',

            method: 'post',
            headers: params.toHeaders(),
            body: {
              ...params.toMap(),
              'EnterpriseCode': enterpriseCode,
              'SaleRequestCode': saleRequestCode,
              'CustomerCode': customerCode,
              'ErrorType': errorType.code,
            },
          ),
        ).called(1);
      },
    );
  });
  group('Vote', () {
    test('should call http with correct parameters', () async {
      httpClient.mockRequest(null);
      final processCode = faker.randomGenerator.integer(100);
      final authorized = faker.randomGenerator.boolean();
      final observations = faker.lorem.sentence();

      await sut.vote(
        params,
        processCode: processCode,
        authorized: authorized,
        observations: observations,
      );

      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/ProcessAuthorization/Vote',
          method: 'post',
          headers: params.toHeaders(),
          body: {
            ...params.toMap(),
            'ProcessCode': processCode,
            'Authorized': authorized,
            'Observations': observations,
          },
        ),
      ).called(1);
    });
  });

  group('getGRDocFiscalNoteDifferences', () {
    test('should call http with correct parameters and return model', () async {
      final documentCode = faker.randomGenerator.integer(100);
      final model = BSFGRModel.fromEntity(EntityFactory.makeBSFGREntity());
      httpClient.mockRequest(json.encode(model.toJson()));

      final response = await sut.getGRDocFiscalNoteDifferences(
        params,
        documentCode,
      );

      expect(response.toJson(), model.toJson());
      verify(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/ProcessAuthorization/GetGRDocFiscalNoteDifferences?documentCode=$documentCode',
          method: 'post',
          headers: params.toHeaders(),
          body: params.toMap(),
        ),
      ).called(1);
    });
  });

  group('markStatusJudgment', () {
    test('should call http with correct parameters', () async {
      httpClient.mockRequest(null);
      final grDocProductCodes = [
        faker.randomGenerator.integer(100),
        faker.randomGenerator.integer(100),
      ];
      final grDocGroupCode = faker.randomGenerator.integer(100);
      const judgmentStatus = BsfGRProductJudgmentStatus.accept;
      const judgementType = BsfGRProductJudgmentType.requestForCounting;

      await sut.markStatusJudgment(
        params,
        grDocProductCodes: grDocProductCodes,
        grDocGroupCode: grDocGroupCode,
        judgmentStatus: judgmentStatus,
        judgementType: judgementType,
      );

      verify(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/ProcessAuthorization/MarkStatusJudgement',
          method: 'post',
          headers: params.toHeaders(),
          body: {
            ...params.toMap(),
            'GrDocProductCodes': grDocProductCodes,
            'GrDocGroupCode': grDocGroupCode,
            'JudgmentStatus': judgmentStatus.value,
            'JudgementType': judgementType.value,
          },
        ),
      ).called(1);
    });
  });

  group('annulStatusJudgment', () {
    test('should call http with correct parameters', () async {
      httpClient.mockRequest(null);
      final grDocProductCodes = [
        faker.randomGenerator.integer(100),
        faker.randomGenerator.integer(100),
      ];
      final grDocGroupCode = faker.randomGenerator.integer(100);
      const judgementType = BsfGRProductJudgmentType.requestForCounting;

      await sut.annulStatusJudgment(
        params,
        grDocProductCodes: grDocProductCodes,
        grDocGroupCode: grDocGroupCode,
        judgementType: judgementType,
      );

      verify(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/ProcessAuthorization/AnnulStatusJudgement',
          method: 'post',
          headers: params.toHeaders(),
          body: {
            ...params.toMap(),
            'GrDocProductCodes': grDocProductCodes,
            'GrDocGroupCode': grDocGroupCode,
            'JudgementType': judgementType.value,
          },
        ),
      ).called(1);
    });
  });

  group('linkProductWithoutCadaster', () {
    late int documentCode;
    late int productCode;
    late int productWithoutCadasterCode;

    setUp(() {
      documentCode = faker.randomGenerator.integer(100);
      productCode = faker.randomGenerator.integer(100);
      productWithoutCadasterCode = faker.randomGenerator.integer(100);
    });

    test('should call http with correct parameters', () async {
      httpClient.mockRequest(null);

      await sut.linkProductWithoutCadaster(
        params,
        documentCode: documentCode,
        productCode: productCode,
        productWithoutCadasterCode: productWithoutCadasterCode,
      );

      verify(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/ProcessAuthorization/LinkProductWithoutCadaster',
          method: 'post',
          headers: params.toHeaders(),
          body: {
            ...params.toMap(),
            'DocumentCode': documentCode,
            'ProductCode': productCode,
            'ProductWithoutCadasterCode': productWithoutCadasterCode,
          },
        ),
      ).called(1);
    });

    test('should rethrow when http request fails', () async {
      final exception = Exception('Failed to link product without cadaster');
      when(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/ProcessAuthorization/LinkProductWithoutCadaster',
          method: 'post',
          headers: params.toHeaders(),
          body: {
            ...params.toMap(),
            'DocumentCode': documentCode,
            'ProductCode': productCode,
            'ProductWithoutCadasterCode': productWithoutCadasterCode,
          },
        ),
      ).thenThrow(exception);

      final call = sut.linkProductWithoutCadaster(
        params,
        documentCode: documentCode,
        productCode: productCode,
        productWithoutCadasterCode: productWithoutCadasterCode,
      );

      await expectLater(call, throwsA(same(exception)));
    });
  });
}
