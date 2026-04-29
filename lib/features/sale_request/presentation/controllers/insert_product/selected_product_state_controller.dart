import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'selected_product_state_controller.g.dart';

@riverpod
class SelectedProductStateController extends _$SelectedProductStateController {
  @override
  BSFProductItemEntity? build() => null;

  void setProduct(BSFProductItemEntity product) {
    state = product;
  }
}
