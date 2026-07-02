import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'judgment_details_state_controller.g.dart';

@Riverpod(keepAlive: true)
class JudgmentDetailsStateController extends _$JudgmentDetailsStateController {
  @override
  FutureOr<BSFProcessAuthorizationJudgmentEntity> build(int processCode) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = EcRequestParams(
      workingUrl: validatedUser!.enterprise!.workingUrl!,
      user: validatedUser.user.name!,
      accessKey: validatedUser.user.AccessKey!,
    );

    return (await repository.getJudgments(
      ecParams,
      processCode: processCode,
    )).first;
  }
}
