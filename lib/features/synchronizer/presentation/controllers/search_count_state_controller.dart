import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_count_state_controller.g.dart';

@riverpod
class SearchCountStateController extends _$SearchCountStateController {
  @override
  FutureOr<dynamic> build() async {
    final repository = ref.read(ecSynchronizerRepositoryProvider);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);
    //TODO create tests
    return repository.searchCount(ecParams);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);
      return await repository.searchCount(ecParams);
    });
  }
}
