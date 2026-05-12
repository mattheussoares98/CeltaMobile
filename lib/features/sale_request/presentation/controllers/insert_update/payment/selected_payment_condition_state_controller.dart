import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/domain/entities/entities.dart';

part 'selected_payment_condition_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedPaymentConditionStateController
    extends _$SelectedPaymentConditionStateController {
  @override
  BSFPaymentConditionEntity? build() => null;

  void select(BSFPaymentConditionEntity? payment) => state = payment;
}
