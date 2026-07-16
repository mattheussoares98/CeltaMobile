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

  Future<void> judge(
    BsfGRProductJudgmentStatus judgmentStatus, {
    required bool areJudgedItems,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.read(validatedUserSessionProvider.future);
      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final uiState = ref.read(
        gRValidateDocXmlUiControllerProvider(processCode),
      );
      final ecParams = EcRequestParams(
        workingUrl: validatedUser!.enterprise!.workingUrl!,
        user: validatedUser.user.name!,
        accessKey: validatedUser.user.AccessKey!,
      );

      final details = await ref.read(
        gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
      );

      await repository.markStatusJudgment(
        ecParams,
        grDocProductCodes: areJudgedItems
            ? uiState.selectedProductsWithJudgmentIds.toList()
            : uiState.selectedProductsWithoutJudgmentIds.toList(),
        grDocGroupCode: details.group?.code ?? 0,
        judgmentStatus: judgmentStatus,
        judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
      );
    });
  }

  Future<void> annul() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.read(validatedUserSessionProvider.future);
      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final uiState = ref.read(
        gRValidateDocXmlUiControllerProvider(processCode),
      );
      final ecParams = EcRequestParams(
        workingUrl: validatedUser!.enterprise!.workingUrl!,
        user: validatedUser.user.name!,
        accessKey: validatedUser.user.AccessKey!,
      );
      final details = await ref.read(
        gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
      );

      await repository.annulStatusJudgment(
        ecParams,
        grDocProductCodes: uiState.selectedProductsWithJudgmentIds.toList(),
        grDocGroupCode: details.group?.code ?? 0,
        judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
      );
    });
  }
}
