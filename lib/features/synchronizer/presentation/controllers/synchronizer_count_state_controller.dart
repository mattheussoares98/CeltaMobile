import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'synchronizer_count_state_controller.g.dart';

@riverpod
class SynchronizerCountStateController
    extends _$SynchronizerCountStateController {
  @override
  FutureOr<List<SynchronizerErrorSummaryEntity>> build() async {
    ref.cache(1);

    await ref.watch(validatedUserSessionProvider.future);
    final canAccess = ref.watch(
      canAccessResourceStateControllerProvider(
        BsRoutine.generic,
        BsResource.synchronizer,
      ),
    );

    if (canAccess.value != true) {
      throw AppException.localized(
        CoreFailure.userDoesNotHavePermissionToAccessThisModule,
      );
    }

    final repository = ref.read(ecSynchronizerRepositoryProvider);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    final timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => refreshSilently(),
    );

    ref.onDispose(timer.cancel);

    return await repository.searchCount(ecParams);
  }

  Future<void> refreshSilently() async {
    try {
      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);
      final newData = await repository.searchCount(ecParams);
      state = AsyncData(newData);
    } catch (_) {
      // Keep the current state when a silent refresh fails.
    }
  }
}
