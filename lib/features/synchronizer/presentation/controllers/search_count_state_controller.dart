import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_count_state_controller.g.dart';

@riverpod
class SearchCountStateController extends _$SearchCountStateController {
  @override
  FutureOr<dynamic> build() async {
    final repository = ref.read(ecSynchronizerRepositoryProvider);
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final ecParams = EcRequestParams(
      workingUrl: userSession!.enterprise!.workingUrl!,
      user: userSession.user.name!,
      accessKey: userSession.user.AccessKey!,
    );
    //TODO create tests
    return repository.searchCount(ecParams);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final userSession = await ref.read(validatedUserSessionProvider.future);

      final ecParams = EcRequestParams(
        workingUrl: userSession!.enterprise!.workingUrl!,
        user: userSession.user.name!,
        accessKey: userSession.user.AccessKey!,
      );
      return await repository.searchCount(ecParams);
    });
  }
}
