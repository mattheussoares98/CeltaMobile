import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/models.dart';

part 'ui_state_controller.g.dart';

@riverpod
class UiStateController extends _$UiStateController {
  @override
  UiStateModel build(int codigoInternoInvCont) => const UiStateModel();

  void updateProductIndex(int? value) {
    if (state.selectedProductIndex == value || value == null) {
      state = state.copyWith(annulSelectedProductIndex: true);
    } else {
      state = state.copyWith(selectedProductIndex: value);
    }
  }

  void updateInsertIndividually() {
    state = state.copyWith(insertIndividually: !state.insertIndividually);
  }
}
