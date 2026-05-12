import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcPaymentFinalizationDatasourceSpy extends Mock
    implements IEcPaymentFinalizationDatasource {
  void mockGetPaymentOptions(List<BSFPaymentFinalizationModel> response) =>
      when(
        () => getPaymentFinalizations(
          enterpriseCode: any(named: 'enterpriseCode'),
          params: any(named: 'params'),
        ),
      ).thenAnswer((_) async => response);

  void mockGetPaymentConditions(List<BSFPaymentConditionModel> response) =>
      when(
        () => getPaymentConditions(params: any(named: 'params')),
      ).thenAnswer((_) async => response);
}

void main() {
  late IEcPaymentFinalizationRepository sut;
  late EcPaymentFinalizationDatasourceSpy mockDatasource;

  late EcRequestParams params;
  late int enterpriseCode;

  setUp(() {
    mockDatasource = EcPaymentFinalizationDatasourceSpy();
    sut = EcPaymentFinalizationRepositoryImpl(mockDatasource);

    params = EntityFactory.makeEcRequestParams();
    enterpriseCode = faker.randomGenerator.integer(100);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  group('GetPaymentOptions', () {
    test('should behave correctly on success', () async {
      final paymentOptions = [
        BSFPaymentFinalizationModel.fromEntity(
          EntityFactory.makeBSFPaymentFinalizationEntity(),
        ),
        BSFPaymentFinalizationModel.fromEntity(
          EntityFactory.makeBSFPaymentFinalizationEntity(),
        ),
      ];
      mockDatasource.mockGetPaymentOptions(paymentOptions);

      final response = await sut.getPaymentFinalizations(
        enterpriseCode: enterpriseCode,
        params: params,
      );

      expect(response, paymentOptions.map((e) => e.toEntity()).toList());

      verify(
        () => mockDatasource.getPaymentFinalizations(
          enterpriseCode: enterpriseCode,
          params: params,
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
      mockDatasource.mockGetPaymentConditions(paymentConditions);

      final response = await sut.getPaymentConditions(params: params);

      expect(response, paymentConditions.map((e) => e.toEntity()).toList());

      verify(
        () => mockDatasource.getPaymentConditions(params: params),
      ).called(1);
    });
  });
}
