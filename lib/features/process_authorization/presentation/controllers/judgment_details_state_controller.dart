import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'judgment_details_state_controller.g.dart';

@Riverpod(keepAlive: true)
class JudgmentDetailsStateController extends _$JudgmentDetailsStateController {
  @override
  FutureOr<BSFProcessAuthorizationJudgmentEntity> build(int processCode) async {
    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    return (await repository.getJudgments(
      ecParams,
      processCode: processCode,
    )).first;
  }
}
