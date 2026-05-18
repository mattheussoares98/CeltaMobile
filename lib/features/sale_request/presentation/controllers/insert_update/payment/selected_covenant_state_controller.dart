import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/domain/entities/entities.dart';

part 'selected_covenant_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedCovenantStateController extends _$SelectedCovenantStateController {
  @override
  BsfCovenantEntity? build() => null;

  void select(BsfCovenantEntity? covenant) => state = covenant;
}
