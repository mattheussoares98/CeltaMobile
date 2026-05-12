import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
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

class FakeInsertUpdateStateController extends InsertUpdateStateController {
  final BSFSaleRequestEntity entity;
  FakeInsertUpdateStateController(this.entity);

  @override
  FutureOr<BSFSaleRequestEntity> build({
    required int enterpriseCode,
    required int customerCode,
    required int saleRequestId,
  }) {
    return entity;
  }
}

class FakeAllPaymentFinalizationsController
    extends AllPaymentFinalizationsController {
  final List<BSFPaymentFinalizationEntity> entities;
  FakeAllPaymentFinalizationsController(this.entities);

  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build({
    required int enterpriseCode,
  }) {
    return entities;
  }
}

class FakeAllPaymentConditionsController
    extends AllPaymentConditionsController {
  final List<BSFPaymentConditionEntity> entities;
  FakeAllPaymentConditionsController(this.entities);

  @override
  FutureOr<List<BSFPaymentConditionEntity>> build({
    required int enterpriseCode,
  }) {
    return entities;
  }
}
