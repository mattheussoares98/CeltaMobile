import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

part 'selected_payment_type_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedPaymentTypeStateController
    extends _$SelectedPaymentTypeStateController {
  @override
  BSFPaymentFinalizationEntity? build() => null;

  void select(BSFPaymentFinalizationEntity? payment) => state = payment;
}
