import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
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
      final validatedUser = await ref.read(validatedUserSessionProvider.future);

      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final ecParams = EcRequestParams(
        workingUrl: validatedUser!.enterprise!.workingUrl!,
        user: validatedUser.user.name!,
        accessKey: validatedUser.user.AccessKey!,
      );

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
