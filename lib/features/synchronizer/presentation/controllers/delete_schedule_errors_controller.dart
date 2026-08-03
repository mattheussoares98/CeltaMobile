import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_schedule_errors_controller.g.dart';

@riverpod
class DeleteScheduleErrorsController extends _$DeleteScheduleErrorsController {
  @override
  FutureOr<void> build() {
    ref.cache();
  }

  Future<void> delete(List<int> codes, String errorKey) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (codes.isEmpty) {
        return;
      }

      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      await repository.deleteScheduleErrors(ecParams, codes);
      ref.invalidate(synchronizerDetailsStateControllerProvider(errorKey));
    });
  }
}
