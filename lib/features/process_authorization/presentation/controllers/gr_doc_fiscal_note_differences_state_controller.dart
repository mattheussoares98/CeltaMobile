import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gr_doc_fiscal_note_differences_state_controller.g.dart';

@Riverpod(keepAlive: true)
class GRDocFiscalNoteDifferencesStateController
    extends _$GRDocFiscalNoteDifferencesStateController {
  @override
  FutureOr<BSFGREntity> build(int processCode) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = EcRequestParams(
      workingUrl: validatedUser!.enterprise!.workingUrl!,
      user: validatedUser.user.name!,
      accessKey: validatedUser.user.AccessKey!,
    );

    final details = await ref.read(
      judgmentDetailsStateControllerProvider(processCode).future,
    );
    final defendant = details.defendants
        ?.cast<BSFGRDefendantEntity>()
        .firstOrNull;

    if (defendant == null) {
      throw AppException('Processo não encontrado'.hardcoded);
    }

    return await repository.getGRDocFiscalNoteDifferences(
      ecParams,
      defendant.goodsReceiving.code!,
    );
  }
}
