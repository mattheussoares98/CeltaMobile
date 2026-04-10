import 'dart:async';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

class FakeSaleRequestDetailsController
    extends SaleRequestDetailsStateController {
  final BSFSaleRequestEntity entity;
  FakeSaleRequestDetailsController(this.entity);

  @override
  FutureOr<BSFSaleRequestEntity> build({
    required int customerCode,
    required int enterpriseCode,
    required int saleRequestCode,
  }) {
    return entity;
  }
}

void main() {
  group('InsertUpdateController', () {
    test('should return empty entity when saleRequestId is 0', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        insertUpdateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).future,
      );

      expect(result, isA<BSFSaleRequestEntity>());
      expect(result, BSFSaleRequestEntity.empty());
      expect(result.code, isNull);
    });

    test(
      'should return data from saleRequestDetailsStateControllerProvider when saleRequestId is not 0',
      () async {
        final fakeEntity = EntityFactory.makeBSFSaleRequestEntity();
        const enterpriseCode = 1;
        const customerCode = 2;
        const saleRequestId = 123;

        final container = ProviderContainer(
          overrides: [
            saleRequestDetailsStateControllerProvider(
              customerCode: customerCode,
              enterpriseCode: enterpriseCode,
              saleRequestCode: saleRequestId,
            ).overrideWith(() => FakeSaleRequestDetailsController(fakeEntity)),
          ],
        );
        addTearDown(container.dispose);

        final result = await container.read(
          insertUpdateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ).future,
        );

        expect(result, fakeEntity);
      },
    );
  });
}
