import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
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
      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      final details = await ref.read(
        gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
      );

      final uiState = ref.read(
        gRValidateDocXmlUiControllerProvider(processCode),
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

      final uiController = gRValidateDocXmlUiControllerProvider(processCode);
      ref
          .read(uiController.notifier)
          .clearSelectedProducts(areJudgedItems: areJudgedItems);
    });
  }

  Future<void> annulStatus() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);
      final details = await ref.read(
        gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
      );

      final uiState = ref.read(
        gRValidateDocXmlUiControllerProvider(processCode),
      );
      await repository.annulStatusJudgment(
        ecParams,
        grDocProductCodes: uiState.selectedProductsWithJudgmentIds.toList(),
        grDocGroupCode: details.group?.code ?? 0,
        judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
      );
      final uiController = gRValidateDocXmlUiControllerProvider(processCode);
      ref
          .read(uiController.notifier)
          .clearSelectedProducts(areJudgedItems: true);
    });
  }

  Future<void> linkProductWithoutCadaster({
    required int productCode,
    required int productWithoutCadasterCode,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);
      final details = await ref.read(
        gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
      );

      await repository.linkProductWithoutCadaster(
        ecParams,
        documentCode: details.code ?? 0,
        productCode: productCode,
        productWithoutCadasterCode: productWithoutCadasterCode,
      );

      final uiController = gRValidateDocXmlUiControllerProvider(processCode);
      if (details.productsWithoutCadaster?.length == 1) {
        ref.read(uiController.notifier).updatePageIndex(0);
        //the third bottom navigation bar only appears when there are products without register.
        //if the link succeeds, will reload the products and this bottom bar should disappear.
        //updating the page index fix the BUG trying to show a empty page 2
      }
    });
  }
}
