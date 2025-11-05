import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';

part 'selected_discount_type_controller.g.dart';

@riverpod
class SelectedDiscountTypeController extends _$SelectedDiscountTypeController {
  @override
  FutureOr<PercentageOrValue?> build() {
    return null;
  }

  void updateSelectedDiscountType(PercentageOrValue? discountType) {
    state = AsyncValue.data(discountType);
  }
}
