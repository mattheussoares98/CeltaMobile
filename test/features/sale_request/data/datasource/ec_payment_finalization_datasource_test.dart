import 'dart:convert';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcPaymentFinalizationDatasource sut;

  late HttpClientSpy httpClient;

  late EcRequestParams params;
  late int enterpriseCode;

  void initSut() {
    sut = EcPaymentFinalizationDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void initEntities() {
    params = EntityFactory.makeEcRequestParams();
    enterpriseCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
  });

  group('GetPaymentFinalizations', () {
    test('should behave correctly on success', () async {
      final paymentOptions = [
        BSFPaymentFinalizationModel.fromEntity(
          EntityFactory.makeBSFPaymentFinalizationEntity(),
        ),
        BSFPaymentFinalizationModel.fromEntity(
          EntityFactory.makeBSFPaymentFinalizationEntity(),
        ),
      ];
      httpClient.mockRequest(
        json.encode(paymentOptions.map((e) => e.toJson()).toList()),
      );

      final response = await sut.getPaymentFinalizations(
        enterpriseCode: enterpriseCode,
        params: params,
      );

      expect(response, paymentOptions);

      verify(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/PaymentFinalization/GetPaymentFinalizations?enterpriseCode=$enterpriseCode',
          method: 'post',
          headers: params.toHeaders(),
          body: params.toMap(),
        ),
      ).called(1);
    });
  });

  group('GetPaymentConditions', () {
    test('should behave correctly on success', () async {
      final paymentConditions = [
        BSFPaymentConditionModel.fromEntity(
          EntityFactory.makeBSFPaymentConditionEntity(),
        ),
        BSFPaymentConditionModel.fromEntity(
          EntityFactory.makeBSFPaymentConditionEntity(),
        ),
      ];
      httpClient.mockRequest(
        json.encode(paymentConditions.map((e) => e.toJson()).toList()),
      );

      final response = await sut.getPaymentConditions(params: params);

      expect(response, paymentConditions);

      verify(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/PaymentFinalization/SearchPaymentConditions',
          method: 'post',
          headers: params.toHeaders(),
          body: params.toMap(),
        ),
      ).called(1);
    });
  });
}
