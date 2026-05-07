import 'dart:async';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';

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
