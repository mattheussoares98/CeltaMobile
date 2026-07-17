import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vote_controller.g.dart';

@riverpod
class VoteController extends _$VoteController {
  @override
  FutureOr<void> build(int processCode) {}

  Future<void> vote(bool authorized, String? observations) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.processAuthorizationVote);

      await repository.vote(
        ecParams,
        processCode: processCode,
        authorized: authorized,
        observations: observations,
      );

      ref.invalidate(judgmentsStateControllerProvider);
    });
  }
}
