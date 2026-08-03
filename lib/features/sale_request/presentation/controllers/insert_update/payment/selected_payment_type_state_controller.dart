import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_payment_type_state_controller.g.dart';

@riverpod
class SelectedPaymentTypeStateController
    extends _$SelectedPaymentTypeStateController {
  @override
  BSFPaymentFinalizationEntity? build() {
    ref.cache(60);

    return null;
  }

  void select(BSFPaymentFinalizationEntity? payment) => state = payment;
}
