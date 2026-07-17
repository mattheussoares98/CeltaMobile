import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'judgments_state_controller.g.dart';

@Riverpod(keepAlive: true)
class JudgmentsStateController extends _$JudgmentsStateController {
  @override
  FutureOr<List<BSFProcessAuthorizationJudgmentEntity>> build() async {
    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    return repository.getJudgments(ecParams);
  }
}
