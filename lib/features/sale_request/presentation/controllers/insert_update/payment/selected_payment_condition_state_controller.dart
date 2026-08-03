import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_payment_condition_state_controller.g.dart';

@riverpod
class SelectedPaymentConditionStateController
    extends _$SelectedPaymentConditionStateController {
  @override
  BSFPaymentConditionEntity? build() {
    ref.cache(60);
    return null;
  }

  void select(BSFPaymentConditionEntity? payment) => state = payment;
}
