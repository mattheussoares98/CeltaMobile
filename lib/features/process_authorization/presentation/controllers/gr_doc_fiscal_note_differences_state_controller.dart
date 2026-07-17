import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
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
    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    final detailsProvider = judgmentDetailsStateControllerProvider(processCode);
    if (ref.read(detailsProvider).hasError) {
      ref.invalidate(detailsProvider);
    }
    final details = await ref.read(detailsProvider.future);
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
