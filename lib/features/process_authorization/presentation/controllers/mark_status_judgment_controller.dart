import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_status_judgment_controller.g.dart';

@riverpod
class MarkStatusJudgmentController extends _$MarkStatusJudgmentController {
  @override
  FutureOr<void> build(int processCode) {}

  Future<void> judge({
    required bool areJudgedItems,
    required BsfGoodsReceivingProductJudgmentStatus judgmentStatus,
  }) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.read(validatedUserSessionProvider.future);
      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final uiState = ref.read(
        gRValidateDocXmlUiControllerProvider(processCode),
      );
      final grDocProductCodes = areJudgedItems
          ? uiState.selectedProductsWithJudgmentIds.toList()
          : uiState.selectedProductsWithoutJudgmentIds.toList();
      final ecParams = EcRequestParams(
        workingUrl: validatedUser!.enterprise!.workingUrl!,
        user: validatedUser.user.name!,
        accessKey: validatedUser.user.AccessKey!,
      );

      await repository.markStatusJudgment(
        ecParams,
        grDocProductCodes: grDocProductCodes,
        grDocGroupCode: 0,
        judgmentStatus: judgmentStatus,
        judgementType:
            BsfGoodsReceivingProductJudgmentType.requestForFiscalNote,
      );
    });
  }
}
