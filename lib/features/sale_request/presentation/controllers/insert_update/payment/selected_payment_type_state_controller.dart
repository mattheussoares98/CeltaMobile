import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/entities.dart';

part 'selected_payment_type_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedPaymentTypeStateController
    extends _$SelectedPaymentTypeStateController {
  @override
  BSFPaymentFinalizationEntity? build(int saleRequestCode) => null;

  void select(BSFPaymentFinalizationEntity? payment) => state = payment;
}
