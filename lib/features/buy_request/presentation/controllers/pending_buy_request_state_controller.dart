import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'pending_buy_request_state_controller.g.dart';

@Riverpod(keepAlive: true)
class PendingBuyRequestStateController
    extends _$PendingBuyRequestStateController {
  @override
  FutureOr<PendingBuyRequestEntity> build() async {
    await ref.watch(
      userSessionProvider.future,
    ); //force update the data when do logout
    final repository = ref.read(localPendingBuyRequestRepositoryProvider);
    final localData = await repository.load();

    return localData ?? PendingBuyRequestEntity.empty();
  }

  Future<void> updatePending(PendingBuyRequestEntity entity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localPendingBuyRequestRepositoryProvider);
      final currentState = state.value!;
      if (currentState.selectedRequestType != entity.selectedRequestType ||
          currentState.selectedSupplier != entity.selectedSupplier) {
        ref.invalidate(enterprisesStateControllerProvider);
      }

      await repository.update(entity);

      return entity;
    });
  }
}
