import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gr_doc_fiscal_note_differences_state_controller.g.dart';

@Riverpod(keepAlive: true)
class GRDocFiscalNoteDifferencesStateController
    extends _$GRDocFiscalNoteDifferencesStateController {
  @override
  FutureOr<dynamic> build(int processCode) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = EcRequestParams(
      workingUrl: validatedUser!.enterprise!.workingUrl!,
      user: validatedUser.user.name!,
      accessKey: validatedUser.user.AccessKey!,
    );
    //TODO create tests

    //TODO probably should load the gr and get the code here. Or, check whether
    //receive this code or not on the previous page (item) when mounting the defendants
    return await repository.getGRDocFiscalNoteDifferences(
      ecParams,
      processCode,
    );
  }
}
