import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'pending_buy_request_state_controller.g.dart';

@Riverpod(keepAlive: true)
class PendingBuyRequestStateController
    extends _$PendingBuyRequestStateController {
  @override
  FutureOr<PendingBuyRequestEntity> build() async {
    final repository = ref.read(localPendingBuyRequestRepositoryProvider);
    final localData = await repository.load();

    return localData ?? PendingBuyRequestEntity.empty();
  }

  Future<void> updatePending(PendingBuyRequestEntity entity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localPendingBuyRequestRepositoryProvider);
      repository.update(entity);

      return entity;
    });
  }
}
