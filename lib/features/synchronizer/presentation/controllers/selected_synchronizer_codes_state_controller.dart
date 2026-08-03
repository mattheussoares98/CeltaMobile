import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_synchronizer_codes_state_controller.g.dart';

@riverpod
class SelectedSynchronizerCodesStateController
    extends _$SelectedSynchronizerCodesStateController {
  @override
  Set<int> build(SynchronizerErrorDetailType detailType) => {};

  void select(int code) {
    if (state.any((e) => e == code)) {
      state = state.where((e) => e != code).toSet();
    } else {
      state = {...state, code};
    }
  }
}
