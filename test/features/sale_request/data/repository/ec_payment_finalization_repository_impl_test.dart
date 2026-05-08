import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
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
        () => getPaymentOptions(
          enterpriseCode: any(named: 'enterpriseCode'),
          params: any(named: 'params'),
        ),
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

      final response = await sut.getPaymentOptions(
        enterpriseCode: enterpriseCode,
        params: params,
      );

      expect(response, paymentOptions.map((e) => e.toEntity()).toList());

      verify(
        () => mockDatasource.getPaymentOptions(
          enterpriseCode: enterpriseCode,
          params: params,
        ),
      ).called(1);
    });
  });
}
