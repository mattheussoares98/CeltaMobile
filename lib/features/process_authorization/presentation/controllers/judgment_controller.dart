import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'judgment_controller.g.dart';

@riverpod
class JudgmentController extends _$JudgmentController {
  @override
  FutureOr<void> build(int processCode) {}

  Future<void> judgeStatus(
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

  Future<void> annulStatus() async {
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

  Future<void> linkProductWithoutCadaster({
    required int productCode,
    required int productWithoutCadasterCode,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.read(validatedUserSessionProvider.future);
      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final ecParams = EcRequestParams(
        workingUrl: validatedUser!.enterprise!.workingUrl!,
        user: validatedUser.user.name!,
        accessKey: validatedUser.user.AccessKey!,
      );
      final details = await ref.read(
        gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
      );

      await repository.linkProductWithoutCadaster(
        ecParams,
        documentCode: details.code ?? 0,
        productCode: productCode,
        productWithoutCadasterCode: productWithoutCadasterCode,
      );
    });
  }
}
