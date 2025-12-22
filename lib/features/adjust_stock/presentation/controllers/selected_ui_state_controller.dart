import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';

part 'selected_ui_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedUIStateController extends _$SelectedUIStateController {
  @override
  SelectedItemUIState build() {
    return SelectedItemUIState.empty();
  }

  void udpateValues(SelectedItemUIState value) {
    state = value;
  }
}
